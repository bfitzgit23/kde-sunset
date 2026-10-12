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
| `qt4-gcc6.patch` | 1 | AUR `qt4` | GCC 6 build failure in `configure` |
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
