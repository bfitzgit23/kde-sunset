# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kde-runtime"
kde4-meta

DESCRIPTION="KDE Password Server"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug gpg"

DEPEND="
 dev-libs/libgcrypt:0=
 gpg? (
 app-crypt/gpgme
 $(add_kdeapps_dep kdepimlibs)
 )
"
RDEPEND="${DEPEND}"

RESTRICT="test"
# testpamopen crashes with a buffer overflow (__fortify_fail)

PATCHES=(
 "${FILESDIR}/${P}-CVE-2013-7252.patch"
 "${FILESDIR}/${P}-fix-random-open.patch"
)

src_configure() {
 local mycmakeargs=(
 $(cmake-utils_use_find_package gpg Gpgme)
 $(cmake-utils_use_find_package gpg QGpgme)
 )

 kde4-base_src_configure
}
