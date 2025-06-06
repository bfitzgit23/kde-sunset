# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

mono-env kde4-base

DESCRIPTION="C# bindings for KDE"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="akonadi debug plasma"

DEPEND="
 dev-lang/mono
 $(add_kdebase_dep qyoto 'webkit')
 $(add_kdebase_dep smokeqt)
 $(add_kdebase_dep smokekde)
 plasma? ( $(add_kdebase_dep smokeqt 'webkit') )
"
RDEPEND="${DEPEND}"

pkg_setup() {
 mono-env_pkg_setup
 kde4-base_pkg_setup
}

src_prepare() {
 kde4-base_src_prepare

 sed -e "/add_subdirectory( examples )/ s:^:#:" \
 -i plasma/CMakeLists.txt || die
}

src_configure() {
 local mycmakeargs=(
 -DWITH_Soprano=OFF
 -DWITH_Nepomuk=OFF
 $(cmake-utils_use_with akonadi)
 $(cmake-utils_use_with akonadi KdepimLibs)
 $(cmake-utils_use_disable plasma)
 )
 kde4-base_src_configure
}
