# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kde-runtime"
kde4-meta

DESCRIPTION="Open Collaboration Services provider management"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
 dev-libs/libattica
"
RDEPEND="${DEPEND}"
