# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_MINIMAL="4.8"
kde4-base

DESCRIPTION="kwin plugin that makes the entire screen darker"
HOMEPAGE="http://kde-apps.org/content/show.php/Nightmode?content=123805"
SRC_URI="http://static.davidedmundson.co.uk/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="kde-plasma/kwin:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}

PATCHES=( "${FILESDIR}/${P}-kde-4.10.patch" )
