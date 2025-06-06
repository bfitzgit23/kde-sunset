# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_LINGUAS="bg bs ca ca@valencia cs da de el en_GB eo es et fr ga gl hi hne hr hu
is it ja kk lt mai mr nb nds nl nn pl pt pt_BR ro sk sl sv tr uk zh_TW"
KDE_HANDBOOK="optional"
VIRTUALX_REQUIRED="test"
WEBKIT_REQUIRED="always"
kde4-base

DESCRIPTION="A recipe application by KDE"
HOMEPAGE="https://apps.kde.org/en/krecipes"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
 dev-db/sqlite:3
 dev-libs/libxml2
 dev-libs/libxslt
 media-libs/qimageblitz
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS BUGS README TODO ChangeLog )
