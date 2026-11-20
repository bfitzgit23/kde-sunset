# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @DEAD
# Removal on 2018-05-03.
# @ECLASS: kde4-base.eclass
# @MAINTAINER:
# kde-sunset overlay maintainers
# @BLURB: This eclass provides functions for kde 4.X ebuilds
# @DESCRIPTION:
# The kde4-base.eclass provides support for building KDE4 based ebuilds
# and KDE4 applications.
#
# NOTE: KDE 4 ebuilds currently support EAPI 5. This will be
# reviewed over time as new EAPI versions are approved.

if [[ -z ${_KDE4_BASE_ECLASS} ]]; then
_KDE4_BASE_ECLASS=1


# @ECLASS-VARIABLE: EAPI
# @DESCRIPTION:
# Currently kde4 eclasses support 6, 7 and 8.
case ${EAPI} in
	6) : ;;
	7|8) : ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

# @ECLASS-VARIABLE: KDE_SELINUX_MODULE
# @DESCRIPTION:
# If set to "none", do nothing.
# For any other value, add selinux to IUSE, and depending on that useflag
# add a dependency on sec-policy/selinux-${KDE_SELINUX_MODULE} to (R)DEPEND
: ${KDE_SELINUX_MODULE:=none}

# @ECLASS-VARIABLE: VIRTUALDBUS_TEST
# @DESCRIPTION:
# If defined, launch and use a private dbus session during src_test.

# @ECLASS-VARIABLE: VIRTUALX_REQUIRED
# @DESCRIPTION:
# For proper description see virtualx.eclass manpage.
# Here we redefine default value to be manual, if your package needs virtualx
# for tests you should proceed with setting VIRTUALX_REQUIRED=test.
: ${VIRTUALX_REQUIRED:=manual}

inherit kde4-functions toolchain-funcs flag-o-matic virtualx multilib xdg-utils


if [[ ${KDE_BUILD_TYPE} = live ]]; then
	case ${KDE_SCM} in
		svn) inherit subversion ;;
		git) inherit git-r3 ;;
	esac
fi

# @ECLASS-VARIABLE: CMAKE_REQUIRED
# @DESCRIPTION:
# Specify if cmake buildsystem is being used. Possible values are 'always' and 'never'.
# Please note that if it's set to 'never' you need to explicitly override following phases:
# src_configure, src_compile, src_test and src_install.
# Defaults to 'always'.
: ${CMAKE_REQUIRED:=always}
if [[ ${CMAKE_REQUIRED} = always ]]; then
	buildsystem_eclass="cmake"
	export_fns="src_configure src_compile src_test src_install"
fi

# @ECLASS-VARIABLE: KDE_MINIMAL
# @DESCRIPTION:
# This variable is used when KDE_REQUIRED is set, to specify required KDE minimal
# version for apps to work. Currently defaults to 4.4
# One may override this variable to raise version requirements.
# Note that it is fixed to ${PV} for kde-base packages.
KDE_MINIMAL="${KDE_MINIMAL:-4.4}"

# Set slot for KDEBASE known packages
case ${KDEBASE} in
	kde-base)
		SLOT=4/$(ver_cut 1-2)
		KDE_MINIMAL="${PV}"
		;;
	kdevelop)
		if [[ ${KDE_BUILD_TYPE} = live ]]; then
			# @ECLASS-VARIABLE: KDEVELOP_VERSION
			# @DESCRIPTION:
			# Specifies KDevelop version. Default is 4.0.0 for tagged packages and 9999 for live packages.
			# Applies to KDEBASE=kdevelop only.
			KDEVELOP_VERSION="${KDEVELOP_VERSION:-4.9999}"
			# @ECLASS-VARIABLE: KDEVPLATFORM_VERSION
			# @DESCRIPTION:
			# Specifies KDevplatform version. Default is 1.0.0 for tagged packages and 9999 for live packages.
			# Applies to KDEBASE=kdevelop only.
			KDEVPLATFORM_VERSION="${KDEVPLATFORM_VERSION:-4.9999}"
		else
			case ${PN} in
				kdevelop)
					KDEVELOP_VERSION=${PV}
					KDEVPLATFORM_VERSION="$(($(ver_cut 1)-3)).$(ver_cut 2-)"
					;;
				kdevplatform|kdevelop-php*|kdevelop-python)
					KDEVELOP_VERSION="$(($(ver_cut 1)+3)).$(ver_cut 2-)"
					KDEVPLATFORM_VERSION=${PV}
					;;
				*)
					KDEVELOP_VERSION="${KDEVELOP_VERSION:-4.0.0}"
					KDEVPLATFORM_VERSION="${KDEVPLATFORM_VERSION:-1.0.0}"
			esac
		fi
		SLOT="4"
		;;
esac

inherit ${buildsystem_eclass}

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare ${export_fns} pkg_preinst pkg_postinst pkg_postrm

unset buildsystem_eclass
unset export_fns

# @ECLASS-VARIABLE: DECLARATIVE_REQUIRED
# @DESCRIPTION:
# Is qtdeclarative required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
DECLARATIVE_REQUIRED="${DECLARATIVE_REQUIRED:-never}"

# @ECLASS-VARIABLE: QT3SUPPORT_REQUIRED
# @DESCRIPTION:
# Is qt3support required? Possible values are 'true' or 'false'.
# This variable must be set before inheriting any eclasses. Defaults to 'false'.
QT3SUPPORT_REQUIRED="${QT3SUPPORT_REQUIRED:-false}"

# @ECLASS-VARIABLE: QTHELP_REQUIRED
# @DESCRIPTION:
# Is qthelp required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
QTHELP_REQUIRED="${QTHELP_REQUIRED:-never}"

# @ECLASS-VARIABLE: OPENGL_REQUIRED
# @DESCRIPTION:
# Is qtopengl required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
OPENGL_REQUIRED="${OPENGL_REQUIRED:-never}"

# @ECLASS-VARIABLE: MULTIMEDIA_REQUIRED
# @DESCRIPTION:
# Is qtmultimedia required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
MULTIMEDIA_REQUIRED="${MULTIMEDIA_REQUIRED:-never}"

# @ECLASS-VARIABLE: SQL_REQUIRED
# @DESCRIPTION:
# Is qtsql required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
SQL_REQUIRED="${SQL_REQUIRED:-never}"

# @ECLASS-VARIABLE: WEBKIT_REQUIRED
# @DESCRIPTION:
# QtWebKit is intentionally unsupported in this overlay.  Ignore per-ebuild
# settings so no KDE4 package can pull in QtWebKit.
WEBKIT_REQUIRED="never"

# @ECLASS-VARIABLE: CPPUNIT_REQUIRED
# @DESCRIPTION:
# Is cppunit required for tests? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
CPPUNIT_REQUIRED="${CPPUNIT_REQUIRED:-never}"

