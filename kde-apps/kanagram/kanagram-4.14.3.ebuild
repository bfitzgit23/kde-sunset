# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE: letter order game"
HOMEPAGE="https://www.kde.org/applications/education/kanagram
https://edu.kde.org/kanagram"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep libkdeedu)
"
RDEPEND=${DEPEND}
