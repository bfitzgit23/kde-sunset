# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="Jukebox and music manager for KDE"
HOMEPAGE="https://www.kde.org/applications/multimedia/juk/"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 >=media-libs/taglib-1.6
"
RDEPEND="${DEPEND}"

src_configure() {
 # https://bugs.gentoo.org/410551 for disabling deprecated TunePimp support
 local mycmakeargs=(
 -DWITH_TunePimp=OFF
 )

 kde4-base_src_configure
}
