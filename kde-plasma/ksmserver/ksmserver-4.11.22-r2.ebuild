# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DECLARATIVE_REQUIRED="optional"
KMNAME="kde-workspace"
inherit kde4-meta pax-utils

DESCRIPTION="The reliable Plasma session manager that talks the standard X11R6"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +declarative +qimageblitz"

DEPEND="
	kde-plasma/kcminit:4
	kde-plasma/libkworkspace:4
	qimageblitz? ( media-libs/qimageblitz )
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXrender
"
RDEPEND="${DEPEND}
	kde-plasma/libkgreeter:4
"

KMEXTRACTONLY="
	kcminit/main.h
	libs/kdm/kgreeterplugin.h
	kcheckpass/
	libs/kephal/
	libs/kworkspace/
"

KMLOADLIBS="libkworkspace"

PATCHES=(
	"${FILESDIR}/${P}-optional-qml.patch"
)

src_prepare() {
	kde4-meta_src_prepare

	# KDeclarative and friends are soft dependencies; this downgrades the
	# find_package() blocks and defines HAVE_QTDECLARATIVE for the sources
	# guarded by it.  Done here instead of by a patch: the block sits at a
	# different offset in different 4.11.22 snapshots and the hunk was
	# rejected there.
	kde4_make_qml_optional
}


src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_KDeclarative="$(usex !declarative)"
		-DCMAKE_DISABLE_FIND_PACKAGE_QtDeclarative="$(usex !declarative)"
		-DCMAKE_DISABLE_FIND_PACKAGE_QImageBlitz="$(usex !qimageblitz)"
	)

	kde4-meta_src_configure
}

src_install() {
	kde4-meta_src_install

	# bug #483236
	pax-mark m "${ED}/usr/$(get_libdir)/kde4/libexec/kscreenlocker_greet"
}
