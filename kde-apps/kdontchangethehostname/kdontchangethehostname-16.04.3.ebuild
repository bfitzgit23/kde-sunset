# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kde-runtime"
kde4-meta

DESCRIPTION="Tool to inform Plasma about a change in hostname"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
 x11-apps/xauth
"
