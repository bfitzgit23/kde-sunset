# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
OPENGL_REQUIRED="optional"
kde4-base

DESCRIPTION="KDE Sudoku"
HOMEPAGE="
 https://www.kde.org/applications/games/ksudoku/
 https://games.kde.org/game.php?game=ksudoku
"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep libkdegames)
 opengl? ( virtual/glu )
"
RDEPEND="${DEPEND}"

src_configure() {
 local mycmakeargs=(
 $(cmake-utils_use_with opengl OpenGL)
 )
 kde4-base_src_configure
}
