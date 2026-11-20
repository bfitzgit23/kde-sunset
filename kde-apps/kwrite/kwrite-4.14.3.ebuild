# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kate"
KMEXTRACTONLY="doc/kate"
inherit kde4-meta

DESCRIPTION="KDE MDI editor/IDE"
HOMEPAGE="https://www.kde.org/applications/utilities/kwrite"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep katepart)
"

src_install() {
	kde4-meta_src_install

	# Gear 6 ships /usr/bin/kwrite; keep the KDE4 copy suffixed.
	kde4_suffix_binaries kwrite
}


