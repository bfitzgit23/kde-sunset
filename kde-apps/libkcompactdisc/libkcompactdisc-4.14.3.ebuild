# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="KDE library for playing & ripping CDs"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="alsa debug"

src_configure() {
 local mycmakeargs=(
 $(cmake-utils_use_with alsa)
 )
 kde4-base_src_configure
}
