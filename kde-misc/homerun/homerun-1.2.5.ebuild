# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DECLARATIVE_REQUIRED="always"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
KDE_LINGUAS="ca ca@valencia cs da de el es fi fr gl hu it nl pl pt pt_BR ro sk
sl sv tr uk zh_CN"
kde4-base

DESCRIPTION="Application launcher for KDE Plasma desktop"
HOMEPAGE="https://projects.kde.org/projects/playground/base/homerun"
[[ ${PV} == *9999 ]] || SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1 BSD"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep libkonq)
 kde-plasma/libkworkspace:4
"
RDEPEND="
 ${DEPEND}
 kde-plasma/plasma-workspace:4
"

# Fails 2 out of 6, check later again.
# With virtualx/virtualdbus it hangs
RESTRICT="test"
