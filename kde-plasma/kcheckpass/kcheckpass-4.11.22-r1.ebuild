# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="A simple password checker, used by any software in need of user authentication"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug pam"

DEPEND="
	pam? ( sys-libs/pam )
"
RDEPEND="${DEPEND}
	pam? ( || (
		kde-plasma/kdebase-pam
		kde-plasma/kscreenlocker:5
	) )
"

src_prepare() {
	kde4-meta_src_prepare

	# Drop the "chown root && chmod +s" install hook when PAM is used; the hook
	# is only needed for the non-PAM fallback.  Do the edit here instead of with
	# a patch, whose context (the line after the block) differs between the
	# 4.4.2 and 4.11.22 tree layouts.
	if use pam ; then
		local f="${S}/CMakeLists.txt"

		[[ -f ${f} ]] || die "missing ${f}"

		if grep -q 'chmod +s' "${f}" ; then
			awk '/^install\(CODE "/ { skip = 1 }
				skip && /^"\)$/ { skip = 0; next }
				!skip { print }' "${f}" > "${f}.kde4tmp" ||
				die "failed to rewrite ${f}"
			mv "${f}.kde4tmp" "${f}" || die

			if grep -q 'chmod +s' "${f}" ; then
				die "failed to remove the SUID install hook from ${f}"
			fi
			if ! grep -q 'install(TARGETS kcheckpass' "${f}" ; then
				die "the SUID removal in ${f} ate the target install rule"
			fi
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_pam="$(usex pam)"
	)

	kde4-meta_src_configure
}


