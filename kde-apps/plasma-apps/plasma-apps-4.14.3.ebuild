# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kde-baseapps"
KMMODULE="plasma"
kde4-meta

DESCRIPTION="Additional Applets for Plasma"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep libkonq)
"
RDEPEND="${DEPEND}"
