# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Common library for KDE PIM apps"
KEYWORDS="amd64 x86"
LICENSE="LGPL-2.1"
IUSE="debug ldap prison test +handbook"

# some akonadi tests timeout, that probably needs more work as its ~700 tests
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.8.0
	dev-libs/boost:=
	dev-libs/cyrus-sasl
	dev-libs/libgpg-error
	dev-libs/libical:=
	dev-libs/qjson
	kde-apps/akonadi:4
	media-libs/phonon:0-qt4
	x11-misc/shared-mime-info
	ldap? ( net-nds/openldap )
	prison? ( kde-frameworks/prison:4 )
"
# boost is not linked to, but headers which include it are installed
# bug #418071
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/fix-build-with-ical-3.0.diff"
	"${FILESDIR}/kdepimlibs-4.14.11-gpgme2-trustlist.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TOOLS=OFF
		-DBUILD_doc=$(usex handbook)
		-DCMAKE_DISABLE_FIND_PACKAGE_Ldap="$(usex !ldap)"
		-DCMAKE_DISABLE_FIND_PACKAGE_Prison="$(usex !prison)"
	)

	# The bundled gpgme++ still uses std::auto_ptr, which newer standards
	# remove, while some dependencies now require C++11 or later.  Build in
	# C++11 mode, where auto_ptr is still available, and keep the deprecation
	# warnings from becoming errors.
	append-cxxflags -std=gnu++11 -Wno-deprecated-declarations

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	# Collides with net-im/choqok
	rm "${ED}"usr/share/apps/cmake/modules/FindQtOAuth.cmake || die

	# contains constants/defines only
	QA_DT_NEEDED="$(find "${ED}" -type f -name 'libakonadi-kabc.so.*' -printf '/%P\n')"
}


