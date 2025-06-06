# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
kde4-base

DESCRIPTION="KDE Wallet Management Tool"
HOMEAGE="https://www.kde.org/applications/system/kwalletmanager
https://utils.kde.org/projects/kwalletmanager"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="!kde-base/kwallet:4"
