# meta-os agile pack

The **agile delivery discipline** for a [meta-os](https://github.com/meta-agentic/meta-os)
Agentic OS instance — extracted from the framework core so the core stays generic and this
process opinion stays optional. A pack is a codified discipline: a method, a standard of
rigor, and portability across estates (see the framework's `systems/pack-strategy.md`).

| Skill | What it drives | Checkable output |
|-------|----------------|------------------|
| `skills/agile-process/` | The harness: backlog-of-record ceremonies (planning, standup/retro, sprint open/close), story transitions, sprint stamping, draft-PR and one-story-one-branch rules — over a Jira mirror, a `backlog.json` monolith, or a per-item store, per `backlog-layout` | **transition ledger** |
| `skills/agile-swarm/` | Multi-lane sprint execution: dependency-free vertical-slice lanes, verified worktree isolation, engineering-discipline gates, independent review, PO-owned merges | **lane ledger** |
| `skills/story-estimation/` | Sizing discipline: the extension/intension (complicated vs complex) quadrant, a prescription per quadrant (do it · split · spike · don't commit), two-axis team estimation for planning/refinement | **estimate ledger** |

All three skills are parameterized (`<space>`, `<owner>/<repo>`, `<tooling>` …) — they
carry the method, not anyone's estate — and each emits a named ledger that can read
*reject*, so a reviewer can audit the run against the discipline's own standard rather
than taking it on trust.

## Why this is a discipline, not a prompt pile

The three-part test every pack must pass (`systems/pack-strategy.md`):

- **Recognizable** — a scrum master, a delivery lead, or an engineer who has run a sprint
  reads the ceremonies, gates and estimation quadrant as "how we actually work".
- **Portable** — the methodology itself is one config line (`profile: scrum | kanban`), and
  every tracker, space, path and tool name resolves from instance config. Adopting the pack
  never means adopting one shop's setup.
- **Checkable** — every skill emits a ledger with a failing reading defined: a transition
  written outside the sanctioned tool, a lane on a shared checkout, an estimate with no
  axis placement.

## Mount it

From your instance root (see the framework's `systems/packs.md`):

```bash
scripts/packs.sh add agile
```

Skills land in the instance's union `skills/` and project-local `.claude/skills/`.
This pack ships no hooks and no agents.

## Provenance

First-party: authored in [meta-agentic/meta-os](https://github.com/meta-agentic/meta-os)
(see its `PROVENANCE.md` history) and moved here when the framework core was slimmed to
generic-only skills. MIT. Per-skill origins, the public-safe statement, and why *this*
coverage was chosen are in [`PROVENANCE.md`](PROVENANCE.md). No dependencies on other
packs; `pack.yaml` declares all three skills as this pack's `provides:` surface.

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
