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
LOWER_KEY=$(printf '%s-%s' abc 123)
CVE=$(printf '%s-%s-%s' CVE 2026 1234)
HOME_PATH=$(printf '/%s/someone/repo' Users)
WIN_PATH=$(printf '%s:\\%s\\repo' C dev)
TOKEN=$(printf '%s_%s' ghp aBcDeFgHiJkLmNoP1234)
# shellcheck disable=SC2016  # literal Markdown backticks
FENCED=$(printf 'Notes.\n```\ngit push origin docs/lane-branch\n```\n')

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
case_ "a longer branch is not this branch"  1 "Branch: docs/lane-branch-two."
case_ "a dotted suffix is not this branch"  1 "Branch: docs/lane-branch.v2"
case_ "branch only inside a code fence"     1 "$FENCED"
# shellcheck disable=SC2016  # literal Markdown backticks
case_ "branch in inline code counts"      0 'Branch: `docs/lane-branch`'
case_ "lower-case tracker key"              1 "Branch: docs/lane-branch. Fixes $LOWER_KEY."
case_ "CVE id is not a key"                 0 "Branch: docs/lane-branch. Patches $CVE."
case_ "file:// link"                        1 "Branch: docs/lane-branch. file:///tmp/x"
case_ "loopback address"                    1 "Branch: docs/lane-branch. http://127.0.0.1:9000"
case_ "private address 10/8"                1 "Branch: docs/lane-branch. 10.1.2.3"
case_ "private address 192.168/16"          1 "Branch: docs/lane-branch. 192.168.1.10"
case_ "private address 172.16/12"           1 "Branch: docs/lane-branch. 172.20.0.5"
case_ "public 172 address"                  0 "Branch: docs/lane-branch. 172.40.0.5"
case_ ".internal host"                      1 "Branch: docs/lane-branch. https://build.internal/x"
case_ "tilde path"                          1 "Branch: docs/lane-branch. See ~/notes/x."
case_ "Windows path"                        1 "Branch: docs/lane-branch. See $WIN_PATH."
case_ "token prefix"                        1 "Branch: docs/lane-branch. $TOKEN"
case_ "prose is not a token"                0 "Branch: docs/lane-branch. A risk-assessment-for-the-whole-lane-run."
case_ "public link"                         0 "Branch: docs/lane-branch. https://github.com/example/repo/pull/1"
PR_BODY_PRIVATE_RE='git\.example-corp\.test' \
case_ "instance private host"               1 "Branch: docs/lane-branch. https://git.example-corp.test/a"
PR_BODY_ALLOW_RE="$KEY" \
case_ "instance allow-list"                 0 "Branch: docs/lane-branch. $KEY."
"$CHECK" >/dev/null 2>&1
if [ $? = 2 ]; then echo "  PASS  usage exits 2"; PASS=$((PASS + 1)); else echo "  FAIL  usage exits 2"; FAIL=$((FAIL + 1)); fi

echo "passed $PASS, failed $FAIL"
[ "$FAIL" = 0 ]
