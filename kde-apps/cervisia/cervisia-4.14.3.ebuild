# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="Cervisia - A KDE CVS frontend"
HOMEPAGE="https://www.kde.org/applications/development/cervisia"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
 dev-vcs/cvs
"
