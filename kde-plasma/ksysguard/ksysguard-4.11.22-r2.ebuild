# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-workspace"
CPPUNIT_REQUIRED="optional"
VIRTUALX_REQUIRED="test"
WEBKIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="Network-enabled task manager and system monitor"
HOMEPAGE+=" https://userbase.kde.org/KSysGuard"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug lm-sensors test webkit"

DEPEND="\n\tsys-libs/zlib\n\tx11-libs/libX11\n\tx11-libs/libXres\n\t\tlm-sensors? ( sys-apps/lm-sensors )\n"
RDEPEND="${DEPEND}"
RESTRICT="test"

KMEXTRA="libs/ksysguard/"

PATCHES=(
\t"${FILESDIR}/${P}-optional-webkit.patch"
\t"${FILESDIR}/${P}-processlisthelper-target.patch"
)

src_configure() {
\tlocal mycmakeargs=(
\t\t-DCMAKE_DISABLE_FIND_PACKAGE_QtWebKit="$(usex !webkit)"
\t\t-DWITH_Sensors="$(usex lm-sensors)"
\t)

\tkde4-meta_src_configure
}

pkg_postinst() {
\tkde4-meta_pkg_postinst
\twarn "Note that ksysguard has powerful features; one of these is the executing of arbitrary"
\twarn "programs with elevated privileges (as data sources). So be careful opening worksheets"
\twarn "from untrusted sources!"
}