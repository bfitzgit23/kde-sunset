# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-runtime"
KMMODULE="phonon"
inherit kde4-meta

DESCRIPTION="Phonon KDE Integration"
HOMEPAGE="https://phonon.kde.org"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="alsa debug"

DEPEND="
	media-libs/phonon:0-qt4
	alsa? ( media-libs/alsa-lib )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_tests=OFF
		-DWITH_Xine=OFF
		-DWITH_alsa="$(usex alsa)"
		-DWITH_PulseAudio=OFF
	)

	kde4-meta_src_configure
}


