# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kdepim"
kde4-meta

DESCRIPTION="Viewer for TNEF attachments"

KEYWORDS="amd64 x86"
LICENSE="LGPL-2.1"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep kdepimlibs)
 kde-apps/akonadi:4
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
 akonadi/
"
