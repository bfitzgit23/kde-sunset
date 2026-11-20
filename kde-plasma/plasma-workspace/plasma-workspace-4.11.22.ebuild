# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DECLARATIVE_REQUIRED="always"
KMNAME="kde-workspace"
KMMODULE="plasma"
OPENGL_REQUIRED="always"
WEBKIT_REQUIRED="always"
inherit kde4-meta

DESCRIPTION="Plasma: KDE desktop framework"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug gps json +pim qalculate"

# Compiler fixes that 4.11.22 needs on a modern toolchain.  This revision is the
# only one with stable keywords, so it is what portage builds by default and it
# has to carry them; the -r1/-r2/-r3 revisions are ~amd64.
PATCHES=(
	"${FILESDIR}/${P}-bbcukmet-contains.patch"
	"${FILESDIR}/${P}-plasma-akonadi-cxx11.patch"
	"${FILESDIR}/${P}-rss-cxx11.patch"
)

COMMONDEPEND="
	dev-libs/libdbusmenu-qt[qt4(-)]
	>=dev-qt/qtcore-4.8.4-r3:4
	kde-frameworks/kactivities:4
	kde-plasma/kephal:4
	kde-plasma/ksysguard:4
	kde-plasma/libkworkspace:4
	kde-plasma/libplasmaclock:4[pim?]
	kde-plasma/libplasmagenericshell:4
	kde-plasma/libtaskmanager:4
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	gps? ( >=sci-geosciences/gpsd-2.37 )
	json? ( dev-libs/qjson )
	pim? ( $(add_kdeapps_dep kdepimlibs) )
	qalculate? ( sci-libs/libqalculate )
"
DEPEND="${COMMONDEPEND}
	dev-libs/boost
	x11-base/xorg-proto
"
RDEPEND="${COMMONDEPEND}
	$(add_kdeapps_dep plasma-runtime)
"

KMEXTRA="
	appmenu/
	ktouchpadenabler/
	statusnotifierwatcher/
"
KMEXTRACTONLY="
	kcheckpass/
	krunner/dbus/org.freedesktop.ScreenSaver.xml
	krunner/dbus/org.kde.krunner.App.xml
	ksmserver/org.kde.KSMServerInterface.xml
	ksmserver/screenlocker/
	libs/kephal/
	libs/kworkspace/
	libs/taskmanager/
	libs/plasmagenericshell/
	libs/ksysguard/
	libs/kdm/kgreeterplugin.h
	ksysguard/
"

src_unpack() {
	if kde4_use_handbook ; then
		KMEXTRA+=" doc/plasma-desktop"
	fi

	kde4-meta_src_unpack
}

src_prepare() {
	kde4-meta_src_prepare

	# FindQalculate.cmake asks pkg-config for "cln --libs" with exec_program(),
	# which captures stderr as well: when cln.pc is missing, the error text lands
	# in CLN_LIBRARIES and the newline it carries corrupts build.ninja
	# ("build.ninja: expected '=', got identifier").  qalculate_engine.cpp only
	# uses the libqalculate API and libqalculate links libcln itself, so the
	# runner does not need that flag.
	local calculator="${S}/plasma/generic/runners/calculator/CMakeLists.txt"
	if grep -q '${CLN_LIBRARIES}' "${calculator}" ; then
		sed -i 's/ ${CLN_LIBRARIES}//' "${calculator}" ||
			die "failed to drop CLN_LIBRARIES from ${calculator}"
	fi
	if grep -q '${CLN_LIBRARIES}' "${calculator}" ; then
		die "CLN_LIBRARIES is still referenced in ${calculator}"
	fi
	# KDE4's kmenuedit and systemsettings are installed as kmenuedit4 and
	# systemsettings4 so they stop colliding with Plasma 6, so the launchers here
	# have to ask for the suffixed names: kickoff's "Edit Applications" action and
	# the favourites/models entries that reference the settings service.
	local ref
	for ref in plasma/desktop/applets/kickoff/applet/applet.cpp plasma/desktop/applets/kickoff/simpleapplet/simpleapplet.cpp; do
		[[ -f ${S}/${ref} ]] || continue
		sed -i -e 's/KProcess::execute("kmenuedit")/KProcess::execute("kmenuedit4")/' "${S}/${ref}" || die "failed to redirect kmenuedit launch in ${ref}"
	done
	for ref in plasma/desktop/applets/kickoff/core/favoritesmodel.cpp plasma/desktop/applets/kickoff/core/models.cpp plasma/netbook/containments/sal/models/favouritesmodel.cpp; do
		[[ -f ${S}/${ref} ]] || continue
		sed -i -e 's/"systemsettings"/"systemsettings4"/' "${S}/${ref}" || die "failed to redirect the systemsettings service in ${ref}"
	done
}


src_configure() {
	local mycmakeargs=(
		-DWITH_NepomukCore=OFF
		-DWITH_PythonLibrary=OFF
		-DWITH_Soprano=OFF
		-DWITH_Xmms=OFF
		-DWITH_libgps="$(usex gps)"
		-DWITH_QJSON="$(usex json)"
		-DWITH_Akonadi="$(usex pim)"
		-DWITH_KdepimLibs="$(usex pim)"
		-DWITH_qalculate="$(usex qalculate)"
	)

	kde4-meta_src_configure
}
