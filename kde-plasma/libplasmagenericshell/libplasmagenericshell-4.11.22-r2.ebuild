# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DECLARATIVE_REQUIRED="optional"
KMNAME="kde-workspace"
KMMODULE="libs/plasmagenericshell"
inherit kde4-meta

DESCRIPTION="Libraries for the KDE Plasma shell"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +declarative"

DEPEND="
	kde-plasma/kephal:4
	kde-plasma/libkworkspace:4
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

KMSAVELIBS="true"

KMEXTRACTONLY="
	libs/kephal/kephal/
	plasma/desktop/shell/data/
"

PATCHES=(
	"${FILESDIR}/${P}-optional-qml-shell.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_KDeclarative="$(usex !declarative)"
		-DCMAKE_DISABLE_FIND_PACKAGE_QtDeclarative="$(usex !declarative)"
	)

	kde4-meta_src_configure
}
