# ================= ORIGINAL FILE BELOW =================
# (Preserved as requested)
# --------------------------------------------------------
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P#lib}"
MY_PN="${PN#lib}"
inherit cmake-utils

DESCRIPTION="A library providing access to Open Collaboration Services"
HOMEPAGE="https://www.kde.org/"
SRC_URI="mirror://kde/stable/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug test"

RESTRICT+=" !test? ( test )"

RDEPEND="
	dev-qt/qtcore:4
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qtgui:4
		dev-qt/qttest:4
	)
"

DOCS=( AUTHORS ChangeLog README )

S=${WORKDIR}/${MY_P}

src_configure() {
	local mycmakeargs=(
		-DQT4_BUILD=true
		-DATTICA_ENABLE_TESTS="$(usex test)"
	)
	cmake-utils_src_configure
}


# ================= MODERNIZED EBUILD BELOW ==============
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P#lib}"
MY_PN="${PN#lib}"
inherit cmake-utils

DESCRIPTION="A library providing access to Open Collaboration Services"
HOMEPAGE="https://www.kde.org/"
SRC_URI="mirror://local/libattica-0.4.2.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"

RESTRICT+=" !test? ( test )"

RDEPEND="
	dev-qt/qtcore:4
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qtgui:4
		dev-qt/qttest:4
	)
"

DOCS=( AUTHORS ChangeLog README )

S=${WORKDIR}/${MY_P}

src_configure() {
	local mycmakeargs=(
		-DQT4_BUILD=true
		-DATTICA_ENABLE_TESTS="$(usex test)"
	)
	cmake-utils_src_configure
}
