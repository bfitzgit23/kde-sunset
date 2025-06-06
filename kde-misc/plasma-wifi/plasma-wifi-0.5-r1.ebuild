# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="Plasmoid which displays the currect signal strength"
HOMEPAGE="http://www.kde-look.org/content/show.php/cpuload?content=79476"
SRC_URI="http://kde-look.org/CONTENT/content-files/79476-${P}.tgz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND="
 kde-plasma/plasma-workspace:4
"

src_prepare() {
 sed -i "s:find_package(Plasma REQUIRED)::" CMakeLists.txt || die "sed failed"
 sed -i "s:PLASMA_LIBS:KDE4_PLASMA_LIBS:" CMakeLists.txt || die "sed failed"

 kde4-base_src_prepare
}
