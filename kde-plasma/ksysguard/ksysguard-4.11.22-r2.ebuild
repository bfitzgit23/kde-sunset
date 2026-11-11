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

DEPEND="
    sys-libs/zlib
    x11-libs/libX11
    x11-libs/libXres
    lm-sensors? ( sys-apps/lm-sensors )
"
RDEPEND="${DEPEND}"

RESTRICT="test"
# bug 393091

KMEXTRA="libs/ksysguard/"

PATCHES=(
    "${FILESDIR}/${P}-cmake4-auth-actions.patch"
    "${FILESDIR}/${P}-optional-webkit.patch"
)

src_prepare() {
    kde4-meta_src_prepare

    # CMake 4 (CMP0037): kde4_install_auth_actions() builds an invalid target name
    # from the dotted helper id. Apply the inlined replacement here as well, so the
    # build does not depend on the eclass having honoured PATCHES.
    local pc="${S}/libs/ksysguard/processcore/CMakeLists.txt"
    if grep -q 'kde4_install_auth_actions(org\.kde\.ksysguard\.processlisthelper actions\.actions)' "${pc}"; then
        eapply "${FILESDIR}/${P}-cmake4-auth-actions.patch"
    fi
    if grep -q 'kde4_install_auth_actions(org\.kde\.ksysguard\.processlisthelper actions\.actions)' "${pc}"; then
        die "CMake 4 auth-actions replacement missing in ${pc}"
    fi
}

src_configure() {
    local mycmakeargs=(
        -DCMAKE_DISABLE_FIND_PACKAGE_QtWebKit="$(usex !webkit)"
        -DWITH_Sensors="$(usex lm-sensors)"
    )

    kde4-meta_src_configure
}

pkg_postinst() {
    kde4-meta_pkg_postinst
    ewarn "Note that ksysguard has powerful features; one of these is the executing of arbitrary"
    ewarn "programs with elevated privileges (as data sources). So be careful opening worksheets"
    ewarn "from untrusted sources!"
}
