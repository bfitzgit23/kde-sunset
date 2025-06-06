# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_REQUIRED="never"
kde4-base

DESCRIPTION="Scripting Meta Object Kompiler Engine - generators"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"
HOMEPAGE="https://techbase.kde.org/Development/Languages/Smoke"

DEPEND="
 dev-qt/qtcore:4
"
RDEPEND="${DEPEND}"
