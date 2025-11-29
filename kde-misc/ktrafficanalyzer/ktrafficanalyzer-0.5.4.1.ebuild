# ================= ORIGINAL FILE BELOW =================
# (Preserved as requested)
# --------------------------------------------------------
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde4-base

MY_P=KTrafficAnalyzer-${PV}

DESCRIPTION="A network traffic visualizer"
HOMEPAGE="http://ktrafficanalyze.sourceforge.net/"
SRC_URI="mirror://sourceforge/ktrafficanalyze/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

S=${WORKDIR}/${MY_P}

DOCS=(CHANGELOG SSHUsage TODO)


# ================= MODERNIZED EBUILD BELOW ==============
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde4-base

MY_P=KTrafficAnalyzer-${PV}

DESCRIPTION="A network traffic visualizer"
HOMEPAGE="http://ktrafficanalyze.sourceforge.net/"
SRC_URI="mirror://local/ktrafficanalyzer-0.5.4.1.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

S=${WORKDIR}/${MY_P}

DOCS=(CHANGELOG SSHUsage TODO)
