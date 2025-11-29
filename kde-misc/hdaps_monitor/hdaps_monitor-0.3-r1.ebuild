# ================= ORIGINAL FILE BELOW =================
# (Preserved as requested)
# --------------------------------------------------------
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit kde4-base

DESCRIPTION="KDE-based monitor for the IBM HDAPS system"
HOMEPAGE="http://www.kde-look.org/content/show.php/HDAPS+monitor?content=103481"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/103481-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="kde-plasma/plasma-workspace:4"
RDEPEND="${DEPEND}
	app-laptop/hdapsd"


# ================= MODERNIZED EBUILD BELOW ==============
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit kde4-base

DESCRIPTION="KDE-based monitor for the IBM HDAPS system"
HOMEPAGE="http://www.kde-look.org/content/show.php/HDAPS+monitor?content=103481"
SRC_URI="mirror://local/hdaps_monitor-0.3-r1.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="kde-plasma/plasma-workspace:4"
RDEPEND="${DEPEND}
	app-laptop/hdapsd"
