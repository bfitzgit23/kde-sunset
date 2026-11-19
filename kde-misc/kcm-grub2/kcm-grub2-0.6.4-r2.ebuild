# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_LINGUAS="ca ca@valencia cs da de el es et fi fr ga gl hu it lt nl pa pl pt
pt_BR ro ru sk sl sv uk tr zh_TW"
inherit kde4-base

DESCRIPTION="KCModule for configuring the GRUB2 bootloader"
HOMEPAGE="http://kde-apps.org/content/show.php?content=139643"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-3"

KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="+hwinfo imagemagick"

COMMON_DEPEND="
	hwinfo? ( sys-apps/hwinfo )
	imagemagick? ( media-gfx/imagemagick )
"
DEPEND="${COMMON_DEPEND}
	dev-util/automoc
"
RDEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep kcmshell)
"

src_configure() {
	local mycmakeargs=(
		"-DWITHQApt=OFF"
		"-DWITH_QPackageKit=OFF"
		"-DGRUB_INSTALL_EXE=${EPREFIX}/usr/sbin/grub-install"
		"-DGRUB_MKCONFIG_EXE=${EPREFIX}/usr/sbin/grub-mkconfig"
		"-DGRUB_PROBE_EXE=${EPREFIX}/usr/sbin/grub-probe"
		"-DGRUB_SET_DEFAULT_EXE=${EPREFIX}/usr/sbin/grub-set-default"
		"-DGRUB_MENU=/boot/grub/grub.cfg"
		"-DGRUB_CONFIG=/etc/default/grub"
		"-DGRUB_ENV=/boot/grub/grubenv"
		"-DGRUB_MEMTEST=/etc/grub.d/39_memtest86+"
		-DWITH_ImageMagick="$(usex imagemagick)"
		-DWITH_HD="$(usex hwinfo)"
	)
	kde4-base_src_configure
}

PATCHES=(
	"${FILESDIR}/kcm-grub2-0.6.4-cmake4-auth-actions.patch"
)

src_prepare() {
	kde4-base_src_prepare

	# CMake 4 (CMP0037): kde4_install_auth_actions() builds an invalid target name
	# from the dotted helper id, so the call is dropped and the policy is installed
	# from FILESDIR. Apply that replacement here as well, so the build does not
	# depend on the eclass having honoured PATCHES.
	local pc="${S}/src/helper/CMakeLists.txt"
	if grep -q 'kde4_install_auth_actions(org\.kde\.kcontrol\.kcmgrub2 kcmgrub2\.actions)' "${pc}"; then
		eapply "${FILESDIR}/kcm-grub2-0.6.4-cmake4-auth-actions.patch"
	fi
	if grep -q 'kde4_install_auth_actions(org\.kde\.kcontrol\.kcmgrub2 kcmgrub2\.actions)' "${pc}"; then
		die "CMake 4 auth-actions replacement missing in ${pc}"
	fi
}

src_install() {
	kde4-base_src_install

	# The helper action policy is installed from the pre-generated policy: the KAuth
	# policy generator cannot produce a valid target name under CMake 4, and a fake
	# KAuth backend emits an empty file.
	insinto /usr/share/polkit-1/actions
	doins "${FILESDIR}/org.kde.kcontrol.kcmgrub2.policy"
}
