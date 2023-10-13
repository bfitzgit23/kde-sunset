# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib qt4-build-multilib

DESCRIPTION="The SQL module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc x86"
fi

IUSE="freetds mysql odbc postgres qt3support +sqlite"

REQUIRED_USE="|| ( freetds mysql odbc postgres sqlite )"

DEPEND="
	~dev-qt/qtcore-${PV}[debug=,qt3support=,${MULTILIB_USEDEP}]
	freetds? ( dev-db/freetds )
	mysql? ( dev-db/mysql-connector-c:=[${MULTILIB_USEDEP}] )
	odbc? ( || (
		>=dev-db/unixODBC-2.3.2-r2[${MULTILIB_USEDEP}]
		>=dev-db/libiodbc-3.52.8-r2[${MULTILIB_USEDEP}]
	) )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( >=dev-db/sqlite-3.8.3:3[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/sql
	src/plugins/sqldrivers"

PATCHES=( "${FILESDIR}/${P}-mysql-8.patch"
          "${FILESDIR}/${PN}-4.8.7-gcc9.patch" )

multilib_src_configure() {
	local myconf=(
		$(qt_native_use freetds  sql-tds    plugin)
		$(qt_use        mysql    sql-mysql  plugin) $(use mysql && echo -mysql_config "${EPREFIX}/usr/bin/${CHOST}-mysql_config")
		$(qt_use        odbc     sql-odbc   plugin) $(use odbc && echo "-I${EPREFIX}/usr/include/iodbc")
		$(qt_native_use postgres sql-psql   plugin) $(use postgres && multilib_is_native_abi && echo "-I${EPREFIX}/usr/include/postgresql/pgsql")
		$(qt_use        sqlite   sql-sqlite plugin) $(use sqlite && echo -system-sqlite)
		-no-sql-db2
		-no-sql-ibase
		-no-sql-oci
		-no-sql-sqlite2
		-no-sql-symsql
		$(qt_use qt3support)
		-no-accessibility -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon
		-no-phonon-backend -no-svg -no-webkit -no-script -no-scripttools -no-declarative
		-system-zlib -no-gif -no-libtiff -no-libpng -no-libmng -no-libjpeg -no-openssl
		-no-cups -no-dbus -no-gtkstyle -no-nas-sound -no-nis -no-opengl
		-no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes
		-no-xrandr -no-xrender -no-mitshm -no-fontconfig -no-freetype -no-xinput -no-xkb
		-no-glib
	)
	qt4_multilib_src_configure
}
