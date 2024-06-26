# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DECLARATIVE_REQUIRED="always"
inherit kde4-base

DESCRIPTION="Qt Quick 1 plugin for beautiful and interactive charts"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="$(add_kdeapps_dep plasma-runtime)"
