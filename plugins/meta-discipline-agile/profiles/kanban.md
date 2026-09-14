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
| `tracker` | `local` (no external tracker — the mirror is the top authority, shaped by `backlog-layout`) or `none` (items live only in the tool's head / an external board) | `none` |
| `backlog-layout` | `monolith` (one tracker-derived file) or `per-item` (one file per work item) — `tracker: local` only | `monolith` |
| `space` | optional label for the flow | — |
| `spaces` | the space keys this instance carries, when more than one is in play | — |
| `mirror-repo` | `<owner>/<repo>` holding the mirror | required when `tracker: local` |

`tracker: jira` belongs to the `scrum` profile — this one mirrors nothing external.
Under `tracker: none` there is no mirror at all, so `mirror-repo` is unused.

## Conventions this profile asserts

- **Authority order — resolved per space, not globally:** `tracker` → the `mirror-repo`
  mirror → the pack's skills → CLAUDE.md invariants. On any state conflict the tracker
  wins. Under `tracker: local` there is no external tracker, so the mirror is itself the
  top authority; under `backlog-layout: per-item` the mirror repo is the **sole
  authority** for every space it carries and `<tooling>` is its only writer. Every key in
  `spaces` resolves this order independently — one space may be tracker-backed while
  another is mirror-native.
  With `tracker: none` there is no backlog of record at all and no mirror to be the
  authority; work is tracked ad hoc and the transition procedures do not apply.
- **Flow:** a single continuous board — backlog → in-progress → done, WIP-limited, pulled
  not planned. No sprints, no velocity, no burndown.
- **Discipline gates kept:** one-branch-per-item, clean-verify before PR, review before
  merge. **Dropped:** sprint planning/close, standup/retro cadence, PO sprint gates.
- **Cadence:** none scheduled; groom the board when it needs it.

This profile deliberately does the *least* — add ceremony back by switching to `scrum`.
