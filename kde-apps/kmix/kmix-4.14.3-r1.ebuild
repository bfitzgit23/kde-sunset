# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE mixer gui"
HOMEPAGE="https://www.kde.org/applications/multimedia/kmix/"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="alsa debug canberra +handbook"

DEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.14a )
	canberra? ( media-libs/libcanberra )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.14.3-alsa-optional.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_alsa="$(usex !alsa)"
		-DWITH_canberra="$(usex canberra)"
		-DWITH_PulseAudio=OFF
	)

	kde4-base_src_configure
}


