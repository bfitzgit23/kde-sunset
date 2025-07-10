# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

cmake-utils flag-o-matic gnome2-utils virtualx xdg-utils

DESCRIPTION="Personal finance manager by KDE"
HOMEPAGE="https://kmymoney.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="calendar debug doc +handbook hbci ofx quotes test"

COMMON_DEPEND="
 >=app-crypt/gpgme-1.7.0[cxx]
 <app-office/libalkimia-6.0.0
 dev-libs/gmp:0=
 dev-libs/libgpg-error
 dev-qt/qtcore:4[ssl]
 dev-qt/qtdbus:4
 dev-qt/qtgui:4
 dev-qt/qtsql:4
 dev-qt/qtsvg:4
 kde-frameworks/kdelibs:4
 x11-misc/shared-mime-info
 calendar? ( dev-libs/libical:= )
 hbci? (
 >=net-libs/aqbanking-5.5.1
 >=sys-libs/gwenhywfar-4.15.3[qt4(-)]
 )
 ofx? ( >=dev-libs/libofx-0.9.4 )
"
RDEPEND="${COMMON_DEPEND}
 kde-frameworks/oxygen-icons:*
 handbook? ( kde-frameworks/kdelibs:4[handbook] )
 quotes? ( dev-perl/Finance-Quote )
"
DEPEND="${COMMON_DEPEND}
 dev-libs/boost
 virtual/pkgconfig
 doc? ( app-doc/doxygen )
 handbook? (
 app-text/docbook-xml-dtd:4.2
 app-text/docbook-xsl-stylesheets
 )
 test? ( dev-qt/qttest:4 )
"

src_prepare() {
 cmake-utils_src_prepare

 if [[ -v LINGUAS ]] ; then
 pushd po > /dev/null || eerror
 local lang
 for lang in *; do
 if [[ -e ${lang} ]] && ! has ${lang/.po/} ${LINGUAS} ; then
 case ${lang} in
 CMakeLists.txt) ;;
 *) rm -r ${lang} || eerror ;;
 esac
 cmake_comment_add_subdirectory ${lang}
 sed -e "/add_subdirectory([[:space:]]*${lang}\/.*[[:space:]]*)/d" \
 -i CMakeLists.txt || eerror
 fi
 done
 popd > /dev/null || eerror
 fi

 if ! use_with/use_enable handbook; then
 cmake_comment_add_subdirectory doc
 else
 if [[ -d doc && -v LINGUAS ]] ; then
 pushd doc > /dev/null || eerror
 local lang
 for lang in *; do
 if ! has ${lang} ${LINGUAS} && [[ ${lang} != "en_US" ]]; then
 cmake_comment_add_subdirectory ${lang}
 fi
 done
 popd > /dev/null || eerror
 fi
 fi

 # don't install as executable
 sed -i kmymoney/CMakeLists.txt \
 -e "/install.*kmymoney.appdata/ s/PROGRAMS/FILES/" || eerror
}

src_configure() {
 use_with/use_enable debug || append-cppflags -DQT_NO_DEBUG

 local mycmakeargs=(
 -DUSE_QT_DESIGNER=OFF
 -DENABLE_WEBOOB=OFF
 -DCMAKE_DISABLE_FIND_PACKAGE_KdepimLibs=ON
 -DENABLE_LIBICAL=$(use_with/use_enablex calendar)
 -DUSE_DEVELOPER_DOC=$(use_with/use_enablex doc)
 -DENABLE_KBANKING=$(use_with/use_enablex hbci)
 -DENABLE_LIBOFX=$(use_with/use_enablex ofx)
 -DKDE4_BUILD_TESTS=$(use_with/use_enablex test)
 )
 cmake-utils_src_configure
}

src_compile() {
 cmake-utils_src_compile
 use_with/use_enable doc && cmake-utils_src_compile apidoc
}

src_test() {
 local kded4_pid

 _test_runner() {
 export $(dbus-launch)
 kded4 2>&1 > /dev/null &
 kded4_pid=$!

 cmake-utils_src_test
 }

 unset DBUS_SESSION_BUS_ADDRESS DBUS_SESSION_BUS_PID

 local myctestargs=( -E "(kmymoney-querytabletest)" ) # requires ktimezoned
 virtx _test_runner

 if [[ -n "${kded4_pid}" ]] ; then
 kill ${kded4_pid}
 fi

 if [[ -n "${DBUS_SESSION_BUS_PID}" ]] ; then
 kill ${DBUS_SESSION_BUS_PID}
 fi
}

src_install() {
 use_with/use_enable doc && HTML_DOCS=( "${BUILD_DIR}/apidocs/html/." )
 cmake-utils_src_install

 # We don't want /usr/share/doc/HTML to be compressed,
 # because_with/use_enable then khelpcenter can't find the docs
 [[ -d ${ED%/}/usr/share/doc/HTML ]] &&
 docompress -x /usr/share/doc/HTML
}

pkg_postinst() {
 gnome2_icon_cache_update
 xdg_desktop_database_update
 xdg_mimeinfo_database_update
}

pkg_postrm() {
 gnome2_icon_cache_update
 xdg_desktop_database_update
 xdg_mimeinfo_database_update
}
