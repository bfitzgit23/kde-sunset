# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE application that helps you manage system users"
HOMEPAGE="https://www.kde.org/applications/system/kuser/"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep kdepimlibs)
"
# notify is needed for dialogs
RDEPEND="${DEPEND}
 $(add_kdeapps_dep knotify)
"
