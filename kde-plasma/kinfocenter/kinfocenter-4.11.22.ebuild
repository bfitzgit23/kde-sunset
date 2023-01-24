# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="A utility that provides information about a computer system"
HOMEPAGE="https://www.kde.org/applications/system/kinfocenter/"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug ieee1394"

DEPEND="
	sys-apps/pciutils
	x11-libs/libX11
	ieee1394? ( sys-libs/libraw1394 )
	opengl? (
		virtual/glu
		virtual/opengl
	)
"
RDEPEND="${DEPEND}
	sys-apps/usbutils
"

src_configure() {
	local mycmakeargs=(
		-DWITH_RAW1394="$(usex ieee1394)"
		-DWITH_OpenGL="$(usex opengl)"
	)

	kde4-meta_src_configure
}
