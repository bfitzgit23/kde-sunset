# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

cmake-utils

DESCRIPTION="Application menu module for Qt"
HOMEPAGE="https://launchpad.net/appmenu-qt"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
 >=dev-libs/libdbusmenu-qt-0.9.0[qt4(-)]
 dev-qt/qtcore:4
 dev-qt/qtdbus:4
 dev-qt/qtgui:4
"
RDEPEND="${DEPEND}"

DOCS=( NEWS README )
