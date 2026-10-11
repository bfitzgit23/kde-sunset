# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit kde4-meta

DESCRIPTION="A Thumbnail Generator for Video Files on KDE filemanagers"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep kdebase-kioslaves)
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_PHONON_SUPPORT=ON
	)

	kde4-meta_src_configure
}
SLOT=0
