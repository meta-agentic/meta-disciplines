---
type: index
tags: [os, skills, pack, software-engineering]
---
# software-engineering pack — skills

Each skill is an *executable discipline*: a method + a standard of rigor + a checkable
artifact. This pack codifies software engineering as **judgment**, not process — what
"done right" means and how to check it — and is deliberately narrow: it owns the questions
the coding-born skill collections leave unanswered rather than restating the ones they
already cover. Process, ceremonies and delivery cadence belong to the agile pack.

Skills activate on mount, as in the sibling discipline packs, with **one exception**:
`constrained-generation` stays gated behind a config switch that defaults to `off`,
because building a language carries a real, compounding cost. Gating is decided per
skill — a skill is gated only when adopting it unprompted would be a liability.

| Skill | Discipline | Switch (default) | Checkable output |
|-------|------------|------------------|------------------|
| [[skills/design-review/SKILL\|design-review]] | Structure judged against the change pattern the system actually has; coupling/cohesion, SOLID and GRASP as diagnostics, indirection priced, the simpler alternative always stated | — (active) | design-review ledger (change pattern + finding · diagnostic · endangered change · verdict · simpler alternative) |
| [[skills/architecture-tradeoffs/SKILL\|architecture-tradeoffs]] | Choosing between architectures: quality attributes as scenarios with response measures, sensitivity and tradeoff points, risks vs non-risks, cost scored separately from reversibility | — (active) | trade-study ledger (an option winning every scenario is the failing reading) |
| [[skills/test-strategy/SKILL\|test-strategy]] | Which tests should exist at all: enumerate failures and their cost, buy evidence at the cheapest level that can see each one, name the oracle, state the blind spot | — (active) | test-strategy ledger + ESCAPES line assigning every production defect to a level |
| [[skills/decision-records/SKILL\|decision-records]] | ADR discipline: what is worth recording, forces in tension, rejected alternatives with reasons, accepted costs, immutable history, reopening triggers | — (active) | decision ledger + an INTEGRITY line whose non-zero counts are defects |
| [[skills/constrained-generation/SKILL\|constrained-generation]] | Generation reliability — constrain *what may be emitted* (DSL, schema, typed builder API) instead of enlarging the prompt; a four-condition gate whose default answer is no; deterministic validator closing a bounded repair loop | `dsl_generation` (`off`) | generation-constraint ledger (gate verdict + form + repair counts) |

Config knobs in `pack.yaml`; no profiles (see the note there). See `README.md`.

## Scope boundaries

The pack owns **design-altitude judgment** and **generation reliability**. Where the
`mattpocock` or `superpowers` packs are mounted, defer rather than restate:

- `code-review` judges the code written; `design-review` judges the shape proposed. Line
  and naming defects go to the former.
- `tdd` / `diagnosing-bugs` are theirs. This pack cites them.
- `domain-modeling` is theirs; `design-review` consumes the model and reviews the
  structure around it.
- Sprint process, ceremonies, and delivery cadence are the agile pack's.
