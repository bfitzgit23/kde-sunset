# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT_MINIMAL="4.8.7"
cmake flag-o-matic toolchain-funcs xdg-utils

DESCRIPTION="Libraries needed for programs by KDE"
HOMEPAGE="https://kde.org/"
SRC_URI="mirror://kde/stable/applications/17.08.3/src/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="4/4.14"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_3dnow acl altivec +bzip2 debug doc fam +handbook kerberos
libressl lzma cpu_flags_x86_mmx nls openexr opengl +plasma +policykit qt3support spell
test cpu_flags_x86_sse cpu_flags_x86_sse2 ssl +udev +udisks +upower webkit zeroconf"

REQUIRED_USE="
 opengl? ( plasma )
 udisks? ( udev )
 upower? ( udev )
"

# needs the kate regression testsuite from svn
RESTRICT="test"

COMMON_DEPEND="
 app-text/docbook-xml-dtd:4.2
 app-text/docbook-xsl-stylesheets
 dev-lang/perl
 >=dev-libs/libattica-0.4.2
 dev-libs/libdbusmenu-qt[qt4(-)]
 dev-libs/libpcre[unicode]
 dev-libs/libxml2
 dev-libs/libxslt
 >=dev-qt/designer-${QT_MINIMAL}:4
 >=dev-qt/qtcore-${QT_MINIMAL}:4[qt3support?,ssl]
 >=dev-qt/qtdbus-${QT_MINIMAL}:4
 >=dev-qt/qtdeclarative-${QT_MINIMAL}:4
 >=dev-qt/qtgui-${QT_MINIMAL}:4[accessibility,dbus(+)]
 >=dev-qt/qtscript-${QT_MINIMAL}:4
 >=dev-qt/qtsvg-${QT_MINIMAL}:4
 media-libs/fontconfig
 media-libs/freetype:2
 media-libs/giflib:=
 media-libs/libpng:0=
 media-libs/phonon:0-qt4
 sys-libs/libutempter
 sys-libs/zlib
 virtual/jpeg:0
 x11-libs/libICE
 x11-libs/libSM
 x11-libs/libX11
 x11-libs/libXau
 x11-libs/libXcursor
 x11-libs/libXdmcp
 x11-libs/libXext
 x11-libs/libXfixes
 x11-libs/libXft
 x11-libs/libXpm
 x11-libs/libXrender
 x11-libs/libXScrnSaver
 x11-libs/libXtst
 x11-misc/shared-mime-info
 acl? ( virtual/acl )
 bzip2? ( app-arch/bzip2 )
 fam? ( virtual/fam )
 kerberos? ( virtual/krb5 )
 openexr? (
 media-libs/ilmbase:=
 media-libs/openexr:=
 )
 opengl? ( >=dev-qt/qtopengl-${QT_MINIMAL}:4 )
 plasma? (
 app-crypt/qca:2-qt4
 >=dev-qt/qtsql-${QT_MINIMAL}:4[qt3support?]
 )
 policykit? ( sys-auth/polkit-qt:0-qt4 )
 spell? ( app-text/enchant:= )
 ssl? (
 libressl? ( dev-libs/libressl:0= )
 !libressl? ( dev-libs/openssl:0= )
 )
 udev? ( virtual/udev )
 webkit? ( >=dev-qt/qtwebkit-${QT_MINIMAL}:4 )
 zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"
DEPEND="${COMMON_DEPEND}
 >=dev-qt/qttest-${QT_MINIMAL}:4
 test? ( dev-util/cppunit )
"
RDEPEND="${COMMON_DEPEND}
 !dev-qt/qtphonon
 >=app-crypt/gnupg-2.0.11
 app-misc/ca-certificates
 kde-frameworks/kdelibs-env:4
 kde-frameworks/oxygen-icons
 sys-apps/dbus[X]
 x11-apps/iceauth
 x11-apps/rgb
 x11-misc/xdg-utils
 plasma? ( !sci-libs/plasma )
 udev? ( app-misc/media-player-info )
 udisks? ( sys-fs/udisks:2 )
 upower? ( >=sys-power/upower-0.9.23 )
