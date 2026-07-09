---
type: profile
profile: scrum
tags: [pack/agile, profile]
---
# Profile: scrum (default)

The full Scrum harness — sprints, ceremonies, a tracker-backed backlog. This is the
methodology the pack's skills document in detail; the profile just names it and pins its
parameters. `[[skills/agile-process/SKILL|agile-process]]` and
`[[skills/agile-swarm/SKILL|agile-swarm]]` are the procedures.

## Parameters (from `packs.agile.config`)

| Key | Meaning | Default |
|-----|---------|---------|
| `tracker` | `jira` (external source of truth, mirrored) or `local` (a `backlog.json` in-repo) | `local` |
| `space` | backlog space name — resolves `<space>` in the skills | — |
| `mirror-repo` | `<owner>/<repo>` holding the mirror | required when `tracker: jira` |

## Conventions this profile asserts

- **Authority order:** `tracker` → `backlog.json` mirror → the skills → CLAUDE.md
  invariants. On conflict the tracker wins (for `tracker: local` the `backlog.json` *is*
  the top authority).
- **Flow:** timeboxed sprints; stories move to-do → in-progress → in-review → done.
- **Discipline gates:** one-story-one-branch, foreground clean-verify, review + security
  before PR, PO-owned merges and sprint close.
- **Cadence:** planning at sprint open, daily standup/retro, retro + close at sprint end.

Override any of these per instance — see "Overrides" in the README.
