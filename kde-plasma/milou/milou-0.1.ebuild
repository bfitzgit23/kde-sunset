# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_MINIMAL="4.13"
KDE_LINGUAS="bs ca cs da de el es fi fr hu ja ko lt nds nl pl pt pt_BR ro sk sv
uk zh_CN zh_TW"
kde4-base

DESCRIPTION="Dedicated search application built on top of Baloo"
HOMEPAGE="https://projects.kde.org/projects/extragear/base/milou"
SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
 $(add_kdeapps_dep kdepimlibs)
 kde-frameworks/baloo:4
"
DEPEND="${RDEPEND}
 kde-frameworks/kfilemetadata:4
"