"
BDEPEND="
 doc? ( app-doc/doxygen )
 nls? ( virtual/libintl )
"
PDEPEND="
 dev-util/automoc
 virtual/pkgconfig
 x11-base/xorg-proto
 >=x11-libs/libXtst-1.1.0
 x11-misc/xdg-utils
 handbook? ( kde-apps/khelpcenter:* )
 policykit? ( kde-plasma/polkit-kde-agent:* )
"

DOCS=( AUTHORS README{,-WIN32.TXT} TODO )

PATCHES=(
 "${FILESDIR}/dist/01_gentoo_set_xdg_menu_prefix-1.patch"
 "${FILESDIR}/dist/02_gentoo_append_xdg_config_dirs-1.patch"
 "${FILESDIR}/${PN}-4.14.5-fatalwarnings.patch"
 "${FILESDIR}/${PN}-4.14.5-mimetypes.patch"
 "${FILESDIR}/${PN}-4.4.90-xslt.patch"
 "${FILESDIR}/${PN}-4.6.3-no_suid_kdeinit.patch"
 "${FILESDIR}/${PN}-4.8.1-norpath.patch"
 "${FILESDIR}/${PN}-4.9.3-werror.patch"
 "${FILESDIR}/${PN}-4.10.0-udisks.patch"
 "${FILESDIR}/${PN}-4.14.20-FindQt4.patch"
 "${FILESDIR}/${PN}-4.14.22-webkit.patch"
 "${FILESDIR}/${PN}-4.14.35-3dnow.patch"
 "${FILESDIR}/${PN}-4.14.35-kde3support.patch"
 "${FILESDIR}/${PN}-4.14.35-plasma4.patch"
 "${FILESDIR}/${PN}-4.14.37-exiv2-cmake.patch"
 "${FILESDIR}/${P}-CVE-2019-14744.patch"
 "${FILESDIR}/${P}-kio-tls1x.patch"
 "${FILESDIR}/${P}-narrowing-warning.patch"
 "${FILESDIR}/${P}-openssl-1.1.patch"
 "${FILESDIR}/${P}-qiodevice.patch"
 "${FILESDIR}/${P}-library-doc-policy-links.patch"
 "${FILESDIR}/${P}-gentoo-slotted-FindPopplerQt4.patch"
 "${FILESDIR}/${P}-gentoo-docbundledir.patch" # bug 667138
)

src_prepare() {
 cmake_src_prepare

 # Rename applications.menu (needs 01_gentoo_set_xdg_menu_prefix-1.patch to work)
 sed -e 's|FILES[[:space:]]applications.menu|FILES applications.menu RENAME kde-4-applications.menu|g' \
 -i kded/CMakeLists.txt || die "Sed on CMakeLists.txt for applications.menu failed."

 if ! use opengl; then
 sed -i -e "/if/ s/QT_QTOPENGL_FOUND/FALSE/" \
 plasma/CMakeLists.txt plasma/tests/CMakeLists.txt includes/CMakeLists.txt \
 || die "failed to sed out QT_QTOPENGL_FOUND"
 fi
}

