# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_SELINUX_MODULE="games"
kde4-base

DESCRIPTION="KDE Bounce Ball Game"
HOMEPAGE="
 https://www.kde.org/applications/games/kbounce/
 https://games.kde.org/game.php?game=kbounce
"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="$(add_kdeapps_dep libkdegames)"
RDEPEND="${DEPEND}"
