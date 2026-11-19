# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="4.14.3"
inherit kde4-base

DESCRIPTION="Framework for searching and managing metadata"
SRC_URI="
	mirror://kde/stable/${MY_PV}/src/${PN}-${MY_PV}.tar.xz
	https://dev.gentoo.org/~asturm/${P}.tar.xz
"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
	dev-libs/qjson
	dev-libs/xapian:=[chert(+)]
"
RDEPEND="${DEPEND}
	!<kde-apps/nepomuk-4.12.50
"

RESTRICT="test"

PATCHES=(
	"${WORKDIR}/${P}" # intevation branch + disable non-PIM stuff
	"${FILESDIR}/baloo-4.14.3-cmake4-auth-actions.patch"
)

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	kde4-base_src_prepare

	# CMake 4 (CMP0037): kde4_install_auth_actions() builds an invalid target name
	# from the dotted helper id, so the call is dropped and the policy is installed
	# from FILESDIR. Apply that replacement here as well, so the build does not
	# depend on the eclass having honoured PATCHES.
	local pc="${S}/src/file/inotify/CMakeLists.txt"
	if grep -q 'kde4_install_auth_actions(org\.kde\.baloo\.filewatch org\.kde\.baloo\.filewatch\.actions)' "${pc}"; then
		eapply "${FILESDIR}/baloo-4.14.3-cmake4-auth-actions.patch"
	fi
	if grep -q 'kde4_install_auth_actions(org\.kde\.baloo\.filewatch org\.kde\.baloo\.filewatch\.actions)' "${pc}"; then
		die "CMake 4 auth-actions replacement missing in ${pc}"
	fi
}

src_install() {
	kde4-base_src_install

	# The helper action policy is installed from the pre-generated policy: the KAuth
	# policy generator cannot produce a valid target name under CMake 4, and a fake
	# KAuth backend emits an empty file.
	insinto /usr/share/polkit-1/actions
	doins "${FILESDIR}/org.kde.baloo.filewatch.policy"
}
