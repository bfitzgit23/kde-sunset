# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

if [[ ${PV} == *9999 ]]; then
	KMNAME="kdesupport"
fi
KDE_REQUIRED="never"
KDE_SCM="svn"
inherit kde4-base

DESCRIPTION="Oxygen SVG icon theme"
HOMEPAGE="http://www.oxygen-icons.org/"
# The formerly repacked archive is no longer hosted; use the canonical
# upstream tarball, which also contains the SVG sources.
[[ ${PV} == *9999 ]] || \
SRC_URI="
	https://download.kde.org/Attic/4.14.3/src/${P}.tar.xz
	mirror://kde/Attic/4.14.3/src/${P}.tar.xz
"

LICENSE="LGPL-3"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="sources"

DEPEND=""
RDEPEND="${DEPEND}"