# @ECLASS-VARIABLE: KDE_REQUIRED
# @DESCRIPTION:
# Is kde required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'always'
# If set to 'always' or 'optional', KDE_MINIMAL may be overridden as well.
# Note that for kde-base packages this variable is fixed to 'always'.
KDE_REQUIRED="${KDE_REQUIRED:-always}"

# @ECLASS-VARIABLE: KDE_HANDBOOK
# @DESCRIPTION:
# Set to enable handbook in application. Possible values are 'always', 'optional'
# (handbook USE flag) and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
# It adds default handbook dirs for kde-base packages to KMEXTRA and in any case it
# ensures buildtime and runtime dependencies.
# Handbook support is disabled in this overlay; no KHelpCenter dependency.
KDE_HANDBOOK=never

# @ECLASS-VARIABLE: KDE_LINGUAS_LIVE_OVERRIDE
# @DESCRIPTION:
# Set this varible if you want your live package to manage its
# translations. (Mostly all kde ebuilds does not ship documentation
# and translations in live ebuilds)
if [[ ${KDE_BUILD_TYPE} == live && -z ${KDE_LINGUAS_LIVE_OVERRIDE} ]]; then
	# Kdebase actually provides the handbooks even for live stuff
	[[ ${KDEBASE} == kde-base ]] || KDE_HANDBOOK=never
	KDE_LINGUAS=""
fi

# Setup packages inheriting this eclass
case ${KDEBASE} in
	kde-base)
		HOMEPAGE="https://www.kde.org/"
		LICENSE="GPL-2"
		if [[ ${KDE_BUILD_TYPE} = live && -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
			# Disable tests for live ebuilds by default
			RESTRICT+=" test"
		fi

		# This code is to prevent portage from searching GENTOO_MIRRORS for
		# packages that will never be mirrored. (As they only will ever be in
		# the overlay).
		case ${PV} in
			*9999* | 4.?.[6-9]? | 4.??.[6-9]? | ??.?.[6-9]? | ??.??.[6-9]?)
				RESTRICT+=" mirror"
				;;
		esac
		;;
	kdevelop)
		HOMEPAGE="https://www.kdevelop.org/"
		LICENSE="GPL-2"
		;;
esac

# @ECLASS-VARIABLE: QT_MINIMAL
# @DESCRIPTION:
# Determine version of qt we enforce as minimal for the package.
QT_MINIMAL="${QT_MINIMAL:-4.8.5}"

# Declarative dependencies
qtdeclarativedepend="
	>=dev-qt/qtdeclarative-${QT_MINIMAL}:4
"
case ${DECLARATIVE_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtdeclarativedepend}"
		;;
	optional)
		IUSE+=" declarative"
		COMMONDEPEND+=" declarative? ( ${qtdeclarativedepend} )"
		;;
	*) ;;
esac
unset qtdeclarativedepend

# Qt3Support dependencies
qt3supportdepend="
	>=dev-qt/qt3support-${QT_MINIMAL}:4[accessibility]
"
case ${QT3SUPPORT_REQUIRED} in
	true)
		COMMONDEPEND+=" ${qt3supportdepend}"
		[[ -n ${qtcoreuse} ]] && qtcoreuse+=",qt3support" || qtcoreuse="qt3support"
		[[ -n ${qtsqluse} ]] && qtsqluse+=",qt3support" || qtsqluse="qt3support"
		[[ -n ${kdelibsuse} ]] && kdelibsuse+=",qt3support(+)" || kdelibsuse="qt3support(+)"
		;;
	*) ;;
esac
unset qt3supportdepend

# QtHelp dependencies
qthelpdepend="
	>=dev-qt/qthelp-${QT_MINIMAL}:4
"
case ${QTHELP_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qthelpdepend}"
		;;
	optional)
		IUSE+=" qthelp"
		COMMONDEPEND+=" qthelp? ( ${qthelpdepend} )"
		;;
esac
unset qthelpdepend

# OpenGL dependencies
qtopengldepend="
	>=dev-qt/qtopengl-${QT_MINIMAL}:4
"
case ${OPENGL_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtopengldepend}"
		;;
	optional)
		IUSE+=" opengl"
		COMMONDEPEND+=" opengl? ( ${qtopengldepend} )"
		;;
	*) ;;
esac
unset qtopengldepend

# MultiMedia dependencies
qtmultimediadepend="
	>=dev-qt/qtmultimedia-${QT_MINIMAL}:4
"
case ${MULTIMEDIA_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtmultimediadepend}"
		;;
	optional)
		IUSE+=" multimedia"
		COMMONDEPEND+=" multimedia? ( ${qtmultimediadepend} )"
		;;
	*) ;;
esac
unset qtmultimediadepend

# Sql dependencies
[[ -n ${qtsqluse} ]] && qtsqluse="[${qtsqluse}]"
qtsqldepend="
	>=dev-qt/qtsql-${QT_MINIMAL}:4${qtsqluse}
"
case ${SQL_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtsqldepend}"
		;;
	optional)
		IUSE+=" sql"
		COMMONDEPEND+=" sql? ( ${qtsqldepend} )"
		;;
	*) ;;
esac
unset qtsqluse
unset qtsqldepend

# WebKit dependencies
qtwebkitdepend="
	>=dev-qt/qtwebkit-${QT_MINIMAL}:4
"
case ${WEBKIT_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtwebkitdepend}"
		[[ -n ${kdelibsuse} ]] && kdelibsuse+=",webkit(+)" || kdelibsuse="webkit(+)"
		;;
	optional)
		IUSE+=" +webkit"
		COMMONDEPEND+=" webkit? ( ${qtwebkitdepend} )"
		[[ -n ${kdelibsuse} ]] && kdelibsuse+=",webkit?" || kdelibsuse="webkit?"
		;;
	*) ;;
esac
unset qtwebkitdepend

# CppUnit dependencies
cppuintdepend="
	dev-util/cppunit
"
case ${CPPUNIT_REQUIRED} in
	always)
		DEPEND+=" ${cppuintdepend}"
		;;
	optional)
		IUSE+=" test"
		DEPEND+=" test? ( ${cppuintdepend} )"
		RESTRICT+=" !test? ( test )"
		;;
	*) ;;
esac
unset cppuintdepend

# KDE dependencies
# Qt accessibility classes are needed in various places, bug 325461
[[ -n ${qtcoreuse} ]] && qtcoreuse+=",ssl" || qtcoreuse="ssl"
[[ -n ${qtcoreuse} ]] && qtcoreuse="[${qtcoreuse}]"
kdecommondepend="
	dev-lang/perl
	>=dev-qt/designer-${QT_MINIMAL}:4
	>=dev-qt/qtcore-${QT_MINIMAL}:4${qtcoreuse}
	>=dev-qt/qtdbus-${QT_MINIMAL}:4
	>=dev-qt/qtgui-${QT_MINIMAL}:4[accessibility,dbus(+)]
	>=dev-qt/qtscript-${QT_MINIMAL}:4
	>=dev-qt/qtsvg-${QT_MINIMAL}:4
	>=dev-qt/qttest-${QT_MINIMAL}:4
