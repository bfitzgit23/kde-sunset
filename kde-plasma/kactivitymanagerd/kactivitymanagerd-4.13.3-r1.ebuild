# ================= ORIGINAL FILE BELOW =================
# (Preserved as requested)
# --------------------------------------------------------
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kactivities"
inherit kde4-base

DESCRIPTION="KDE Activity Manager Daemon"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	!<kde-frameworks/kactivities-4.13.3-r1
"

S=${WORKDIR}/${KMNAME}-${PV}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DWITH_NepomukCore=OFF
	)
	kde4-base_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/src/service/${PN}"
}


# ================= MODERNIZED EBUILD BELOW ==============
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kactivities"
inherit kde4-base

DESCRIPTION="KDE Activity Manager Daemon"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	!<kde-frameworks/kactivities-4.13.3-r1
"

S=${WORKDIR}/${KMNAME}-${PV}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
	)
	kde4-base_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/src/service/${PN}"
}
