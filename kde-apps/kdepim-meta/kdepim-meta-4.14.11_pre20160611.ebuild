# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="kdepim - merge this to pull in all kdepim-derived packages"
HOMEPAGE+=" https://community.kde.org/KDE_PIM"

LICENSE="metapackage"
KEYWORDS="amd64 x86"
IUSE="nls"
SLOT="4"

RDEPEND="
 >=kde-apps/akonadiconsole-4.14.11_pre20160611:4
 >=kde-apps/akregator-4.14.11_pre20160611:4
 >=kde-apps/blogilo-4.14.11_pre20160611:4
 >=kde-apps/calendarjanitor-4.14.11_pre20160611:4
 >=kde-apps/kabcclient-4.14.11_pre20160611:4
 >=kde-apps/kaddressbook-4.14.11_pre20160611:4
 >=kde-apps/kalarm-4.14.11_pre20160611:4
 >=kde-apps/kdepim-kresources-4.14.11_pre20160611:4
 >=kde-apps/kdepim-runtime-4.14.11_pre20160211:4
 >=app-text/kjots-4.14.11_pre20160611:4
 >=kde-apps/kleopatra-4.14.11_pre20160611:4
 >=kde-apps/kmail-4.14.11_pre20160611:4
 >=kde-apps/knode-4.14.11_pre20160611:4
 >=kde-apps/knotes-4.14.11_pre20160611:4
 >=kde-apps/konsolekalendar-4.14.11_pre20160611:4
 >=kde-apps/kontact-4.14.11_pre20160611:4
 >=kde-apps/korganizer-4.14.11_pre20160611:4
 >=kde-apps/ktimetracker-4.14.11_pre20160611:4
 >=kde-apps/ktnef-4.14.11_pre20160611:4
 kde-frameworks/oxygen-icons:5
 nls? (
 >=kde-apps/kde4-l10n-4.11.2:4
 >=kde-apps/kdepim-l10n-4.14.3-r1:4
 )
"