"
unset qtcoreuse

[[ -n ${kdelibsuse} ]] && kdelibsuse="[${kdelibsuse}]"
kdecommondepend+=" kde-frameworks/kdelibs:4${kdelibsuse}"
if [[ ${KDEBASE} = kdevelop ]]; then
	if [[ ${PN} != kdevplatform ]]; then
		# @ECLASS-VARIABLE: KDEVPLATFORM_REQUIRED
		# @DESCRIPTION:
		# Specifies whether kdevplatform is required. Possible values are 'always' (default) and 'never'.
		# Applies to KDEBASE=kdevelop only.
		KDEVPLATFORM_REQUIRED="${KDEVPLATFORM_REQUIRED:-always}"
		case ${KDEVPLATFORM_REQUIRED} in
			always)
				kdecommondepend+="
					>=dev-util/kdevplatform-${KDEVPLATFORM_VERSION}:4
				"
				;;
			*) ;;
		esac
	fi
fi
unset kdelibsuse

kdedepend="
	dev-util/automoc
	virtual/pkgconfig
	>=x11-libs/libXtst-1.1.0
	x11-base/xorg-proto
"

kderdepend=""

# all packages needs oxygen icons for basic iconset
if [[ ${PN} != oxygen-icons ]]; then
	kderdepend+=" kde-frameworks/oxygen-icons"
fi

# add a dependency over kde4-l10n
if [[ ${KDEBASE} != "kde-base" && -n ${KDE_LINGUAS} ]]; then
	for _lingua in $(kde4_lingua_to_l10n ${KDE_LINGUAS}); do
		# if our package has linguas, pull in kde4-l10n with selected lingua enabled,
		# but only for selected ones.
		# this can't be done on one line because if user doesn't use any localisation
		# then he is probably not interested in kde4-l10n at all.
		kderdepend+="
		l10n_${_lingua}? ( $(add_kdeapps_dep kde4-l10n "l10n_${_lingua}(+)") )
		"
	done
	unset _lingua
fi

# Handbook support is disabled in this overlay; no build/runtime dependencies.

case ${KDE_SELINUX_MODULE} in
	none)	;;
	*)
		IUSE+=" selinux"
		kderdepend+=" selinux? ( sec-policy/selinux-${KDE_SELINUX_MODULE} )"
		;;
esac

case ${KDE_REQUIRED} in
	always)
		[[ -n ${kdecommondepend} ]] && COMMONDEPEND+=" ${kdecommondepend}"
		[[ -n ${kdedepend} ]] && DEPEND+=" ${kdedepend}"
		[[ -n ${kderdepend} ]] && RDEPEND+=" ${kderdepend}"
		;;
	optional)
		IUSE+=" kde"
		[[ -n ${kdecommondepend} ]] && COMMONDEPEND+=" kde? ( ${kdecommondepend} )"
		[[ -n ${kdedepend} ]] && DEPEND+=" kde? ( ${kdedepend} )"
		[[ -n ${kderdepend} ]] && RDEPEND+=" kde? ( ${kderdepend} )"
		;;
	*) ;;
esac

unset kdecommondepend kdedepend kderdepend

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: COMMONDEPEND is ${COMMONDEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: DEPEND (only) is ${DEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: RDEPEND (only) is ${RDEPEND}"

# Accumulate dependencies set by this eclass
DEPEND+=" ${COMMONDEPEND}"
RDEPEND+=" ${COMMONDEPEND}"
unset COMMONDEPEND

# Fetch section - If the ebuild's category is not 'kde-base' and if it is not a
# kdevelop ebuild, the URI should be set in the ebuild itself
_calculate_src_uri() {
	debug-print-function ${FUNCNAME} "$@"

	local _kmname _kmname_pv

	# we calculate URI only for known KDEBASE modules
	[[ -n ${KDEBASE} ]] || return

	# calculate tarball module name
	if [[ -n ${KMNAME} ]]; then
		_kmname="${KMNAME}"
	else
		_kmname=${PN}
	fi
	_kmname_pv="${_kmname}-${PV}"
	case ${KDEBASE} in
		kde-base)
			case ${PV} in
				4.4.20*)
					# KDEPIM 4.4 no-akonadi branch, special case
					# TODO: Remove this part when KDEPIM 4.4 gets out of the tree
					SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${_kmname_pv}.tar.xz" ;;
				4.?.[6-9]? | 4.??.[6-9]?)
					# Unstable KDE SC releases
					SRC_URI="mirror://kde/unstable/${PV}/src/${_kmname_pv}.tar.xz" ;;
				4.11.22)
					# Part of 15.08.0 actually, sigh. Not stable for next release!
					SRC_URI="mirror://kde/Attic/applications/15.08.0/src/${_kmname_pv}.tar.xz" ;;
				4.13.3)
					# kde-plasma/kactivitymanagerd
					SRC_URI="mirror://kde/Attic/${PV}/src/${_kmname_pv}.tar.xz" ;;
				4.14.3)
					# Last SC release
					SRC_URI="mirror://kde/Attic/${PV}/src/${_kmname_pv}.tar.xz" ;;
				4.14.10)
					# Part of 15.04.3 actually, sigh. Used by last version of KDE PIM 4.
					SRC_URI="mirror://kde/Attic/applications/15.04.3/src/${_kmname_pv}.tar.xz" ;;
				4.14.11*)
					# KDEPIM 4.14 snapshot with Gentoo patches
					SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${_kmname_pv}.tar.xz" ;;
				16.12.3)
					SRC_URI="mirror://kde/Attic/applications/16.12.3/src/${_kmname_pv}.tar.xz" ;;
				??.?.[6-9]? | ??.??.[4-9]?)
					# Unstable KDE Applications releases
					SRC_URI="mirror://kde/unstable/applications/${PV}/src/${_kmname}-${PV}.tar.xz" ;;
				*)
					# Stable KDE Applications releases
					SRC_URI="mirror://kde/stable/applications/${PV}/src/${_kmname}-${PV}.tar.xz"
				;;
			esac
			;;
		kdevelop|kdevelop-php*|kdevplatform)
			case ${KDEVELOP_VERSION} in
				4.[123].[6-9]*) SRC_URI="mirror://kde/unstable/kdevelop/${KDEVELOP_VERSION}/src/${P}.tar.xz" ;;
				4.7.3) SRC_URI="mirror://kde/stable/kdevelop/${KDEVELOP_VERSION}/src/${P}.tar.bz2" ;;
				4.7.4) SRC_URI="mirror://kde/stable/kdevelop/${KDEVELOP_VERSION}/${P}.tar.xz" ;;
				*) SRC_URI="mirror://kde/stable/kdevelop/${KDEVELOP_VERSION}/src/${P}.tar.xz" ;;
			esac
			;;
	esac
}

