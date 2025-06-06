# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kdepim"
kde4-meta

DESCRIPTION="Application to create, edit and update blog content"
HOMEPAGE="https://www.kde.org/applications/internet/blogilo"

KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep kdepim-common-libs)
 $(add_kdeapps_dep kdepimlibs)
 $(add_kdeapps_dep libkgapi '' 2.2.0)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
 composereditor-ng/
 pimcommon/
"
