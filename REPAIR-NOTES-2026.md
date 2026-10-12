# kde-sunset: 2026 Gentoo repair notes

Deep dive into why `eix-update` and `emerge` were throwing errors, what was
fixed, how to verify it on your box, and what is still blocking an actual
build.

Nothing here is overlay content. `REPAIR-NOTES-2026.md`, `check-overlay.py`
and `verify-on-gentoo.sh` are plain files at the repository root; portage
ignores non-directory entries at the root, so they cannot affect the overlay.

---

## 1. TL;DR

| | |
|---|---|
| **Root cause of the error spam** | `eclass/virtualx.eclass` still had `*) die "virtualx.eclass: EAPI 8 is not supported yet."`, and `kde4-base.eclass` inherits `virtualx`. **472 of the 589 ebuilds** (everything built on `kde4-base`/`kde4-meta`) therefore failed the *metadata* phase — which is exactly what `eix-update` runs when there is no `metadata/md5-cache`. |
| **Fixed** | that guard, plus 8 other real defects (below). |
| **Static findings** | 1435 → 8, and 7 of the remaining 8 are informational. |
| **Still blocking a build** | the Qt 4 patch bundle that `qt4-build-multilib.eclass` fetches from `mirror://kde-sunset/` — **all three mirrors in `profiles/thirdpartymirrors` are dead**. Without it Qt 4 cannot be fetched, and Qt 4 is the foundation of the whole KDE 4 stack. |
| **Also inert** | `patchsets/gcc-fixes/*.patch` and `patchsets/qt4-aur/qt4-aur.tar.gz` are referenced by no ebuild, so your gcc-15 fixes are never applied. |

---

## 2. Why `eix-update` was noisy

`eix-update` prefers a pre-generated metadata cache (`metadata/md5-cache`).
This overlay has no cache in git, so eix falls back to running the **metadata
phase** for every ebuild — the same code path as `emerge`/`egencache`, i.e.
sourcing the ebuild plus all inherited eclasses with portage's `ebuild.sh`.

An eclass that `die`s at inherit time therefore produces one error block *per
ebuild that inherits it*. The chain here was:

```
kde4-base.eclass:48   inherit kde4-functions toolchain-funcs flag-o-matic virtualx multilib xdg-utils
eclass/virtualx.eclass
    case "${EAPI:-0}" in
        0|1|2|3) die "virtualx.eclass: EAPI ${EAPI} is too old." ;;
        4|5|6|7) ;;                      # <- no 8
        *)       die "virtualx.eclass: EAPI ${EAPI} is not supported yet." ;;
    esac
```

Every ebuild in this overlay is `EAPI=8`, so:

```
* ERROR: kde-base/kdelibs-4.14.38-r1::kde-sunset failed (depend phase):
*   virtualx.eclass: EAPI 8 is not supported yet.
```

× 472. The old (2019) `virtualx.eclass` was shadowing the current Gentoo one,
and a previous bulk "EAPI → 8" pass never relaxed it.

### How the tree got this way

The history shows a repair loop rather than a planned port:

* `8821e2b "updates for 2026 gentoo"` temporarily replaced the body of
  `kde4-base.eclass` / `kde4-meta.eclass` with 7-line stubs.
* `dd5a92b "repair overlay: restore ebuild and eclass consistency"` restored
  them — but the EAPI guards inside the *inherited* eclasses were still 2015
  vintage, and the blanket `inherit versionator` removal in that pass left
  callers behind (see §3.2).
* `c055db8f "fixes for september 2026"` (only on `origin/master`, not in your
  working tree) touched 589 files in `.backup_20251130_1032/` — a repair
  artifact directory sitting in the repository.

---

## 3. What was actually broken, and what changed

### 3.1 `eclass/virtualx.eclass` — the mass failure (472 ebuilds)

