#!/usr/bin/env python3
"""
check-overlay.py - static QA for a Gentoo ebuild overlay.

Targets the failure classes that make `eix-update` print errors and make
`emerge` fail while reading metadata or fetching sources:

  eclass-missing           inherit of an eclass that exists in neither the
                           overlay nor the master repo
  eclass-eapi-mismatch     an eclass (directly, or through another inherited
                           eclass) has an EAPI guard that `die`s for the
                           ebuild's EAPI
  missing-inherit          the ebuild calls a helper that only the overlay's
                           eclasses provide, without inheriting it
  eclass-shadows-master    overlay eclass shadows the master repo
  eclass-no-eapi-info      used eclass has neither @SUPPORTED_EAPIS nor a guard
  unknown-category-dir / invalid-category-name
  missing-metadata-xml / bad-metadata-xml
  missing-manifest         SRC_URI fetches, but there is no Manifest at all
  manifest-missing-dist    SRC_URI wants a distfile no Manifest DIST matches
  manifest-orphan-dist     Manifest lists a distfile no SRC_URI token matches
  unfetchable-package      Manifest has DIST entries but no SRC_URI exists
  mismatched-ebuild-name   ebuild filename does not match its package name
  banned-helper            helper removed by the ebuild's EAPI
  missing-file-in-filesdir
  profile-bad-line
  bash-syntax

Usage:
    python3 check-overlay.py <overlay-dir> [--ref <gentoo-repo-dir>]
                            [--json out.json] [--max-per-kind N]
"""
from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import xml.etree.ElementTree as ET
from collections import defaultdict, deque

SPECIAL_DIRS = {"metadata", "profiles", "eclass", "licenses", "files"}
SKIP_CATS = SPECIAL_DIRS | {"Documentation", "patchsets"}

BANNED_HELPERS = {
    "dohtml": ({"7", "8", "9"}, "use `docinto html`"),
    "useq": ({"5", "6", "7", "8", "9"}, "use `use` / `usex`"),
    "epatch": ({"7", "8", "9"}, "use `eapply`"),
    "epatch_user": ({"7", "8", "9"}, "use `eapply_user`"),
    "built_with_use": ({"7", "8", "9"}, "use `has_version` / `has_version -b`"),
    "dolib": ({"7", "8", "9"}, "use `dolib.so` / `dolib.a`"),
    "has_version --host-root": ({"7", "8", "9"}, "use `has_version -b`"),
}

ARCHIVE_RE = re.compile(
    r"\.(tar\.(gz|bz2|xz|lzma|zst)|tgz|tbz2|zip|gz|bz2|xz|zst|patch|diff|jar|tar|run|bin|deb)$")


def rel(base, p):
    try:
        return os.path.relpath(p, base).replace(os.sep, "/")
    except ValueError:
        return p


def read(path):
    for enc in ("utf-8", "latin-1"):
        try:
            with open(path, encoding=enc) as fh:
                return fh.read()
        except (UnicodeDecodeError, OSError):
            continue
    return ""


def strip_comments(text):
    return "\n".join(l for l in text.splitlines() if not l.lstrip().startswith("#"))


# --------------------------------------------------------------------- parsing

def get_var(text, var):
    """Top-level assignments to a metadata variable, quote-aware.

    Metadata variables live at column 0; anything indented is ebuild code and
    must not be mistaken for metadata.
    """
    out = []
    for m in re.finditer(r"(?m)^" + var + r"\+?=[ \t]*", text):
        i = m.end()
        if i < len(text) and text[i] in "\"'":
            q, j = text[i], i + 1
            while j < len(text):
                if text[j] == "\\":
                    j += 2
                    continue
                if text[j] == q:
                    break
                j += 1
            chunk = text[i + 1:j]
        else:
            j = text.find("\n", i)
            j = len(text) if j == -1 else j
            chunk = text[i:j]
        out.append(chunk.replace("\\\r\n", " ").replace("\\\n", " "))
    return " ".join(out)


def split_uri_tokens(val):
    """Split on whitespace, but never inside ${...}, $(...) or quotes."""
    toks, buf, depth, quote, i = [], [], 0, None, 0
    while i < len(val):
        c = val[i]
        if quote:
            buf.append(c)
            if c == quote:
                quote = None
            i += 1
            continue
        if c in "\"'":
            quote = c
            buf.append(c)
            i += 1
            continue
        if c == "$" and i + 1 < len(val) and val[i + 1] in "({":
            depth += 1
            buf.append(c)
            buf.append(val[i + 1])
            i += 2
            continue
        if depth:
            buf.append(c)
            if c in ")}":
                depth -= 1
            i += 1
            continue
        if c.isspace():
            if buf:
                toks.append("".join(buf))
                buf = []
            i += 1
            continue
        buf.append(c)
        i += 1
    if buf:
        toks.append("".join(buf))
    return toks