_calculate_live_repo() {
	debug-print-function ${FUNCNAME} "$@"

	SRC_URI=""
	case ${KDE_SCM} in
		svn)
			# Determine branch URL based on live type
			local branch_prefix
			case ${PV} in
				9999*)
					# trunk
					branch_prefix="trunk/KDE"
					;;
				*)
					# branch
					branch_prefix="branches/KDE/$(get_kde_version)"

					if [[ ${PV} == ??.??.49.9999 && ${CATEGORY} = kde-apps ]]; then
						branch_prefix="branches/Applications/$(get_kde_version)"
					fi

					# @ECLASS-VARIABLE: ESVN_PROJECT_SUFFIX
					# @DESCRIPTION
					# Suffix appended to ESVN_PROJECT depending on fetched branch.
					# Defaults is empty (for -9999 = trunk), and "-${PV}" otherwise.
					ESVN_PROJECT_SUFFIX="-${PV}"
					;;
			esac
			# @ECLASS-VARIABLE: ESVN_MIRROR
			# @DESCRIPTION:
			# This variable allows easy overriding of default kde mirror service
			# (anonsvn) with anything else you might want to use.
			ESVN_MIRROR=${ESVN_MIRROR:=svn://anonsvn.kde.org/home/kde}
			# Split ebuild, or extragear stuff
			if [[ -n ${KMNAME} ]]; then
				ESVN_PROJECT="${KMNAME}${ESVN_PROJECT_SUFFIX}"
				if [[ -z ${KMNOMODULE} ]] && [[ -z ${KMMODULE} ]]; then
					KMMODULE="${PN}"
				fi
				# Split kde-base/ ebuilds: (they reside in trunk/KDE)
				case ${KMNAME} in
					kdebase-*)
						ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/kdebase/${KMNAME#kdebase-}"
						;;
					kdelibs-*)
						ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/kdelibs/${KMNAME#kdelibs-}"
						;;
					kdereview*)
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						;;
					kdesupport)
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
						;;
					kde*)
						ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/${KMNAME}"
						;;
					extragear*|playground*)
						# Unpack them in toplevel dir, so that they won't conflict with kde4-meta
						# build packages from same svn location.
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
						;;
					*)
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						;;
				esac
			else
				# kdelibs, kdepimlibs
				ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/${PN}"
				ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
			fi
			# @ECLASS-VARIABLE: ESVN_UP_FREQ
			# @DESCRIPTION:
			# This variable is used for specifying the timeout between svn synces
			# for kde-base modules. Does not affect misc apps.
			# Default value is 1 hour.
			[[ ${KDEBASE} = kde-base ]] && ESVN_UP_FREQ=${ESVN_UP_FREQ:-1}
			;;
		git)
			local _kmname
			# @ECLASS-VARIABLE: EGIT_MIRROR
			# @DESCRIPTION:
			# This variable allows easy overriding of default kde mirror service
			# (anongit) with anything else you might want to use.
			EGIT_MIRROR=${EGIT_MIRROR:=https://anongit.kde.org}

			# @ECLASS-VARIABLE: EGIT_REPONAME
			# @DESCRIPTION:
			# This variable allows overriding of default repository
			# name. Specify only if this differ from PN and KMNAME.
			if [[ -n ${EGIT_REPONAME} ]]; then
				# the repository and kmname different
				_kmname=${EGIT_REPONAME}
			elif [[ -n ${KMNAME} ]]; then
				_kmname=${KMNAME}
			else
				_kmname=${PN}
			fi

			# default branching
			[[ ${PV} != 4.9999* && ${PV} != 9999 && ${KDEBASE} == kde-base ]] && \
				EGIT_BRANCH="KDE/$(get_kde_version)"

			# Applications branching
			[[ ${PV} == ??.??.49.9999 && ${KDEBASE} == kde-base ]] && \
				EGIT_BRANCH="Applications/$(get_kde_version)"

			# default repo uri
			EGIT_REPO_URI+=( "${EGIT_MIRROR}/${_kmname}" )

			debug-print "${FUNCNAME}: Repository: ${EGIT_REPO_URI}"
			debug-print "${FUNCNAME}: Branch: ${EGIT_BRANCH}"
			;;
	esac
}

case ${KDE_BUILD_TYPE} in
	live) _calculate_live_repo ;;
	*) _calculate_src_uri ;;
esac

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: SRC_URI is ${SRC_URI}"

# @ECLASS-VARIABLE: PREFIX
# @DESCRIPTION:
# Set the installation PREFIX for non kde-base applications. It defaults to /usr.
# kde-base packages go into KDE4 installation directory (/usr).
# No matter the PREFIX, package will be built against KDE installed in /usr.

# @FUNCTION: kde4-base_pkg_setup
# @DESCRIPTION:
# Do some basic settings
kde4-base_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	if has handbook ${IUSE} || has "+handbook" ${IUSE} && [[ "${KDE_HANDBOOK}" != optional ]] ; then
		eqawarn "Handbook support is enabled via KDE_HANDBOOK=optional in the ebuild."
		eqawarn "Please do not just set IUSE=handbook, as this leads to dependency errors."
	fi

	# Don't set KDEHOME during compilation, it will cause access violations
	unset KDEHOME

	KDEDIR=/usr
	: ${PREFIX:=/usr}
	EKDEDIR=${EPREFIX}/usr

	# Point to correct QT plugins path
	QT_PLUGIN_PATH="${EPREFIX}/usr/$(get_libdir)/kde4/plugins/"

	# Fix XDG collision with sandbox
	export XDG_CONFIG_HOME="${T}"
}

# @FUNCTION: kde4-base_src_unpack
# @DESCRIPTION:
# This function unpacks the source tarballs for KDE4 applications.
kde4-base_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${KDE_BUILD_TYPE} = live ]]; then
		case ${KDE_SCM} in
			svn)
				subversion_src_unpack
				;;
			git)
				git-r3_src_unpack
				;;
		esac
	else
		unpack ${A}
	fi
}