```diff
-# @SUPPORTED_EAPIS: 4 5 6 7
+# @SUPPORTED_EAPIS: 4 5 6 7 8
-	4|5|6|7)
+	4|5|6|7|8|9)
```

The rest of the eclass is EAPI-8-safe: its EAPI-conditional branches are all
`[[ ${EAPI} == [45] ]]`, which are simply false for EAPI 8, and `virtx` (the
function `kde4-base_src_test` calls) has no EAPI gate.

This copy is kept deliberately rather than deleted in favour of Gentoo's
current `virtualx.eclass`: `kde4-base.eclass` sets `VIRTUALX_REQUIRED=manual`
and then does its own `get_libdir`/`virtx` dance keyed on
`${VIRTUALX_COMMAND}`; the modern eclass *dies* if `VIRTUALX_COMMAND` is set
and has dropped `virtualmake`. Keeping the legacy copy preserves the KDE 4
behaviour (and the shadowing is harmless because an overlay eclass only
applies to that overlay's ebuilds).

### 3.2 `eclass/versionator.eclass` is gone from Gentoo — 5 ebuilds still called it

`versionator.eclass` was removed from `gentoo.git` on 2024-10-08 (its
functions are built into EAPI 7+ as `ver_cut`, `ver_rs`, `ver_test`). The
overlay ships a copy, but a previous pass deleted `inherit versionator` from
most ebuilds while leaving the calls. `get_version_component_range` was being
used at global scope, so `SLOT` evaluated to `4/` and metadata generation
printed "command not found":

* `app-editors/okteta/okteta-4.14.3.ebuild`
* `app-text/kjots/kjots-4.14.11_pre20160611.ebuild`
* `kde-plasma/drkonqi/drkonqi-4.14.3.ebuild`
* `kde-plasma/drkonqi/drkonqi-16.04.3.ebuild`
* `sci-astronomy/kstars/kstars-4.14.3-r1.ebuild`

Fixed by using the EAPI builtin: `SLOT=4/$(get_version_component_range 1-2)`
→ `SLOT=4/$(ver_cut 1-2)`.

Three other ebuilds were converted off `versionator` entirely so the eclass is
no longer needed at all:

| ebuild | before | after |
|---|---|---|
| `app-backup/qt4-fsarchiver` | `replace_version_separator 3 '-'` / `get_version_component_range 1-3` | `ver_rs 3 '-'` / `ver_cut 1-3` |
| `kde-misc/plasmatvgr` | `replace_version_separator . ''` | `ver_rs 1 ''` |
| `kde-misc/stdin-plasmoid` | `replace_version_separator 2 '-'` | `ver_rs 2 '-'` |

The eclass itself now also accepts EAPI 7/8 (`0|1|2|3|4|5|6` →
`0|1|2|3|4|5|6|7|8`), so it is no longer a trap if something else inherits it.

### 3.3 `eclass/java-ant-2.eclass` was deleted upstream — 2 ebuilds inherited it

`java-ant-2.eclass` was removed from `gentoo.git` on 2024-11-03
(`f28ab51fad9acb876a8fef5dd56f656afcd2776c`; Gentoo's last consumer was
`media-libs/opencv`). `kde-base/krossjava` and `media-libs/opencv` still
inherit it → "eclass not found".

Fixed by **vendoring the last upstream revision** (14091 bytes, which declares
`@SUPPORTED_EAPIS: 7 8`) into `eclass/java-ant-2.eclass`, with a header noting
where it came from. That is the standard advice for overlays that still need a
removed eclass, and it is what this overlay already does for
`cmake-utils.eclass`, `kde4-*.eclass`, etc.

### 3.4 `eclass/user.eclass` — EAPI 8 spam on `kde-plasma/kdm`

The vendored `user.eclass` kept Gentoo's GLEP 81 EAPI-8 branch:

```bash
8)  if [[ ${CATEGORY} != acct-* ]]; then
        eerror "In EAPI ${EAPI}, packages must not inherit user.eclass"
        ...
    fi ;;
```

`kde-plasma/kdm` inherits it to create the `kdm` user, so metadata generation
emitted 5 `eerror` lines. Since no `acct-user/kdm`/`acct-group/kdm` package
exists in Gentoo (kdm left the tree in 2015, before the GLEP 81 migration),
creating the account at install time is the only workable option here. The
EAPI-8 branch now accepts the EAPI with a comment explaining why.

*(A GLEP 81 port would mean shipping `acct-user/kdm` + `acct-group/kdm` in this
overlay and adding the `acct-user`/`acct-group` categories — a bigger,
optional change.)*

### 3.5 `sys-power/kpowersave` inherited a KDE 3 eclass that no longer exists

`inherit kde` + `need-kde 3.5` — `kde.eclass` was removed from Gentoo in 2015,
and `need-kde` is an undefined command at global scope, so this ebuild failed
the metadata phase outright. Removed both (plus the KDE 3 `ARTS_REQUIRED`
variable) and replaced `info` (also a KDE 3 eclass function) with `einfo`.

The package is still unbuildable — it depends on `sys-apps/hal`,
`dev-libs/dbus-qt3-old` and `kdelibs-3` — so it is now metadata-clean but
historically inert; a `metadata.xml` was added noting that.

### 3.6 `dev-qt/qt1`: `dolib` is banned in EAPI 7+

```diff
-	dolib src/libqt.so*
+	dolib.so src/libqt.so*
```

### 3.7 `dev-libs/libindicate-qt`: `virtualmake` dies above EAPI 5

```diff
-	VIRTUALX_COMMAND="ctest ${ctestargs}" virtualmake || die
+	virtx ctest ${ctestargs} || die
```

### 3.8 Four packages had no `metadata.xml`

Added well-formed ones (portage requires the file, and its absence is a
`pkgcheck` error): `kde-apps/kipi-plugins`, `media-gfx/digikam`,
`media-libs/opencv`, `sys-power/kpowersave`.

### 3.9 `profiles/use.desc` was not valid `use.desc` syntax

55 lines were bare flag names with no description:

```
# dropped 2017-12-27 in 2dbbacd
linguas_ar          <- no " - description"
```

The file's own convention (see the `kontact` and `qt4` entries below them) is
an active entry with a description. All 55 `linguas_*` flags are real: they are
declared in `IUSE` by `kde-apps/kde4-l10n` (`IUSE="${IUSE} linguas_${MY_LANG}"`)
and `kde-misc/kdesudo`. They now carry descriptions borrowed from Gentoo's own
`profiles/desc/l10n.desc`, in the required `flag - description` form, with CRLF
preserved.

### 3.10 `metadata/layout.conf` was 2020-era

```ini
masters = gentoo

cache-formats = md5-dict        # lets eix/emerge read a prebuilt cache
eapis-banned = 0 1 2 3 4 5 6    # Council 2023-07-11
eapis-deprecated = 7            # Council 2025-07-13
thin-manifests = true
sign-manifests = false
update-changelog = false
```

`cache-formats = md5-dict` matters: once you run `egencache` (§5), `eix-update`
stops sourcing 589 ebuilds and simply reads the cache — fast, silent, and the
tool for *finding* metadata failures becomes `egencache`, not eix.

### 3.11 Repository hygiene

* **Removed `kde-sunset-master/`** — the leftover of extracting a
  `kde-sunset-master.tar.gz`; it contained only `.mailmap`, and it was being
  parsed as a category directory.
* **Moved `.backup_20251130_1032/` out of the overlay** to
  `../kde-sunset-repair/backup-20251130_1032/`. It held 589 loose ebuilds at
  the repository root (portage ignores dot-directories, so it was not causing
  the eix errors, but it is what `c055db8f` churned and it confuses every
  grep/scan). Undo with `mv ../kde-sunset-repair/backup-20251130_1032 .` or
  `git checkout -- .backup_20251130_1032`.
* Left `Documentation/` (upstream maintainer scripts) and `patchsets/` (your
  gcc-15 patch collection) in place. Both are non-category directories, so
  `pkgcheck` flags them (`UnknownCategoryDirs` / invalid category name);
  portage and eix ignore them because `profiles/categories` exists. Move them
  out if you want a zero-warning `pkgcheck` run.

---

## 4. Verification: what was checked here, and what was not

**Not possible in this environment.** This is a Windows checkout with no
portage, no `eix`, no `pkgcheck` and no Gentoo tree. I could not run
`egencache`, `eix-update` or `emerge`, so I am **not** claiming the overlay is
proven clean — only that every class of defect I can detect statically is
gone.

**What was run.**

1. `bash -n` on all 589 ebuilds and all 19 eclasses — no syntax errors.
2. `check-overlay.py` (below), which resolves the *transitive* eclass graph
   against a real current Gentoo tree (shallow partial clone of
   `gentoo/gentoo`, `eclass/` + `profiles/` + `metadata/`) and checks EAPI
   guards, helper reachability, categories, manifests, `metadata.xml`,
   `profiles/`, and ebuild/package name agreement.

Real finding classes, before → after:

```
  eclass-eapi-mismatch       5 direct  ->  0      (+472 ebuilds transitively, see note)
  eclass-missing             3         ->  0
  banned-helper              1         ->  0
  missing-metadata-xml       4         ->  0
  profile-bad-line          56         ->  0
  missing-eapi               0         ->  0
  bash-syntax                0         ->  0
  mismatched-ebuild-name     0         ->  0
  eclass-no-eapi-info        5         ->  0      (kde5*/virtualdbus now moot or guarded)
  missing-manifest           1         ->  1      (genuine, see §6.2)
  unknown-category-dir       1         ->  1      (patchsets/, informational)
  invalid-category-name      1         ->  1      (Documentation/, informational)
  unused-eclass              0         ->  5      (informational)
```

The first scan (with an earlier revision of the checker) also reported
`missing-metadata-var` ×1320 and `missing-file-in-filesdir` ×34; **both were
checker bugs, not overlay bugs**, and were eliminated: the first because
metadata variables are legitimately set by inherited eclasses, the second
because the regex was matching `files/…` inside `SRC_URI` URLs and inside
commented-out code. The transitive EAPI check was added afterwards, which is
why the 472-ebuild blast radius is not in the before column.

Re-run it any time (paths are the two checkouts):

```bash
python3 check-overlay.py . --ref /path/to/gentoo
```

**What proves it on your machine.** `verify-on-gentoo.sh` — copy the overlay
to the box and run it from inside the checkout:

```bash
cd /var/db/repos/kde-sunset && ./verify-on-gentoo.sh
```

It runs `egencache --update` for every ebuild (this *is* the metadata phase, so
a failure names the offending ebuild), then `eix-update`, then a targeted
`ebuild <file> depend` smoke test over the packages that used to fail, then
`pkgcheck scan`. Exit status 0 means no metadata failures.

---

## 5. Order of operations on the Gentoo box

```bash
# 1. register the overlay (if not already done)
#    /etc/portage/repos.conf/kde-sunset.conf
#      [kde-sunset]
#      location = /var/db/repos/kde-sunset
#      auto-sync = no
#      masters = gentoo

# 2. generate the metadata cache (authoritative metadata test, a few minutes)
egencache --repo kde-sunset --update --jobs "$(nproc)"

# 3. eix now reads the cache instead of sourcing ebuilds
eix-update

# 4. QA scan (optional; warnings are fine, errors are not)
pkgcheck scan --repo kde-sunset --exit error

# 5. sanity-check dependency resolution
emerge --pretend --verbose kde-apps/kde-meta:4
```

If step 2 prints error blocks, that is a real defect in an ebuild — the log
line names it.

---

## 6. Remaining blockers (not fixable by static analysis)

### 6.1 The Qt 4 patch bundle is unfetchable — the real blocker

`eclass/qt4-build-multilib.eclass`:

```bash
PATCH_VERSION="1"
PATCHNAME="${MY_P}-patches-${PATCH_VERSION}"
SRC_URI="
    http://download.qt.io/official_releases/qt/${PV%.*}/${PV}/${MY_P}.tar.gz
    mirror://kde-sunset/${PATCHNAME}.tgz"

qt4-build-multilib_src_prepare() {
    ...
    eapply "${WORKDIR}/patch/fix-build-icu59.patch"
    eapply "${WORKDIR}/patch/qt4-openssl-1.1.patch"
    eapply "${WORKDIR}/patch/CVE-2018-19873.patch"
    ... CVE-2018-19872 / 19871 / 19870 / 19869 / 15518 ...
}
```

`profiles/thirdpartymirrors`:

```
kde-sunset http://mirror.krakonos.org/kde-sunset ftp://punk.uchicago.edu/pub/kde-sunset http://punk.uchicago.edu/pub/kde-sunset http://mirror.hasnoname.de/kde-sunset
```

Checked 2026-10-11: `mirror.krakonos.org` → 404, `mirror.hasnoname.de` → 403,
`punk.uchicago.edu` → 404. `qt-everywhere-opensource-src-4.8.7-patches-1.tgz`
is **9 KB** and is listed in the Manifests, so its hashes are known, but there
is no live copy I could find (not on `distfiles.gentoo.org`). Since the patch
files exist nowhere in the tree either, `dev-qt/qtcore` — and therefore all 19
`dev-qt/qt*` split packages and the entire KDE 4 stack — cannot be fetched or
built until this is resolved.

Two ways out:

1. **Restore the bundle (no code change).** It is small; check an old KDE 4
   install's `/var/cache/distfiles/`, a distfiles backup, or any archived
   `kde-sunset` mirror. Drop the file into `DISTDIR` and portage proceeds.
2. **Re-home the patches into the overlay (no network dependency).** Two of the
   eight already exist under different names in `dev-qt/qtcore/files/`
   (`qtcore-4.8.7-icu-59.patch`, `qtcore-4.8.7-openssl-1.1.patch`); the six
   `CVE-2018-*` patches are public Qt 4 security fixes. Put all eight in
   `dev-qt/qtcore/files/`, change the `eapply` lines to `${FILESDIR}`, and drop
   the dead `mirror://kde-sunset/` entry from `SRC_URI` and from the Manifests.
   That removes `mirror://kde-sunset` from the overlay entirely (only
   `x11-libs/qscintilla` also uses it, and it has a live upstream URL as the
   first `SRC_URI` entry).

### 6.2 `sys-power/kpowersave` has no `Manifest`

It fetches `mirror://sourceforge/powersave/…`, `mirror://gentoo/kde-admindir-3.5.5.tar.bz2`
and a Debian `.diff.gz`, but the directory has no Manifest. With
`use-manifests` defaulting to `strict`, portage refuses to build it. Either

```bash
pkgdev manifest sys-power/kpowersave    # or: ebuild <path> digest
```

or delete the package (it cannot build on 2026 Gentoo anyway — HAL, KDE 3).

### 6.3 Your gcc-15 patchsets are not wired in

`patchsets/gcc-fixes/kdelibs-gcc15.patch`, `patchsets/gcc-fixes/qt4-gcc15.patch`
and `patchsets/qt4-aur/qt4-aur.tar.gz` are referenced by **no** ebuild's
`PATCHES` or `SRC_URI`, so they are never applied. Given that GCC 15 defaults
to C23 (no implicit function declarations, stricter C++ diagnostics), these
are exactly the patches a 2026 build needs — they just have to be connected to
`dev-qt/qtcore` / `kde-frameworks/kdelibs`.

### 6.4 Two overlay eclasses shadow current Gentoo ones

`qmake-utils.eclass` and `virtualx.eclass` also exist in `gentoo.git`. Both
shadowings are intentional here (the overlay copies carry Qt 4 helpers that
modern `qmake-utils` dropped, and the KDE 4 `virtualx` behaviour described in
§3.1), but they are a divergence risk: Gentoo's versions keep evolving and
these copies will not. `pkgcheck` reports the shadowing.

### 6.5 Dead eclasses left in place

`kde5.eclass`, `kde5-functions.eclass`, `kde5-meta-pkg.eclass`,
`versionator.eclass` and `virtualdbus.eclass` are inherited by no ebuild. They
are now EAPI-8-safe thanks to §3.1/§3.2, so they are harmless, but they are
KDE 5 leftovers in a KDE 4 overlay and can be deleted.

### 6.6 Beyond repository validity

Making the repo *readable* is different from making KDE 4 *build* on 2026
Gentoo. Expect build-level work in: OpenSSL 3 (`qt4-openssl-1.1.patch` is not
OpenSSL 3), ICU ≥ 70, Boost ≥ 1.85, GCC 15/C23, `dev-libs/dbus-glib`,
`sys-apps/hal` (gone), and the old `dev-qt/qtwebkit-4.x` against modern libs.
`emerge -p kde-apps/kde-meta:4` will surface these as dependency errors, one
at a time.

---

## 7. Files changed

```
eclass/virtualx.eclass                                EAPI 8 accepted
eclass/versionator.eclass                             EAPI 7/8 accepted
eclass/user.eclass                                    EAPI 8 accepted for non-acct categories
eclass/java-ant-2.eclass                              NEW - vendored last upstream revision
metadata/layout.conf                                  cache-formats, eapis-banned/deprecated, ...
profiles/use.desc                                     55 malformed lines given descriptions
dev-qt/qt1/qt1-9999.ebuild                            dolib -> dolib.so
dev-libs/libindicate-qt/…-0.2.5.91.ebuild             virtualmake -> virtx
app-backup/qt4-fsarchiver/…-0.6.19.7.ebuild           versionator -> ver_* builtins
kde-misc/plasmatvgr/…-0.47.ebuild                     versionator -> ver_* builtins
kde-misc/stdin-plasmoid/…-0.2_beta1.ebuild            versionator -> ver_* builtins
app-editors/okteta/okteta-4.14.3.ebuild               ver_cut
app-text/kjots/…_pre20160611.ebuild                   ver_cut
kde-plasma/drkonqi/{4.14.3,16.04.3}.ebuild            ver_cut
sci-astronomy/kstars/kstars-4.14.3-r1.ebuild          ver_cut
sys-power/kpowersave/…-0.7.3-r2.ebuild                dropped KDE 3 kde.eclass usage
{4 packages}/metadata.xml                             NEW
removed  kde-sunset-master/
moved    .backup_20251130_1032/  ->  ../kde-sunset-repair/
```

Nothing is committed or pushed. `git status` shows the changes unstaged so you
can review them; the two deletions are `git checkout`-able.

## Line endings: the entire repository was CRLF

The September 2026 commit ("fixes for september 2026") rewrote 2725 files with
CRLF line endings.  On the target host that is a defect, not cosmetics:

* bash on Linux keeps the trailing CR as part of the shell word, so a line
  `EAPI=8` written as `EAPI=8\r` assigns the literal string `8\r`;
* Portage parses the EAPI line with the PMS 7.3.1 pattern in
  `lib/portage/__init__.py` (`_pms_eapi_re`), whose value character class
  `[A-Za-z0-9+_.-]` does not contain CR, so EAPI detection can fail outright for
  every ebuild in the tree;
* every metadata value that bash assigns (KEYWORDS, IUSE, SRC_URI, DEPEND,
  DESCRIPTION, ...) can carry a trailing CR into the md5-cache and into every
  tool that consumes it.

`c5e69c0a` restores LF for all 2725 text files; blob content is otherwise
unchanged.  The 6 binary files (PNG icons, qt4-aur tarball) and the 7 files that
were already LF were left untouched.  The overlay is now LF everywhere: 2739
text blobs, 0 containing CR.

## Qt 4 and KDE 4 patch sets, rebuilt from live sources

The blocker in the previous section is gone. `qt-everywhere-opensource-src-4.8.7-patches-1.tgz`
now exists, is built from sources that are still live, and is committed to this
repository as `patchsets/qt-everywhere-opensource-src-4.8.7-patches-1.tgz`; the
dead `kde-sunset` mirrors in `profiles/thirdpartymirrors` now point at this
repository's raw URL. The 22 `dev-qt/*` Manifests carry the new checksum.

`eclass/qt4-build-multilib.eclass` applies 13 patches with explicit strip levels
(the old list referenced a bundle nobody could fetch, asked for a
`CVE-2018-19872` patch that has never been published, and relied on whatever
fuzz the missing tarball happened to give) and then the build fixes for a
C++17 toolchain that the AUR qt4 PKGBUILD carries as `sed` edits. What the set
contains and where each patch comes from is tabulated in
[patchsets/README.md](patchsets/README.md).

Three pre-existing bugs surfaced while doing this, all of which would have
stopped the build before any patch content mattered:

* `qtcore-4.8.5-qeventdispatcher-recursive.patch`,
  `qtdbus-4.7-qdbusintegrator-no-const.patch`,
  `assistant-4.8.2+gcc-4.7.patch` and `4.8.2-javascriptcore-x32.patch` are not
  `-p1` compatible but were listed in `PATCHES`, so `eapply` would fail. They
  now run from `src_prepare` as `eapply -p0`.
* `qtcore-4.8.7-libressl.patch` does not apply to the released 4.8.7 tree at any
  strip level and `qtcore-4.8.7-moc.patch` only applies when the AUR's
  `moc-boost-workaround` has not been applied first. The shared set now carries
  the OpenSSL work and the moc work stays with the per-package patch, so the two
  never overlap.
* The AUR patches that this overlay already carried per-package (cups, systray,
  the glib-event-loop pair, the clipboard pair, JIT) are deliberately **not** in
  the shared set: applying both copies makes `eapply` fail, and each is listed in
  `patchsets/README.md`.

For the AUR `kdelibs` and `kdebase-workspace` packages named in the same request,
the three non-Arch-specific kdelibs patches (`ordered`, `klocale-kde`,
`libjasper-functions`) and the startkde/kdm patches (`dbus-update-environment`,
`etc-scripts`, `terminate-server`) are now wired in. `kdm-xinitrd` is skipped
because `kdm-4-gentoo-xinitrc.d.patch` already generates the same
`/etc/X11/xinit/xinitrc.d` loop; the Arch menu patches, `no-webkit` and
`khotkeys-qt4` are Arch-specific and skipped.

**What is proven.** Every patch in the shipped bundle was applied, in the eclass's
own order and at the eclass's own strip level, to a freshly extracted
`qt-everywhere-opensource-src-4.8.7` tree (tarball size 241075567 bytes, matching
this overlay's Manifest): 13/13 patches apply and all 15 `sed` statements run
clean, with no `.rej` files. The same was done for the per-package patch lists of
all 22 `dev-qt/*` packages and for `kdelibs-4.14.38`, `kdm-4.11.22` and
`kdebase-startkde-4.11.22`.

**What is not proven.** Nothing was compiled. Whether Qt 4.8.7 with this patch
set survives GCC 15, glibc 2.4x, ICU 7x and OpenSSL 3 is exactly what
`./verify-on-gentoo.sh` and then a real `emerge` have to show; a patch that
applies is not a patch that builds. `CVE-2018-19872` remains unfixed for lack of
a published patch.
