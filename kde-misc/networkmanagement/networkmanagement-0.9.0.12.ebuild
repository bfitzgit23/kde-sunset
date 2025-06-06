# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_LINGUAS="ar bs ca ca@valencia cs da de el es et fa fi fr ga gl hu ia it
ja kk km ko lt mr nb nds nl nn pl pt pt_BR ro ru se sk sl sr sr@ijekavian
sr@ijekavianlatin sr@Latn sv tr uk zh_CN zh_TW"
KDE_SCM="git"
KDE_MINIMAL="4.11"
kde4-base

DESCRIPTION="KDE frontend for NetworkManager"
HOMEPAGE="https://projects.kde.org/projects/extragear/base/networkmanagement"
[[ ${PV} = 9999* ]] || SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug openconnect"

DEPEND="
 net-misc/mobile-broadband-provider-info
 >=net-misc/networkmanager-0.9.6
 openconnect? (
 net-vpn/networkmanager-openconnect
 net-vpn/openconnect:=
 )
"
RDEPEND="${DEPEND}
 !kde-base/solid
 !kde-plasma/plasma-nm:4
"

src_configure() {
 local mycmakeargs=(
 $(cmake-utils_use_with openconnect)
 )
 kde4-base_src_configure
}
