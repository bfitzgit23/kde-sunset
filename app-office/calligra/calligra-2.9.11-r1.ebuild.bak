# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# note: files that need to be checked for dependencies etc:
# CMakeLists.txt, kexi/CMakeLists.txt kexi/migration/CMakeLists.txt
# krita/CMakeLists.txt

EAPI=7

CHECKREQS_DISK_BUILD="4G"
KDE_HANDBOOK="optional"
KDE_LINGUAS_LIVE_OVERRIDE="true"
OPENGL_REQUIRED="optional"
WEBKIT_REQUIRED="optional"
check-reqs kde4-base

DESCRIPTION="KDE Office Suite"
HOMEPAGE="https://calligra.org/"
SRC_URI="mirror://kde/stable/${P}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="color-management +crypt +eigen +exif fftw +fontconfig freetds +glew +glib
+gsf gsl import-filter +jpeg +lcms mysql openexr +pdf +pim
postgres spacenav sybase test tiff +threads +truetype +xml"

# Don't use_with/use_enable Active, it's broken on desktops.
CAL_FTS="author braindump flow gemini karbon kexi krita plan sheets stage words"
for cal_ft in ${CAL_FTS}; do
 IUSE+=" calligra_features_${cal_ft}"
done
unset cal_ft

REQUIRED_USE="
 || ( $(printf 'calligra_features_%s ' ${CAL_FTS[@]}) )
 calligra_features_author? ( calligra_features_words )
 calligra_features_gemini? ( opengl )
 calligra_features_krita? ( eigen exif lcms opengl )
 calligra_features_plan? ( pim )
 calligra_features_sheets? ( eigen )
 calligra_features_stage? ( webkit )
 test? ( calligra_features_karbon )
"

RDEPEND="
 dev-lang/perl
 dev-libs/boost:=
 dev-qt/qtcore:4[exceptions]
 media-libs/libpng:0=
 sys-libs/zlib
 virtual/libiconv
 color-management? ( media-libs/opencolorio )
 crypt? ( app-crypt/qca:2-qt4 )
 eigen? ( dev-cpp/eigen:3 )
 exif? ( media-gfx/exiv2:= )
 fftw? ( sci-libs/fftw:3.0 )
 fontconfig? ( media-libs/fontconfig )
 freetds? ( dev-db/freetds )
 glib? ( dev-libs/glib:2 )
 gsf? ( gnome-extra/libgsf )
 gsl? ( sci-libs/gsl:= )
 import-filter? (
 app-text/libetonyek
 app-text/libodfgen
 app-text/libwpd:*
 app-text/libwpg:*
 app-text/libwps
 dev-libs/librevenge
 media-libs/libvisio
 )
 jpeg? ( virtual/jpeg:0 )
 lcms? (
 media-libs/lcms:2
 x11-libs/libX11
 )
 mysql? ( virtual/mysql )
 openexr? ( media-libs/openexr:= )
 opengl? (
 media-libs/glew:0
 virtual/glu
 )
 pdf? (
 app-text/poppler:0-qt4=
 media-gfx/pstoedit
 )
 pim? ( $(add_kdeapps_dep kdepimlibs) )
 postgres? (
 dev-db/postgresql:*
 dev-libs/libpqxx
 )
 spacenav? ( dev-libs/libspnav )
 sybase? ( dev-db/freetds )
 tiff? ( media-libs/tiff:0 )
 truetype? ( media-libs/freetype:2 )
 calligra_features_kexi? (
 dev-db/sqlite:3[extensions(+)]
 dev-libs/icu:=
 )
 calligra_features_krita? (
 dev-qt/qtdeclarative:4
 net-misc/curl
 x11-libs/libX11
 x11-libs/libXi
 )
 calligra_features_words? ( dev-libs/libxslt )
"
DEPEND="${RDEPEND}
 x11-misc/shared-mime-info
"
PDEPEND=">=app-office/calligra-l10n-2.9:4"

# bug 394273
RESTRICT=test

