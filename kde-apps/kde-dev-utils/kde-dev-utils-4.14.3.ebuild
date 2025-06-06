# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="KDE Development Utilities"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
 !kde-base/kdesdk-misc:4
 !kde-base/kstartperf:4
 !kde-base/kuiviewer:4
"
