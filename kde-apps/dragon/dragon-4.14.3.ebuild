# ================= ORIGINAL FILE BELOW =================
# (Preserved as requested)
# --------------------------------------------------------
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Dragon Player is a simple video player for KDE 4"
HOMEPAGE="https://www.kde.org/applications/multimedia/dragonplayer"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug xine"

RDEPEND="
	media-libs/phonon:0-qt4
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"


# ================= MODERNIZED EBUILD BELOW ==============
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Dragon Player is a simple video player for KDE 4"
HOMEPAGE="https://www.kde.org/applications/multimedia/dragonplayer"
KEYWORDS="~amd64 ~x86"
IUSE="debug xine"

RDEPEND="
	media-libs/phonon:0-qt4
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