# @FUNCTION: kde4-base_src_prepare
# @DESCRIPTION:
# General pre-configure and pre-compile function for KDE4 applications.
# It also handles translations if KDE_LINGUAS is defined. See KDE_LINGUAS and
# enable_selected_linguas() and enable_selected_doc_linguas()
# in kde4-functions.eclass(5) for further details.
kde4-base_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	# enable handbook and linguas only when not using live ebuild

	# Only enable selected languages, used for KDE extragear apps.
	if [[ -n ${KDE_LINGUAS} ]]; then
		enable_selected_linguas
	fi

	# Enable/disable handbooks for kde4-base packages
	# kde4-l10n inherits kde4-base but is metapackage, so no check for doc
	if ! has kde4-meta ${INHERITED} && in_iuse handbook; then
		if [[ ${KDEBASE} == kde-base ]]; then
			if [[ ${PN} != kde4-l10n && ${PN} != kdepim-l10n ]] && use !handbook; then
				# documentation in kde4-functions
				: ${KDE_DOC_DIRS:=doc}
				local dir
				for dir in ${KDE_DOC_DIRS}; do
					sed -e "\!^[[:space:]]*add_subdirectory[[:space:]]*([[:space:]]*${dir}[[:space:]]*)!s/^/#DONOTCOMPILE /" \
						-e "\!^[[:space:]]*ADD_SUBDIRECTORY[[:space:]]*([[:space:]]*${dir}[[:space:]]*)!s/^/#DONOTCOMPILE /" \
						-e "\!^[[:space:]]*macro_optional_add_subdirectory[[:space:]]*([[:space:]]*${dir}[[:space:]]*)!s/^/#DONOTCOMPILE /" \
						-e "\!^[[:space:]]*MACRO_OPTIONAL_ADD_SUBDIRECTORY[[:space:]]*([[:space:]]*${dir}[[:space:]]*)!s/^/#DONOTCOMPILE /" \
						-i CMakeLists.txt || die "failed to comment out handbook"
				done
			fi
		else
			enable_selected_doc_linguas
		fi
	fi

	# SCM bootstrap
	if [[ ${KDE_BUILD_TYPE} = live ]]; then
		case ${KDE_SCM} in
			svn) subversion_src_prepare ;;
		esac
	fi

	# Apply patches, cmake does the job already
	cmake_src_prepare

	# CMake 4 requires a policy version (CMP0000), rejects policy versions
	# below 3.5 and removed export_library_dependencies() (CMP0033).  KDE4
	# sources predate all of it, so repair them here instead of patching
	# every module.
	if [[ -f ${S}/CMakeLists.txt ]]; then
		# A package split out of a combined KDE4 tree (kde-workspace, kde-runtime,
		# kdepim) still orders its build against targets that only exist when the
		# siblings are built too: kmenuedit waits for kded_khotkeys, kalarm for the
		# Akonadi resource XML targets.  CMake then refuses to generate:
		#   The dependency target "..." of target "..." does not exist.
		# Give every literal dependency its own if(TARGET ...) guard so a dependency
		# that is not part of this build is dropped instead of aborting configure.
		# CMake has always required the dependency to exist at that point, so the
		# guard cannot change a build in which it does exist; the #kde4-guarded
		# marker keeps a second run idempotent.
		if [[ ! -f ${TMPDIR}/kde4-guard-add-deps.awk ]]; then
			cat > "${TMPDIR}/kde4-guard-add-deps.awk" <<-'EOF'
			{ lines[NR] = $0 }
			END {
				for (i = 1; i <= NR; i++) {
					s = lines[i]
					if (s ~ /#kde4-guarded/ || s !~ /^[[:space:]]*add_dependencies[[:space:]]*\([^()]*\)[[:space:]]*$/) { print s; continue }
					x = s
					sub(/^[[:space:]]*add_dependencies[[:space:]]*\(/, "", x)
					sub(/\)[[:space:]]*$/, "", x)
					n = split(x, a, /[[:space:]]+/)
					literal = (n >= 2)
					for (j = 2; j <= n; j++) { if (a[j] !~ /^[A-Za-z0-9_.:+-]+$/) literal = 0 }
					if (literal == 0) { print s; continue }
					ind = s
					sub(/[^[:space:]].*$/, "", ind)
					for (j = 2; j <= n; j++) {
						print ind "if(TARGET " a[j] ")"
						print ind "add_dependencies(" a[1] " " a[j] ") #kde4-guarded"
						print ind "else()"
						print ind "message(STATUS \"kde4: dropping dependency '" a[j] "' of target '" a[1] "', not built here\")"
						print ind "endif()"
					}
				}
			}
			EOF
		fi
		while IFS= read -r -d '' _cmake_file; do
			# The old target_link_libraries(<tgt> LINK_INTERFACE_LIBRARIES ...)
			# signature is often split over two lines, which the per-line rules
			# below cannot see (they need the target name and the keyword in the
			# same buffer).  Convert it whole-file first, otherwise the plain
			# keyword rename turns it into -lINTERFACE_LINK_LIBRARIES.
			sed -z -i -E -e 's/target_link_libraries[[:space:]]*\([[:space:]]*([^[:space:])]+)[[:space:]]+(LINK_INTERFACE_LIBRARIES|INTERFACE_LINK_LIBRARIES)[[:space:]]+/set_property(TARGET \1 APPEND PROPERTY INTERFACE_LINK_LIBRARIES /Ig' "${_cmake_file}" ||
				die "failed to rewrite split LINK_INTERFACE_LIBRARIES in ${_cmake_file}"
			sed -i -E -e '/\.\.\./! s/(cmake_minimum_required[[:space:]]*\([[:space:]]*VERSION)[[:space:]]*[012]\.[0-9][0-9.]*/\1 3.5/I' -e '/\.\.\./! s/(cmake_minimum_required[[:space:]]*\([[:space:]]*VERSION)[[:space:]]*3\.[0-4]([^0-9]|$)/\1 3.5\2/I' -e '/\.\.\./! s/(cmake_policy[[:space:]]*\([[:space:]]*VERSION)[[:space:]]*[012]\.[0-9][0-9.]*/\1 3.5/I' -e '/\.\.\./! s/(cmake_policy[[:space:]]*\([[:space:]]*VERSION)[[:space:]]*3\.[0-4]([^0-9]|$)/\1 3.5\2/I' -e 's/^([[:space:]]*)target_link_libraries[[:space:]]*\([[:space:]]*([^[:space:])]+)[[:space:]]+LINK_INTERFACE_LIBRARIES[[:space:]]+/\1set_property(TARGET \2 APPEND PROPERTY INTERFACE_LINK_LIBRARIES /I' -e 's/\bLINK_INTERFACE_LIBRARIES\b/INTERFACE_LINK_LIBRARIES/g' -e 's/^[[:space:]]*export_library_dependencies[[:space:]]*\((.*)\)[[:space:]]*$/file(WRITE \1 "")/I' "${_cmake_file}" || die "failed to rewrite CMake 4 incompatibilities in ${_cmake_file}"
			awk -f "${TMPDIR}/kde4-guard-add-deps.awk" "${_cmake_file}" > "${_cmake_file}.kde4tmp" ||
				die "failed to guard add_dependencies() in ${_cmake_file}"
			mv "${_cmake_file}.kde4tmp" "${_cmake_file}" ||
				die "failed to rewrite ${_cmake_file}"
			# konqueror and many others add their tests directory unconditionally,
			# and KDE4Macros' kde4_add_unit_test() uses the pre-3.5
			#   if( ${ARGV1} STREQUAL "TESTNAME" )
			# form, which CMake 4 rejects with "Unknown arguments specified" as soon
			# as it is reached - even though the tests themselves are off.  Skip the
			# test directories unless they are wanted; with KDE4_BUILD_TESTS=ON the
			# guard is true and nothing changes.
			sed -i -E -e 's:^([[:space:]]*)add_subdirectory[[:space:]]*\([[:space:]]*((\$\{CMAKE_CURRENT_SOURCE_DIR\}/)?(tests|autotests|autotest)/?[^()]*)\)[[:space:]]*$:\1if(KDE4_BUILD_TESTS)\n\1add_subdirectory(\2) #kde4-tests-guarded\n\1endif():' "${_cmake_file}" ||
				die "failed to guard test directories in ${_cmake_file}"
		done < <(find "${S}" -type f \( -name CMakeLists.txt -o -name '*.cmake' \) -print0)
		if ! grep -q 'cmake_minimum_required' "${S}/CMakeLists.txt"; then
			{ printf '%s
' 'cmake_minimum_required(VERSION 3.5)'; cat "${S}/CMakeLists.txt"; } > "${S}/CMakeLists.txt.kde4tmp"
			mv "${S}/CMakeLists.txt.kde4tmp" "${S}/CMakeLists.txt" || die "failed to add cmake_minimum_required"
		fi
		# CMake 4 (CMP0037) rejects the custom target name that KDE4Macros paths
		# build from a dotted KAuth helper id.  Replace the macro right after
		# KDE4Defaults is included (KDE4Macros is loaded by then, no subdirectory
		# has run yet) so the policy is still generated and installed, just under
		# a target name CMake accepts.
		if ! grep -q 'KDE4_CMAKE4_AUTH_ACTIONS_FIX' "${S}/CMakeLists.txt"; then
			cat > "${TMPDIR}/kde4-auth-actions.cmake" <<-'EOF'
				# CMake 4 (CMP0037) rejects the custom target name that KDE4Macros' 
				# kde4_install_auth_actions() builds from a dotted KAuth helper id
				# ("actions for org.kde.foo").  powerdevil, kdm, systemsettings and
				# ksysguard's processcore all call it, so generate and install the policy
				# file the same way under a target name CMake accepts.
				if(COMMAND kde4_install_auth_actions)
				set(KDE4_CMAKE4_AUTH_ACTIONS_FIX TRUE)
				function(kde4_install_auth_actions _kde4_helper_id _kde4_actions_file)
				  if(KDE4_AUTH_BACKEND_NAME STREQUAL "APPLE" OR KDE4_AUTH_BACKEND_NAME STREQUAL "OSX")
				    install(CODE "execute_process(COMMAND ${KDE4_KAUTH_POLICY_GEN_EXECUTABLE} ${_kde4_actions_file} WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})")
				  elseif(KDE4_AUTH_BACKEND_NAME STREQUAL "POLKITQT" OR KDE4_AUTH_BACKEND_NAME STREQUAL "POLKITQT-1")
				    set(_kde4_policy ${CMAKE_CURRENT_BINARY_DIR}/${_kde4_helper_id}.policy)
				    get_filename_component(_kde4_input ${_kde4_actions_file} ABSOLUTE)
				    string(REPLACE "." "_" _kde4_target "kde4_auth_actions_${_kde4_helper_id}")
				    add_custom_command(OUTPUT ${_kde4_policy}
				                       COMMAND ${KDE4_KAUTH_POLICY_GEN_EXECUTABLE} ${_kde4_input} > ${_kde4_policy}
				                       MAIN_DEPENDENCY ${_kde4_input}
				                       WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
				                       COMMENT "Generating ${_kde4_helper_id}.policy"
				                       DEPENDS ${_KDE4_KAUTH_POLICY_GEN_EXECUTABLE_DEP})
				    add_custom_target(${_kde4_target} ALL DEPENDS ${_kde4_policy})
				    install(FILES ${_kde4_policy} DESTINATION ${KDE4_AUTH_POLICY_FILES_INSTALL_DIR})
				  endif()
				endfunction()
				endif()
				# CMake 3.27+ treats the AUTOMOC include directory as a system
				# directory; KDE4 was written against the older behaviour, so state a
				# value instead of leaving the policy unset.
				if(POLICY CMP0151)
				cmake_policy(SET CMP0151 NEW)
				endif()
				# Qt 4.8's headers predate most of the diagnostics current GCC grew,
				# and KDE4 turns on -Wall, so every translation unit drowns in
				# -Wdeprecated-copy / -Wdeprecated-enum-enum-conversion /
				# -Wtemplate-id-cdtor notes coming from /usr/include/qt4.  Options
				# added here land after CMAKE_CXX_FLAGS on the compile line, so they
				# win over KDE's -Wall.  Third-party gating is by compiler version
				# because -Wno-<unknown> is silently accepted by GCC and cannot be
				# probed with check_cxx_compiler_flag().
				if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
				  add_compile_options(-Wno-deprecated-copy)
				  if(NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 11)
				    add_compile_options(-Wno-deprecated-enum-enum-conversion -Wno-template-id-cdtor)
				  endif()
				endif()
				# CMake 3.28+ (CMP0153) warns about exec_program() in the installed
				# launcher-wrapper module, and a "cmake -P" script has no way to set
				# the policy for itself.  Those wrappers only chmod +x a helper
				# script, so run the same module body with execute_process().  When
				# the installed kdelibs already carries the fix this block is inert.
				if(POLICY CMP0153)
				set(_kde4_sh_src "${KDE4_MODULE_DIR}/kde4_exec_via_sh.cmake")
				if(EXISTS "${_kde4_sh_src}")
				  file(READ "${_kde4_sh_src}" _kde4_sh_text)
				  if(_kde4_sh_text MATCHES "exec_program")
				    set(_kde4_sh_dir "${CMAKE_BINARY_DIR}/CMakeFiles/kde4-cmake4-modules")
				    file(COPY "${KDE4_MODULE_DIR}/" DESTINATION "${_kde4_sh_dir}")
				    string(REPLACE "exec_program(chmod ARGS ug+x" "execute_process(COMMAND chmod ug+x" _kde4_sh_text "${_kde4_sh_text}")
				    string(REPLACE "OUTPUT_VARIABLE _dummy )" "OUTPUT_QUIET)" _kde4_sh_text "${_kde4_sh_text}")
				    string(REPLACE "\\\"\${_filename}\\\"" "\"\${_filename}\"" _kde4_sh_text "${_kde4_sh_text}")
				    file(WRITE "${_kde4_sh_dir}/kde4_exec_via_sh.cmake" "${_kde4_sh_text}")
				    if(_kde4_sh_text MATCHES "exec_program")
				      message(FATAL_ERROR "kde4: could not port ${_kde4_sh_src} off exec_program()")
				    endif()
				    set(KDE4_MODULE_DIR "${_kde4_sh_dir}")
				  endif()
				endif()
				endif()
			EOF
			# kwalletmanager and friends write "include( KDE4Defaults )", with spaces
			# inside the parentheses, so allow them here as well.
			if grep -q '^[[:space:]]*include[[:space:]]*([[:space:]]*KDE4Defaults' "${S}/CMakeLists.txt"; then
				sed -i -e "/^[[:space:]]*include[[:space:]]*([[:space:]]*KDE4Defaults/r ${TMPDIR}/kde4-auth-actions.cmake" \
					"${S}/CMakeLists.txt" || die "failed to redefine kde4_install_auth_actions"
			else
				cat "${TMPDIR}/kde4-auth-actions.cmake" >> "${S}/CMakeLists.txt" ||
					die "failed to append the kde4_install_auth_actions fix"
			fi
		fi
		# KDE4 add_test() names predate CMP0110; leave the old escaping alone
		# but allow the names under CMake 3.19+, otherwise the CTest file
		# generation step fails after developer warnings.  Anchor it after the
		# policy version so subdirectories inherit it.
		if ! grep -q 'CMP0110' "${S}/CMakeLists.txt"; then
			awk '!ins && /^[[:space:]]*cmake_minimum_required/ { print; print "if(POLICY CMP0110)"; print "  cmake_policy(SET CMP0110 NEW)"; print "endif()"; ins=1; next } { print }' "${S}/CMakeLists.txt" > "${S}/CMakeLists.txt.kde4tmp"
			mv "${S}/CMakeLists.txt.kde4tmp" "${S}/CMakeLists.txt" || die "failed to set CMP0110"
		fi
		if ! grep -q 'CMake 4 removed export_library_dependencies' "${S}/CMakeLists.txt"; then
			{ printf '%s
' '# Compatibility shim: CMake 4 removed export_library_dependencies().' 'if(NOT CMAKE_VERSION VERSION_LESS 4.0)' 'function(export_library_dependencies _kde4_file)' 'file(WRITE "${_kde4_file}" "")' 'endfunction()' 'endif()'; cat "${S}/CMakeLists.txt"; } > "${S}/CMakeLists.txt.kde4tmp"
			mv "${S}/CMakeLists.txt.kde4tmp" "${S}/CMakeLists.txt" || die "failed to add export_library_dependencies shim"
		fi
		# KDE4 sets the old-style LINK_INTERFACE_LIBRARIES property, which
		# makes install(EXPORT) fail under CMP0022 NEW.  Move it to the
		# modern property and clear the old one for every target.
		if ! grep -q 'KDE4_CMAKE4_INTERFACE_FIX' ""${S}/CMakeLists.txt""; then
			printf '
' >> ""${S}/CMakeLists.txt"" || die "failed to terminate "${S}/CMakeLists.txt""
			cat >> ""${S}/CMakeLists.txt"" <<-'EOF'
			# KDE4 sets the old-style LINK_INTERFACE_LIBRARIES property, which makes
			# install(EXPORT) fail under CMP0022 NEW.  Move it to the modern property
			# and unset the old one for every target, including subdirectories.
			if(NOT DEFINED KDE4_CMAKE4_INTERFACE_FIX)
			set(KDE4_CMAKE4_INTERFACE_FIX TRUE)
			if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.7)
			function(_kde4_fix_interface_props _dir)
			  get_property(_targets DIRECTORY "${_dir}" PROPERTY BUILDSYSTEM_TARGETS)
			  foreach(_t IN LISTS _targets)
			    get_target_property(_old "${_t}" LINK_INTERFACE_LIBRARIES)
			    if(NOT _old STREQUAL "_old-NOTFOUND")
			      if(_old)
			        set_property(TARGET "${_t}" PROPERTY INTERFACE_LINK_LIBRARIES "${_old}")
			      endif()
			      set_property(TARGET "${_t}" PROPERTY LINK_INTERFACE_LIBRARIES)
			    endif()
			  endforeach()
			  get_property(_subdirs DIRECTORY "${_dir}" PROPERTY SUBDIRECTORIES)
			  foreach(_d IN LISTS _subdirs)
			    _kde4_fix_interface_props("${_d}")
			  endforeach()
			endfunction()
			_kde4_fix_interface_props("${CMAKE_SOURCE_DIR}")
			endif()
			endif()
			EOF
		fi
	fi
	# Save library dependencies
	if [[ -n ${KMSAVELIBS} ]] ; then
		save_library_dependencies
	fi

	# Inject library dependencies
	if [[ -n ${KMLOADLIBS} ]] ; then
		load_library_dependencies
	fi

	# Hack for manuals relying on outdated DTD, only outside kde-base/...
	if [[ -z ${KDEBASE} ]]; then
		find "${S}" -name "*.docbook" \
			-exec sed -i -r \
				-e 's:-//KDE//DTD DocBook XML V4\.1(\..)?-Based Variant V1\.[01]//EN:-//KDE//DTD DocBook XML V4.2-Based Variant V1.1//EN:g' {} + \
			|| die 'failed to fix DocBook variant version'
	fi
}

# @FUNCTION: _kde4_qt4_qmake
# @INTERNAL
# @DESCRIPTION:
# Echo Qt4's qmake path.  FindQt4 runs qmake to locate Qt4's headers,
# libraries and moc, and a generic /usr/bin/qmake may belong to Qt5/Qt6.
_kde4_qt4_qmake() {
	local qmake=${EPREFIX}/usr/$(get_libdir)/qt4/bin/qmake
	[[ -x ${qmake} ]] || qmake=${EPREFIX}/usr/bin/qmake
	[[ -x ${qmake} ]] || return 0
	echo "${qmake}"
}

# @FUNCTION: kde4-base_src_configure
# @DESCRIPTION:
# Function for configuring the build of KDE4 applications.
kde4-base_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	# Build tests in src_test only, where we override this value.
	# CMake 4 removed compatibility with policy versions below 3.5.
	local cmakeargs=(
		-DKDE4_BUILD_TESTS=OFF
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5
	)

	local qt4_qmake=$(_kde4_qt4_qmake)
	[[ -n ${qt4_qmake} ]] && cmakeargs+=( -DQT_QMAKE_EXECUTABLE="${qt4_qmake}" )

	if in_iuse debug && use debug; then
		# Set "real" debug mode
		CMAKE_KDE_BUILD_TYPE="Debugfull"
	else
		# Handle common release builds
		append-cppflags -DQT_NO_DEBUG
	fi

	# Here we set the install prefix
	tc-is-cross-compiler || cmakeargs+=(-DCMAKE_INSTALL_PREFIX="${EPREFIX}${PREFIX}")

	# Use colors
	QTEST_COLORED=1

	# Shadow existing installations
	unset KDEDIRS

	#qmake -query QT_INSTALL_LIBS unavailable when cross-compiling
	tc-is-cross-compiler && cmakeargs+=(-DQT_LIBRARY_DIR=${ROOT}/usr/$(get_libdir)/qt4)
	#kde-config -path data unavailable when cross-compiling
	tc-is-cross-compiler && cmakeargs+=(-DKDE4_DATA_DIR=${ROOT}/usr/share/apps/)

	# sysconf needs to be /etc, not /usr/etc
	cmakeargs+=(-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc)

	if [[ $(declare -p mycmakeargs 2>&-) != "declare -a mycmakeargs="* ]]; then
		if [[ ${mycmakeargs} ]]; then
			eqawarn "mycmakeargs should always be declared as an array, not a string"
		fi
		mycmakeargs=(${mycmakeargs})
	fi

	mycmakeargs=("${cmakeargs[@]}" "${mycmakeargs[@]}")

	cmake_src_configure
}

