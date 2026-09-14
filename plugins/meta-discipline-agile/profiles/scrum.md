---
type: profile
profile: scrum
tags: [pack/agile, profile]
---
# Profile: scrum (default)

The full Scrum harness — sprints, ceremonies, a backlog of record. This is the
methodology the pack's skills document in detail; the profile just names it and pins its
parameters. `[[skills/agile-process/SKILL|agile-process]]` and
`[[skills/agile-swarm/SKILL|agile-swarm]]` are the procedures.

## Parameters (from `packs.agile.config`)

| Key | Meaning | Default |
|-----|---------|---------|
| `tracker` | `jira` (an external source of truth, mirrored) or `local` (no external tracker — the mirror is the top authority, shaped by `backlog-layout`) | `local` |
| `backlog-layout` | `monolith` (one tracker-derived file) or `per-item` (one file per work item) — `tracker: local` only | `monolith` |
| `space` | backlog space name — resolves `<space>` in the skills | — |
| `spaces` | the space keys this instance carries, when more than one is in play | — |
| `mirror-repo` | `<owner>/<repo>` holding the mirror | required when `tracker: jira` or `tracker: local` |

## Conventions this profile asserts

- **Authority order — resolved per space, not globally:** `tracker` → the `mirror-repo`
  mirror → the pack's skills → CLAUDE.md invariants. On any state conflict the tracker
  wins. Under `tracker: local` there is no external tracker, so the mirror is itself the
  top authority; under `backlog-layout: per-item` the mirror repo is the **sole
  authority** for every space it carries and `<tooling>` is its only writer. Every key in
  `spaces` resolves this order independently — one space may be tracker-backed while
  another is mirror-native.
- **Flow:** timeboxed sprints; stories move to-do → in-progress → in-review → done.
- **Discipline gates:** one-story-one-branch, foreground clean-verify, review + security
  before PR, PO-owned merges and sprint close.
- **Cadence:** planning at sprint open, daily standup/retro, retro + close at sprint end.

Override any of these per instance — see "Overrides" in the README.
