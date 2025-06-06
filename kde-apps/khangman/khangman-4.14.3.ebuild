# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="Classical hangman game for KDE"
HOMEPAGE="https://www.kde.org/applications/education/khangman
https://edu.kde.org/khangman"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep libkdeedu)
"
RDEPEND=${DEPEND}
