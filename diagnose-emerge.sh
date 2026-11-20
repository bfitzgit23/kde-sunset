#!/usr/bin/env bash
# diagnose-emerge.sh - build one package under a timeout and record what really
# happened, so "the build stopped and the log tail is empty" stops being a
# mystery.
#
#     ./diagnose-emerge.sh kde-apps/kwalletmanager [timeout-seconds]
#
# Writes /tmp/emerge-<pkg>-<stamp>.log (emerge's whole stdout+stderr) and
# /tmp/emerge-<pkg>-<stamp>.ps (a process snapshot every 20s, which is what
# identifies a hang), then prints the exit status, line/byte counts, every
# error-looking line, the tail, and the last snapshot.
#
# Exit status: emerge's own, or 124 when the timeout fired.
set -uo pipefail

target=${1:-}
limit=${2:-${TIMEOUT:-1200}}
if [[ -z ${target} ]]; then
	echo "usage: ${0##*/} <category/package> [timeout-seconds]" >&2
	exit 2
fi

# Sample at most 20 times over the run, but never more often than every 2s.
step=$(( limit / 20 ))
(( step < 2 )) && step=2
(( step > 20 )) && step=20

log=/tmp/emerge-$(printf '%s' "${target}" | tr '/' '-')-$(date +%Y%m%d-%H%M%S).log
snap=${log%.log}.ps
# What to look for while it runs: compilers, the build driver, the terminal
# wrapper of the package under test.
ps_re='cc1plus|[n]inja|[c]make|[m]ake |[e]merge|[q]make|cc1 |[l]d '

hdr() { printf '\n\033[1m== %s ==\033[0m\n' "$*"; }

hdr "timeout ${limit}s emerge -1 ${target}"
echo "  emerge output: ${log}"
echo "  liveness:      ${snap}"

timeout --signal=TERM "${limit}" emerge -1 "${target}" >"${log}" 2>&1 &
runner=$!
: >"${snap}"
while kill -0 "${runner}" 2>/dev/null; do
	sleep "${step}"
	kill -0 "${runner}" 2>/dev/null || break
	{
		printf -- '--- %s ---\n' "$(date +%H:%M:%S)"
		ps -eo pid,ppid,etime,pcpu,rss,args | awk -v re="${ps_re}" 'NR==1 || $0 ~ re'
	} >>"${snap}"
done
wait "${runner}"
rc=$?

lines=$(wc -l <"${log}")
bytes=$(wc -c <"${log}")
warnings=$(grep -c 'warning:' "${log}" 2>/dev/null)
warnings=${warnings:-0}

hdr "result"
printf '  EXIT=%s  LINES=%s  BYTES=%s  WARNINGS=%s\n' \
	"${rc}" "${lines}" "${bytes}" "${warnings}"
case ${rc} in
	0) echo "  -> emerge returned 0: it finished; verify with 'qlist -e ${target}'" ;;
	124) echo "  -> the timeout fired while the build was still running: this is a hang, not a failure" ;;
	*) echo "  -> emerge failed: the lines below say where" ;;
esac

hdr "error-looking lines"
grep -nE 'error:|internal compiler error|FAILED:| died|Killed|No space left|Traceback|>>> (Failed|Source)' "${log}" |
	tail -20 || echo '  (none)'

hdr "tail of emerge output"
tail -20 "${log}" || true

hdr "processes seen while it ran (last snapshot)"
if [[ -s ${snap} ]]; then
	tail -25 "${snap}"
else
	echo '  (none captured)'
fi

hdr "portage's own build.log (survives a failed build only)"
found=0
for f in /var/tmp/portage/${target}-*/temp/build.log; do
	[[ -f ${f} ]] || continue
	found=1
	echo "  ${f}"
	tail -15 "${f}" | sed 's/^/    /'
done
if (( found == 0 )); then
	echo '  (no build.log - portage cleans the work dir between emerges)'
fi

exit "${rc}"
