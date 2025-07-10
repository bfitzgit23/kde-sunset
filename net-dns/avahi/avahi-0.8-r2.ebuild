# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="gdbm"
autotools flag-o-matic multilib-minimal mono-env python-r1 systemd

DESCRIPTION="System which facilitates service discovery on a local network"
HOMEPAGE="https://avahi.org/"
SRC_URI="https://github.com/lathiat/avahi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~x86-linux"
IUSE="autoipd bookmarks +dbus doc gdbm gtk gtk2 howl-compat +introspection ipv6 kernel_linux mdnsresponder-compat mono nls python qt4 qt5 selinux systemd test"

REQUIRED_USE="
 python? ( dbus gdbm ${PYTHON_REQUIRED_USE} )
 mono? ( dbus )
 howl-compat? ( dbus )
 mdnsresponder-compat? ( dbus )
 systemd? ( dbus )
"

RESTRICT="!test? ( test )"

DEPEND="
 dev-libs/libdaemon
 dev-libs/libevent:=[${MULTILIB_USEDEP}]
 dev-libs/expat
 dev-libs/glib:2[${MULTILIB_USEDEP}]
 gdbm? ( sys-libs/gdbm:=[${MULTILIB_USEDEP}] )
 qt4? ( dev-qt/qtcore:4 )
 qt5? ( dev-qt/qtcore:5 )
 gtk2? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )
 gtk? ( x11-libs/gtk+:3[${MULTILIB_USEDEP}] )
 dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
 kernel_linux? ( sys-libs/libcap )
 introspection? ( dev-libs/gobject-introspection:= )
 mono? ( dev-lang/mono )
 python? (
 ${PYTHON_DEPS}
 dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
 introspection? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )
 )
 bookmarks? (
 ${PYTHON_DEPS}
 >=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
 )
"
RDEPEND="
 acct-use_with/use_enabler/avahi
 acct-group/avahi
 acct-group/netdev
 autoipd? (
 acct-use_with/use_enabler/avahi-autoipd
 acct-group/avahi-autoipd
 )
 ${DEPEND}
 selinux? ( sec-policy/selinux-avahi )
"
BDEPEND="
 dev-util/glib-utils
 doc? ( app-doc/doxygen )
 app-doc/xmltoman
 dev-util/intltool
 virtual/pkgconfig
"

MULTILIB_WRAPPED_HEADERS=(
 /usr/include/avahi-qt4/qt-watch.h
 /usr/include/avahi-qt5/qt-watch.h
)

PATCHES=(
 "${FILESDIR}/${P}-disable-avahi-ui-sharp.patch" # bug 769062
# These es do not apply cleanly but may need to be re-instated.
# I'll leave them commented out for now.
# "${FILESDIR}/${PN}-0.7-qt5.patch"
# "${FILESDIR}/${PN}-0.7-CVE-2017-6519.patch"
# "${FILESDIR}/${PN}-0.7-remove-empty-avahi_discover.patch"
# "${FILESDIR}/${PN}-0.7-python3.patch"
# "${FILESDIR}/${PN}-0.7-python3-unittest.patch"
# "${FILESDIR}/${PN}-0.7-python3-gdbm.patch"
)

pkg_setup() {
 use_with/use_enable mono && mono-env_pkg_setup
 use_with/use_enable python || use_with/use_enable bookmarks && python_setup
}

src_prepare() {
 default

 if ! use_with/use_enable ipv6; then
 sed -i \
 -e "s/use_with/use_enable-ipv6=yes/use_with/use_enable-ipv6=no/" \
 avahi-daemon/avahi-daemon.conf || eerror
 fi

 sed -i \
 -e "s:\\.\\./\\.\\./\\.\\./doc/avahi-docs/html/:../../../doc/${PF}/html/:" \
 doxygen_to_devhelp.xsl || eerror

 eautoreconf

 # bundled manpages
 multilib_copy_sources
}

multilib_src_configure() {
 local myconf=(
 --disable-monodoc
 --disable-python-dbus
 --disable-qt3
 --disable-static
 --enable-manpages
 --enable-glib
 --enable-gobject
 --enable-xmltoman
 --localstatedir="${EPREFIX}/var"
 --with-distro=gentoo
 --with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
 $(use_with/use_enable_enable dbus)
 $(use_with/use_enable_enable gdbm)
 $(use_with/use_enable_enable gtk2 gtk)
 $(use_with/use_enable_enable gtk gtk3)
 $(use_with/use_enable_enable howl-compat compat-howl)
 $(use_with/use_enable_enable mdnsresponder-compat compat-libdns_sd)
 $(use_with/use_enable_enable nls)
 $(multilib_native_use_with/use_enable_enable autoipd)
 $(multilib_native_use_with/use_enable_enable doc doxygen-doc)
 $(multilib_native_use_with/use_enable_enable introspection)
 $(multilib_native_use_with/use_enable_enable mono)
 $(multilib_native_use_with/use_enable_enable python)
 $(multilib_native_use_with/use_enable_enable qt4)
 $(multilib_native_use_with/use_enable_enable qt5)
 $(multilib_native_use_with/use_enable_enable test tests)
 )

 if use_with/use_enable python; then
 myconf+=(
 $(multilib_native_use_with/use_enable_enable dbus python-dbus)
 $(multilib_native_use_with/use_enable_enable introspection pygobject)
 )
 fi

 if use_with/use_enable mono; then
 myconf+=( $(multilib_native_use_with/use_enable_enable doc monodoc) )
 fi

 if ! multilib_is_native_abi; then
 myconf+=(
 # use_with/use_enabled by daemons only
 --disable-libdaemon
 --with-xml=none
 )
 fi

 econf --disable-dependency-tracking "${myconf[@]}"
}

multilib_src_compile() {
 emake

 multilib_is_native_abi && use_with/use_enable doc && emake avahi.devhelp
}

multilib_src_install() {
 emake install DESTDIR="${D}"
 use_with/use_enable bookmarks && use_with/use_enable python && use_with/use_enable dbus && use_with/use_enable gtk2 || \
 rm -f "${ED}"/usr/bin/avahi-bookmarks

 # https://github.com/lathiat/avahi/issues/28
 use_with/use_enable howl-compat && dosym avahi-compat-howl.pc /usr/$(get_libdir)/pkgconfig/howl.pc
 use_with/use_enable mdnsresponder-compat && dosym avahi-compat-libdns_sd/dns_sd.h /usr/include/dns_sd.h

 if multilib_is_native_abi && use_with/use_enable doc; then
 docinto html
 dodoc -r doxygen/html/.
 insinto /usr/share/devhelp/books/avahi
 doins avahi.devhelp
 fi

 # The build system creates an empty "/run" directory, so we clean it up here
 rmdir "${ED}"/run || eerror
}

multilib_src_install_all() {
 if use_with/use_enable autoipd; then
 insinto /lib/rcscripts/net
 doins "${FILESDIR}"/autoipd.sh

 insinto /lib/netifrc/net
 newins "${FILESDIR}"/autoipd-openrc.sh autoipd.sh
 fi

 dodoc docs/{AUTHORS,NEWS,README,TODO}

 find "${ED}" -name '*.la' -type f -delete || eerror
}

pkg_postinst() {
 if use_with/use_enable autoipd; then
 elog
 elog "To use_with/use_enable avahi-autoipd to configure your interfaces with IPv4LL (RFC3927)"
 elog "addresses, just set config_<interface>=( autoipd ) in /etc/conf.d/net!"
 elog
 fi

 systemd_reenable avahi-daemon.service
}
