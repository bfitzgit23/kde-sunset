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

	kde4-meta_src_configure
}

src_install() {
	kde4-meta_src_install

	# kde-plasma/kmenuedit (Plasma 6) installs /usr/bin/kmenuedit, and merging
	# over it would leave Plasma's editor behind its own package until the next
	# update.  Install the KDE4 one under a suffix and point its menu entry at
	# it (Plasma 6 ships org.kde.kmenuedit.desktop, so the desktop file itself
	# does not clash).
	mv "${ED}"/usr/bin/kmenuedit "${ED}"/usr/bin/kmenuedit4 || die
	sed -i -e "s/^Exec=kmenuedit$/Exec=kmenuedit4/" "${ED}"/usr/share/applications/kmenuedit.desktop || die
}
