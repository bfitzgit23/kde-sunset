# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_SELINUX_MODULE="games"
kde4-base

DESCRIPTION="KMines is a classic mine sweeper game"
HOMEPAGE="
 https://www.kde.org/applications/games/kmines/
 https://games.kde.org/game.php?game=kmines
"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="$(add_kdeapps_dep libkdegames)"
RDEPEND="${DEPEND}"
