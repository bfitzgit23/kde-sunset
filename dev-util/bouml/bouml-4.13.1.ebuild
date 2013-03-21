# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bouml/Attic/bouml-4.13.1.ebuild,v 1.1 2009/09/12 01:34:29 patrick Exp $

EAPI=1

inherit multilib qt3

MY_P="${PN}_${PV}"

DESCRIPTION="Free UML 2 tool with code generation"
HOMEPAGE="http://bouml.free.fr/"
SRC_URI="mirror://kde-sunset/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-qt/qt-meta:3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	find src/ genplugouts/ -type f -name "*.pro" | while read file; do
		local subdir="${file%/*}"
		eqmake3 "${file}" -o "${subdir}"/Makefile
		emake -C "${subdir}" || die "emake failed in ${subdir}"
	done
}

src_install() {
	emake BOUML_LIB="/usr/$(get_libdir)/bouml" DESTDIR="${D}" install \
		|| die "emake install failed"
}
