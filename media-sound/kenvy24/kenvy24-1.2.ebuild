# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
# po/ directory is disabled in CMakeLists.txt
# KDE_LINGUAS="es fr pl ro"
kde4-base

DESCRIPTION="VIA Envy24 based sound card control utility for KDE"
HOMEPAGE="https://sourceforge.net/projects/kenvy24/"
SRC_URI="mirror://sourceforge/kenvy24/${P}-src.tgz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook"

DEPEND="
 media-libs/alsa-lib
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

S=${WORKDIR}/${P}-src
