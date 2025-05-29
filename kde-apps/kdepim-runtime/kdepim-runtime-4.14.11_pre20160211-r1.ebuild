# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kdepim-runtime"
QT_MINIMAL="4.8.7"
EGIT_BRANCH="KDE/4.14"
inherit kde4-base

DESCRIPTION="KDE PIM runtime plugin collection"
COMMIT_ID="bb194cc299839cb00b808c9c5740169815ba9e39"
SRC_URI="https://invent.kde.org/pim/${KMNAME}/-/archive/${COMMIT_ID}/kdepim-runtime-${COMMIT_ID}.tar.gz -> ${KMNAME}-${PV}.tar.gz"
S=${WORKDIR}/${PN}-${COMMIT_ID}

KEYWORDS="amd64 x86"
IUSE="debug google"

RESTRICT="test"
# Would need test programs _testrunner and akonaditest from kdepimlibs, see bug 313233

DEPEND="
	$(add_kdeapps_dep kdepimlibs 'akonadi(+)' ${PV})
	dev-libs/boost:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	kde-apps/akonadi:4
	x11-misc/shared-mime-info
	google? ( $(add_kdeapps_dep libkgapi '' 2.0) )
"
RDEPEND="${DEPEND}
	kde-frameworks/oxygen-icons:5
	!kde-misc/akonadi-google
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package google LibKGAPI2)
	)

	kde4-base_src_configure
}
