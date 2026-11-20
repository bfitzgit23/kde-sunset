# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="The KDE Control Center"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep zeroconf-ioslave)
	|| ( kde-plasma/khotkeys:4 kde-plasma/khotkeys:5 )
"

src_prepare() {
	kde4-meta_src_prepare

	# kde-apps/keditfiletype installs the editor as keditfiletype4 (the bare
	# name belongs to kde-plasma/keditfiletype), so the "Add..." button of the
	# file manager chooser has to ask for that name.
	local chooser=kcontrol/componentchooser/componentchooserfilemanager.cpp
	sed -i -e 's/proc << "keditfiletype";/proc << "keditfiletype4";/' "${chooser}" ||
		die "failed to point componentchooser at keditfiletype4"

	if kde4_use_handbook ; then
		sed -i -e "/add_subdirectory(kcm_ssl)/d" doc/kcontrol/CMakeLists.txt || die
		sed -i -e "/add_subdirectory(trash)/d" doc/kcontrol/CMakeLists.txt || die
	fi
}


