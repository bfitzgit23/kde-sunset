# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base kde4-functions-extra

DESCRIPTION="KDE: screensaver featuring the Space-Faring Tux"
HOMEPAGE+=" https://userbase.kde.org/KTux"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# libkworkspace - only as a stub to provide KDE4Workspace config
DEPEND="
 $(add_kdeplasma_dep kscreensaver '' 4.11)
 $(add_kdeplasma_dep libkworkspace '' 4.11)
"
RDEPEND="${DEPEND}"
