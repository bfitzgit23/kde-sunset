# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kdepim"
KMMODULE="console/${PN}"
kde4-meta

DESCRIPTION="Command line client for accessing the KDE addressbook"

KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep kdepimlibs)
"
RDEPEND="${DEPEND}"

src_install() {
 kde4-meta_src_install

 # work around NULL DT_RPATH in kabc2mutt
 dosym kabcclient /usr/bin/kabc2mutt
}
