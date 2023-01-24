# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="never"
OPENGL_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="KDE library for mathematical features"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug readline"

DEPEND="
	opengl? ( virtual/glu )
	readline? ( sys-libs/readline )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_OpenGL="$(usex opengl)"
		-DWITH_readline="$(usex readline)"
	)

	kde4-base_src_configure
}
