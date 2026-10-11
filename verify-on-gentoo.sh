#!/usr/bin/env bash
# verify-on-gentoo.sh - prove the repaired kde-sunset overlay is clean on a
# current Gentoo box.
#
# Run it from inside the overlay checkout, as the user that owns it
# (root is fine too):
#
#     cd /var/db/repos/kde-sunset && ./verify-on-gentoo.sh
#
# What it does
#   1. shows the toolchain versions
#   2. `egencache --update`  -> generates metadata/md5-cache for EVERY ebuild.
#      This is exactly the metadata phase eix and portage run, so any ebuild
#      whose eclass/EAPI/metadata is broken is reported here, by name.
#   3. `eix-update`          -> now reads the generated cache instead of
#      sourcing every ebuild, so it should be silent and fast.
#   4. `ebuild <file> depend`-> targeted smoke test on the packages that used
#      to fail.
#   5. `pkgcheck scan`       -> optional QA scan, if installed.
#
# Exit status: 0 when no metadata failures were seen.

set -uo pipefail

REPO_NAME="${REPO_NAME:-kde-sunset}"
REPO_PATH="${1:-$(pwd)}"
JOBS="${JOBS:-$(nproc 2>/dev/null || echo 4)}"
fail=0

hdr() { printf '\n\033[1m== %s ==\033[0m\n' "$*"; }
ok()  { printf '  \033[32mOK\033[0m   %s\n' "$*"; }
bad() { printf '  \033[31mFAIL\033[0m %s\n' "$*"; fail=1; }

hdr "environment"
for t in emerge portageq egencache eix eix-update ebuild pkgcheck pkgdev; do
    if command -v "$t" >/dev/null 2>&1; then
        printf '  %-11s %s\n' "$t" "$(command -v "$t")"
    else
        printf '  %-11s %s\n' "$t" "(not installed)"
    fi
done
echo "  portage     $(portageq envvar PORTAGE_BIN_PATH >/dev/null 2>&1 && echo present || echo absent)"
echo "  repo path   ${REPO_PATH}"
echo "  jobs        ${JOBS}"

hdr "0. overlay layout sanity"
[ -f "${REPO_PATH}/metadata/layout.conf" ] || bad "no metadata/layout.conf"
grep -q '^masters' "${REPO_PATH}/metadata/layout.conf" \
    && ok "masters declared: $(grep '^masters' "${REPO_PATH}/metadata/layout.conf")" \
    || bad "layout.conf has no masters entry"
grep -q '^cache-formats' "${REPO_PATH}/metadata/layout.conf" \
    && ok "cache-formats declared" || echo "  note: no cache-formats in layout.conf"

