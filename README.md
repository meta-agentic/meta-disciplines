# meta-disciplines

The **meta-discipline** skill packs, and the **`meta-agentic` plugin marketplace** that
publishes them for Claude.

A discipline is not a pile of facts about a field. Each pack codifies how a competent
practitioner actually works: a repeatable **method**, a **standard of rigor**, and a
**checkable artifact** — every skill ends on a ledger a reviewer can audit.

| Plugin | Skills | What it codifies |
|---|---|---|
| [`meta-discipline-agents`](plugins/meta-discipline-agents) | 7 | Agent engineering: architecture, harness, prompting, evaluation, safety, skills, loop engineering |
| [`meta-discipline-agile`](plugins/meta-discipline-agile) | 3 | Agile delivery: backlog-of-record process, multi-lane sprint execution, two-axis estimation |
| [`meta-discipline-math`](plugins/meta-discipline-math) | 17 | Mathematics: a rigor spine, nine branch disciplines, empirical statistics, scientific validation, graph drawing |
| [`meta-discipline-physics`](plugins/meta-discipline-physics) | 16 | Physics: a method spine (symmetry, limits, estimation, modelling, error analysis) and the core branches |
| [`meta-discipline-swe`](plugins/meta-discipline-swe) | 8 | Software engineering judgment: design review, trade-offs, test strategy, resilience, performance, decisions |

## Install in Claude

**Claude Code**

```text
/plugin marketplace add meta-agentic/meta-disciplines
/plugin install meta-discipline-math@meta-agentic
```

Skills are then available as `/meta-discipline-math:multivariate-analysis`, and Claude
loads them on its own when a task matches. Install only the packs you use: every
installed pack adds its skill descriptions to each session (from about 700 tokens for
`agile` to about 3,500 for `physics`).

**Claude app (web, desktop, Cowork)** — *Customize › Plugins › Add › Add marketplace*,
enter `meta-agentic/meta-disciplines`, then add the packs you want. A plugin added there
is also available in Claude Code signed in to the same account.

**Updates.** Auto-update is off by default for marketplaces outside Anthropic's own.
Turn it on in `/plugin` › *Marketplaces* › `meta-agentic` › *Enable auto-update*, or
update by hand with `/plugin marketplace update meta-agentic`.

## Use with meta-os

These packs are also the first-party skill packs of [meta-os](https://github.com/meta-agentic/meta-os),
which mounts them into an instance and resolves their configuration from the instance's
`.packs.yaml`. Each pack's `pack.yaml` declares that configuration with documented
defaults. meta-os instances currently mount the packs from their former per-pack
repositories; mounting from this repository is the next meta-os change.

## Layout

```
.claude-plugin/marketplace.json        the catalogue — generated
plugins/meta-discipline-<x>/
├── .claude-plugin/plugin.json         the plugin manifest — generated
├── pack.yaml                          the source of truth: name, description, config
├── skills/<skill>/SKILL.md
├── README.md · PROVENANCE.md · LICENSE
scripts/sync_manifests.py              pack.yaml → plugin.json + catalogue (--check in CI)
```

Each pack was imported with its full history from its original repository
(`meta-agentic/meta-discipline-<x>`); `git log --follow` on any file shows it.

## Contributing and releasing

- Edit a pack under `plugins/meta-discipline-<x>/`. Never edit the generated manifests:
  run `python3 scripts/sync_manifests.py` and commit what it writes.
- A pull request must pass CI: the manifests agree with `pack.yaml`,
  `claude plugin validate --strict` passes on the catalogue and on every plugin, and each
  pack passes the meta-os pack conformance gate.
- To release a pack, bump `version` in its `plugin.json` (semver; users receive a new
  copy only when it changes) and tag the commit `meta-discipline-<x>--v<version>`.

## Licence

MIT — see [`LICENSE`](LICENSE). Each pack carries its own `LICENSE` and `PROVENANCE.md`.
