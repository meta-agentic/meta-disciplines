---
type: index
tags: [os, skills, pack, software-engineering]
---
# software-engineering pack — skills

Each skill is an *executable discipline*: a method + a standard of rigor + a checkable
artifact. This pack codifies software engineering as **judgment**, not process — what
"done right" means and how to check it — and is deliberately narrow: it owns the
questions the coding-born skill collections leave unanswered rather than restating the
ones they already cover.

**Every skill here is opt-in.** Mounting the pack enables nothing: each skill's master
switch defaults to `off` in `pack.yaml` and the skill declines until the instance sets it
in `.packs.yaml`. This is the one place this pack departs from its sibling discipline
packs, and it is deliberate — the practices codified here carry real, compounding cost,
and an agent that adopts one unprompted is a liability.

| Skill | Discipline | Switch (default) | Checkable output |
|-------|------------|------------------|------------------|
| [[skills/constrained-generation/SKILL\|constrained-generation]] | Generation reliability — constrain *what may be emitted* (DSL, schema, typed builder API) instead of enlarging the prompt; a four-condition gate whose default answer is no; deterministic validator closing a bounded repair loop | `dsl_generation` (`off`) | generation-constraint ledger (gate verdict + form + repair counts) |

Config knobs in `pack.yaml`; no profiles (see the note there). See `README.md`.

## Scope boundary

This pack owns the **generation-reliability** question only. Domain modelling, TDD, and
debugging discipline belong to the `mattpocock` and `superpowers` packs where those are
mounted — cite them rather than restating them. The overlap at the gate's cheap path
(named types and a clean API before any new syntax) is a hand-off, not a duplication.
