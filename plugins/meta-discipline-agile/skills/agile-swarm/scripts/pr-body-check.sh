#!/usr/bin/env bash
#
# pr-body-check.sh — run before every `gh pr create` / `gh pr edit --body-file`.
#
# Refuses a PR body that is not this lane's, or that would leak private text into a
# public repository. Exists because a fixed, shared body file was once overwritten by a
# parallel lane and posted, private content and all, on a public PR.
#
#   pr-body-check.sh [--private-repo] <body-file> <branch>
#
# Always: the body must name <branch> (the lane's own branch). A body that does not is
# presumed to be another lane's file.
# Unless --private-repo: no tracker key and no private link. The patterns are
# configurable, so an instance declares its own without editing this script:
#   PR_BODY_KEY_RE      ERE for a tracker key       (default: [A-Z][A-Z0-9]{1,9}-[0-9]+)
#   PR_BODY_ALLOW       space-separated tokens the key pattern may match but are not keys
#   PR_BODY_PRIVATE_RE  extra ERE for private links, e.g. a private host or org URL
#
# Exit 0 = postable, 1 = refused (each reason printed), 2 = usage.
# bash 3.2-compatible.

set -uo pipefail

PRIVATE_REPO=no
if [ "${1:-}" = "--private-repo" ]; then PRIVATE_REPO=yes; shift; fi
BODY=${1:-}
BRANCH=${2:-}
if [ -z "$BODY" ] || [ -z "$BRANCH" ]; then
  echo "usage: $0 [--private-repo] <body-file> <branch>" >&2; exit 2
fi
[ -f "$BODY" ] || { echo "pr-body-check: no such file: $BODY" >&2; exit 2; }

KEY_RE=${PR_BODY_KEY_RE:-'[A-Z][A-Z0-9]{1,9}-[0-9]+'}
ALLOW=${PR_BODY_ALLOW:-'UTF-8 UTF-16 ISO-8601 RFC-3339 SHA-1 SHA-256 SHA-512'}
PRIVATE_RE='(/Users|/home)/[A-Za-z0-9._-]+|file://|localhost|127\.0\.0\.1'
[ -n "${PR_BODY_PRIVATE_RE:-}" ] && PRIVATE_RE="$PRIVATE_RE|$PR_BODY_PRIVATE_RE"

FAIL=0
refuse() { echo "REFUSED: $1" >&2; FAIL=1; }

grep -qF -- "$BRANCH" "$BODY" \
  || refuse "the body does not name its branch '$BRANCH' -- is this another lane's file?"

if [ "$PRIVATE_REPO" = no ]; then
  while IFS= read -r key; do
    case " $ALLOW " in *" $key "*) continue ;; esac
    refuse "tracker key '$key' in a public PR body"
  done < <(grep -oE "(^|[^A-Za-z0-9])($KEY_RE)" "$BODY" | sed -E 's/^[^A-Za-z0-9]//' | sort -u)
  while IFS= read -r hit; do
    refuse "private link or path at line ${hit%%:*}"
  done < <(grep -nE "$PRIVATE_RE" "$BODY")
fi

[ "$FAIL" = 0 ] && echo "pr-body-check: OK ($BODY for $BRANCH)"
exit "$FAIL"
