# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WEBKIT_REQUIRED="always"
inherit flag-o-matic kde4-base

DESCRIPTION="Extra Plasma applets and engines"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="attica debug desktopglobe eigen exif fcitx ibus json oauth +pim
qalculate qwt scim"

RESTRICT=test
# tests hang

# krunner is only needed to generate dbus interface for lancelot
COMMON_DEPEND="
	app-crypt/qca:2-qt4
	kde-plasma/krunner:4
	kde-plasma/plasma-workspace:4
	x11-misc/shared-mime-info
	attica? ( dev-libs/libattica )
	desktopglobe? ( $(add_kdeapps_dep marble) )
	exif? ( $(add_kdeapps_dep libkexiv2) )
	fcitx? ( app-i18n/fcitx[dbus(+)] )
	ibus? ( app-i18n/ibus )
	json? ( dev-libs/qjson )
	oauth? ( dev-libs/qoauth:0 )
	pim? ( $(add_kdeapps_dep kdepimlibs) )
	qalculate? ( sci-libs/libqalculate )
	qwt? ( x11-libs/qwt:5 )
	scim? ( app-i18n/scim )
"
DEPEND="${COMMON_DEPEND}
	eigen? ( dev-cpp/eigen:2 )
"
RDEPEND="${COMMON_DEPEND}
	app-crypt/qca:2-qt4[ssl]
"

PATCHES=(
   "${FILESDIR}/${P}-webkit.patch"
)

src_configure() {
	local mycmakeargs=(
		-DDBUS_INTERFACES_INSTALL_DIR="${EPREFIX}/usr/share/dbus-1/interfaces/"
		-DWITH_Nepomuk=OFF
		-DWITH_KDEWEBKIT=OFF
		-DWITH_LibAttica="$(usex attica)"
		-DWITH_Marble="$(usex desktopglobe)"
		-DCMAKE_DISABLE_FIND_PACKAGE_Eigen2="$(usex !eigen)"
		-DWITH_Kexiv2="$(usex exif)"
		-DBUILD_ibus="$(usex ibus)"
		-DWITH_QJSON="$(usex json)"
		-DWITH_QtOAuth="$(usex oauth)"
		-DWITH_KdepimLibs="$(usex pim)"
		-DWITH_qalculate="$(usex qalculate)"
		-DWITH_qwt="$(usex qwt)"
		-DBUILD_scim="$(usex scim)"
	)

	kde4-base_src_configure
}
