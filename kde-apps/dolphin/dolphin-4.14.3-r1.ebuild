# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kde-baseapps"
kde4-meta kde4-functions-extra

DESCRIPTION="A KDE filemanager focusing on usability"
HOMEPAGE="https://dolphin.kde.org https://www.kde.org/applications/system/dolphin"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug semantic-desktop thumbnail"

DEPEND="
 $(add_kdeframeworks_dep kactivities '' 4.13)
 $(add_kdeapps_dep libkonq)
 media-libs/phonon:0-qt4
 x11-libs/libXrender
 semantic-desktop? (
 $(add_kdeframeworks_dep baloo)
 $(add_kdeapps_dep baloo-widgets)
 $(add_kdeframeworks_dep kfilemetadata)
 )
"
RDEPEND="${DEPEND}
 $(add_kdeapps_dep kdebase-kioslaves)
 $(add_kdeapps_dep kfind)
 $(add_kdeapps_dep konsolepart)
 thumbnail? (
 $(add_kdeapps_dep thumbnailers)
 $(add_kdeapps_dep ffmpegthumbs)
 )
"

RESTRICT="test"
# bug 393129

src_configure() {
 local mycmakeargs=(
 $(cmake-utils_use_with semantic-desktop Baloo)
 $(cmake-utils_use_with semantic-desktop BalooWidgets)
 $(cmake-utils_use_with semantic-desktop KFileMetaData)
 )

 kde4-meta_src_configure
}

pkg_postinst() {
 kde4-base_pkg_postinst

 if ! has_version media-gfx/icoutils ; then
 elog "For .exe file preview support, install media-gfx/icoutils."
 fi
}
