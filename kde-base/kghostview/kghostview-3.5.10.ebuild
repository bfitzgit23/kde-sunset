# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kghostview/kghostview-3.5.10.ebuild,v 1.7 2009/07/12 09:37:46 armin76 Exp $

EAPI="2"
KMNAME=kdegraphics
inherit kde-meta eutils

DESCRIPTION="KDE: Viewer for PostScript (.ps, .eps) and Portable Document Format (.pdf) files"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="X"
# Should also rdepend on kdeprint. Since kdeprint rdepends on kghostview for previews, we'd had a conflict, so we can't.
RDEPEND="app-text/ghostscript-gpl[X]"
KMEXTRA="kfile-plugins/ps"
