# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

MY_P=${P/-/_}

DESCRIPTION="Amarok Fullscreen Player"
HOMEPAGE="http://kde-apps.org/content/show.php?content=108863"
SRC_URI="http://linux.wuertz.org/dists/sid/main/source/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="media-sound/amarok:4"

S=${WORKDIR}/${PN}