# @FUNCTION: kde4-base_src_compile
# @DESCRIPTION:
# General function for compiling KDE4 applications.
kde4-base_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	cmake_src_compile "$@"
}

# @FUNCTION: kde4-base_src_test
# @DESCRIPTION:
# Function for testing KDE4 applications.
kde4-base_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	local kded4_pid

	_test_runner() {
		if [[ -n "${VIRTUALDBUS_TEST}" ]]; then
			export $(dbus-launch)
			kded4 2>&1 > /dev/null &
			kded4_pid=$!
		fi

		cmake_src_test
	}

	# When run as normal user during ebuild development with the ebuild command, the
	# kde tests tend to access the session DBUS. This however is not possible in a real
	# emerge or on the tinderbox.
	# > make sure it does not happen, so bad tests can be recognized and disabled
	unset DBUS_SESSION_BUS_ADDRESS DBUS_SESSION_BUS_PID

	# Override this value, set in kde4-base_src_configure()
	mycmakeargs+=(-DKDE4_BUILD_TESTS=ON -DCMAKE_POLICY_VERSION_MINIMUM=3.5)
	local qt4_qmake=$(_kde4_qt4_qmake)
	[[ -n ${qt4_qmake} ]] && mycmakeargs+=(-DQT_QMAKE_EXECUTABLE="${qt4_qmake}")
	cmake_src_configure
	kde4-base_src_compile

	if [[ ${VIRTUALX_REQUIRED} == always || ${VIRTUALX_REQUIRED} == test ]]; then
		# check for sanity if anyone already redefined VIRTUALX_COMMAND from the default
		if [[ ${VIRTUALX_COMMAND} != emake ]]; then
			# surprise- we are already INSIDE virtualmake!!!
			debug-print "QA Notice: This version of kde4-base.eclass includes the virtualx functionality."
			debug-print "           You may NOT set VIRTUALX_COMMAND or call virtualmake from the ebuild."
			debug-print "           Setting VIRTUALX_REQUIRED is completely sufficient. See the"
			debug-print "           kde4-base.eclass docs for details... Applying workaround."
			_test_runner
		else
			virtx _test_runner
		fi
	else
		_test_runner
	fi

	if [ -n "${kded4_pid}" ] ; then
		kill ${kded4_pid}
	fi

	if [ -n "${DBUS_SESSION_BUS_PID}" ] ; then
		kill ${DBUS_SESSION_BUS_PID}
	fi
}

