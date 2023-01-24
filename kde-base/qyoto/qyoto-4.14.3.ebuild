# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_REQUIRED="never"
inherit mono-env kde4-base

DESCRIPTION="C# bindings for Qt"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +phonon qscintilla webkit"
HOMEPAGE="https://techbase.kde.org/Development/Languages/Qyoto"

DEPEND="
	dev-lang/mono
	$(add_kdebase_dep smokeqt 'opengl,phonon?,qscintilla?,webkit?')
"
RDEPEND="${DEPEND}"

pkg_setup() {
	mono-env_pkg_setup
	kde4-base_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DWITH_phonon="$(usex phonon)"
		-DDISABLE_QScintilla="$(usex !qscintilla)"
		-DDISABLE_QtWebKit="$(usex !webkit)"
	)
	kde4-base_src_configure
}
