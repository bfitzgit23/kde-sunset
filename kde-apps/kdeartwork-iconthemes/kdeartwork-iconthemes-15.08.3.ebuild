# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kdeartwork"
KMMODULE="IconThemes"
KDE_SCM="svn"
kde4-meta

DESCRIPTION="Icon themes for kde"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Provides nuvola icon theme
RDEPEND="
 !x11-themes/nuvola
"
