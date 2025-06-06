# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

qt4-build-multilib

DESCRIPTION="Demonstration module and examples for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
 KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
fi

IUSE="dbus declarative multimedia opengl phonon webkit xmlpatterns"

DEPEND="
 ~dev-qt/designer-${PV}[debug=,${MULTILIB_USEDEP}]
 ~dev-qt/qtcore-${PV}[debug=,${MULTILIB_USEDEP}]
 ~dev-qt/qtgui-${PV}[debug=,${MULTILIB_USEDEP}]
 ~dev-qt/qthelp-${PV}[debug=,${MULTILIB_USEDEP}]
 ~dev-qt/qtscript-${PV}[debug=,${MULTILIB_USEDEP}]
 ~dev-qt/qtsql-${PV}[debug=,${MULTILIB_USEDEP}]
 ~dev-qt/qtsvg-${PV}[debug=,${MULTILIB_USEDEP}]
 ~dev-qt/qttest-${PV}[debug=,${MULTILIB_USEDEP}]
 dbus? ( ~dev-qt/qtdbus-${PV}[debug=,${MULTILIB_USEDEP}] )
 declarative? ( ~dev-qt/qtdeclarative-${PV}[debug=,webkit?,${MULTILIB_USEDEP}] )
 multimedia? ( ~dev-qt/qtmultimedia-${PV}[debug=,${MULTILIB_USEDEP}] )
 opengl? ( ~dev-qt/qtopengl-${PV}[debug=,${MULTILIB_USEDEP}] )
 phonon? ( media-libs/phonon:0-qt4[${MULTILIB_USEDEP}] )
 webkit? ( >=dev-qt/qtwebkit-${PV}:4[debug=,${MULTILIB_USEDEP}] )
 xmlpatterns? ( ~dev-qt/qtxmlpatterns-${PV}[debug=,${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.6-plugandpaint.patch" )

QT4_TARGET_DIRECTORIES="
 demos
 examples"

src_prepare() {
 qt4-build-multilib_src_prepare

 # Array mapping USE flags to subdirs
 local flags_subdirs_map=(
 'dbus'
 'declarative:declarative'
 'multimedia:spectrum'
 'opengl:boxes|glhypnotizer'
 'phonon:mediaplayer'
 'webkit:browser'
 'xmlpatterns'
 )

 # Disable unwanted examples/demos
 for flag in "${flags_subdirs_map[@]}"; do
 if ! use ${flag%:*}; then
 einfo "Disabling ${flag%:*} examples"
 sed -i -e "/SUBDIRS += ${flag%:*}/d" \
 examples/examples.pro || die

 if [[ ${flag} == *:* ]]; then
 einfo "Disabling ${flag%:*} demos"
 sed -i -re "/SUBDIRS \+= demos_(${flag#*:})/d" \
 demos/demos.pro || die
 fi
 fi
 done

 # Remove bogus dependency on qt3support (bug 510042)
 sed -i -e 's/contains(QT_CONFIG, qt3support)://' \
 examples/graphicsview/graphicsview.pro || die
}

multilib_src_configure() {
 local myconf=(
 $(qt_use dbus)
 $(qt_use declarative)
 $(qt_use multimedia) -no-audio-backend
 $(qt_use opengl)
 -no-openvg
 $(qt_use phonon) -no-phonon-backend
 $(qt_use webkit)
 $(qt_use xmlpatterns)
 )
 qt4_multilib_src_configure
}
