# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_SELINUX_MODULE="gpg"
kde4-base

DESCRIPTION="KDE gpg keyring manager"
HOMEPAGE="https://www.kde.org/applications/utilities/kgpg
https://utils.kde.org/projects/kgpg"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
 $(add_kdeapps_dep kdepimlibs)
"
RDEPEND="${DEPEND}
 app-crypt/gnupg
"

pkg_postinst() {
 kde4-base_pkg_postinst

 if ! has_version 'app-crypt/dirmngr' && ! has_version '>=app-crypt/gnupg-2.1'; then
 elog "For improved key search functionality, install app-crypt/dirmngr."
 fi
}
