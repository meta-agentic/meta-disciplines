#!/usr/bin/env bash
#
# Tests for pr-body-check.sh. No network, no gh: bodies are scratch files.
# Keys and paths are assembled at run time so this file stays estate-neutral itself.
#
#   ./skills/agile-swarm/scripts/test-pr-body-check.sh

set -uo pipefail   # not -e: a failing case is reported, not fatal

CHECK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/pr-body-check.sh"
D=$(mktemp -d) && trap 'rm -rf "$D"' EXIT
PASS=0 FAIL=0
KEY=$(printf '%s-%s' ABC 123)
HOME_PATH=$(printf '/%s/someone/repo' Users)

# case <name> <expected-rc> <body> [args...]
case_() {
  local name=$1 want=$2 body=$3; shift 3
  local f; f=$(mktemp "$D/pr-body-XXXXXX")
  printf '%s\n' "$body" >"$f"
  "$CHECK" "$@" "$f" docs/lane-branch >/dev/null 2>&1; local rc=$?
  if [ "$rc" = "$want" ]; then echo "  PASS  $name"; PASS=$((PASS + 1))
  else echo "  FAIL  $name (exit $rc, wanted $want)"; FAIL=$((FAIL + 1)); fi
}

case_ "clean body naming its branch"        0 "Branch: docs/lane-branch. Head: abc1234."
case_ "body without its branch"             1 "Branch: docs/other-lane."
case_ "tracker key"                         1 "Branch: docs/lane-branch. Fixes $KEY."
case_ "tracker key allowed on private repo" 0 "Branch: docs/lane-branch. Fixes $KEY." --private-repo
case_ "branch still checked on private"     1 "Fixes $KEY." --private-repo
case_ "allow-listed standard token"         0 "Branch: docs/lane-branch. UTF-8, ISO-8601."
case_ "home path"                           1 "Branch: docs/lane-branch. See $HOME_PATH."
case_ "localhost link"                      1 "Branch: docs/lane-branch. http://localhost:8080/x"
PR_BODY_PRIVATE_RE='git\.internal\.example' \
case_ "instance private host"               1 "Branch: docs/lane-branch. https://git.internal.example/a"
PR_BODY_ALLOW="$KEY" \
case_ "instance allow-list"                 0 "Branch: docs/lane-branch. $KEY."
"$CHECK" >/dev/null 2>&1
if [ $? = 2 ]; then echo "  PASS  usage exits 2"; PASS=$((PASS + 1)); else echo "  FAIL  usage exits 2"; FAIL=$((FAIL + 1)); fi

echo "passed $PASS, failed $FAIL"
[ "$FAIL" = 0 ]
