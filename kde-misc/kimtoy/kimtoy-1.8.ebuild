# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KDE_LINGUAS="cs da de es et ga ja it nds nl pl pt pt_BR sk sv uk zh_CN"
inherit kde4-base kde4-functions-extra

DESCRIPTION="An input method frontend for KDE"
HOMEPAGE="http://kde-apps.org/content/show.php/KIMToy?content=140967"
SRC_URI="http://kde-apps.org/CONTENT/content-files/140967-${P}.tar.bz2"

SLOT="4"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+"
IUSE=""

DEPEND="
	>=app-i18n/fcitx-4.0
	>=app-i18n/scim-1.4.9
	dev-libs/dbus-c++
"
RDEPEND="${DEPEND}
	$(add_kdeplasma_dep plasma-workspace)
"

src_configure() {
	local mycmakeargs=(
		-DWITH_IBus=OFF
	)

	kde4-base_src_configure
}
