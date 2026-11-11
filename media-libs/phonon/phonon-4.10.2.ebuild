# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
inherit cmake-multilib qmake-utils

PATCHES=( "${FILESDIR}/${P}-cmake-interface-link.patch" )

DESCRIPTION="KDE multimedia API"
HOMEPAGE="https://community.kde.org/Phonon"
SRC_URI="mirror://kde/stable/phonon/${PV}/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="0-qt4"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="debug designer gstreamer +vlc"

DEPEND="
	!!dev-qt/qtphonon:4
	>=dev-qt/qtcore-4.8.7-r2:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtdbus-4.8.7:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtgui-4.8.7:4[${MULTILIB_USEDEP}]
	designer? ( >=dev-qt/designer-4.8.7:4[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}
	!<media-libs/phonon-4.11:0
"
BDEPEND="virtual/pkgconfig"
PDEPEND="
	gstreamer? ( media-libs/phonon-gstreamer:0-qt4 )
	vlc? ( media-libs/phonon-vlc:0-qt4 )
"

multilib_src_configure() {
	local mycmakeargs=(
		-DPHONON_BUILD_PHONON4QT5=OFF
		-DWITH_QZeitgeist=OFF
		-DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=ON
		-DPHONON_BUILD_DESIGNER_PLUGIN=$(usex designer)
		-DWITH_GLIB2=OFF
		-DWITH_PulseAudio=OFF
		-DQT_QMAKE_EXECUTABLE="$(qt4_get_bindir)"/qmake
	)
	cmake_src_configure
}


