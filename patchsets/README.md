# Vendored patch bundles

## `qt-everywhere-opensource-src-4.8.7-patches-1.tgz`

This is the patch bundle that `eclass/qt4-build-multilib.eclass` extracts into
`${WORKDIR}/patch/` for every `dev-qt/qt*` module. The bundle the overlay used to
fetch (`mirror://kde-sunset/…`) is gone: all three mirrors in
`profiles/thirdpartymirrors` have returned 404/403 for years and the file is not
on `distfiles.gentoo.org`. This copy is rebuilt from live sources and is now
served from this repository's own raw GitHub URL:

    profiles/thirdpartymirrors:  kde-sunset https://raw.githubusercontent.com/bfitzgit23/kde-sunset/master/patchsets

Contents (`patch/`, applied in the order listed in the eclass):

| patch | -p | source | what it fixes |
|---|---|---|---|
| `qt4-gcc6.patch` | 1 | AUR `qt4` | `configure` recognises GCC 6, 7 and 8 (plus the XML Patterns shift overflow) |
| `qt4-gcc10.patch` | 1 | PLD Linux `qt4` + this overlay | extends that same version list to two-digit GCC (10 and up) in both places it appears — see "Modern toolchain" below |
| `qt4-gcc9.patch` | 0 | AUR `qt4` | GCC 9 build failure (`qglobal.h`) |
| `qt4-gcc11.patch` | 0 | AUR `qt4` | GCC 11 build failure (`linguist`) |
| `qt4-glibc-2.25.patch` | 1 | AUR `qt4` (Fedora) | glibc 2.25 `sysmacros.h` breakage; **only the `qglobal.h` half is kept** — the `src/tools/moc/main.cpp` half is already done by `dev-qt/qtcore/files/qtcore-4.8.7-moc.patch`, which is a superset of the AUR `moc-boost-workaround.patch` |
| `qt4-icu59.patch` | 1 | AUR `qt4` (pld-linux) | ICU 59+ build failure (was `fix-build-icu59.patch`) |
| `qt4-openssl-1.1.patch` | 1 | AUR `qt4` (Debian + OpenMandriva) | OpenSSL 1.1/3 support; supersedes the per-package `qtcore-4.8.7-openssl-1.1.patch` / `libressl` patches so that every qt4 module gets it |
| `disable-sslv3.patch` | 1 | AUR `qt4` | build against OpenSSL built with `OPENSSL_NO_SSL3` |
| `kde4-settings.patch` | 0 | AUR `qt4` (Kubuntu) | `src/gui/kernel/qkde.cpp` settings integration (FS#45106) |
| `CVE-2018-19869.patch` | 1 | upstream Qt / Mageia via `slowphil/mingw-w64-qt4` | SVG malformed url reference crash |
| `CVE-2018-19870.patch` | 1 | ditto | GIF handler QImage allocation failure |
| `CVE-2018-19871.patch` | 1 | ditto | TGA handler out-of-range image size |
| `CVE-2018-19873.patch` | 1 | ditto | BMP handler out-of-range image size |
| `CVE-2018-15518.patch` | 1 | ditto | heap corruption in `QXmlStream` |

`patchsets/qt4/` holds the same 13 patches as loose files so the bundle can be
rebuilt and reviewed:

    tar --sort=name --owner=0 --group=0 --numeric-owner \
        --mtime='2026-10-11 12:00:00 UTC' -czf \
        patchsets/qt-everywhere-opensource-src-4.8.7-patches-1.tgz patch

(rename `patchsets/qt4` to `patch` first). Every `dev-qt/*/Manifest` carries the
matching `DIST` line — **regenerate it (`pkgdev manifest`) after touching the
bundle**, otherwise portage refuses the fetch.

### Deliberately not in the bundle

* **`CVE-2018-19872`** — the `qppmhandler` division by zero. No patch for Qt 4.8.7
  was ever published anywhere I could fetch; the eclass applies the other five.
* **AUR patches this overlay already carries per-package** (adding them twice
  makes `eapply` fail, which is why they are not in the shared set):
  `improve-cups-support` ⊂ `qtgui-4.7.3-cups.patch`,
  `kubuntu_14_systemtrayicon` ⊂ `qtgui-4.8.6-systemtrayicon-plugin-system.patch`,
  `glib-honor-ExcludeSocketNotifiers-flag` ⊂
  `qtcore-4.8.5-honor-ExcludeSocketNotifiers-in-glib-event-loop.patch`,
  `l-qclipboard_fix_recursive` ⊂ `qtcore-4.8.5-qeventdispatcher-recursive.patch`,
  `l-qclipboard_delay` ⊂ `qtgui-4.8.5-qclipboard-delay.patch`,
  `moc-boost-workaround` ⊂ `qtcore-4.8.7-moc.patch`,
  `fix_jit` / `qt4-gcc8` ⊂ `qtscript-5.11.3-gcc-8.3.patch` and
  `4.8.6-javascriptcore-x32.patch`.

## Modern toolchain (GCC 10–15)

**`configure` did not recognise GCC 10 or later.** Qt 4.8.7 matches the compiler
version with a glob list (`5*|4*|3.4*`), and the AUR's `qt4-gcc6.patch` extends
it only to `8*|7*|6*|5*|4*|3.4*`. Neither matches a two-digit version:

| GCC version | `8*|7*|6*|5*|4*|3.4*` (before) | `[1-9][0-9]*|9*|8*|…` (after) |
|---|---|---|
| 4.8, 5, 8 | match | match |
| 9 | **no match** | match |
| 10, 11, 13, 15 | **no match** | match |

An unmatched version falls into `configure`'s `*)` case, which sets
`canBuildWebKit="no"` **and** `canBuildQtXmlPatterns="no"`, so those modules
were silently dropped for every GCC from 10 up; the later `COMPILER_VERSION`
case then leaves the version unmapped instead of reducing it to Qt's `"4"`.
`qt4-gcc10.patch` fixes both: its first hunk is PLD Linux's own `gcc9.patch`
verbatim, the second extends the same treatment to the `COMPILER_VERSION`
mapping, which PLD's patch misses.

The eclass used to "teach configure about gcc-6 and later" with
`sed -i -e 's:5\*|:[5-9]*|:'`, which rewrote those same two lines (to
`[5-9]*|4*|3.4*` — still no two-digit match) *before* the patch set ran. Since
`qt4-gcc6.patch` expects the unmodified text, that sed made **both** of its
`configure` hunks fail, and `eapply` dies on failure, so every `dev-qt/qt*` build
stopped in `src_prepare`. The sed is gone: the patch set owns those lines now,
and `verify-patchsets.py` replays the whole pipeline (seds, bundle, per-package
patches) so this cannot regress unnoticed.

**GCC 14/15 and C23.** GCC 14 makes implicit function declarations in C an error
and GCC 15 defaults C to C23, which the bundled 3rdparty C sources predate, so
the eclass appends `-Wno-error=implicit-function-declaration` for GCC 14 and up.
This is a pre-emptive guard taken from the GCC 14 porting guide and is **the one
change here that was not reproduced** — there is no compiler on the machine this
was prepared on. Drop it if a real build shows it is unnecessary.

**A dead patch that blocked `qtcore`.** `dev-qt/qtcore/files/gcc-algorithm-fix.patch`
had a hunk header claiming six old and seven new lines but carried only three
and four, so `patch` reports `unexpected end of file in patch`, and the context
it wants (`#include <stdio.h>` then `#include <string.h>` inside `qstring.h`)
does not exist in 4.8.7 at all. `eapply` dies on that, so every `qtcore` build
stopped there. The file and its three `eapply` lines are gone; nothing in
`src/corelib/tools` uses a `std::` algorithm without including `<algorithm>`, so
nothing is lost. If a real build does report such an error, that is where the
include belongs.

### Considered and rejected

* PLD's `qt-less-warnings` and `webkit-no_Werror` — `dev-qt/qtwebkit-4.8.7`
  already strips `-Werror` from `WebKit.pri` in its own `src_prepare`, and the
  standalone 4.10.4 tarball never adds it.
* PLD's `qt-asm-volatile` — the same `asm volatile` → `asm` fix is already in
  `dev-qt/qtscript/files/qtscript-5.11.3-gcc-8.3.patch`.
* PLD's `cxx11.patch` — its TR1/`auto_ptr`/accessibility hunks are exactly what
  the eclass's "JavaScriptCore mess" seds already do.
* OpenMandriva's `gcc8_qtscript` — an `-O1` workaround for a GCC 8 miscompile.
* No GCC 14/15-specific Qt 4.8.7 patch exists to vendor: the newest Qt4 compiler
  fixes in Alpine, Debian, Ubuntu, Fedora, PLD, OpenMandriva and Qt's own 4.8
  branch are the GCC 6/9/11 ones already carried here.

## AUR `kdelibs` and `kdebase-workspace`

The AUR packages named in the same request supply patches for two other packages
in this overlay. Only the ones that are not Arch-specific were taken, and each
is applied at the strip level the AUR uses:

| file added under `files/` | -p | ebuild |
|---|---|---|
| `kdelibs-4.14.38-ordered.patch` | 1 | `kde-frameworks/kdelibs/kdelibs-4.14.38-r1.ebuild` |
| `kdelibs-4.14.38-klocale-kde.patch` | 1 | ditto |
| `kdelibs-4.14.38-libjasper-functions.patch` | 1 | ditto (fixes `undefined reference to jp2_encode`) |
| `kdebase-startkde-4.11.22-dbus-update-environment.patch` | 1 | `kde-plasma/kdebase-startkde` r2/r3 |
| `kdebase-startkde-4.11.22-etc-scripts.patch` | 0 | ditto (startkde reads `/etc/kde/lib`) |
| `kdm-4.11.22-terminate-server.patch` | 0 | `kde-plasma/kdm` |
| `kdelibs-4.14.38-build.patch` | 1 | `kde-frameworks/kdelibs` (PLD Linux, see below) |
| `kdelibs-4.14.38-jasper-const-write.patch` | 1 | ditto (const-correct JasPer 2.x write callback) |

The AUR's own `patch-klocale-kde.cpp.patch` carries no trailing newline, which
makes `patch` report "unexpectedly ends in middle of line" and apply its hunk
with fuzz 1. The vendored copy is identical apart from one trailing `\n`, so it
now applies cleanly (verified both ways against `kdelibs-4.14.38`).

Skipped on purpose: Arch's menu patches (`kde-applications-menu`,
`archlinux-menu`), `kdelibs-no-kdewebkit` and `no-webkit` (they exist only
because Arch's kdelibs has no `kdewebkit`; this overlay has one),
`khotkeys-qt4` (renames `qdbusviewer` to Arch's `qdbusviewer-qt4`),
`kdelibs-openssl-1.1` (`kdelibs-4.14.37/38-openssl-1.1.patch` is here already)
and `kdm-xinitrd` (`kdm-4-gentoo-xinitrc.d.patch` already generates the same
`/etc/X11/xinit/xinitrc.d` loop — applying both emits it twice).

PLD Linux's `kde4-kdelibs` `build.patch` touches six files; only two are new
here. `klocale_kde.cpp` is the AUR's `klocale-kde.patch` reached another way,
`kpropertiesdialog.cpp` and `kopenwithdialog.cpp` are `ordered.patch`, and the
`unsigned int cnt` pair in `jp2.cpp` is the overlay's own
`kdelibs-4.14.38-qiodevice.patch`. The one part of that file PLD adds on top,
`const char *buf` on the write callback (what JasPer 2.x now declares), is
vendored on its own as `jasper-const-write`. The AUR's
`CXXFLAGS="-fpermissive -Wno-narrowing"` was **not** copied: this ebuild already
handles those limits surgically with `kdelibs-4.9.3-werror.patch`,
`kdelibs-4.14.5-fatalwarnings.patch` and
`kdelibs-4.14.38-narrowing-warning.patch`.

Both sides are replayable:

    python verify-patchsets.py --qt <qt-everywhere-opensource-src-4.8.7> \
                               --kdelibs <kdelibs-4.14.38>

It applies the eclass seds, the 14-patch bundle at the strip level the eclass
uses, every `dev-qt` package's own patches and all 29 kdelibs patches, in
ebuild order, and exits non-zero on anything that does not apply. The trees it
is given are modified in place, so pass throwaway extractions. Last run: 0
failures on both sides.

## Where these came from

AUR is behind an anti-bot gate for plain HTTP, but its git endpoint is not, so
the patches were taken from real clones:

    git clone --depth 1 https://aur.archlinux.org/qt4.git
    git clone --depth 1 https://aur.archlinux.org/kdelibs.git
    git clone --depth 1 https://aur.archlinux.org/kdebase-workspace.git

(`kdebase-workspace`'s PKGBUILD builds `kde-workspace-4.11.22` from
`download.kde.org/Attic/…`, the same tarball this overlay's `kde4-meta` packages
split — so the patches line up exactly.) The CVE patches come from
`github.com/slowphil/mingw-w64-qt4`, which ports Mageia's Qt 4.8.7 packaging;
their upstream is Qt's own `qt/qt` 4.8 branch.
