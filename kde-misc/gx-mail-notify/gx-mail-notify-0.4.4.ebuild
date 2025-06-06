# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

OPENGL_REQUIRED=always
kde4-base

MY_P=gx_mail_notify-${PV}

DESCRIPTION="Plasmoid for checking unread mail"
HOMEPAGE="http://www.kde-look.org/content/show.php/GX+Mail+Notify?content=99617"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/99617-${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="kde-plasma/plasma-workspace:4"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-qt-4.7.patch" )

S=${WORKDIR}/${MY_P}

DOCS=( README )
