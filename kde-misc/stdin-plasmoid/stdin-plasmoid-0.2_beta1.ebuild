# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

 kde4-base 

MY_P="$(replace_version_separator 2 '-')"

DESCRIPTION="Plasmoid for executing a process and capturing its stderr and stdout"
HOMEPAGE="http://www.kde-look.org/content/show.php/STDIN+Plasmoid?content=92309"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/92309-${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND="
 kde-plasma/plasma-workspace:4
"

S="${WORKDIR}/${MY_P}"
