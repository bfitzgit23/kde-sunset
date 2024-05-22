# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt4-build-multilib

DESCRIPTION="The OpenGL module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc x86"
fi

IUSE="egl qt3support"

DEPEND="
	~dev-qt/qtcore-${PV}[debug=,qt3support=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[debug=,egl=,qt3support=,${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.5.0-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXrender-0.9.7-r1[${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/opengl
	src/plugins/graphicssystems/opengl"

QCONFIG_ADD="opengl"
QCONFIG_DEFINE="QT_OPENGL"
PATCHES=( "${FILESDIR}/${PN}-4.8.7-gcc9.patch" )

multilib_src_configure() {
	local myconf=(
		-opengl
		$(qt_use qt3support)
		$(qt_use egl)
	)
	qt4_multilib_src_configure
}

multilib_src_install_all() {
	qt4_multilib_src_install_all

	dodir /usr/share/qt4/graphicssystems
	echo "experimental" > "${ED}"/usr/share/qt4/graphicssystems/opengl || die
}
