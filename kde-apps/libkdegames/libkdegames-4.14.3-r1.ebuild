# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="Base library common to many KDE games"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 media-libs/libsndfile
 media-libs/openal
"
RDEPEND="${DEPEND}"

KMSAVELIBS="true"
