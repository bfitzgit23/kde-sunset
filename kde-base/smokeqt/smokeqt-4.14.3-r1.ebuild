# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DECLARATIVE_REQUIRED="optional"
MULTIMEDIA_REQUIRED="optional"
QTHELP_REQUIRED="optional"
OPENGL_REQUIRED="optional"
KDE_REQUIRED="never"
kde4-base

DESCRIPTION="Scripting Meta Object Kompiler Engine - Qt bindings"
HOMEPAGE="https://techbase.kde.org/Development/Languages/Smoke"

KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +phonon qimageblitz qscintilla qwt webkit xmlpatterns"

# Maybe make more of Qt optional?
DEPEND="
 $(add_kdebase_dep smokegen)
 dev-qt/designer:4
 dev-qt/qtcore:4
 dev-qt/qtdbus:4
 dev-qt/qtgui:4
 dev-qt/qtscript:4
 dev-qt/qtsql:4
 dev-qt/qtsvg:4
 dev-qt/qttest:4
 phonon? ( media-libs/phonon:0-qt4 )
 qimageblitz? ( media-libs/qimageblitz )
 qscintilla? ( x11-libs/qscintilla:0-qt4= )
 qwt? ( x11-libs/qwt:5[svg] )
 webkit? ( dev-qt/qtwebkit:4 )
 xmlpatterns? ( dev-qt/qtxmlpatterns:4 )
"
RDEPEND="${DEPEND}"

src_configure() {
 local mycmakeargs=(
 -DDISABLE_Qt3Support=ON
 -DWITH_QT3_SUPPORT=OFF
 $(cmake-utils_use_disable declarative QtDeclarative)
 $(cmake-utils_use_disable multimedia QtMultimedia)
 $(cmake-utils_use_disable opengl QtOpenGL)
 $(cmake-utils_use_with phonon)
 $(cmake-utils_use_with qimageblitz QImageBlitz)
 $(cmake-utils_use_with qscintilla QScintilla)
 $(cmake-utils_use_disable qthelp QtHelp)
 $(cmake-utils_use_with qwt Qwt5)
 $(cmake-utils_use_disable webkit QtWebKit)
 $(cmake-utils_use_disable xmlpatterns QtXmlPatterns)
 )
 kde4-base_src_configure
}
