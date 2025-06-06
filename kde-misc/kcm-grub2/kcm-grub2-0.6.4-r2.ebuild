# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_LINGUAS="ca ca@valencia cs da de el es et fi fr ga gl hu it lt nl pa pl pt
pt_BR ro ru sk sl sv uk tr zh_TW"
kde4-base

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
 $(cmake-utils_use_with imagemagick ImageMagick)
 $(cmake-utils_use_with hwinfo HD)
 )
 cmake-utils_src_configure
}
