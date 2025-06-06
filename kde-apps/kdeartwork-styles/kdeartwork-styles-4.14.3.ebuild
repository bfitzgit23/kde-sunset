# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMMODULE="styles"
KMNAME="kdeartwork"
KDE_SCM="svn"
kde4-meta kde4-functions-extra

DESCRIPTION="Extra KWin styles and window decorations"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 $(add_kdeplasma_dep kwin '' 4.11)
"
RDEPEND="${DEPEND}"

KMEXTRA="
 kwin-styles/
"
