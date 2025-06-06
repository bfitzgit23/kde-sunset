# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="Library to support mobipocket ebooks"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

src_configure() {
 local mycmakeargs=(
 -DCMAKE_DISABLE_FIND_PACKAGE_Strigi=ON
 )

 kde4-base_src_configure
}
