# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

qmake-utils

DESCRIPTION="Qt4 cross-platform multi-threaded download utility"
HOMEPAGE="http://qt-apps.org/content/show.php/?content=103312"
SRC_URI="https://netfleet.googlecode.com/files/${PN}_${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
 dev-qt/qtcore:4[ssl]
 dev-qt/qtgui:4
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_configure() {
 eqmake4
}

src_install() {
 emake INSTALL_ROOT="${D}" install
}
