# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="Mathematical function plotter for KDE"
HOMEPAGE="https://www.kde.org/applications/education/kmplot https://edu.kde.org/kmplot"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
 $(add_kdeapps_dep knotify)
"
