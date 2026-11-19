# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-workspace"
DECLARATIVE_REQUIRED="optional"
OPENGL_REQUIRED="always"
#VIRTUALX_REQUIRED=test
inherit flag-o-matic kde4-meta

DESCRIPTION="KDE window manager"
HOMEPAGE+=" https://userbase.kde.org/KWin"

KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug gles2-only +declarative"

RESTRICT+=" test"
# test 8: kwin-TestVirtualDesktops hangs even with virtualx

COMMONDEPEND="
	kde-frameworks/kactivities:4
	kde-frameworks/kdelibs:4[opengl]
	kde-plasma/kephal:4
	kde-plasma/libkworkspace:4
	kde-plasma/liboxygenstyle:4
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/libXrandr-1.2.1
	x11-libs/libXrender
	x11-libs/libXxf86vm
	!gles2-only? ( >=media-libs/mesa-7.10 )
	gles2-only? ( >=media-libs/mesa-7.12[egl(+),gles2] )
"
DEPEND="${COMMONDEPEND}
	x11-libs/xcb-util-renderutil
	x11-base/xorg-proto
"
RDEPEND="${COMMONDEPEND}"


KMEXTRACTONLY="
	ksmserver/
	libs/kephal/
	libs/oxygen/
"

PATCHES=( "${FILESDIR}/${P}-gcc6.patch" )

PATCHES=(
	"${FILESDIR}/${PN}-4.11.22-cpp11-compat.patch"
	"${FILESDIR}/${P}-optional-qml-sweep.patch"
)


src_prepare() {
	kde4-meta_src_prepare

	# KDeclarative and friends are soft dependencies; this downgrades the
	# find_package() blocks and defines HAVE_QTDECLARATIVE for the sources
	# guarded by it.  Done here instead of by a patch: the block sits at a
	# different offset in different 4.11.22 snapshots and the hunk was
	# rejected there.
	kde4_make_qml_optional --qt-only
}


src_configure() {
	# FIXME Remove when activity API moved away from libkworkspace
	append-cppflags "-I${EPREFIX}/usr/include/kworkspace"

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_KDeclarative="$(usex !declarative)"
		-DCMAKE_DISABLE_FIND_PACKAGE_QtDeclarative="$(usex !declarative)"
		-DWITH_Wayland=OFF
		-DWITH_OpenGLES=$(usex gles2-only)
		-DWITH_OpenGL=$(usex !gles2-only)
	)

	kde4-meta_src_configure
}
