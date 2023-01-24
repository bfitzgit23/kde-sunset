# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_SCM="git"
if [[ ${PV} != 9999* ]]; then
	KDE_HANDBOOK="optional"
	KDE_DOC_DIRS="doc"

	SRC_URI="http://deb.debian.org/debian/pool/main/k/${PN}/${P}.orig.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}"/"${MY_P}"

	KEYWORDS="~amd64 ~x86"
else
	LIBKT_VERSION_MIN="${PV}"
	LIBKT_VERSION_MAX="99999999"
fi

inherit kde4-base kde4-functions-extra

DESCRIPTION="Powerful BitTorrent client by KDE"
HOMEPAGE="http://ktorrent.pwsp.net/"

LICENSE="GPL-2"
SLOT="4"
IUSE="+bwscheduler debug +downloadorder +infowidget +ipfilter +logviewer
+magnetgenerator +mediaplayer plasma rss +scanfolder +search +shutdown +stats
+upnp webinterface +zeroconf"

COMMONDEPEND="
	>=net-libs/libktorrent-1.3.1:4
	infowidget? ( dev-libs/geoip )
	mediaplayer? ( >=media-libs/taglib-1.5 )
	plasma? ( $(add_kdeplasma_dep libtaskmanager) )
	rss? ( $(add_kdeapps_dep kdepimlibs) )
	search? (
		$(add_kdeframeworks_dep kdelibs webkit 4.14.22)
		dev-qt/qtwebkit:4
	)
	shutdown? ( $(add_kdeplasma_dep libkworkspace) )
"
DEPEND="${COMMONDEPEND}
	dev-libs/boost
	sys-devel/gettext
"
RDEPEND="${COMMONDEPEND}
	ipfilter? (
		app-arch/bzip2
		app-arch/unzip
		$(add_kdeapps_dep kdebase-kioslaves)
	)
"

PATCHES=(
	"${FILESDIR}/${P}-ipfilter.patch"
	"${FILESDIR}/${P}-underlinking.patch"
)

src_prepare() {
	if ! use plasma; then
		sed -i \
			-e "s:add_subdirectory(plasma):#nada:g" \
			CMakeLists.txt || die "Failed to make plasmoid optional"
	fi

	kde4-base_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_BWSCHEDULER_PLUGIN="$(usex bwscheduler)"
		-DENABLE_DOWNLOADORDER_PLUGIN="$(usex downloadorder)"
		-DENABLE_INFOWIDGET_PLUGIN="$(usex infowidget)"
		-DWITH_SYSTEM_GEOIP="$(usex infowidget)"
		-DENABLE_IPFILTER_PLUGIN="$(usex ipfilter)"
		-DENABLE_SCRIPTING_PLUGIN=OFF
		-DENABLE_LOGVIEWER_PLUGIN="$(usex logviewer)"
		-DENABLE_MAGNETGENERATOR_PLUGIN="$(usex magnetgenerator)"
		-DENABLE_MEDIAPLAYER_PLUGIN="$(usex mediaplayer)"
		-DENABLE_SYNDICATION_PLUGIN="$(usex rss)"
		-DENABLE_SCANFOLDER_PLUGIN="$(usex scanfolder)"
		-DENABLE_SEARCH_PLUGIN="$(usex search)"
		-DENABLE_SHUTDOWN_PLUGIN="$(usex shutdown)"
		-DENABLE_STATS_PLUGIN="$(usex stats)"
		-DENABLE_UPNP_PLUGIN="$(usex upnp)"
		-DENABLE_WEBINTERFACE_PLUGIN="$(usex webinterface)"
		-DENABLE_ZEROCONF_PLUGIN="$(usex zeroconf)"
	)
	kde4-base_src_configure
}