src_configure() {
 local mycmakeargs=(
 -DWITH_HSPELL=OFF
 -DWITH_ASPELL=OFF
 -DKDE_DEFAULT_HOME=.kde4
 -DKDE_DISTRIBUTION_TEXT=Gentoo
 -DKDE4_BUILD_TESTS=OFF
 -DKAUTH_BACKEND=POLKITQT-1
 -DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
 -DWITH_Soprano=OFF
 -DWITH_SharedDesktopOntologies=OFF
 -DCMAKE_DISABLE_FIND_PACKAGE_Strigi=ON
 -DBUILD_doc=$(usex handbook)
 -DHAVE_X86_3DNOW=$(usex cpu_flags_x86_3dnow)
 -DHAVE_PPC_ALTIVEC=$(usex altivec)
 -DHAVE_X86_MMX=$(usex cpu_flags_x86_mmx)
 -DHAVE_X86_SSE=$(usex cpu_flags_x86_sse)
 -DHAVE_X86_SSE2=$(usex cpu_flags_x86_sse2)
 -DWITH_ACL=$(usex acl)
 -DWITH_BZip2=$(usex bzip2)
 -DWITH_FAM=$(usex fam)
 -DWITH_Jasper=OFF
 -DWITH_GSSAPI=$(usex kerberos)
 -DWITH_LibLZMA=$(usex lzma)
 -DWITH_Libintl=$(usex nls)
 -DWITH_OpenEXR=$(usex openexr)
 -DWITH_PLASMA4SUPPORT=$(usex plasma)
 -DWITH_QCA2=$(usex plasma)
 -DWITH_PolkitQt-1=$(usex policykit)
 -DWITH_KDE3SUPPORT=$(usex qt3support)
 -DWITH_ENCHANT=$(usex spell)
 -DWITH_OpenSSL=$(usex ssl)
 -DWITH_UDev=$(usex udev)
 -DWITH_SOLID_UDISKS2=$(usex udisks)
 -DWITH_KDEWEBKIT=$(usex webkit)
 -DWITH_Avahi=$(usex zeroconf)
 )

 use zeroconf || mycmakeargs+=( -DWITH_DNSSD=OFF )

 if use debug; then
 # Set "real" debug mode
 CMAKE_KDE_BUILD_TYPE="Debugfull"
 else
 # Handle common release builds
 append-cppflags -DQT_NO_DEBUG
 fi

 tc-is-cross-compiler || cmakeargs+=( -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr" )
 #qmake -query QT_INSTALL_LIBS unavailable when cross-compiling
 tc-is-cross-compiler && cmakeargs+=( -DQT_LIBRARY_DIR="${ROOT}"/usr/$(get_libdir)/qt4 )
 #kde-config -path data unavailable when cross-compiling
 tc-is-cross-compiler && cmakeargs+=( -DKDE4_DATA_DIR="${ROOT}"/usr/share/apps/ )

 cmake_src_configure
}

src_compile() {
 cmake_src_compile

 # The building of apidox is not managed anymore by the build system
 if use doc; then
 einfo "Building API documentation"
 cd "${S}"/doc/api/ || die
 ./doxygen.sh "${S}" || die "APIDOX generation failed"
 fi
}

src_install() {
 for doc in "${S}"/*/{AUTHORS,ChangeLog*,README*,TODO}; do
 [[ -f ${doc} && -s ${doc} ]] && newdoc "${doc}" "$(basename $(dirname ${doc})).$(basename ${doc})"
 done

 cmake_src_install

 # use system certificates
 rm -f "${ED}"/usr/share/apps/kssl/ca-bundle.crt || die
 dosym ../../../../etc/ssl/certs/ca-certificates.crt /usr/share/apps/kssl/ca-bundle.crt

 if use doc; then
 einfo "Installing API documentation. This could take a bit of time."
 cd "${S}"/doc/api/ || die
 docinto html
 dodoc -r ${P}-apidocs/.
 fi

 # We don't package it, so don't install headers
 rm -r "${ED}"/usr/include/KDE/Nepomuk || die

 einfo Installing environment file.
 # Since 44qt4 is sourced earlier QT_PLUGIN_PATH is defined.
 echo "COLON_SEPARATED=QT_PLUGIN_PATH" > "${T}/77kde"
 echo "QT_PLUGIN_PATH=${EPREFIX}/usr/$(get_libdir)/kde4/plugins" >> "${T}/77kde"
 doenvd "${T}/77kde"
}

pkg_postinst() {
 xdg_desktop_database_update
 xdg_mimeinfo_database_update

 if use zeroconf; then
 elog
 elog "To make zeroconf support available in applications make sure that the avahi daemon"
 elog "is running."
 elog
 elog "If you also want to use zeroconf for hostname resolution, emerge sys-auth/nss-mdns"
 elog "and enable multicast dns lookups by editing the 'hosts:' line in /etc/nsswitch.conf"
 elog "to include 'mdns', e.g.:"
 elog " hosts: files mdns dns"
 elog
 fi
}

pkg_prerm() {
 # Remove ksycoca4 global database
 rm -f "${EROOT}"/usr/share/kde4/services/ksycoca4 || die
}

pkg_postrm() {
 xdg_desktop_database_update
 xdg_mimeinfo_database_update
}