# @FUNCTION: kde4_suffix_binaries
# @USAGE: <binary>...
# @DESCRIPTION:
# Rename $ED/usr/bin/<binary> to <binary>4 and point the Exec=/TryExec=
# entries of the installed .desktop files at the renamed binary.
#
# A KDE4 application and its KF6/Plasma 6 successor normally install the same
# program name into $PATH.  Merging the KDE4 package over the modern one
# leaves the file untracked by that package, which replaces it again on its
# next update, so the KDE4 copy lives on under a suffixed name and keeps its
# own menu entry.  Binaries the package did not install are skipped, which
# keeps the call safe where only part of a module was extracted.
kde4_suffix_binaries() {
	debug-print-function ${FUNCNAME} "$@"

	local bin desktop apps="${ED%/}/usr/share/applications"

	for bin in "$@"; do
		[[ -e ${ED%/}/usr/bin/${bin} ]] || continue
		mv "${ED%/}/usr/bin/${bin}" "${ED%/}/usr/bin/${bin}4" ||
			die "failed to suffix ${bin}"
		for desktop in "${apps}"/*.desktop "${apps}"/kde4/*.desktop; do
			[[ -f ${desktop} ]] || continue
			grep -qE "^(Exec|TryExec)=${bin}([[:space:]]|\$)" "${desktop}" || continue
			sed -i -E "s@^(Exec|TryExec)=${bin}([[:space:]]|\$)@\1=${bin}4\2@" \
				"${desktop}" || die "failed to repoint ${desktop##*/} at ${bin}4"
		done
	done
}

