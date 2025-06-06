# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE mixer gui"
HOMEPAGE="https://www.kde.org/applications/multimedia/kmix/"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="alsa debug canberra pulseaudio"

DEPEND="
 alsa? ( >=media-libs/alsa-lib-1.0.14a )
 canberra? ( media-libs/libcanberra )
 pulseaudio? ( >=media-sound/pulseaudio-0.9.12 )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.14.3-alsa-optional.patch" )

src_configure() {
 local mycmakeargs=(
 $(cmake-utils_use_find_package alsa)
 $(cmake-utils_use_with canberra)
 $(cmake-utils_use_with pulseaudio PulseAudio)
 )

 kde4-base_src_configure
}
