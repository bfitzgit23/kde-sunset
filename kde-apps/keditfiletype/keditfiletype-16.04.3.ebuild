# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="KDE mime/file type assocciation editor"
KEYWORDS="amd64 x86"
IUSE="debug"

# test fails, last checked for 4.2.89
RESTRICT=test

src_install() {
	kde4-meta_src_install

	# kde-plasma/keditfiletype (Plasma 5/6) already owns /usr/bin/keditfiletype.
	# Merging over it would put the KDE4 editor behind Plasma's own package, which
	# reinstates its binary on the next upgrade, so install this one under a
	# suffix.  Nothing in the KDE4 package calls the path back: the KCModule
	# service entry (filetypes.desktop) runs "kcmshell4 filetypes" instead.
	local bin="${ED}/usr/bin/keditfiletype"
	[[ -e ${bin} ]] || die "expected keditfiletype binary at ${bin}"
	mv "${bin}" "${bin}4" || die
}
