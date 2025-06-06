# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

cmake-utils

DESCRIPTION="Simple SMS tool"
HOMEPAGE="https://www.linux-apps.com/content/show.php/past+-+SMS+Tool?content=74036"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1466626318/74036-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
 app-mobilephone/gnokii[sms]
 dev-qt/qtcore:4
 dev-qt/qtdbus:4
 dev-qt/qtgui:4
"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog TODO )
PATCHES=( "${FILESDIR}/${P}-gcc-4.7.patch" )
