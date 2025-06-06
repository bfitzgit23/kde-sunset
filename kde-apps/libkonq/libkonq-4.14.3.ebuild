# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kde-baseapps"
KMMODULE="lib/konq"
CPPUNIT_REQUIRED="optional"
kde4-meta

DESCRIPTION="The embeddable part of konqueror"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"
RESTRICT="test"

KMSAVELIBS="true"

PATCHES=( "${FILESDIR}/${PN}-4.9.0-cmake.patch" )
