#!/usr/bin/env python3
"""Replay this overlay's patch pipeline against real upstream sources.

Applies, in the exact order the ebuilds do:

  1. the ``src_prepare`` seds from ``eclass/qt4-build-multilib.eclass``,
  2. the shared patch bundle (``patchsets/…-4.8.7-patches-1.tgz``) at the strip
     level the eclass uses, in eclass order,
  3. each ``dev-qt/*`` ebuild's own ``PATCHES`` and its explicit
     ``eapply -pN`` calls, and
  4. ``kde-frameworks/kdelibs``'s ``PATCHES``.

and reports every patch or sed that does not apply.  This is what catches the
class of bug a plain patch-by-patch dry-run misses: a ``sed`` that runs before a
patch and edits the lines that patch expects, or two distinct patches that
touch the same hunk.

The trees you pass in are modified in place, so point it at throwaway
extractions:

    python verify-patchsets.py --qt /path/qt-everywhere-opensource-src-4.8.7 \\
                               --kdelibs /path/kdelibs-4.14.38
"""

from __future__ import annotations

import argparse
import glob
import os
import re
import subprocess
import sys
import tarfile
import tempfile

REPO = os.path.dirname(os.path.abspath(__file__))
ECLASS = os.path.join(REPO, "eclass", "qt4-build-multilib.eclass")
BUNDLE = os.path.join(REPO, "patchsets",
                      "qt-everywhere-opensource-src-4.8.7-patches-1.tgz")
KDELIBS_EBUILD = os.path.join(REPO, "kde-frameworks", "kdelibs",
                              "kdelibs-4.14.38-r1.ebuild")

failures: list[str] = []


def read(path: str) -> str:
    return open(path, encoding="utf-8", newline="").read().replace("\r\n", "\n")


def apply_patch(tree: str, path: str, level: str, label: str) -> None:
    r = subprocess.run(["patch", level, "-f", "-g0", "--no-backup-if-mismatch",
                        "-i", path], cwd=tree, capture_output=True, text=True)
    out = (r.stdout or "") + (r.stderr or "")
    bad = [l.strip() for l in out.splitlines()
           if "FAILED" in l or "Reversed" in l or "No file to patch" in l
           or "can't find file" in l]
    if r.returncode != 0 or bad:
        failures.append(f"{label}: {bad[0] if bad else 'rc=%d' % r.returncode}")
        print(f"  FAIL  {label}  :: {bad[0] if bad else r.returncode}")
    else:
        print(f"  ok    {label}")


def run_seds(tree: str) -> None:
    """Replay the src_prepare seds: the two conditional ones, then the block."""
    text = read(ECLASS)
    block = text.split("# Build fixes for a >= C++17 toolchain", 1)[1]
    block = block.split("\n", 1)[1]          # drop the rest of the marker line
    block = block.split("[[ ${PATCHES[@]} ]]", 1)[0]
    script = "\n".join([
        "set -e",
        "sed -i -e 's/^if true;/if false;/' configure",
        "sed -i -e '/^if.*PLATFORM_X11.*CFG_GUI/,/^fi$/d' configure",
        block,
    ])
    print("=== 1. src_prepare seds ===")
    r = subprocess.run(["bash", "-e", "-c", script], cwd=tree,
                       capture_output=True, text=True)
    n = script.count("sed -i")
    if r.returncode != 0:
        failures.append(f"src_prepare seds: {(r.stderr or '').strip().splitlines()[-1:]}")
        print(f"  FAIL  seds rc={r.returncode}\n{(r.stderr or '').strip()[:400]}")
    else:
        print(f"  ok    {n} sed invocations")


def bundle_order() -> list[tuple[str, str]]:
    """[('-p1', 'qt4-gcc6.patch'), …] straight out of the eclass."""
    out = []
    for level, name in re.findall(
            r'eapply (-p[01]) "\$\{WORKDIR\}"/patch/(\S+\.patch)', read(ECLASS)):
        out.append((level, name))
    return out


