# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_MINIMAL="4.10.0"
kde4-base

DESCRIPTION="A Plasma widget to display menubar of application windows"
HOMEPAGE="https://launchpad.net/plasma-widget-menubar"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
 >=dev-libs/libdbusmenu-qt-0.6.0[qt4(-)]
 >=dev-libs/qjson-0.7.1
"
RDEPEND="${DEPEND}
 !kde-misc/plasma-indicatordisplay
 x11-misc/appmenu-qt
"

# last checked 0.1.18
RESTRICT="test"
