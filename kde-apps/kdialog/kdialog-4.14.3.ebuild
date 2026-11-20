# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-baseapps"
inherit kde4-meta

DESCRIPTION="KDialog can be used to show nice dialog boxes from shell scripts"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

src_install() {
	kde4-meta_src_install

	# KF6 ships /usr/bin/kdialog; keep the KDE4 copy suffixed so merging one
	# does not take the other's file with it.
	kde4_suffix_binaries kdialog
}


