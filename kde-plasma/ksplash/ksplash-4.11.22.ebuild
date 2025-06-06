# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DECLARATIVE_REQUIRED="always"
KMNAME="kde-workspace"
kde4-meta

DESCRIPTION="KDE Plasma splashscreen framework"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_3dnow altivec debug cpu_flags_x86_mmx cpu_flags_x86_sse
cpu_flags_x86_sse2 xinerama"

RDEPEND="
 media-libs/libpng:0=
 virtual/jpeg:0
 x11-libs/libX11
 x11-libs/libXext
 xinerama? ( x11-libs/libXinerama )
"
DEPEND="${RDEPEND}
 xinerama? ( x11-base/xorg-proto )
"

src_configure() {
 local mycmakeargs=(
 $(cmake-utils_use_has cpu_flags_x86_3dnow X86_3DNOW)
 $(cmake-utils_use_has altivec PPC_ALTIVEC)
 $(cmake-utils_use_has cpu_flags_x86_mmx X86_MMX)
 $(cmake-utils_use_has cpu_flags_x86_sse X86_SSE)
 $(cmake-utils_use_has cpu_flags_x86_sse2 X86_SSE2)
 $(cmake-utils_use_with xinerama)
 )

 kde4-meta_src_configure
}
