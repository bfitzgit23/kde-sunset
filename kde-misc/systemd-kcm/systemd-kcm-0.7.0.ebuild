# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="kcmsystemd"
inherit kde4-base

DESCRIPTION="KDE control module for systemd"
HOMEPAGE="https://projects.kde.org/projects/playground/sysadmin/systemd-kcm"
SRC_URI="https://github.com/rthomsen/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

IUSE="debug"
LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/boost-1.45
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kcmshell)
	sys-apps/systemd
"

# only needed for 0.7.0 and 1.1.0
S="${WORKDIR}"/${MY_PN}-${PV}

PATCHES=(
	"${FILESDIR}/systemd-kcm-0.7.0-cmake4-auth-actions.patch"
)

src_prepare() {
	kde4-base_src_prepare

	# CMake 4 (CMP0037): kde4_install_auth_actions() builds an invalid target name
	# from the dotted helper id, so the call is dropped and the policy is installed
	# from FILESDIR. Apply that replacement here as well, so the build does not
	# depend on the eclass having honoured PATCHES.
	local pc="${S}/src/helper/CMakeLists.txt"
	if grep -q 'kde4_install_auth_actions(org\.kde\.kcontrol\.kcmsystemd kcmsystemd\.actions)' "${pc}"; then
		eapply "${FILESDIR}/systemd-kcm-0.7.0-cmake4-auth-actions.patch"
	fi
	if grep -q 'kde4_install_auth_actions(org\.kde\.kcontrol\.kcmsystemd kcmsystemd\.actions)' "${pc}"; then
		die "CMake 4 auth-actions replacement missing in ${pc}"
	fi
}

src_install() {
	kde4-base_src_install

	# The helper action policy is installed from the pre-generated policy: the KAuth
	# policy generator cannot produce a valid target name under CMake 4, and a fake
	# KAuth backend emits an empty file.
	insinto /usr/share/polkit-1/actions
	doins "${FILESDIR}/org.kde.kcontrol.kcmsystemd.policy"
}
