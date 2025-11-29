# ================= ORIGINAL FILE BELOW =================
# (Preserved as requested)
# --------------------------------------------------------
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde4-base

DESCRIPTION="Plasmoid that shows the state of keyboard leds"
HOMEPAGE="https://websvn.kde.org/trunk/playground/base/plasma/applets/kbstateapplet"
SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	x11-libs/libX11
"
RDEPEND="
	${DEPEND}
	kde-plasma/plasma-workspace:4
"


# ================= MODERNIZED EBUILD BELOW ==============
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde4-base

DESCRIPTION="Plasmoid that shows the state of keyboard leds"
HOMEPAGE="https://websvn.kde.org/trunk/playground/base/plasma/applets/kbstateapplet"
SRC_URI="mirror://local/kbstateapplet-0_p1268845.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	x11-libs/libX11
"
RDEPEND="
	${DEPEND}
	kde-plasma/plasma-workspace:4
"
