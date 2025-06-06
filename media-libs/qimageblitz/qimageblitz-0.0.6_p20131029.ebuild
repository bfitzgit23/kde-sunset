# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

cmake

DESCRIPTION="Graphical effect and filter library by KDE"
HOMEPAGE="https://websvn.kde.org/trunk/kdesupport/qimageblitz/"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="altivec cpu_flags_x86_3dnow cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 debug"

DEPEND="
 dev-qt/qtcore:4
 dev-qt/qtgui:4
"
RDEPEND="${DEPEND}"

PATCHES=(
 "${FILESDIR}/${P}-gcc.patch"
 "${FILESDIR}/${P}-cxx11.patch" # bug 690360
)

src_configure() {
 local mycmakeargs=(
 -DQT4_BUILD=ON
 -DHAVE_3DNOW=$(usex cpu_flags_x86_3dnow)
 -DHAVE_MMX=$(usex cpu_flags_x86_mmx)
 -DHAVE_SSE=$(usex cpu_flags_x86_sse)
 -DHAVE_SSE2=$(usex cpu_flags_x86_sse2)
 )
 use ppc && mycmakeargs+=( -DHAVE_ALTIVEC=$(usex altivec) )

 cmake_src_configure
}
