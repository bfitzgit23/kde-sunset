# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ string template engine based on the Django template system"
HOMEPAGE="https://github.com/steveire/grantlee"
SRC_URI="https://ftp.osuosl.org/pub/blfs/conglomeration/grantlee/grantlee-0.4.0.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="debug doc test"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4
"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.7.6.1[dot] )
	test? ( dev-qt/qttest:4 )
"

# Some tests fail
RESTRICT="test"

DOCS=( AUTHORS CHANGELOG GOALS README )
PATCHES=(
	"${FILESDIR}/${PN}-0.3.0-nonfatal-warnings.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS="$(usex test)"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && cmake-utils_src_compile docs
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}/apidox/" )

	cmake-utils_src_install
}
