# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit kde4-base

DESCRIPTION="KDE Wallet Management Tool"
HOMEAGE="https://www.kde.org/applications/system/kwalletmanager
https://utils.kde.org/projects/kwalletmanager"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND=""
RDEPEND="
	!kde-base/kwallet:4
	|| ( >=kde-base/legacy-icons-4.11.22-r1 kde-apps/kwalletmanager:5 )
"

src_install() {
	kde4-base_src_install
	rm -r "${ED}/usr/share/icons"  || die

	# The helper action policy is installed from the pre-generated policy: the KAuth
	# policy generator cannot produce a valid target name under CMake 4, and a fake
	# KAuth backend emits an empty file.
	insinto /usr/share/polkit-1/actions
	doins "${FILESDIR}/org.kde.kcontrol.kcmkwallet.policy"
}

PATCHES=(
	"${FILESDIR}/kwalletmanager-4.14.3-cmake4-auth-actions.patch"
)

src_prepare() {
	kde4-base_src_prepare

	# CMake 4 (CMP0037): kde4_install_auth_actions() builds an invalid target name
	# from the dotted helper id, so the call is dropped and the policy is installed
	# from FILESDIR. Apply that replacement here as well, so the build does not
	# depend on the eclass having honoured PATCHES.
	local pc="${S}/src/konfigurator/CMakeLists.txt"
	if grep -q 'kde4_install_auth_actions(org\.kde\.kcontrol\.kcmkwallet kwallet\.actions)' "${pc}"; then
		eapply "${FILESDIR}/kwalletmanager-4.14.3-cmake4-auth-actions.patch"
	fi
	if grep -q 'kde4_install_auth_actions(org\.kde\.kcontrol\.kcmkwallet kwallet\.actions)' "${pc}"; then
		die "CMake 4 auth-actions replacement missing in ${pc}"
	fi
}

