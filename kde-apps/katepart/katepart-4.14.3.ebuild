# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kate"
KMMODULE="part"
kde4-meta

DESCRIPTION="Editor KPart by KDE"
HOMEPAGE+=" http://kate-editor.org/about-katepart/"
KEYWORDS="amd64 x86"
IUSE="debug"

RESTRICT="test"
# bug 392993

KMEXTRA="
 addons/ktexteditor
"

PATCHES=( "${FILESDIR}/${PN}-4.14.3-gcc7.patch" )
