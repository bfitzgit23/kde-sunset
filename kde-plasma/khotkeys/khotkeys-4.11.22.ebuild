# ================= ORIGINAL FILE BELOW =================
# (Preserved as requested)
# --------------------------------------------------------
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="KDE Plasma workspace hotkey module"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	kde-plasma/libkworkspace:4
	x11-libs/libX11
	x11-libs/libXtst
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libs/kworkspace/
"


# ================= MODERNIZED EBUILD BELOW ==============
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="KDE Plasma workspace hotkey module"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	kde-plasma/libkworkspace:4
	x11-libs/libX11
	x11-libs/libXtst
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libs/kworkspace/
"
