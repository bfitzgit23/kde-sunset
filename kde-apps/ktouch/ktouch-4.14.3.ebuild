# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE: A program that helps you to learn and practice touch typing"
HOMEPAGE="https://edu.kde.org/applications/miscellaneous/ktouch"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
 $(add_kdeapps_dep knotify)
 $(add_kdeapps_dep kqtquickcharts)
 $(add_kdeapps_dep plasma-runtime)
"
