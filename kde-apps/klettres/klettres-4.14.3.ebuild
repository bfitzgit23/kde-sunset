# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE: KLettres helps a very young child or an adult learning "
HOMEPAGE="https://www.kde.org/applications/education/klettres
https://edu.kde.org/klettres"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
 $(add_kdeapps_dep knotify)
"
