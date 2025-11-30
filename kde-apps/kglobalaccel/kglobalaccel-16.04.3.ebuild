# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-runtime"
inherit 

DESCRIPTION="KDE's Global Shortcut Daemon"
KEYWORDS="amd64 x86"
IUSE="debug"

src_configure() {
	local mycmakeargs=(
		-DKDEBASE_KGLOBALACCEL_REMOVE_OBSOLETE_KDED_DESKTOP_FILE=NOTFOUND
		-DKDEBASE_KGLOBALACCEL_REMOVE_OBSOLETE_KDED_PLUGIN=NOTFOUND
	)

	_src_configure
}
RDEPEND="${DEPEND}"
