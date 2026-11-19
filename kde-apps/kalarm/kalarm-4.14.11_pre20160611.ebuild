# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Personal alarm message, command and email scheduler by KDE"
HOMEPAGE+=" https://userbase.kde.org/KAlarm"

KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep kdepim-common-libs)
	$(add_kdeapps_dep kdepimlibs)
	$(add_kdeapps_dep ktimezoned)
	media-libs/phonon:0-qt4
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

KMEXTRACTONLY="
	kmail/
"

PATCHES=(
	"${FILESDIR}/kalarm-4.14.11-cmake4-auth-actions.patch"
)

src_prepare() {
	kde4-meta_src_prepare

	# CMake 4 (CMP0037): kde4_install_auth_actions() builds an invalid target name
	# from the dotted helper id, so the call is dropped and the policy is installed
	# from FILESDIR. Apply that replacement here as well, so the build does not
	# depend on the eclass having honoured PATCHES.
	local pc="${S}/kalarm/CMakeLists.txt"
	if grep -q 'kde4_install_auth_actions(org\.kde\.kalarmrtcwake rtcwakeaction\.actions)' "${pc}"; then
		eapply "${FILESDIR}/kalarm-4.14.11-cmake4-auth-actions.patch"
	fi
	if grep -q 'kde4_install_auth_actions(org\.kde\.kalarmrtcwake rtcwakeaction\.actions)' "${pc}"; then
		die "CMake 4 auth-actions replacement missing in ${pc}"
	fi
}

src_install() {
	kde4-meta_src_install

	# The helper action policy is installed from the pre-generated policy: the KAuth
	# policy generator cannot produce a valid target name under CMake 4, and a fake
	# KAuth backend emits an empty file.
	insinto /usr/share/polkit-1/actions
	doins "${FILESDIR}/org.kde.kalarmrtcwake.policy"
}
