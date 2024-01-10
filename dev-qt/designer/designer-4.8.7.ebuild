# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils qt4-build-multilib

DESCRIPTION="WYSIWYG tool for designing and building Qt-based GUIs"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~mips ~ppc ~ppc64 ~sparc x86"
fi

DESIGNER_PLUGINS="declarative phonon qt3support webkit"
IUSE="${DESIGNER_PLUGINS}"

DEPEND="
	~dev-qt/qtcore-${PV}[debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtscript-${PV}[debug=,${MULTILIB_USEDEP}]
	declarative? ( ~dev-qt/qtdeclarative-${PV}[debug=,${MULTILIB_USEDEP}] )
	qt3support? ( ~dev-qt/qt3support-${PV}[debug=,${MULTILIB_USEDEP}] )
	webkit? ( >=dev-qt/qtwebkit-${PV}:4[debug=,${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"
PDEPEND="phonon? ( media-libs/phonon:0-qt4[designer] )"
PATCHES=( "${FILESDIR}/${PN}-4.8.7-gcc9.patch" )

QT4_TARGET_DIRECTORIES="tools/designer"

src_prepare() {
	qt4-build-multilib_src_prepare

	local plugin
	for plugin in ${DESIGNER_PLUGINS}; do
		if ! use ${plugin} || [[ ${plugin} == phonon ]]; then
			sed -i -e "/\<${plugin}\>/d" \
				tools/designer/src/plugins/plugins.pro || die
		fi
	done
}

multilib_src_configure() {
	local myconf=(
		-system-libpng -system-libjpeg -system-zlib
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2 -no-sql-odbc
		-sm -xshape -xsync -xcursor -xfixes -xrandr -xrender -mitshm -xinput -xkb
		-fontconfig -no-svg -no-webkit -no-phonon -no-opengl
	)
	qt4_multilib_src_configure
}

multilib_src_install_all() {
	qt4_multilib_src_install_all

	doicon tools/designer/src/designer/images/designer.png
	make_desktop_entry designer Designer designer 'Qt;Development;GUIDesigner'
}
