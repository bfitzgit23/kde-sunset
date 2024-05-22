# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

if [[ "${PV}" != "9999" ]]; then
	SRC_URI="http://www.vandenoever.info/software/strigi/${P}.tar.bz2"
	KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
else
	EGIT_REPO_URI=( "git://anongit.kde.org/strigi" )
	GIT_ECLASS="git-r3"
	KEYWORDS=""
fi

inherit cmake ${GIT_ECLASS}

DESCRIPTION="Fast crawling desktop search engine with Qt4 GUI"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/strigi/strigi"

LICENSE="GPL-2"
SLOT="0"
IUSE="clucene +dbus debug exif fam ffmpeg +inotify libav log +qt4 test"

RDEPEND="
	app-arch/bzip2
	dev-libs/libxml2:2
	sys-libs/zlib
	virtual/libiconv
	clucene? ( >=dev-cpp/clucene-0.9.21[-debug] )
	dbus? (
		sys-apps/dbus
		qt4? ( dev-qt/qtdbus:4 )
	)
	exif? ( media-gfx/exiv2:= )
	fam? ( virtual/fam )
	ffmpeg? (
		libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
	log? ( >=dev-libs/log4cxx-0.10.0 )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
"
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )
"

PATCHES=(
	"${FILESDIR}/${P}-libav10.patch"
	"${FILESDIR}/${P}-ffmpeg29.patch"
	"${FILESDIR}/${P}-gcc-4.8.patch"
)

if [[ ${PV} == 9999 ]] ; then
	src_unpack() {
		git config --global url."git://anongit.kde.org/".insteadOf "kde:" || die
		git-r3_src_unpack
		pushd "${S}" > /dev/null || die
		git submodule foreach git checkout master || die
		popd > /dev/null || die
	}
fi

src_configure() {
	# Enabled: POLLING (only reliable way to check for files changed.)
	# Disabled: xine - recommended upstream to keep it this way
	local mycmakeargs=(
		-DENABLE_POLLING=ON
		-DFORCE_DEPS=ON
		-DENABLE_REGENERATEXSD=OFF
		-DENABLE_XINE=OFF
		-WITH_clucene=$(usex clucene CLUCENE)
		-WITH_clucene=$(usex clucene CLUCENE_NG)
		-WITH_dbus=$(usex dbus)
		-WITH_exif=$(usex exif EXIV2)
		-WITH_fam=$(usex fam)
		-WITH_ffmpeg=$(usex ffmpeg)
		-WITH_inotify=$(usex inotify)
		-WITH_log=$(usex log LOG4CXX)
		-WITH_qt4=$(usex qt4)
		-WITH_test=$(usex test CPPUNIT)
	)

	if use qt4; then
		mycmakeargs+=( -DENABLE_DBUS=ON )
	fi

	cmake_src_configure
}

pkg_postinst() {
	if ! use clucene ; then
		elog "Because you didn't enable the clucene backend, strigi may not be functional."
		elog "If you intend to use standalone strigi indexer (not needed for KDE),"
		elog "be sure to reinstall app-misc/strigi with the clucene USE flag enabled."
	fi
}
