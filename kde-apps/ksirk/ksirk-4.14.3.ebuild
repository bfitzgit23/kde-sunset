# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="Port of the board game risk"
HOMEPAGE="
 https://www.kde.org/applications/games/ksirk/
 https://games.kde.org/game.php?game=ksirk
"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 app-crypt/qca:2-qt4
 $(add_kdeapps_dep libkdegames)
 sys-libs/zlib
"
RDEPEND="${DEPEND}"
