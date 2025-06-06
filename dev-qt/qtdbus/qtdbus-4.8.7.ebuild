# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
qt4-build-multilib

DESCRIPTION="The DBus module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
 KEYWORDS="amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc x86"
fi

IUSE=""

DEPEND="
 ~dev-qt/qtcore-${PV}[debug=,${MULTILIB_USEDEP}]
 sys-apps/dbus[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

PATCHES=(
 "${FILESDIR}/${PN}-4.7-qdbusintegrator-no-const.patch"
 "${FILESDIR}/${PN}-4.8.4-qdbusconnection-silence-warning.patch"
)

QT4_TARGET_DIRECTORIES="
 src/dbus
 tools/qdbus/qdbus
 tools/qdbus/qdbusxml2cpp
 tools/qdbus/qdbuscpp2xml"

QCONFIG_ADD="dbus dbus-linked"
QCONFIG_DEFINE="QT_DBUS"

multilib_src_configure() {
 local myconf=(
 -dbus-linked
 )
 qt4_multilib_src_configure
}
