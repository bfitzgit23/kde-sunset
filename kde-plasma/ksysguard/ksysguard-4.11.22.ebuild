# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
CPPUNIT_REQUIRED="optional"
VIRTUALX_REQUIRED="test"
WEBKIT_REQUIRED="always"
kde4-meta

DESCRIPTION="Network-enabled task manager and system monitor"
HOMEPAGE+=" https://userbase.kde.org/KSysGuard"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug lm-sensors test"

DEPEND="
 sys-libs/zlib
 x11-libs/libX11
 x11-libs/libXres
 lm-sensors? ( sys-apps/lm-sensors )
"
RDEPEND="${DEPEND}"

RESTRICT="test"
# bug 393091

KMEXTRA="
 libs/ksysguard/
"

src_configure() {
 local mycmakeargs=(
 $(cmake-utils_use_with lm-sensors Sensors)
 )

 kde4-meta_src_configure
}

pkg_postinst() {
 kde4-meta_pkg_postinst
 ewarn "Note that ksysguard has powerful features; one of these is the executing of arbitrary"
 ewarn "programs with elevated privileges (as data sources). So be careful opening worksheets"
 ewarn "from untrusted sources!"
}
