# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT3SUPPORT_REQUIRED="true"
kde4-base

DESCRIPTION="Graphical Portage frontend based on KDELibs4/Qt4"
HOMEPAGE="https://sourceforge.net/projects/kuroo/"
SRC_URI="mirror://sourceforge/kuroo/${PN}4-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-db/sqlite:3"

RDEPEND="${DEPEND}
 app-portage/gentoolkit
 kde-apps/kompare:*
 kde-plasma/kde-cli-tools[kdesu]
"

S="${WORKDIR}/${PN}4-${PV}"
