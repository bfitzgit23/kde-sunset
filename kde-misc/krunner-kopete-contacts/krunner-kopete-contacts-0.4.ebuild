# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="A krunner plug-in that allows you to open conversation with your contact"
HOMEPAGE="http://www.kde-apps.org/content/show.php?action=content&content=105263"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/105263-${P}.tar.gz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
 kde-plasma/libkworkspace:4
 $(add_kdeapps_dep kopete)
"
RDEPEND="${DEPEND}"

DOCS=(README)
