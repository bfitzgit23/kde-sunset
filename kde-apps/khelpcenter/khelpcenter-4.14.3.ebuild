# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="always"
KMNAME="kde-runtime"
kde4-meta

DESCRIPTION="The KDE Help Center"
HOMEPAGE+=" https://userbase.kde.org/KHelpCenter"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
 $(add_kdeapps_dep kdesu)
 >=www-misc/htdig-3.2.0_beta6-r1
"

KMEXTRA="
 doc/documentationnotfound/
 doc/glossary/
 doc/onlinehelp/
"
