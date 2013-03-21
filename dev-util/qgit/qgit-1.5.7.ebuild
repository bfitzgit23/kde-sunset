# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qgit/qgit-1.5.7.ebuild,v 1.5 2007/09/20 21:00:06 ranger Exp $

inherit qt3

MY_PV=${PV//_/}
MY_P=${PN}-${MY_PV}

DESCRIPTION="GUI interface for git/cogito SCM"
HOMEPAGE="http://digilander.libero.it/mcostalba/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="=dev-qt/qt-meta-3*"
RDEPEND="${DEPEND}
	>=dev-vcs/git-1.5"

S="${WORKDIR}/${MY_P}"

src_install() {
	dobin src/qgit
	dodoc README ChangeLog
}
