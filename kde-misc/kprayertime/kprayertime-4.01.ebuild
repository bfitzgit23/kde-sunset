# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="Islamic Prayer Times Plasmoid"
HOMEPAGE="http://kprayertime.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-}.src.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DOCS=(README)

S="${WORKDIR}/src"
