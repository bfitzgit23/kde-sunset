# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Environment setting required for all KDELibs4 apps to run"
HOMEPAGE="https://www.kde.org/"
SRC_URI=""

KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
SLOT="4/4.14"
IUSE=""

S="${WORKDIR}"

src_install() {
 # number goes down with version
 newenvd - 43kdepaths <<EOF
CONFIG_PROTECT="/usr/share/config"
#KDE_IS_PRELINKED=1
EOF

 # Properly place xinitrc.d file that exports XDG_MENU_PREFIX to env
 exeinto /etc/X11/xinit/xinitrc.d/
 newexe - 11-xdg-menu-kde-4 <<EOF
#!/bin/sh

if [ -z "\${XDG_MENU_PREFIX}" ] && [ "\${DESKTOP_SESSION}" = "KDE-4" ]; then
 export XDG_MENU_PREFIX="kde-4-"
fi
EOF
}
