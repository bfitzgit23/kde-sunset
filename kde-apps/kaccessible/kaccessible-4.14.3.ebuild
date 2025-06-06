# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

kde4-base

DESCRIPTION="Provides accessibility services like focus tracking"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +speechd"

DEPEND="speechd? ( app-accessibility/speech-dispatcher )"
RDEPEND=${DEPEND}

src_configure() {
 local mycmakeargs=(
 $(cmake-utils_use_with speechd)
 )
 kde4-base_src_configure
}
