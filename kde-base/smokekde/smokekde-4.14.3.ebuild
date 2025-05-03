# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit kde4-base

DESCRIPTION="Scripting Meta Object Kompiler Engine - KDE bindings"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="akonadi attica debug kate okular"
HOMEPAGE="https://techbase.kde.org/Development/Languages/Smoke"

DEPEND="
	$(add_kdebase_dep smokeqt)
	akonadi? ( $(add_kdeapps_dep kdepimlibs) )
	attica? ( dev-libs/libattica )
	kate? ( $(add_kdeapps_dep kate) )
	okular? ( $(add_kdeapps_dep okular) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_Nepomuk=OFF
		-DWITH_Soprano=OFF
		-DCMAKE_CXX_STANDARD=98
		-DWITH_akonadi="$(usex akonadi)"
		-DWITH_KdepimLibs="$(usex akonadi)"
		-DWITH_LibAttica="$(usex attica)"
		-DDISABLE_kate="$(usex !kate)"
		-DWITH_okular="$(usex okular)"
	)
	kde4-base_src_configure
}
