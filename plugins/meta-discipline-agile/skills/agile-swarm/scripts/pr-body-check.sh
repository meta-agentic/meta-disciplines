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
# Always: the body must name <branch> exactly, as a whole word and outside fenced code
# blocks. A body that does not is presumed to be another lane's file.
# Unless --private-repo: no tracker key (matched case-insensitively) and no private link,
# path or credential. The defaults are a generic floor; an instance adds its own:
#   PR_BODY_KEY_RE      ERE for a tracker key       (default: [A-Z][A-Z0-9]{1,9}-[0-9]+)
#   PR_BODY_ALLOW_RE    extra ERE for look-alikes that are not keys, added to the default
#                       (the default covers UTF-8, ISO/RFC/SHA numbers, x86-64, CVE ids)
#   PR_BODY_PRIVATE_RE  extra ERE for private links, e.g. the instance's private hosts,
#                       organisations or repositories, added to the default
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
ALLOW_RE='UTF-(8|16|32)|ISO-[0-9]+|RFC-[0-9]+|SHA-[0-9]+|X86-64|CVE-[0-9]{4}-[0-9]+'
[ -n "${PR_BODY_ALLOW_RE:-}" ] && ALLOW_RE="$ALLOW_RE|$PR_BODY_ALLOW_RE"
PRIVATE_RE='(/Users|/home)/[A-Za-z0-9._-]+|(^|[^A-Za-z0-9])~/[A-Za-z0-9._-]|(^|[^A-Za-z0-9])[A-Za-z]:\\[A-Za-z0-9._-]'
PRIVATE_RE="$PRIVATE_RE"'|file://|localhost|127\.0\.0\.1'
PRIVATE_RE="$PRIVATE_RE"'|(^|[^0-9.])(10\.[0-9]+\.[0-9]+\.[0-9]+|192\.168\.[0-9]+\.[0-9]+|172\.(1[6-9]|2[0-9]|3[01])\.[0-9]+\.[0-9]+)'
PRIVATE_RE="$PRIVATE_RE"'|[A-Za-z0-9-]+\.(internal|local|lan|corp)([^A-Za-z0-9.-]|$)'
PRIVATE_RE="$PRIVATE_RE"'|(^|[^A-Za-z0-9])((ghp|gho|ghs|ghu|ghr|github_pat)_[A-Za-z0-9_]{10,}|glpat-[A-Za-z0-9_-]{10,}|xox[abprs]-[A-Za-z0-9-]{10,}|AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9_-]{20,})'
[ -n "${PR_BODY_PRIVATE_RE:-}" ] && PRIVATE_RE="$PRIVATE_RE|$PR_BODY_PRIVATE_RE"

FAIL=0
refuse() { echo "REFUSED: $1" >&2; FAIL=1; }

# The branch as a whole word: the characters around it may not continue a branch name
# (a trailing full stop may, if nothing branch-like follows it). Fenced blocks are skipped.
names_branch() {
  awk -v b="$BRANCH" '
    /^[[:space:]]*(```|~~~)/ { fence = !fence; next }
    fence { next }
    {
      s = $0
      while ((i = index(s, b)) > 0) {
        pre = (i > 1) ? substr(s, i - 1, 1) : ""
        post = substr(s, i + length(b), 1)
        if (post == ".") post = substr(s, i + length(b) + 1, 1)
        if (pre !~ /[A-Za-z0-9._\/-]/ && post !~ /[A-Za-z0-9_\/-]/) { found = 1; exit }
        s = substr(s, i + 1)
      }
    }
    END { exit !found }' "$BODY"
}

names_branch || refuse "the body does not name its branch '$BRANCH' as a word outside code fences -- is this another lane's file?"

if [ "$PRIVATE_REPO" = no ]; then
  # Allowed look-alikes and keys in one alternation: at each position the longest match
  # wins, so a CVE id is taken whole rather than as its key-shaped prefix.
  while IFS= read -r tok; do
    printf '%s\n' "$tok" | grep -qiE "^($ALLOW_RE)\$" && continue
    refuse "tracker key '$tok' in a public PR body"
  done < <(grep -oiE "(^|[^A-Za-z0-9])(($ALLOW_RE)|($KEY_RE))" "$BODY" | sed -E 's/^[^A-Za-z0-9]//' | sort -u)
  while IFS= read -r hit; do
    refuse "private link, path or credential at line ${hit%%:*}"
  done < <(grep -nE "$PRIVATE_RE" "$BODY")
fi

[ "$FAIL" = 0 ] && echo "pr-body-check: OK ($BODY for $BRANCH)"
exit "$FAIL"
