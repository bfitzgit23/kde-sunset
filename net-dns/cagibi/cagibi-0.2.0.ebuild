# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

cmake-utils

DESCRIPTION="Cache/proxy system for the SSDP part of UPnP"
HOMEPAGE="https://frinring.wordpress.com/2010/08/09/cagibi-0-1-1-released-network-kio-slave-freezes-kded-in-4-5-0/"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

RDEPEND="
 dev-qt/qtcore:4
 dev-qt/qtdbus:4
"
DEPEND="${RDEPEND}
 dev-util/automoc
"

DOCS=( Changelog README TODO )
