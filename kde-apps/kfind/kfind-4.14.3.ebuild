# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kde-baseapps"
kde4-meta

DESCRIPTION="KDE file finder utility"
HOMEPAGE="https://www.kde.org/applications/utilities/kfind/"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep libkonq)
"
RDEPEND="${DEPEND}"
