# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
OPENGL_REQUIRED="always"
kde4-base

DESCRIPTION="A game based on the \"Rubik's Cube\" puzzle"
HOMEPAGE="https://www.kde.org/applications/games/kubrick/"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="$(add_kdeapps_dep libkdegames)
 virtual/glu
"
DEPEND="${RDEPEND}
 virtual/opengl
"
