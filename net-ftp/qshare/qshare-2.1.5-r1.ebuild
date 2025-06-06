# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

cmake-utils

DESCRIPTION="FTP server with a service discovery feature"
HOMEPAGE="http://www.zuzuf.net/qshare/"
SRC_URI="http://www.zuzuf.net/qshare/files/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-qt/qtcore:4
 dev-qt/qtgui:4
 net-dns/avahi[mdnsresponder-compat]"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README )
PATCHES=( "${FILESDIR}/${P}-desktop.patch" )