def uri_basename(uri):
    """Basename of a URI, ignoring '/' inside ${...} / $(...) and any query."""
    depth, cut, i = 0, len(uri), 0
    while i < len(uri):
        c = uri[i]
        if c == "$" and i + 1 < len(uri) and uri[i + 1] in "({":
            depth += 1
            i += 2
            continue
        if depth:
            depth -= (c in ")}")
            i += 1
            continue
        if c in "?#":
            cut = i
            break
        i += 1
    uri = uri[:cut]
    depth, last, i = 0, -1, 0
    while i < len(uri):
        c = uri[i]
        if c == "$" and i + 1 < len(uri) and uri[i + 1] in "({":
            depth += 1
            i += 2
            continue
        if depth:
            depth -= (c in ")}")
            i += 1
            continue
        if c == "/":
            last = i
        i += 1
    return uri[last + 1:]


def src_uri_tokens(text):
    """[(uri, expected local distfile name)] from a SRC_URI assignment."""
    val = get_var(text, "SRC_URI")
    if not val.strip():
        return []
    parts = split_uri_tokens(val)
    out, i = [], 0
    while i < len(parts):
        if i + 2 < len(parts) and parts[i + 1] == "->":
            out.append((parts[i], parts[i + 2].strip("\"'")))
            i += 3
        else:
            out.append((parts[i], uri_basename(parts[i])))
            i += 1
    return out


def name_to_regex(name):
    """Glob/${VAR} aware regex for a distfile name; None if unresolvable."""
    if not name:
        return None
    parts, i = [], 0
    while i < len(name):
        c = name[i]
        if c == "$":
            if i + 1 < len(name) and name[i + 1] == "{":
                depth, j = 1, i + 2
                while j < len(name) and depth:
                    depth += (name[j] == "{") - (name[j] == "}")
                    j += 1
                parts.append(".*")
                i = j
                continue
            m = re.match(r"\$[A-Za-z_][A-Za-z0-9_]*", name[i:])
            if not m:
                return None
            parts.append(".*")
            i += m.end()
            continue
        if c == "*":
            parts.append(".*")
            i += 1
        elif c == "?":
            parts.append(".")
            i += 1
        else:
            parts.append(re.escape(c))
            i += 1
    return "^" + "".join(parts) + "$"


def parse_supported_eapis(text):
    m = re.search(r"@SUPPORTED_EAPIS:\s*([0-9 ]+)", text)
    if m:
        return set(m.group(1).split()), True
    supported, considered = set(), False
    for cm in re.finditer(r"case\s+\$\{?EAPI", text):
        tail = text[cm.end():cm.end() + 1500]
        end = tail.find("esac")
        block = tail[:end] if end != -1 else tail
        for bm in re.finditer(r"(?m)^\s*([0-9|*][0-9|*a-zA-Z_. -]*)\)(.*?)(?:;;|$)", block, re.S):
            pats, body = bm.group(1).strip(), bm.group(2)
            if "*" in pats or "die" in body:
                continue
            nums = set(re.findall(r"\d+", pats))
            if nums:
                considered = True
                supported |= nums
    if considered:
        return supported, True
    for m in re.finditer(r"(?m)^.*EAPI[^\n]*==[^\n]*\[([0-9]+)-([0-9]+)\][^\n]*die[^\n]*$", text):
        lo, hi = int(m.group(1)), int(m.group(2))
        return {str(i) for i in range(0, 10)} - {str(i) for i in range(lo, hi + 1)}, True
    return set(), False


def find_inherits(text):
    names = []
    for m in re.finditer(r"(?m)^[ \t]*inherit[ \t]+((?:[^\n\\]|\\.)*)", text):
        for tok in m.group(1).replace("\\", " ").split():
            if re.fullmatch(r"[A-Za-z0-9._+-]+", tok):
                names.append(tok)
    return names


CALL_PATTERNS = (
    r"(?<![A-Za-z0-9_.-])%s\s*\((?!\s*\))",   # not a function definition
    r"\$\(\s*%s(?![A-Za-z0-9_.-])",
    r"`\s*%s(?![A-Za-z0-9_.-])",
)


def calls_function(text, fn):
    return any(re.search(p % re.escape(fn), text) for p in CALL_PATTERNS)


def iter_ebuilds(root):
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d != ".git" and not d.startswith(".")]
        for fn in filenames:
            if fn.endswith(".ebuild"):
                yield os.path.join(dirpath, fn)


