# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE: Knetwalk is the kde version of the popular NetWalk game for system administrators"
HOMEPAGE="
 https://www.kde.org/applications/games/knetwalk/
 https://games.kde.org/game.php?game=knetwalk
"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="$(add_kdeapps_dep libkdegames)"
RDEPEND="${DEPEND}"