# @FUNCTION: kde4-base_src_install
# @DESCRIPTION:
# Function for installing KDE4 applications.
kde4-base_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -n ${KMSAVELIBS} ]] ; then
		install_library_dependencies
	fi

	# Install common documentation of KDE4 applications
	local doc
	if ! has kde4-meta ${INHERITED}; then
		for doc in "${S}"/{AUTHORS,CHANGELOG,ChangeLog*,README*,NEWS,TODO,HACKING}; do
			[[ -f ${doc} && -s ${doc} ]] && dodoc "${doc}"
		done
		for doc in "${S}"/*/{AUTHORS,CHANGELOG,ChangeLog*,README*,NEWS,TODO,HACKING}; do
			[[ -f ${doc} && -s ${doc} ]] && newdoc "${doc}" "$(basename $(dirname ${doc})).$(basename ${doc})"
		done
	fi

	cmake_src_install

	# We don't want ${PREFIX}/share/doc/HTML to be compressed,
	# because then khelpcenter can't find the docs
	[[ -d ${ED}/${PREFIX}/share/doc/HTML ]] &&
		docompress -x ${PREFIX}/share/doc/HTML
}

# @FUNCTION: kde4-base_pkg_preinst
# @DESCRIPTION:
# Function storing icon caches
kde4-base_pkg_preinst() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${KDE_BUILD_TYPE} == live && ${KDE_SCM} == svn ]]; then
		subversion_pkg_preinst
	fi
}

# @FUNCTION: kde4-base_pkg_postinst
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been installed.
kde4-base_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	buildsycoca

	if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
		if [[ ${KDE_BUILD_TYPE} = live ]]; then
			echo
			einfo "WARNING! This is an experimental live ebuild of ${CATEGORY}/${PN}"
			einfo "Use it at your own risk."
			einfo "Do _NOT_ file bugs at bugs.gentoo.org because of this ebuild!"
			echo
		fi
	fi
}

# @FUNCTION: kde4-base_pkg_postrm
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been removed.
kde4-base_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"

	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	buildsycoca
}

fi
