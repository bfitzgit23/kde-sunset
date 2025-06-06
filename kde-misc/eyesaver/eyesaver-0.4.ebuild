# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="Plasmoid, which reminds us to take our eyes off the screen"
HOMEPAGE="http://www.kde-look.org/content/show.php/Eyesaver?content=89989"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/89989-${P}.tar.gz"

LICENSE="GPL-1"
# License unclear, HOMEPAGE and .desktop file have "GPL", assuming GPL-1.
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="media-libs/phonon:0-qt4"
RDEPEND="
 ${DEPEND}
 kde-plasma/plasma-workspace:4
"

PATCHES=( "${FILESDIR}/eyesaver-0.2a-fix.patch" )