def bash_syntax(path):
    try:
        p = subprocess.run(["bash", "-n", path], capture_output=True, text=True)
    except FileNotFoundError:
        return None
    return (p.stderr or p.stdout).strip().splitlines()[0] if p.returncode else None


# ------------------------------------------------------------------------ main

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("overlay")
    ap.add_argument("--ref", default=None)
    ap.add_argument("--json", default=None)
    ap.add_argument("--max-per-kind", type=int, default=25)
    args = ap.parse_args()

    root = os.path.abspath(args.overlay)
    ref = os.path.abspath(args.ref) if args.ref else None
    findings, stats = [], defaultdict(int)
    seen_findings = set()

    def add(kind, path, detail):
        key = (kind, path, detail)
        if key in seen_findings:
            return
        seen_findings.add(key)
        findings.append({"kind": kind, "path": path, "detail": detail})
        stats[kind] += 1

    # ------------------------------------------------- eclass graph + providers
    eclass_text, eclass_origin = {}, {}
    if ref and os.path.isdir(os.path.join(ref, "eclass")):
        for fn in sorted(os.listdir(os.path.join(ref, "eclass"))):
            if fn.endswith(".eclass"):
                eclass_text[fn[:-7]] = read(os.path.join(ref, "eclass", fn))
                eclass_origin[fn[:-7]] = "master"
    overlay_eclasses = {}
    if os.path.isdir(os.path.join(root, "eclass")):
        for fn in sorted(os.listdir(os.path.join(root, "eclass"))):
            if fn.endswith(".eclass"):
                name = fn[:-7]
                overlay_eclasses[name] = os.path.join(root, "eclass", fn)
                eclass_text[name] = read(overlay_eclasses[name])
                eclass_origin[name] = "overlay"

    eclass_parents = {n: find_inherits(t) for n, t in eclass_text.items()}
    eclass_support = {n: parse_supported_eapis(t) for n, t in eclass_text.items()}

    # helpers that ONLY the overlay's eclasses define: calling one without
    # inheriting its eclass is always a bug (builtins never live in eclasses).
    overlay_providers, master_providers = defaultdict(set), set()
    for name in eclass_text:
        for m in re.finditer(r"(?m)^([A-Za-z_][A-Za-z0-9_-]*)\(\)", eclass_text[name]):
            if eclass_origin.get(name) == "overlay":
                overlay_providers[m.group(1)].add(name)
            else:
                master_providers.add(m.group(1))

    def closure(start):
        seen, out, q = set(), {}, deque()
        for nm in start:
            q.append((nm, nm))
        while q:
            nm, chain = q.popleft()
            if nm in seen:
                continue
            seen.add(nm)
            out[nm] = chain
            for child in eclass_parents.get(nm, []):
                q.append((child, chain + " -> " + child))
        return out

    # ---------------------------------------------------------------- layout
    cats = set()
    catfile = os.path.join(root, "profiles", "categories")
    if os.path.exists(catfile):
        cats = {l.strip() for l in read(catfile).splitlines()
                if l.strip() and not l.strip().startswith("#")}
    ref_cats = set()
    if ref and os.path.exists(os.path.join(ref, "profiles", "categories")):
        ref_cats = {l.strip() for l in read(os.path.join(ref, "profiles", "categories")).splitlines()
                    if l.strip() and not l.strip().startswith("#")}
    for d in sorted(os.listdir(root)):
        if not os.path.isdir(os.path.join(root, d)) or d.startswith(".") or d in SPECIAL_DIRS:
            continue
        if not re.fullmatch(r"[a-z0-9][a-z0-9+_.-]*", d):
            add("invalid-category-name", d, "directory name is not a valid category")
        elif d not in cats and d not in ref_cats:
            add("unknown-category-dir", d, "not listed in profiles/categories")

    # ---------------------------------------------------------------- ebuilds
    used_eclasses, pkg_dirs = set(), []
    for cat in sorted(os.listdir(root)):
        cd = os.path.join(root, cat)
        if not os.path.isdir(cd) or cat.startswith(".") or cat in SKIP_CATS:
            continue
        for pkg in sorted(os.listdir(cd)):
            pd = os.path.join(cd, pkg)
            if not os.path.isdir(pd) or pkg.startswith("."):
                continue
            ebs = sorted(f for f in os.listdir(pd) if f.endswith(".ebuild"))
            if not ebs:
                continue
            pkg_dirs.append(f"{cat}/{pkg}")
            for eb in ebs:
                if not eb.startswith(pkg + "-"):
                    add("mismatched-ebuild-name", f"{cat}/{pkg}", f"ebuild file {eb} does not match")
            if not os.path.exists(os.path.join(pd, "metadata.xml")):
                add("missing-metadata-xml", f"{cat}/{pkg}", "no metadata.xml")
            else:
                try:
                    mx = ET.parse(os.path.join(pd, "metadata.xml")).getroot()
                    if mx.tag != "pkgmetadata":
                        add("bad-metadata-xml", f"{cat}/{pkg}/metadata.xml",
                            f"root element is <{mx.tag}>, expected <pkgmetadata>")
                except ET.ParseError as exc:
                    add("bad-metadata-xml", f"{cat}/{pkg}/metadata.xml", str(exc))

            # ---- Manifest vs SRC_URI
            # Only the ebuild's OWN SRC_URI is trustworthy: eclass-provided
            # SRC_URI depends on inherit order, and a later eclass may override
            # an earlier one (e.g. mono-env sets a mono tarball that kde4-base
            # then replaces).  own_tokens drives the distfile comparisons;
            # eclass-provided SRC_URI only tells us that fetching happens.
            own_tokens, own_src, eclass_src = [], "", ""
            own_mentions, eclass_touches = False, False
            for eb in ebs:
                t = read(os.path.join(pd, eb))
                own_mentions |= bool(re.search(r"\bSRC_URI\b", t))
                own_src += " " + get_var(t, "SRC_URI")
                own_tokens += src_uri_tokens(t)
                for nm in closure(find_inherits(t)):
                    et = eclass_text.get(nm)
                    if et is None:
                        continue
                    eclass_src += " " + get_var(et, "SRC_URI")
                    if re.search(r"\bSRC_URI\b", et):
                        eclass_touches = True
            manifest = os.path.join(pd, "Manifest")
            dist = set()
            if os.path.exists(manifest):
                dist = {l.split()[1] for l in read(manifest).splitlines()
                        if l.startswith("DIST ") and len(l.split()) > 1}
                if not own_src.strip() and own_mentions:
                    pass                      # conditional SRC_URI we cannot read
                elif not own_src.strip() and not eclass_touches and dist:
                    add("unfetchable-package", f"{cat}/{pkg}",
                        "Manifest lists distfiles but no SRC_URI exists")
                else:
                    for uri, name in own_tokens:
                        if not name or not ARCHIVE_RE.search(name):
                            continue
                        pat = name_to_regex(name)
                        if pat is None or any(re.match(pat, d) for d in dist):
                            continue
                        add("manifest-missing-dist", f"{cat}/{pkg}",
                            f"SRC_URI wants {name} but no Manifest DIST entry matches")
                    if not eclass_touches:
                        for d in sorted(dist):
                            if any((name_to_regex(n) and re.match(name_to_regex(n), d))
                                   for _, n in own_tokens if n):
                                continue
                            add("manifest-orphan-dist", f"{cat}/{pkg}",
                                f"Manifest lists {d} but no SRC_URI token matches it")
            elif re.search(r"(https?|mirror|ftp|git)://", own_src + " " + eclass_src):
                add("missing-manifest", f"{cat}/{pkg}",
                    "no Manifest file, but SRC_URI fetches remote sources")

    for path in iter_ebuilds(root):
        text = read(path)
        rp = rel(root, path)
        m = re.search(r"(?m)^[ \t]*EAPI=[\"']?([0-9]+)", text)
        eapi = m.group(1) if m else ""
        if not eapi:
            add("missing-eapi", rp, "no EAPI set (defaults to 0, which is banned)")

        reach = closure(find_inherits(text))
        used_eclasses.update(reach)
        for nm, chain in sorted(reach.items()):
            if nm in eclass_text:
                sup, explicit = eclass_support[nm]
                if explicit and eapi and eapi not in sup:
                    add("eclass-eapi-mismatch", rp,
                        f"EAPI {eapi} rejected by {nm} "
                        f"(supports {'/'.join(sorted(sup, key=int)) or 'nothing'}); "
                        f"chain: {chain}")
            else:
                add("eclass-missing", rp,
                    f"inherit {nm}: eclass is in neither the overlay nor the master repo")

        code = strip_comments(text)
        for fn, owners in overlay_providers.items():
            # a name the master tree also defines is likely a builtin or a
            # generic hook (multilib_src_*), never a missing inherit
            if fn in master_providers or owners & set(reach):
                continue
            if calls_function(code, fn):
                add("missing-inherit", rp,
                    f"calls {fn}() but does not inherit {sorted(owners)[0]}")

        for helper, (eapis, fix) in BANNED_HELPERS.items():
            if eapi in eapis and re.search(
                    r"(?<![A-Za-z0-9_.-])" + re.escape(helper) + r"(?![A-Za-z0-9_.-])", code):
                add("banned-helper", rp, f"`{helper}` is gone in EAPI {eapi}; {fix}")

        fdir = os.path.join(os.path.dirname(path), "files")
        refs = set(re.findall(r'\$\{FILESDIR\}/+([^"\'\s;$]+)', code))
        refs |= set(re.findall(r'["\']files/([^"\'\s;$]+)', code))
        for r in refs:
            if r.endswith("-") or any(c in r for c in "$*"):
                continue
            if not os.path.exists(os.path.join(fdir, r)):
                add("missing-file-in-filesdir", rp, f"references files/{r} which does not exist")

        syn = bash_syntax(path)
        if syn:
            add("bash-syntax", rp, syn)

    # ---------------------------------------------------------------- eclasses
    for name, path in sorted(overlay_eclasses.items()):
        syn = bash_syntax(path)
        if syn:
            add("bash-syntax", rel(root, path), syn)
        if eclass_origin.get(name) == "master":
            add("eclass-shadows-master", rel(root, path),
                f"{name}.eclass also exists in the master repo; this copy wins")
        if name not in used_eclasses:
            add("unused-eclass", rel(root, path), "not inherited by any ebuild")
        elif not eclass_support[name][1] and not any(
                eclass_support.get(n, (set(), False))[1]
                for n in closure(eclass_parents.get(name, []))):
            add("eclass-no-eapi-info", rel(root, path),
                "no @SUPPORTED_EAPIS and no parseable EAPI guard")

    # ---------------------------------------------------------------- profiles
    for prof in ("use.desc", "use.local.desc"):
        p = os.path.join(root, "profiles", prof)
        if os.path.exists(p):
            for i, line in enumerate(read(p).splitlines(), 1):
                line = line.strip()
                if line and not line.startswith("#") and " - " not in line:
                    add("profile-bad-line", f"profiles/{prof}",
                        f"line {i}: `{line[:70]}` has no ' - ' separator")
    upd = os.path.join(root, "profiles", "updates")
    upds = [upd] if os.path.isfile(upd) else (
        [os.path.join(upd, f) for f in sorted(os.listdir(upd))] if os.path.isdir(upd) else [])
    for f in upds:
        for i, line in enumerate(read(f).splitlines(), 1):
            line = line.strip()
            if line and not line.startswith("#") and not re.match(r"^(move|slotmove)\s+\S+.*\s\S+$", line):
                add("profile-bad-line", f"profiles/updates/{os.path.basename(f)}",
                    f"line {i}: `{line[:70]}` is not a valid update command")

    # ---------------------------------------------------------------- report
    order = ["eclass-missing", "eclass-eapi-mismatch", "missing-inherit",
             "eclass-shadows-master", "unknown-category-dir", "invalid-category-name",
             "missing-manifest", "manifest-missing-dist", "manifest-orphan-dist",
             "unfetchable-package", "missing-metadata-xml", "bad-metadata-xml",
             "banned-helper", "missing-file-in-filesdir", "mismatched-ebuild-name",
             "missing-eapi", "profile-bad-line", "bash-syntax",
             "eclass-no-eapi-info", "unused-eclass"]
    by_kind = defaultdict(list)
    for f in findings:
        by_kind[f["kind"]].append(f)

    print(f"overlay : {root}")
    if ref:
        print(f"master  : {ref}")
    else:
        print("master  : (none)")
        print("NOTE: without --ref every eclass that lives in the master tree is")
        print("      reported as missing.  Pass --ref <gentoo checkout> for a real")
        print("      result: python3 check-overlay.py . --ref /var/db/repos/gentoo")
    print(f"ebuilds : {sum(1 for _ in iter_ebuilds(root))}   packages: {len(pkg_dirs)}   "
          f"overlay eclasses: {len(overlay_eclasses)}")
    print(f"findings: {len(findings)}")
    print()
    for kind in order + sorted(set(by_kind) - set(order)):
        items = by_kind.get(kind)
        if not items:
            continue
        print(f"[{kind}] {len(items)}")
        for f in items[: args.max_per_kind]:
            print(f"    {f['path']}: {f['detail']}")
        if len(items) > args.max_per_kind:
            print(f"    ... and {len(items) - args.max_per_kind} more")
        print()

    if args.json:
        with open(args.json, "w", encoding="utf-8") as fh:
            json.dump({"overlay": root, "ref": ref, "stats": dict(stats),
                       "findings": findings}, fh, indent=2)
        print(f"json written to {args.json}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
