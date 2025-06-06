# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE kioslaves from the kdemultimedia package"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug flac vorbis"

DEPEND="
 $(add_kdeapps_dep libkcddb)
 $(add_kdeapps_dep libkcompactdisc)
 media-sound/cdparanoia
 flac? ( >=media-libs/flac-1.1.2 )
 vorbis? (
 media-libs/libogg
 media-libs/libvorbis
 )
"
RDEPEND="${DEPEND}"

src_configure() {
 local mycmakeargs=(
 $(cmake-utils_use_with flac)
 $(cmake-utils_use_with vorbis OggVorbis)
 )

 kde4-base_src_configure
}
