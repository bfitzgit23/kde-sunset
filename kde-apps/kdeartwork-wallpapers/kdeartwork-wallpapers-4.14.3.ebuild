# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RESTRICT="binchecks strip"

KMMODULE="wallpapers"
KMNAME="kdeartwork"
KDE_SCM="svn"
kde4-meta

DESCRIPTION="Wallpapers from kde"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

KMEXTRA="
 HighResolutionWallpapers/
"

RDEPEND="!<kde-base/kde-wallpapers-4.9.50:4"
