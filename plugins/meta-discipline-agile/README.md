# meta-os agile pack

The agile skill set for a [meta-os](https://github.com/mova77/meta-os) Agentic OS
instance — extracted from the framework core so the core stays generic and this
process opinion stays optional.

| Skill | What it drives |
|-------|----------------|
| `skills/agile-process/` | The Scrum harness: `backlog.json` ↔ Jira reconciliation, ceremonies (planning, standup/retro, sprint open/close), story transitions, draft-PR and one-story-one-branch rules |
| `skills/agile-swarm/` | Multi-lane sprint execution: dependency-free vertical-slice lanes, worktree-isolated leads, engineering-discipline gates, PO-owned merges |

Both skills are parameterized (`<SPACE>`, `<owner>/<scrum-repo>` …) — they carry the
method, not anyone's estate.

## Mount it

From your instance root (see the framework's `systems/packs.md`):

```bash
scripts/packs.sh add agile
```

Skills land in the instance's union `skills/` and project-local `.claude/skills/`.
This pack ships no hooks and no agents.

## Provenance

First-party: authored in [mova77/meta-os](https://github.com/mova77/meta-os) (see its
`PROVENANCE.md` history) and moved here unchanged when the framework core was slimmed
to generic-only skills. MIT.

## Parameters

Set these in your instance's `.packs.yaml` under `packs.agile.config:` (contract:
the framework's `systems/packs.md`, "Parameterisation"). Skills resolve them
config-first; placeholders like `<SPACE>` in the skill docs name these keys.

| Key | Meaning | Default |
|-----|---------|---------|
| `space` | Your backlog space name (`<SPACE>`) | — (required for ceremonies) |
| `tracker` | `jira` \| `local` \| `none` | `local` |
| `mirror-repo` | `<owner>/<scrum-repo>` holding the backlog mirror | — (required for `jira`) |

Methodology **profiles** (e.g. a lightweight Kanban alternative to the full Scrum
harness) are planned; the method itself stays in the pack, your choices stay in your
instance — changing them is an edit to instance data, never a fork of this repo.