PATCHES=(
 "${FILESDIR}"/${PN}-2.9.1-no-arch-detection.patch
 "${FILESDIR}"/${P}-postgresql-9.6.patch
 "${FILESDIR}"/${P}-libwps-0.4.patch
 "${FILESDIR}"/${P}-slotted-popplerqt4.patch
)

pkg_pretend() {
 check-reqs_pkg_pretend
}

pkg_setup() {
 kde4-base_pkg_setup
 check-reqs_pkg_setup
}

src_prepare() {
 kde4-base_src_prepare
 if ! use_with/use_enable webkit; then
 sed -i CMakeLists.txt -e "/^find_package/ s/QtWebKit //" || die
 fi
}

src_configure() {
 local cal_ft myproducts

 # applications
 for cal_ft in ${CAL_FTS}; do
 use_with/use_enable calligra_features_${cal_ft} && myproducts+=( "${cal_ft^^}" )
 done

 local mycmakeargs=( -DPRODUCTSET="${myproducts[*]}" )

 # regular options
 mycmakeargs+=(
 -DCREATIVEONLY=OFF
 -DPACKAGERS_BUILD=OFF
 -DWITH_Soprano=OFF
 -DWITH_KActivities=OFF
 -DWITH_CalligraMarble=OFF
 -DWITH_Iconv=ON
 -DWITH_Vc=OFF
 -DWITH_XBase=OFF
 -DWITH_OCIO=$(use_with/use_enablex color-management)
 -DWITH_QCA2=$(use_with/use_enablex crypt)
 -DWITH_Eigen3=$(use_with/use_enablex eigen)
 -DWITH_Exiv2=$(use_with/use_enablex exif)
 -DWITH_FFTW3=$(use_with/use_enablex fftw)
 -DWITH_Fontconfig=$(use_with/use_enablex fontconfig)
 -DWITH_FreeTDS=$(use_with/use_enablex freetds)
 -DWITH_GLIB2=$(use_with/use_enablex glib)
 -DWITH_GSL=$(use_with/use_enablex gsl)
 -DWITH_LibEtonyek=$(use_with/use_enablex import-filter)
 -DWITH_LibOdfGen=$(use_with/use_enablex import-filter)
 -DWITH_LibRevenge=$(use_with/use_enablex import-filter)
 -DWITH_LibVisio=$(use_with/use_enablex import-filter)
 -DWITH_LibWpd=$(use_with/use_enablex import-filter)
 -DWITH_LibWpg=$(use_with/use_enablex import-filter)
 -DWITH_LibWps=$(use_with/use_enablex import-filter)
 -DWITH_JPEG=$(use_with/use_enablex jpeg)
 -DWITH_OpenJPEG=OFF
 -DWITH_Kdcraw=OFF
 -DWITH_LCMS2=$(use_with/use_enablex lcms)
 -DWITH_MySQL=$(use_with/use_enablex mysql)
 -DWITH_Okular=OFF
 -DWITH_OpenEXR=$(use_with/use_enablex openexr)
 -DUSEOPENGL=$(use_with/use_enablex opengl)
 -DWITH_Poppler=$(use_with/use_enablex pdf)
 -DWITH_Pstoedit=$(use_with/use_enablex pdf)
 -DWITH_KdepimLibs=$(use_with/use_enablex pim)
 -DWITH_CalligraPostgreSQL=$(use_with/use_enablex postgres)
 -DWITH_Spnav=$(use_with/use_enablex spacenav)
 -DWITH_FreeTDS=$(use_with/use_enablex sybase)
 -DWITH_Threads=$(use_with/use_enablex threads)
 -DWITH_TIFF=$(use_with/use_enablex tiff)
 -DWITH_Freetype=$(use_with/use_enablex truetype)
 )

 use_with/use_enable test && mycmakeargs+=( -DENABLE_CSTESTER_TESTING=$(use_with/use_enablex test) )

 kde4-base_src_configure
}

src_install() {
 kde4-base_src_install

 # bug 613414
 QA_DT_NEEDED="usr/lib64/libkoversion.so.14.0.0"
}
