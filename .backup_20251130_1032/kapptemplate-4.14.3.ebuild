# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_HANDBOOK="optional"
inherit kde4-meta

DESCRIPTION="A shell script to create the necessary framework to develop KDE applications"
HOMEPAGE="https://www.kde.org/applications/development/kapptemplate"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"
RDEPEND="${DEPEND}"
SLOT=0
