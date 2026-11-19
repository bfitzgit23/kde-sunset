# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-runtime"
KMMODULE="plasma"
DECLARATIVE_REQUIRED="always"
WEBKIT_REQUIRED="always"
inherit kde4-meta

DESCRIPTION="Script engine and package tool for plasma"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	kde-frameworks/kactivities:4
"
RDEPEND="${DEPEND}"

# bug 443748
RESTRICT=test

PATCHES=(
	"${FILESDIR}/plasma-runtime-cmake4-auth-actions.patch"
)

src_prepare() {
	kde4-meta_src_prepare

	# CMake 4 (CMP0037): kde4_install_auth_actions() builds an invalid target name
	# from the dotted helper id, so the call is dropped and the policy is installed
	# from FILESDIR. Apply that replacement here as well, so the build does not
	# depend on the eclass having honoured PATCHES.
	local pc="${S}/plasma/remotewidgetshelper/CMakeLists.txt"
	if grep -q 'kde4_install_auth_actions(org\.kde\.kcontrol\.kcmremotewidgets kcm_remotewidgets\.actions)' "${pc}"; then
		eapply "${FILESDIR}/plasma-runtime-cmake4-auth-actions.patch"
	fi
	if grep -q 'kde4_install_auth_actions(org\.kde\.kcontrol\.kcmremotewidgets kcm_remotewidgets\.actions)' "${pc}"; then
		die "CMake 4 auth-actions replacement missing in ${pc}"
	fi
	# libplasma installs <Plasma/WebView> and <Plasma/VideoWidget> unconditionally but
	# only compiles webview.cpp / videowidget.cpp when QtWebKit / Phonon were found at
	# its own configure time.  A libplasma built without them leaves those classes
	# unimplemented, and the JavaScript script engine and the graphicswidgets export
	# plugin cannot link under -Wl,--no-undefined.  Drop just those bindings then.
	local lp="${EROOT%/}/usr/$(get_libdir)/libplasma.so.3"
	local have_webview=0 have_videowidget=0
	if [[ -e ${lp} ]]; then
		if nm -D --defined-only "${lp}" 2>/dev/null | grep -q '_ZN6Plasma7WebView'; then
			have_webview=1
		fi
		if nm -D --defined-only "${lp}" 2>/dev/null | grep -q '_ZN6Plasma11VideoWidget'; then
			have_videowidget=1
		fi
		if [[ ${have_webview} == 0 || ${have_videowidget} == 0 ]]; then
			eapply "${FILESDIR}/plasma-runtime-no-optional-plasma-bindings.patch"
		fi
	fi
}

src_install() {
	kde4-meta_src_install

	# The remote-widgets helper action is installed from the pre-generated policy:
	# the KAuth policy generator cannot produce a valid target name under CMake 4,
	# and a fake KAuth backend emits an empty file.
	insinto /usr/share/polkit-1/actions
	doins "${FILESDIR}/org.kde.kcontrol.kcmremotewidgets.policy"
}
