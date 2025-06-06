# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="kde-workspace"
KMMODULE="libs/kworkspace"
kde4-meta

DESCRIPTION="A library for Plasma desktop applications"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

KMEXTRACTONLY="
 ksmserver/org.kde.KSMServerInterface.xml
 kwin/org.kde.KWin.xml
"

KMSAVELIBS="true"

DEPEND="
 x11-libs/libICE
 x11-libs/libSM
 x11-libs/libXau
"
RDEPEND="${DEPEND}"

src_prepare() {
 sed -i -e 's/install( FILES kdisplaymanager.h/install( FILES kdisplaymanager.h screenpreviewwidget.h/' \
 libs/kworkspace/CMakeLists.txt || die "failed to provide screenpreviewwidget.h"

 kde4-meta_src_prepare
}
