# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="KDE Plasma menu editor"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	kde-plasma/khotkeys:4
"
DEPEND=${RDEPEND}

KMEXTRACTONLY="
	libs/kworkspace/
"

src_configure() {
	sed -i -e \
		"s:\${CMAKE_CURRENT_BINARY_DIR}/../khotkeys/app/org.kde.khotkeys.xml:${EPREFIX}/usr/share/dbus-1/interfaces/org.kde.khotkeys.xml:g" \
		kmenuedit/CMakeLists.txt \
		|| die "sed failed"

	# Upstream adds this dependency inside the full kde-workspace build, where
	# khotkeys/ defines kded_khotkeys.  Built standalone (this package) that
	# target does not exist and CMake fails to generate:
	#   The dependency target "kded_khotkeys" of target "kdeinit_kmenuedit"
	#   does not exist.
	if ! grep -q 'if(TARGET kded_khotkeys)' kmenuedit/CMakeLists.txt ; then
		sed -i -e 's:^\([[:space:]]*\)add_dependencies(kdeinit_kmenuedit kded_khotkeys):\1if(TARGET kded_khotkeys)\n\1add_dependencies(kdeinit_kmenuedit kded_khotkeys)\n\1endif():' \
			kmenuedit/CMakeLists.txt ||
			die "failed to guard the kded_khotkeys dependency"
		grep -q 'if(TARGET kded_khotkeys)' kmenuedit/CMakeLists.txt ||
			die "kded_khotkeys guard was not inserted; kmenuedit/CMakeLists.txt changed"
	fi

	kde4-meta_src_configure
}
