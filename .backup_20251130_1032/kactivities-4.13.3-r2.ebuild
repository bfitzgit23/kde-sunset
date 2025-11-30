# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DECLARATIVE_REQUIRED="always"
inherit kde4-meta 

DESCRIPTION="KDE Activity Manager"

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	|| (
		$(add_kdeplasma_dep kactivitymanagerd)
		kde-plasma/kactivitymanagerd:5
	)
"

src_configure() {
	local mycmakeargs=(
		-DKACTIVITIES_LIBRARY_ONLY=ON
		-DWITH_NepomukCore=OFF
	)
	kde4-meta_src_configure
}
SLOT=0
