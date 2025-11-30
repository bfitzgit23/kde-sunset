# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit kde4-meta

DESCRIPTION="Library to support mobipocket ebooks"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Strigi=ON
	)

	kde4-meta_src_configure
}
RDEPEND="${DEPEND}"
SLOT=0
