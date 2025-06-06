# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_LINGUAS="de es fr gl nl pt_BR sv tr zh_CN"
kde4-base

MY_PN="plasma-widget-${PN}"
MY_P="${MY_PN}-${PV}-2"

DESCRIPTION="Plasmoid for the panel provides quick access to the most used folders"
HOMEPAGE="http://kde-look.org/content/show.php?content=134442"
SRC_URI="http://kde-look.org/CONTENT/content-files/134442-${MY_P}.zip"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="$(add_kdeapps_dep libkonq)"
RDEPEND="${DEPEND}
 kde-plasma/plasma-workspace:4
"

S="${WORKDIR}/${MY_P}"
