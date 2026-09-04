# Copyright 1999-2015 Gentoo Foundation
inherit kde4-base
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-baseapps"
inherit  pax-utils

DESCRIPTION="Netscape plugins support for Konqueror"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	x11-libs/libXt
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep konqueror)
"

KMEXTRACTONLY="
	konqueror/settings/
"

src_install() {
	kde4-meta_src_install

	# bug 419513
	pax-mark m "${ED}"/usr/bin/nspluginviewer
}
SLOT=0
