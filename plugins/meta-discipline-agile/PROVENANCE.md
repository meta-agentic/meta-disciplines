# Provenance

| Skill | Origin | License |
|-------|--------|---------|
| `agile-process` | first-party — authored in [meta-agentic/meta-os](https://github.com/meta-agentic/meta-os) (see its `PROVENANCE.md` history) and moved here unchanged when the framework core was slimmed to generic-only skills | MIT |
| `agile-swarm` | first-party — same extraction; distilled from a real multi-lane platform run | MIT |
| `story-estimation` | first-party — authored for this pack | MIT |

All content is original and **public-safe by construction** — no instance data (repo
names, trackers, machine paths, promoted knowledge). Every estate-specific value in the
skills is a placeholder (`<space>`, `<tooling>`, `<owner>/<repo>`) resolved from the
instance's `.packs.yaml`, never a hardcoded name. No third-party code or text is
vendored.

## Selection of coverage

The pack codifies **agile delivery as practised by an agent estate**, and covers exactly
the three places where that practice needs a standard rather than a preference:

- **the harness** (`agile-process`) — the ceremonies and transitions that keep a backlog
  of record trustworthy when agents, not only people, move items;
- **parallel execution** (`agile-swarm`) — running several stories at once without
  corrupting the build or the tracker;
- **sizing** (`story-estimation`) — the one estimation judgment every other ceremony
  depends on (DoR asks for it; lane planning assumes it).

Standard agile bodies of practice — Scrum's ceremony structure, Kanban's pull-based flow,
planning poker, the Cynefin complicated/complex distinction — were used as a **map of what
to cover**, and are named as grounding links where a skill leans on one. No guide,
certification syllabus, course text, figure, or exercise is copied, quoted, or vendored;
every skill is original prose over standard practice. What is *not* here is deliberate:
product discovery, roadmapping and portfolio management are separate disciplines, not
thin sections of this one.

The methodology itself is a parameter, not an opinion: `profile: scrum | kanban` selects
the whole convention bundle (`profiles/<name>.md`), and every tracker, space, path and
tool name resolves from instance config — so adopting the pack never means adopting one
shop's setup.

## Dependency

None. This pack's skills stand alone; `story-estimation` is cited by the other two rather
than duplicated, and all three are listed in `pack.yaml`'s `provides:` as the public
surface other packs may depend on.
