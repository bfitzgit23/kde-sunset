# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DECLARATIVE_REQUIRED="optional"
KMNAME="kde-workspace"
KMMODULE="libs/plasmagenericshell"
inherit kde4-meta

DESCRIPTION="Libraries for the KDE Plasma shell"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +declarative"

DEPEND="
	kde-plasma/kephal:4
	kde-plasma/libkworkspace:4
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

KMSAVELIBS="true"

KMEXTRACTONLY="
	libs/kephal/kephal/
	plasma/desktop/shell/data/
"

src_prepare() {
	kde4-meta_src_prepare

	# KDeclarative is a soft dependency of the shell: downgrade it and define
	# HAVE_QTDECLARATIVE.  kde4_make_qml_optional anchors the edits on the lines
	# themselves, because the block it touches sits at a different offset in
	# different 4.11.22 source snapshots and a patch hunk gets rejected there.
	local widgetexplorer="${S}/libs/plasmagenericshell/widgetsexplorer/widgetexplorer.cpp"

	kde4_make_qml_optional

	# Guard the QML-only parts of the widget explorer with that definition.
	sed -i \
		-e '/^#include <QDeclarativeContext>$/i #ifdef HAVE_QTDECLARATIVE' \
		-e '/^#include <QDeclarativeComponent>$/a #endif' \
		-e '/^#include <Plasma\/DeclarativeWidget>$/i #ifdef HAVE_QTDECLARATIVE' \
		-e '/^#include <Plasma\/DeclarativeWidget>$/a #endif' \
		-e '/^    Plasma::DeclarativeWidget \*declarativeWidget;$/i #ifdef HAVE_QTDECLARATIVE' \
		-e '/^    Plasma::DeclarativeWidget \*declarativeWidget;$/a #endif' \
		-e '/^    declarativeWidget = new Plasma::DeclarativeWidget(q);$/i #ifdef HAVE_QTDECLARATIVE' \
		-e '/^    q->setLayout(mainLayout);$/i #endif' \
		-e '/^    if (declarativeWidget->mainComponent()->isError()) {$/i #ifdef HAVE_QTDECLARATIVE' \
		-e '/^    emit q->widgetsMenuActionsChanged();$/i #endif' \
		-e '/^    QObject::connect(declarativeWidget->rootObject(), SIGNAL(addAppletRequested/i #ifdef HAVE_QTDECLARATIVE' \
		-e '/^    declarativeWidget->rootObject()->setProperty("extraActions", QVariant::fromValue(actionList));$/a #endif' \
		-e '/^            if (d->declarativeWidget->rootObject()) {$/i #ifdef HAVE_QTDECLARATIVE' \
		"${widgetexplorer}" ||
		die "failed to guard the QML parts of ${widgetexplorer}"

	awk '/^[[:space:]]*emit widgetsMenuActionsChanged\(\);$/ {
		print
		getline
		print
		print "#endif"
		next
	} { print }' "${widgetexplorer}" > "${widgetexplorer}.kde4tmp" ||
		die "failed to close the QML guard in ${widgetexplorer}"
	mv "${widgetexplorer}.kde4tmp" "${widgetexplorer}" || die

	# Every insertion above is anchored on a line that must exist; if the source
	# snapshot differs, stop here with a precise message instead of a broken build.
	if [[ $(grep -c '^#ifdef HAVE_QTDECLARATIVE' "${widgetexplorer}") != 7 ]]; then
		die "expected 7 HAVE_QTDECLARATIVE guards in ${widgetexplorer}"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_KDeclarative="$(usex !declarative)"
		-DCMAKE_DISABLE_FIND_PACKAGE_QtDeclarative="$(usex !declarative)"
	)

	kde4-meta_src_configure
}
