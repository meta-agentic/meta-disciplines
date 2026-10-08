---
type: index
tags: [os, skills, pack, agile]
---
# agile pack — skills

Each skill is an *executable discipline*: a method + a standard of rigor + a checkable
artifact. **`agile-process` is the harness** — the ceremony and transition discipline every
other skill here runs inside; **`agile-swarm`** applies that harness to N stories at once
without letting parallelism corrupt the build or the tracker; **`story-estimation`** owns
the one sizing judgment both of the others depend on (DoR asks for an estimate; lane
planning assumes one). No skill restates another: each cites its sibling by wikilink.

| Skill | Discipline | Checkable output |
|-------|------------|------------------|
| [[skills/agile-process/SKILL\|agile-process]] | The backlog-of-record harness: ceremonies, story transitions, sprint stamping, branch/PR gates, the single backlog write path, and intake of issues from a public tracker across the public/private boundary | **transition ledger** (+ intake rows) |
| [[skills/agile-swarm/SKILL\|agile-swarm]] | Multi-lane parallel execution: hazard-free lane planning, verified worktree isolation, independent review, PO-owned merges | **lane ledger** |
| [[skills/story-estimation/SKILL\|story-estimation]] | Sizing as judgment: the extension/intension (complicated vs complex) quadrant and one prescription per quadrant | **estimate ledger** |

Config knobs in `pack.yaml`; profiles in `profiles/` (`scrum` · `kanban`). See `README.md`.

<!--
  Required by the meta-os convention that every folder carries its own _index.md.
  Add a row when you add a skill — this table is what an agent reads on entering the
  folder, so a missing row means a skill nobody finds.
-->
