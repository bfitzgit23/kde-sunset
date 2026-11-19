# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DECLARATIVE_REQUIRED="always"
KDE_LINGUAS="bg bs ca ca@valencia cs da de en_GB eo es et fi fr ga gl hu is it
ja ko lt mai mr nb nds nl nn pl pt pt_BR ro ru sk sv tr ug uk zh_CN zh_TW"
KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
inherit kde4-base

DESCRIPTION="The advanced network neighborhood browser by KDE"
HOMEPAGE="https://sourceforge.net/projects/smb4k/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="net-fs/samba[cups]"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

DOCS=( AUTHORS BUGS ChangeLog README )

PATCHES=(
	"${FILESDIR}/smb4k-1.2.3-CVE-2017-8849.patch"
	"${FILESDIR}/smb4k-1.2.3-cmake4-auth-actions.patch"
)

src_prepare() {
	kde4-base_src_prepare

	# CMake 4 (CMP0037): kde4_install_auth_actions() builds an invalid target name
	# from the dotted helper id, so the call is dropped and the policy is installed
	# from FILESDIR. Apply that replacement here as well, so the build does not
	# depend on the eclass having honoured PATCHES.
	local pc="${S}/helpers/CMakeLists.txt"
	if grep -q 'kde4_install_auth_actions( net\.sourceforge\.smb4k\.mounthelper smb4kmounthelper\.actions )' "${pc}"; then
		eapply "${FILESDIR}/smb4k-1.2.3-cmake4-auth-actions.patch"
	fi
	if grep -q 'kde4_install_auth_actions( net\.sourceforge\.smb4k\.mounthelper smb4kmounthelper\.actions )' "${pc}"; then
		die "CMake 4 auth-actions replacement missing in ${pc}"
	fi
}

src_install() {
	kde4-base_src_install

	# The mount helper action policy is installed from the pre-generated policy: the
	# KAuth policy generator cannot produce a valid target name under CMake 4, and a
	# fake KAuth backend emits an empty file.
	insinto /usr/share/polkit-1/actions
	doins "${FILESDIR}/net.sourceforge.smb4k.mounthelper.policy"
}
