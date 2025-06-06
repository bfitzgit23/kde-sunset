# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kde-wallpapers"
KDE_SCM="svn"
kde4-base

DESCRIPTION="KDE wallpapers"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

src_configure() {
 local mycmakeargs=( -DWALLPAPER_INSTALL_DIR="${EPREFIX}/usr/share/wallpapers" )

 kde4-base_src_configure
}
