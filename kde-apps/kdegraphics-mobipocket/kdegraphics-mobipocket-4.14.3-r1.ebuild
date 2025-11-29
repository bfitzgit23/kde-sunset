# ================= ORIGINAL FILE BELOW =================
# (Preserved as requested)
# --------------------------------------------------------
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde4-base

DESCRIPTION="Library to support mobipocket ebooks"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Strigi=ON
	)

	kde4-base_src_configure
}


# ================= MODERNIZED EBUILD BELOW ==============
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde4-base

DESCRIPTION="Library to support mobipocket ebooks"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

src_configure() {
	local mycmakeargs=(
	)

	kde4-base_src_configure
}
