# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE UML Modeller"
HOMEPAGE="
 https://www.kde.org/applications/development/umbrello
 https://umbrello.kde.org
"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
 dev-libs/libxml2
 dev-libs/libxslt
"
DEPEND="${RDEPEND}"
