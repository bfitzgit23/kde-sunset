# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-runtime"
inherit kde4-meta kde4-functions-extra

DESCRIPTION="The KDE Control Center"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdeplasma_dep khotkeys '' 4.11)
	$(add_kdeapps_dep zeroconf-ioslave)
"

src_prepare() {
	kde4-meta_src_prepare

	# kde-apps/keditfiletype installs the editor as keditfiletype4 (the bare
	# name belongs to kde-plasma/keditfiletype), so the "Add..." button of the
	# file manager chooser has to ask for that name.
	local chooser=kcontrol/componentchooser/componentchooserfilemanager.cpp
	sed -i -e 's/proc << "keditfiletype";/proc << "keditfiletype4";/' "${chooser}" ||
		die "failed to point componentchooser at keditfiletype4"
}
