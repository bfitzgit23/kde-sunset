# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="Program for ripping internet radios"
HOMEPAGE="https://www.linux-apps.com/p/1126631"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 GPL-3"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND=""
#>=net-libs/libproxy-0.3.1
RDEPEND="${DEPEND}
 media-sound/streamripper
"

S=${WORKDIR}/${PN}

DOCS=( TODO.odt )

PATCHES=( "${FILESDIR}/${P}-nodebuglog.patch" )
