# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde4-base

DESCRIPTION="KDE Perl bindings"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="akonadi attica debug kate okular test"

RDEPEND="
	>=dev-lang/perl-5.10.1:=
	$(add_kdebase_dep perlqt)
	$(add_kdebase_dep smokekde 'akonadi?,attica?,kate?,okular?')
"
DEPEND="${RDEPEND}
	test? ( dev-perl/List-MoreUtils )
"

PATCHES=( "${FILESDIR}/${PN}-4.11.3-vendor.patch" )

RESTRICT="test"
# yes they all fail.

src_configure() {
	local mycmakeargs=(
		-DWITH_Nepomuk=OFF
		-DWITH_Soprano=OFF
		-DWITH_akonadi="$(usex akonadi)"
		-DWITH_KdepimLibs="$(usex akonadi)"
		-DWITH_LibAttica="$(usex attica)"
		-DDISABLE_kate="$(usex !kate)"
		-DWITH_okular="$(usex okular)"
	)
	kde4-base_src_configure
}
