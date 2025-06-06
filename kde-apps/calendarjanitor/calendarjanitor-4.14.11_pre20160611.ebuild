# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kdepim"
KMMODULE="console/${PN}"
kde4-meta

DESCRIPTION="Tool to scan calendar data for buggy instances"
HOMEPAGE="https://www.kde.org/"

KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep kdepim-common-libs)
 $(add_kdeapps_dep kdepimlibs)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
 calendarsupport/
"

KMLOADLIBS="kdepim-common-libs"
