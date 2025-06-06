# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE version of the Simon Says game"
HOMEPAGE="https://www.kde.org/applications/education/blinken
https://edu.kde.org/blinken"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

src_install() {
 kde4-base_src_install

 rm "${D}"/usr/share/apps/${PN}/README.packagers
}
