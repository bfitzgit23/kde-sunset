# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DECLARATIVE_REQUIRED="always"
KMNAME="kde-workspace"
inherit kde4-meta

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
		-DHAVE_X86_3DNOW="$(usex cpu_flags_x86_3dnow)"
		-DHAVE_PPC_ALTIVEC="$(usex altivec)"
		-DHAVE_X86_MMX="$(usex cpu_flags_x86_mmx)"
		-DHAVE_X86_SSE="$(usex cpu_flags_x86_sse)"
		-DHAVE_X86_SSE2="$(usex cpu_flags_x86_sse2)"
		-DWITH_xinerama="$(usex xinerama)"
	)

	kde4-meta_src_configure
}
