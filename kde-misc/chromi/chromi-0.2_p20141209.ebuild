# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="kwin-deco-${PN}-${PV}"
kde4-base

DESCRIPTION="Titlebar-less decoration inspired by Google Chrome and Nitrogen minimal mod"
HOMEPAGE="http://kde-look.org/content/show.php/Chromi?content=119069"
SRC_URI="https://dev.gentoo.org/~kensington/distfiles/${MY_P}.tar.xz"

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

DEPEND="
 kde-plasma/kwin:4
"
RDEPEND="${DEPEND}"
