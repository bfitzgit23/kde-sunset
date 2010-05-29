# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/poppler/poppler-0.12.4-r2.ebuild,v 1.1 2010/04/10 02:13:17 reavertm Exp $

EAPI="2"

inherit cmake-utils qt3

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI="http://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+abiword cairo cjk debug doc exceptions jpeg jpeg2k +lcms png qt3 qt4 +utils +xpdf-headers"

COMMON_DEPEND=">=media-libs/fontconfig-2.6.0
	>=media-libs/freetype-2.3.9
	sys-libs/zlib
	abiword? ( dev-libs/libxml2:2 )
	cairo? ( dev-libs/glib:2
			 >=x11-libs/cairo-1.8.4
			 >=x11-libs/gtk+-2.14.0:2 )
	jpeg? ( >=media-libs/jpeg-7:0 )
	jpeg2k? ( media-libs/openjpeg )
	lcms? ( media-libs/lcms )
	png? ( media-libs/libpng )
	qt3? ( >=x11-libs/qt-3.3:3 )
	qt4? ( x11-libs/qt-core:4
		   x11-libs/qt-gui:4 )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	!dev-libs/poppler
	!dev-libs/poppler-glib
	!dev-libs/poppler-qt3
	!dev-libs/poppler-qt4
	!app-text/poppler-utils
	cjk? ( >=app-text/poppler-data-0.2.1 )"

DOCS="AUTHORS ChangeLog NEWS README README-XPDF TODO"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.12.3-cmake-disable-tests.patch
	epatch "${FILESDIR}"/${PN}-0.12.3-fix-headers-installation.patch
	epatch "${FILESDIR}"/${PN}-0.12.3-gdk.patch
	epatch "${FILESDIR}"/${PN}-0.12.3-darwin-gtk-link.patch
	epatch "${FILESDIR}"/${P}-config.patch  #304407
	epatch "${FILESDIR}"/${PN}-0.12.3-cairo-downscale.patch  #303817
	epatch "${FILESDIR}"/${PN}-0.12.3-preserve-cflags.patch  #309297
	epatch "${FILESDIR}"/${PN}-0.12.4-nanosleep-rt.patch
}

src_configure() {
	mycmakeargs=(
		-DBUILD_GTK_TESTS=OFF
		-DBUILD_QT4_TESTS=OFF
		$(cmake-utils_use_with qt3)
		-DENABLE_SPLASH=ON
		-DENABLE_ZLIB=ON
		$(cmake-utils_use_enable abiword)
		$(cmake-utils_use_enable lcms)
		$(cmake-utils_use_enable jpeg2k LIBOPENJPEG)
		$(cmake-utils_use_enable utils)
		$(cmake-utils_use_enable xpdf-headers XPDF_HEADERS)
		$(cmake-utils_use_with cairo)
		$(cmake-utils_use_with cairo GTK)
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with png)
		$(cmake-utils_use_with qt4)
		$(cmake-utils_use exceptions USE_EXCEPTIONS)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use cairo && use doc; then
		# For now install gtk-doc there
		insinto /usr/share/gtk-doc/html/poppler
		doins -r "${S}"/glib/reference/html/* || die 'failed to install API documentation'
	fi
}

pkg_postinst() {
	ewarn 'After upgrading app-text/poppler you may need to reinstall packages'
	ewarn 'depending on it. If you have gentoolkit installed, you can find those'
	ewarn 'with `equery d poppler`.'
}