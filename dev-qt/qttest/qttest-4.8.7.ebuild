# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
qt4-build-multilib

DESCRIPTION="The QtTest module for unit testing Qt applications and libraries"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
 KEYWORDS="amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc x86"
fi

IUSE=""

DEPEND="
 ~dev-qt/qtcore-${PV}[debug=,${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="src/testlib"

multilib_src_configure() {
 local myconf=(
 -no-xkb -no-fontconfig -no-xrender -no-xrandr -no-xfixes -no-xcursor
 -no-xinerama -no-xshape -no-sm -no-opengl
 -no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
 -no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
 -no-qt3support -no-xmlpatterns -no-freetype -no-libtiff
 -no-accessibility -no-fontconfig -no-glib -no-svg
 )
 qt4_multilib_src_configure
}
