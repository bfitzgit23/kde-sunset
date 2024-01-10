# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde4-base

DESCRIPTION="Simple kdelibs4-based live data viewer for collectd"
HOMEPAGE="https://www.forwiss.uni-passau.de/~berberic/Linux/kcollectd.html"
SRC_URI="https://www.forwiss.uni-passau.de/~berberic/Linux/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	dev-libs/boost:=
	net-analyzer/rrdtool"
RDEPEND="${DEPEND}
	|| (
		app-metrics/collectd[collectd_plugins_rrdtool]
		app-metrics/collectd[collectd_plugins_rrdcached]
	)"

PATCHES=(
	"${FILESDIR}/${P}-boost.patch"
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-desktop.patch"
	"${FILESDIR}/${P}-gcc6.patch"
)