# Directories at the repo root that are not categories and not special dirs.
special='metadata profiles eclass licenses files Documentation patchsets'
for d in "${REPO_PATH}"/*/; do
    b="$(basename "$d")"
    case " ${special} " in *" ${b} "*) continue ;; esac
    grep -qx "${b}" "${REPO_PATH}/profiles/categories" 2>/dev/null \
        || echo "  note: '${b}' is not in profiles/categories (pkgcheck flags this)"
done

hdr "1. egencache --update  (metadata phase for every ebuild)"
echo "  this can take several minutes on a laptop ..."
egencache --repo "${REPO_NAME}" --update --jobs "${JOBS}" \
    >/tmp/kde-sunset-egencache.log 2>&1
eg_rc=$?
cache_dir="${REPO_PATH}/metadata/md5-cache"
n_cache=$(find "${cache_dir}" -name '*-*' -type f 2>/dev/null | wc -l)
n_ebuild=$(find "${REPO_PATH}" -name '*.ebuild' -not -path '*/.git/*' -not -path '*/metadata/*' | wc -l)
echo "  egencache exit=${eg_rc}  cache entries=${n_cache}  ebuilds=${n_ebuild}"
if [ "${eg_rc}" -eq 0 ] && [ "${n_cache}" -ge "${n_ebuild}" ]; then
    ok "every ebuild produced metadata"
else
    bad "metadata generation reported problems (see /tmp/kde-sunset-egencache.log)"
fi
# any ebuild that failed shows up as an ERROR block in the log
if grep -qE '^ \* ERROR|^!!! |Traceback' /tmp/kde-sunset-egencache.log; then
    bad "egencache log contains error blocks:"
    grep -nE '^ \* ERROR|^!!! ' /tmp/kde-sunset-egencache.log | head -20 | sed 's/^/      /'
else
    ok "egencache log contains no error blocks"
fi

hdr "2. eix-update"
if command -v eix-update >/dev/null 2>&1; then
    eix-update >/tmp/kde-sunset-eix.log 2>&1
    eix_rc=$?
    echo "  eix-update exit=${eix_rc}"
    if grep -qiE 'error|invalid|failed' /tmp/kde-sunset-eix.log; then
        bad "eix-update still reports errors:"
        grep -inE 'error|invalid|failed' /tmp/kde-sunset-eix.log | head -20 | sed 's/^/      /'
    else
        ok "eix-update is clean (full log: /tmp/kde-sunset-eix.log)"
    fi
else
    echo "  eix-update not installed, skipping (emerge app-portage/eix)"
fi

hdr "3. targeted 'ebuild <file> depend' smoke test"
smoke=(
    "dev-qt/qtcore/qtcore-4.8.7-r5.ebuild"
    "kde-frameworks/kdelibs/kdelibs-4.14.38-r1.ebuild"
    "kde-plasma/kdm/kdm-4.11.22.ebuild"
    "kde-base/krossjava/krossjava-4.14.3.ebuild"
    "media-libs/opencv/opencv-2.4.13-r4.ebuild"
    "app-office/kmymoney/kmymoney-4.8.1.1-r1.ebuild"
    "dev-libs/libindicate-qt/libindicate-qt-0.2.5.91.ebuild"
    "kde-misc/plasmatvgr/plasmatvgr-0.47.ebuild"
    "kde-misc/stdin-plasmoid/stdin-plasmoid-0.2_beta1.ebuild"
    "app-backup/qt4-fsarchiver/qt4-fsarchiver-0.6.19.7.ebuild"
    "dev-qt/qt1/qt1-9999.ebuild"
    "sys-power/kpowersave/kpowersave-0.7.3-r2.ebuild"
)
for rel in "${smoke[@]}"; do
    f="${REPO_PATH}/${rel}"
    if [ ! -f "${f}" ]; then echo "  skip  ${rel} (missing)"; continue; fi
    if ! EBUILD_OUT="$(ebuild "${f}" depend 2>&1)"; then
        bad "${rel}"; echo "${EBUILD_OUT}" | tail -5 | sed 's/^/      /'
    elif echo "${EBUILD_OUT}" | grep -qiE 'ERROR|not found|not supported'; then
        bad "${rel}"; echo "${EBUILD_OUT}" | grep -iE 'ERROR|not found|not supported' | head -3 | sed 's/^/      /'
    else
        ok "${rel}"
    fi
done

hdr "4. pkgcheck scan (optional)"
if command -v pkgcheck >/dev/null 2>&1; then
    pkgcheck scan --repo "${REPO_NAME}" --exit error >/tmp/kde-sunset-pkgcheck.log 2>&1
    pc_rc=$?
    echo "  pkgcheck exit=${pc_rc} (0 = no errors; warnings are fine)"
    tail -30 /tmp/kde-sunset-pkgcheck.log | sed 's/^/      /'
else
    echo "  pkgcheck not installed, skipping (emerge dev-util/pkgcheck)"
fi

hdr "summary"
if [ "${fail}" -eq 0 ]; then
    printf '  \033[32moverlay metadata is clean\033[0m - now try:\n'
    echo "      emerge --pretend --verbose kde-apps/kde-meta:4"
else
    printf '  \033[31mthere are still failures above\033[0m\n'
fi
exit "${fail}"
