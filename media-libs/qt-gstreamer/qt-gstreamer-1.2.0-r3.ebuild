# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ bindings for GStreamer with a Qt-style API"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/qt-gstreamer.html"
SRC_URI="https://gstreamer.freedesktop.org/src/qt-gstreamer/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0-qt4"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="test"

BDEPEND="
	dev-util/glib-utils
"
COMMON_DEPEND="
	dev-libs/boost:=
	dev-libs/glib:2
	dev-qt/qtcore:4
	dev-qt/qtdeclarative:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-qt/qttest:4 )
"
RDEPEND="${COMMON_DEPEND}
	!<media-libs/qt-gstreamer-1.2.0-r4:0
"

PATCHES=(
	"${FILESDIR}/${P}-gstreamer15.patch"
	"${FILESDIR}/${P}-gstreamer16.patch"
	"${FILESDIR}/${P}-gstreamer18.patch"
	"${FILESDIR}/${P}-boost157.patch"
	"${FILESDIR}/${P}-clang-38.patch"
	"${FILESDIR}/${P}-glib-gatomic.patch"
)

# bug 497880
RESTRICT="test"

src_configure() {
	# CMake 4 rejects the pre-3.5 policy version declared upstream, and
	# FindQt4 needs Qt4's qmake rather than Qt5/Qt6's /usr/bin/qmake.
	local qt4_qmake=${EPREFIX}/usr/$(get_libdir)/qt4/bin/qmake
	[[ -x ${qt4_qmake} ]] || qt4_qmake=${EPREFIX}/usr/bin/qmake

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Declarative=ON
		-DQTGSTREAMER_EXAMPLES=OFF
		-DQTGSTREAMER_TESTS=$(usex test)
		-DQT_VERSION=4
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5
		-DQT_QMAKE_EXECUTABLE="${qt4_qmake}"
	)
	cmake_src_configure
}


