# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="KDE digital camera raw image library wrapper"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 >=media-libs/libraw-0.16_beta1-r1:=
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-libraw-0.16.1.patch" )
