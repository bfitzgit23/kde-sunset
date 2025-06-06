# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
kde4-meta

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
