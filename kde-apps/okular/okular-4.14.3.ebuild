# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"

#VIRTUALX_REQUIRED=test
RESTRICT=test
# test 2: parttest hangs

inherit kde4-base

DESCRIPTION="Universal document viewer based on KPDF by KDE"
HOMEPAGE="https://okular.kde.org https://www.kde.org/applications/graphics/okular"
KEYWORDS="amd64 x86"
IUSE="chm crypt debug djvu dpi ebook +jpeg mobi +postscript +pdf +tiff"

DEPEND="
	media-libs/freetype
	media-libs/qimageblitz
	sys-libs/zlib
	chm? ( dev-libs/chmlib )
	crypt? ( app-crypt/qca:2-qt4 )
	djvu? ( app-text/djvu )
	dpi? ( kde-plasma/libkscreen:4 )
	ebook? ( app-text/ebook-tools )
	jpeg? (
		$(add_kdeapps_dep libkexiv2)
		virtual/jpeg:0
	)
	mobi? ( $(add_kdeapps_dep kdegraphics-mobipocket) )
	pdf? ( app-text/poppler:0-qt4 )
	postscript? ( app-text/libspectre )
	tiff? ( media-libs/tiff:0 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_chm="$(usex chm)"
		-DWITH_QCA2="$(usex crypt)"
		-DWITH_DjVuLibre="$(usex djvu)"
		-DWITH_LibKScreen="$(usex dpi)"
		-DWITH_EPub="$(usex ebook)"
		-DWITH_jpeg="$(usex jpeg)"
		-DWITH_Kexiv2="$(usex jpeg)"
		-DWITH_QMobiPocket="$(usex mobi)"
		-DWITH_LibSpectre="$(usex postscript)"
		-DWITH_PopplerQt4="$(usex pdf)"
		-DWITH_Poppler="$(usex pdf)"
		-DWITH_tiff="$(usex tiff)"
	)

	kde4-base_src_configure
}
