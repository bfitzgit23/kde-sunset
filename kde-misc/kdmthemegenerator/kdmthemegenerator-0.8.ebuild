# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

MY_P=KdmThemeGenerator

DESCRIPTION="Generates kdm theme from your current plasma theme and wallpaper"
HOMEPAGE="http://kde-apps.org/content/show.php/Kdm+theme+generator?content=102760"
SRC_URI="http://kde-apps.org/CONTENT/content-files/102760-${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
 kde-plasma/kdm:4
"

S=${WORKDIR}/${MY_P}

src_install() {
 kde4-base_src_install
 exeinto /usr/share/${MY_P}
 doexe copyFromUserToSystem.sh || die
 insinto /usr/share/${MY_P}
 doins input-shadow.svg || die
}
