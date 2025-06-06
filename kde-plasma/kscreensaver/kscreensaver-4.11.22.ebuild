# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kde-workspace"
kde4-meta

DESCRIPTION="KDE Plasma screensaver framework"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
 kde-plasma/kcheckpass:4
 x11-libs/libX11
"
DEPEND="${RDEPEND}"

PATCHES=(
 "${FILESDIR}/${PN}-4.5.95-nsfw.patch"
)
