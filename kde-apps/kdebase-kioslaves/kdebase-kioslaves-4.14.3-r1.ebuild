# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_HANDBOOK="optional"
KMNAME="kde-runtime"
KMMODULE="kioslave"
inherit kde4-meta kde4-functions-extra

KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
DESCRIPTION="kioslave: the kde VFS framework - kioslave plugins present a filesystem-like view of arbitrary data"
IUSE="+bzip2 exif debug lzma minimal openexr samba +sftp"

# tests hang, last checked for 4.2.96
RESTRICT="test"

DEPEND="
	virtual/jpeg:0
	x11-libs/libXcursor
	bzip2? ( app-arch/bzip2 )
	exif? ( media-gfx/exiv2:= )
	openexr? ( media-libs/openexr:= )
	samba? ( || ( <net-fs/samba-4.0.0_alpha1[smbclient] >=net-fs/samba-4.0.0_alpha1[client] ) )
	sftp? ( >=net-libs/libssh-0.4.0:=[sftp] )
"
RDEPEND="${DEPEND}
	$(add_kdeframeworks_dep kdelibs 'bzip2?,lzma?')
	$(add_kdeapps_dep kdialog)
	virtual/ssh
	virtual/eject
"

KMEXTRA="
	kioexec
	kdeeject
"

PATCHES=(
	"${FILESDIR}/${PN}-CVE-2014-8600.patch"
	"${FILESDIR}/${P}-webkit.patch"
	"${FILESDIR}/${P}-samba-4.10.patch"
)

src_configure() {
	local mycmakeargs=(
		-DWITH_SLP=OFF
		-DWITH_KDEWEBKIT=FALSE
		-DWITH_BZip2="$(usex bzip2)"
		-DWITH_Exiv2="$(usex exif)"
		-DWITH_LibLZMA="$(usex lzma)"
		-DWITH_OpenEXR="$(usex openexr)"
		-DWITH_samba="$(usex samba)"
		-DWITH_LibSSH="$(usex sftp)"
	)
	kde4-meta_src_configure
}

src_install() {
	kde4-meta_src_install

	if use minimal; then
		rm "${D}"/usr/lib64/libmolletnetwork.so "${D}"/usr/share/config.kcfg/jpegcreatorsettings.kcfg
		rmdir "${D}"/usr/share/config.kcfg/
	fi
}
