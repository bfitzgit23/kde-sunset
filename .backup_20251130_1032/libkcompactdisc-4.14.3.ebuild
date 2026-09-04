# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit kde4-meta

DESCRIPTION="KDE library for playing & ripping CDs"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="alsa debug"

src_configure() {
	local mycmakeargs=(
		-DWITH_alsa="$(usex alsa)"
	)
	kde4-meta_src_configure
}
RDEPEND="${DEPEND}"
SLOT=0
