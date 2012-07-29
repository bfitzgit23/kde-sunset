# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdat/kdat-3.5.10.ebuild,v 1.4 2009/07/12 11:26:25 armin76 Exp $
EAPI="1"
KMNAME=kdeadmin
inherit kde-meta

DESCRIPTION="tar-based DAT archiver for KDE"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="kdehiddenvisibility"
DEPEND=""

PATCHES=( "${FILESDIR}/${KMNAME}_${PN}-r850245.patch" )
