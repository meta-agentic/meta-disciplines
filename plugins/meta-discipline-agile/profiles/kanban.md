---
type: profile
profile: kanban
tags: [pack/agile, profile]
---
# Profile: kanban (lightweight)

Continuous pull-based flow — no sprints, no ceremonies, minimal ceremony-as-code. For
solo work, research instances, or estates that don't want Scrum overhead. Uses the same
`agile-process` skill *procedures* it needs (story transitions, backlog hygiene) and
ignores the sprint/ceremony ones.

## Parameters (from `packs.agile.config`)

| Key | Meaning | Default |
|-----|---------|---------|
| `tracker` | `local` (a `backlog.json`) or `none` (issues live only in the tool's head / an external board) | `none` |
| `space` | optional label for the flow | — |

`mirror-repo` is unused (no external tracker to mirror).

## Conventions this profile asserts

- **Authority order:** `backlog.json` (if `tracker: local`) → the skills → CLAUDE.md
  invariants. With `tracker: none` there is no backlog file; work is tracked ad hoc.
- **Flow:** a single continuous board — backlog → in-progress → done, WIP-limited, pulled
  not planned. No sprints, no velocity, no burndown.
- **Discipline gates kept:** one-branch-per-item, clean-verify before PR, review before
  merge. **Dropped:** sprint planning/close, standup/retro cadence, PO sprint gates.
- **Cadence:** none scheduled; groom the board when it needs it.

This profile deliberately does the *least* — add ceremony back by switching to `scrum`.
