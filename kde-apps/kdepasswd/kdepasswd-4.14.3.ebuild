# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kde-baseapps"
kde4-meta

DESCRIPTION="KDE GUI for passwd"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep libkonq)
"
RDEPEND="${DEPEND}
 $(add_kdeapps_dep kdesu)
 sys-apps/accountsservice
"
