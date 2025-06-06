# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE screen gamma values kcontrol module"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
 x11-libs/libXxf86vm
"
DEPEND="${RDEPEND}
 x11-base/xorg-proto
"

PATCHES=( "${FILESDIR}/${P}-cmake34.patch" )
