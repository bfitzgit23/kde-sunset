# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_REQUIRED="never"
kde4-base

if [[ ${KDE_BUILD_TYPE} != live ]]; then
 KEYWORDS="amd64 x86"
 SRC_URI="mirror://kde/unstable/modemmanager-qt/${PV}/src/${P}.tar.xz"
fi

DESCRIPTION="Modemmanager bindings for Qt"
HOMEPAGE="https://projects.kde.org/projects/extragear/libs/libmm-qt"

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug"

RDEPEND="
 dev-qt/qtcore:4
 dev-qt/qtdbus:4
 net-misc/mobile-broadband-provider-info
 >=net-misc/networkmanager-0.9.8[modemmanager]
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-cxxflags.patch" )
