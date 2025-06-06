# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="Plasmoid for monitoring emerge progress"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=103928"
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/projects/plasma-emergelog/${P}.tar.gz"

LICENSE="GPL-3+"
# Included LICENSE is GPL-2, but all headers say 3+. hwoarang said
# that it can be licensed as 3+
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND="
 kde-plasma/plasma-workspace:4
"

PATCHES=(
 "${FILESDIR}"/${PN}-0.0.2-list.patch
)

pkg_postinst() {
 kde4-base_pkg_postinst
 einfo "You need to add your user to 'portage' group"
 einfo "in order to use this plasmoid. To do that, use"
 einfo "the following command:"
 einfo "usermod -a -G portage <your_user_here>"
}
