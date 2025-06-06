# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kdepim"
kde4-meta

DESCRIPTION="Personal alarm message, command and email scheduler by KDE"
HOMEPAGE+=" https://userbase.kde.org/KAlarm"

KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
 $(add_kdeapps_dep kdepim-common-libs)
 $(add_kdeapps_dep kdepimlibs)
 $(add_kdeapps_dep ktimezoned)
 media-libs/phonon:0-qt4
 x11-libs/libX11
"
DEPEND="${RDEPEND}"

KMEXTRACTONLY="
 kmail/
"
