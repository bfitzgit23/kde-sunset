# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils multilib

MY_PN="chromium"
MY_ARCHIVE="${MY_PN}-${PV}-1-x86_64.pkg.tar.zst"

DESCRIPTION="Open-source Chromium web browser (prebuilt Arch Linux binary)"
HOMEPAGE="https://www.chromium.org/"
LIBJPEG_PV="3.2.1"
LIBJPEG_ARCHIVE="libjpeg-turbo-${LIBJPEG_PV}-1-x86_64.pkg.tar.zst"

SRC_URI="
	https://archive.archlinux.org/packages/c/${MY_PN}/${MY_ARCHIVE} -> ${P}-x86_64.pkg.tar.zst
	https://archive.archlinux.org/packages/l/libjpeg-turbo/${LIBJPEG_ARCHIVE}
"

LICENSE="BSD IJG"
SLOT="0"
KEYWORDS="amd64"

IUSE=""

BDEPEND="app-arch/zstd"

RESTRICT="strip"
QA_PREBUILT="
	usr/bin/chromedriver
	usr/lib/chromium/*
	usr/lib/libjpeg.so.8*
"

RDEPEND="
	app-accessibility/at-spi2-core
	app-arch/brotli
	app-arch/zstd
	dev-libs/double-conversion
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libffi
	dev-libs/libgcrypt:0
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/nspr
	dev-libs/nss
	dev-cpp/highway
	=dev-cpp/simdutf-9.2.1
	dev-util/desktop-file-utils
	media-libs/alsa-lib
	media-libs/dav1d
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libjpeg-turbo
	media-libs/libva
	media-libs/libwebp
	media-libs/mesa
	media-libs/openh264
	media-libs/opus
	media-video/pipewire
	net-print/cups
	sys-apps/dbus
	sys-apps/pciutils
	sys-libs/zlib[minizip]
	virtual/udev
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-misc/xdg-utils
	x11-themes/hicolor-icon-theme
"

S="${WORKDIR}"

src_unpack() {
	# Arch ships a zstd-compressed tarball; do not rely on tar(1) having
	# zstd support compiled in or on app-arch/zstd already being present.
	# DISTDIR may contain a symlink; -f makes zstd follow it.
	local chromium_archive="${DISTDIR}/${P}-x86_64.pkg.tar.zst"
	local libjpeg_archive="${DISTDIR}/${LIBJPEG_ARCHIVE}"
	zstd -dcf "${chromium_archive}" | tar -x -C "${WORKDIR}" || die
	mkdir -p "${WORKDIR}/libjpeg" || die
	zstd -dcf "${libjpeg_archive}" | tar -x -C "${WORKDIR}/libjpeg" || die
}

src_install() {
	local launcher="${T}/chromium"

	# The Arch package is a complete, prebuilt /usr tree.
	dodir /usr
	cp -a usr/. "${ED%/}/usr/" || die

	# Chromium was built against Arch's JPEG8 ABI; Gentoo's libjpeg-turbo
	# provides libjpeg.so.62, so install the exact ABI privately.
	local libjpeg_so
	libjpeg_so=$(find "${WORKDIR}/libjpeg/usr/lib" -maxdepth 1 -type f -name "libjpeg.so.8.*" -print -quit)
	if [[ -z ${libjpeg_so} ]]; then
		libjpeg_so=$(find "${WORKDIR}/libjpeg/usr/lib" -maxdepth 1 -type f -name "libjpeg.so.8" -print -quit)
	fi
	[[ -n ${libjpeg_so} ]] || die "libjpeg.so.8 not found in ${LIBJPEG_ARCHIVE}"
	dolib.so "${libjpeg_so}" || die
	if [[ ${libjpeg_so##*/} != libjpeg.so.8 ]]; then
		dosym "${libjpeg_so##*/}" "/usr/$(get_libdir)/libjpeg.so.8" || die
	fi

	# Chromium's sandbox helper must be root-owned and setuid.
	fperms 4755 /usr/lib/chromium/chrome-sandbox || die

	# Replace Arch's launcher so the build is not reported as "Arch Linux".
	cat > "${launcher}" <<-'EOF' || die
		#!/bin/sh
		exec /usr/lib/chromium/chromium "$@"
	EOF
	exeinto /usr/bin
	newexe "${launcher}" chromium
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	elog "Chromium was installed from the Arch Linux binary package."
	elog "Its setuid sandbox helper is /usr/lib/chromium/chrome-sandbox (4755)."
	elog "To disable it, run: chmod 0755 /usr/lib/chromium/chrome-sandbox"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