def apply_bundle(tree: str) -> None:
    print("=== 2. shared bundle (eclass order) ===")
    with tempfile.TemporaryDirectory() as tmp:
        with tarfile.open(BUNDLE) as tf:
            tf.extractall(tmp)
        for level, name in bundle_order():
            p = os.path.join(tmp, "patch", name)
            if not os.path.exists(p):
                failures.append(f"bundle {name}: missing from the tarball")
                print(f"  FAIL  {name}  :: not in the bundle")
                continue
            apply_patch(tree, p, level, f"{level} {name}")


def ebuild_patch_calls(ebuild: str) -> list[tuple[str, str]]:
    """[(level, filename)] for one dev-qt ebuild, in application order.

    PATCHES entries are applied by the eclass with eapply's default (-p1)
    before the ebuild's own explicit eapply calls, which is the order here.
    """
    text = read(ebuild)
    calls: list[tuple[str, str]] = []
    block = re.search(r"^PATCHES=\((.*?)^\)", text, re.S | re.M)
    if block:
        for line in block.group(1).splitlines():
            line = line.strip()
            if not line or line.startswith("#") or "${FILESDIR}" not in line:
                continue
            m = re.search(r"\{?FILESDIR\}?/([^\"\s]+)", line)
            if m:
                calls.append(("-p1", m.group(1)))
    for m in re.finditer(r'eapply\s+(-p[01]\s+)?"\$\{FILESDIR\}/([^"]+)"', text):
        calls.append((m.group(1).strip() if m.group(1) else "-p1", m.group(2)))
    return calls


def resolve(ebuild: str, name: str) -> str:
    pn = os.path.basename(os.path.dirname(ebuild))
    p = re.sub(r"-r\d+$", "", os.path.basename(ebuild)[:-len(".ebuild")])
    name = (name.replace("${PN}", pn).replace("${P}", p)
                .replace("${PV}", p[len(pn) + 1:]))
    return os.path.join(os.path.dirname(ebuild), "files", name)


def newest_revision(ebuilds: list[str]) -> list[str]:
    """One ebuild per package: revisions are alternatives for the same tree.

    Packages that build from a different tarball than the one given to --qt
    (qtwebkit-4.10.4) are skipped, since their patches target other sources.
    """
    newest: dict[str, str] = {}
    for e in ebuilds:
        if os.path.basename(e).startswith("qtwebkit-4.10"):
            continue
        key, rev = os.path.dirname(e), int((re.search(r"-r(\d+)\.ebuild$", e) or [None, "0"])[1])
        if key not in newest:
            newest[key] = e
            continue
        cur = int((re.search(r"-r(\d+)\.ebuild$", newest[key]) or [None, "0"])[1])
        if rev > cur:
            newest[key] = e
    return sorted(newest.values())


def check_tree(tree: str, ebuilds: list[str], banner: str) -> None:
    print(f"=== {banner} ===")
    for ebuild in newest_revision(ebuilds):
        calls = ebuild_patch_calls(ebuild)
        if not calls:
            continue
        print(f"  [{os.path.relpath(ebuild, REPO)}] {len(calls)} patches")
        for level, name in calls:
            path = resolve(ebuild, name)
            if not os.path.exists(path):
                failures.append(f"{os.path.basename(ebuild)}: {name} is missing")
                print(f"    FAIL  {name}  :: file not found")
                continue
            apply_patch(tree, path, level, name)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--qt", required=True,
                    help="extracted qt-everywhere-opensource-src-4.8.7 tree")
    ap.add_argument("--kdelibs",
                    help="extracted kdelibs-4.14.38 tree (optional)")
    ap.add_argument("--skip-seds", action="store_true")
    args = ap.parse_args()

    for p in (ECLASS, BUNDLE):
        if not os.path.exists(p):
            print(f"missing input: {p}", file=sys.stderr)
            return 2

    if args.qt:
        if not args.skip_seds:
            run_seds(args.qt)
        apply_bundle(args.qt)
        check_tree(args.qt,
                   sorted(glob.glob(os.path.join(REPO, "dev-qt", "*", "*.ebuild"))),
                   "3. dev-qt per-package patches")

    if args.kdelibs:
        check_tree(args.kdelibs, [KDELIBS_EBUILD], "4. kdelibs patches")

    print()
    if failures:
        print(f"{len(failures)} failure(s):")
        for f in failures:
            print("  -", f)
        return 1
    print("all patches applied cleanly")
    return 0


if __name__ == "__main__":
    sys.exit(main())
