# meta-os agile pack

The agile skill set for a [meta-os](https://github.com/mova77/meta-os) Agentic OS
instance — extracted from the framework core so the core stays generic and this
process opinion stays optional.

| Skill | What it drives |
|-------|----------------|
| `skills/agile-process/` | The Scrum harness: backlog-of-record ceremonies (planning, standup/retro, sprint open/close), story transitions, draft-PR and one-story-one-branch rules — over a Jira mirror, a `backlog.json` monolith, or a per-item store, per `backlog-layout` |
| `skills/agile-swarm/` | Multi-lane sprint execution: dependency-free vertical-slice lanes, worktree-isolated leads, engineering-discipline gates, PO-owned merges |
| `skills/story-estimation/` | Sizing discipline: the extension/intension (complicated vs complex) quadrant, a prescription per quadrant (do it · split · spike · don't commit), two-axis team estimation for planning/refinement, and an auditable estimate ledger |

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

## Configure it

The method lives in the pack; your choices live in your instance. Copy the block from
[`config.example.yaml`](config.example.yaml) under `packs.agile` in your `.packs.yaml`
and edit. `scripts/packs.sh config agile` prints the resolved values (profile defaults
filled in); the skills resolve config-first, so the `<space>` / `<owner>/<scrum-repo>`
placeholders in the docs come from here.

| Key | Meaning | Default |
|-----|---------|---------|
| `profile` | `scrum` (full harness) \| `kanban` (lightweight, pull-based) | `scrum` |
| `tracker` | `jira` \| `local` \| `none` | `local` |
| `space` | backlog space name (resolves `<space>`) | — |
| `mirror-repo` | `<owner>/<repo>` holding the mirror | required when `tracker: jira` or `tracker: local` |
| `backlog-layout` | `monolith` (single `backlog.json`) \| `per-item` (one file per work item) — `tracker: local` only | `monolith` |
| `sprint-files`, `tooling`, `ceremony-home`, `spaces` | `per-item`-only: sprint-file path template, the CLI that mutates the backlog, where ceremony records live, this instance's space keys | — |
| `estimation-scale` | `fibonacci` (1·2·3·5·8) \| `t-shirt` \| `linear` | `fibonacci` |
| `estimation-consensus` | `median` (per axis) \| `strict` (unanimous quadrant) | `median` |
| `estimation-repoint-threshold` | per-axis range that triggers a repoint (span is 2.0) | `1.0` |

### Profiles

A **profile** selects the whole methodology — `profiles/<profile>.md` sets the authority
order, flow, discipline gates, and cadence. Two ship today:

- **`scrum`** — timeboxed sprints, ceremonies, tracker-backed backlog (the full harness;
  what the skills document in detail).
- **`kanban`** — continuous pull-based flow, no sprints or ceremonies, keeps the
  branch/verify/review gates. For solo work, research instances, or low-overhead estates.

Choosing a methodology is one line (`profile: kanban`); changing it is an edit to
instance data, never a fork of this repo.

### Overrides

To change a single convention without switching profiles, add a `conventions-override.md`
in your instance (path documented in `systems/packs.md`); the skills read the active
profile first, then apply your overrides on top (instance wins, additive). `pack.yaml`
declares the config schema `packs.sh config` validates against.
