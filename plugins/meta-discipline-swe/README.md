# meta-discipline-swe

A first-party [meta-os](https://github.com/meta-agentic/meta-os) **skill pack** codifying
**software engineering as judgment** — not a pile of coding prompts, but a *method + a
standard of rigor* that turns an agent into a competent practitioner of the questions the
coding-born skill collections leave unanswered.

> A pack = a codified discipline: a repeatable **method** + a **standard of rigor** +
> **portability** across estates.

## Skills

| Skill | Discipline it codifies | Switch (default) | Checkable output |
|-------|------------------------|------------------|------------------|
| [`design-review`](skills/design-review/SKILL.md) | Judging a **design**, not a diff: establish the change pattern the system actually has, map seams and dependency direction, apply coupling/cohesion, SOLID and GRASP as *diagnostics*, price every indirection, always state the simpler alternative. | — (active) | A design-review ledger: the change pattern, then per finding — diagnostic, endangered change, verdict, simpler alternative. |
| [`architecture-tradeoffs`](skills/architecture-tradeoffs/SKILL.md) | Choosing between architectures: quality attributes written as scenarios with response measures, options scored with reasoning, **sensitivity points** and **tradeoff points** named, cost scored separately from reversibility, one-way doors called out. | — (active) | A trade-study ledger; its conclusion feeds an ADR. An option winning every scenario is the failing reading. |
| [`test-strategy`](skills/test-strategy/SKILL.md) | Which tests should exist at all: enumerate failures and what each costs, buy evidence at the cheapest level that can actually see it, name an oracle per test, state each level's blind spot, set the release signal. | — (active) | A test-strategy ledger plus an ESCAPES line assigning every production defect to the level that should have caught it. |
| [`resilience-review`](skills/resilience-review/SKILL.md) | What happens when a dependency fails: enumerate every out-of-process dependency, **declare a degradation contract** for each, bound everything that waits or grows, permit retry only where idempotency is evidenced, map blast radius, and **exercise** each contract by injected failure. | — (active) | A failure-mode ledger with a timeout-budget line and an INTEGRITY line; an unexercised contract is a hypothesis, not resilience. |
| [`decision-records`](skills/decision-records/SKILL.md) | ADR discipline: deciding what is even worth recording, forces in tension, ≥2 rejected alternatives with reasons, consequences including accepted costs, immutable history via supersession, and a reopening trigger. | — (active) | A decision ledger plus an INTEGRITY line whose non-zero counts are defects, not statistics. |
| [`constrained-generation`](skills/constrained-generation/SKILL.md) | Generation reliability: constrain *what may be emitted* (a DSL, a schema, a typed builder API) instead of enlarging the prompt; a four-condition gate whose default answer is no; a deterministic validator closing a bounded repair loop. | `dsl_generation` (`off`) | A generation-constraint ledger: gate verdicts with evidence, the cheap path's observed failure, chosen form, per-run repair counts. |

## Opt-in is per skill, not pack-wide

Skills activate on mount, as in the sibling math and physics packs — **except
`constrained-generation`**, which declines until an instance sets `dsl_generation`.
Building a language carries a real, compounding cost, so silence is the correct default
there; the other five carry no such cost and are active. New
skills are judged the same way, one at a time: gate a skill only when adopting it
unprompted would be a liability.

## The three-part test (why this is a pack)

1. **Recognizable** — a practitioner would call it "how we actually work": review the
   shape against what will change, write down the decisions that are expensive to
   re-litigate, constrain the language when generation keeps failing.
2. **Portable** — parameterized by `pack.yaml` config (ADR home and format, host language,
   validator command); welded to no single estate or toolchain.
3. **Checkable** — every skill emits a ledger with a *failing* reading: a review that
   cannot name the change pattern, a trade study whose winner sweeps every scenario, a
   test strategy with nothing deliberately uncovered, an ADR log with a non-zero integrity
   count, a repair count sitting at the bound.

## Configure

Set the pack's knobs in the instance's `.packs.yaml` `config:` block (see
`config.example.yaml`). Skills read config-first and fall back to documented defaults.

```yaml
packs:
  software-engineering:
    config:
      fault_injection_command: ./chaos/run.sh   # exercises declared degradation contracts
      adr_home: docs/adr/              # where decision records live
      adr_format: nygard               # nygard | madr | y-statement
      dsl_generation: "off"            # off | advisory | on  ← constrained-generation only
```

Without `validator_command`, `constrained-generation`'s repair loop cannot close and the
skill says so rather than simulating a check. No profiles: this discipline has no
alternative methodologies to bundle.

## Install

```bash
# in a meta-os instance
scripts/packs.sh add software-engineering https://github.com/meta-agentic/meta-discipline-swe
scripts/packs.sh config software-engineering      # resolve/validate config
```

Skills land in the instance's union `skills/` and project-local `.claude/skills/`. This
pack ships no hooks and no agents.

## Scope

The pack owns **design-altitude judgment** and **generation reliability**. Where the
`mattpocock` or `superpowers` packs are mounted it defers rather than restates:
`code-review` judges the code written while `design-review` judges the shape proposed;
`tdd`, `diagnosing-bugs` and `domain-modeling` stay theirs. Sprint process, ceremonies and
delivery cadence belong to the agile pack.

## Provenance & license

First-party (mova77). MIT — see `LICENSE` and `PROVENANCE.md`. Public-safe by
construction: no instance data. Breadth is anchored on the SWEBOK Guide v4.0 (IEEE
Computer Society, 2024) and its 18 knowledge areas, used purely as a map, then filtered to
the areas where judgment — not process — lives; `PROVENANCE.md` carries the full
knowledge-area-to-skill mapping so the coverage claim can be checked against the source.
Sources are cited, never vendored; every skill is original prose over standard practice,
and is deliberately stricter than its sources where the common reading has gone slack.

## Registry entry (`meta-os/systems/packs.yaml`)

```yaml
  software-engineering:
    repo: https://github.com/meta-agentic/meta-discipline-swe
    ref: main
    description: "Software-engineering discipline as judgment, not process: design-review, architecture-tradeoffs, test-strategy, resilience-review, decision-records, and the opt-in constrained-generation — each emitting a checkable ledger. First-party."
    provenance: first-party
    license: MIT
    provides: [design-review, architecture-tradeoffs, test-strategy, resilience-review, decision-records, constrained-generation]
    status: available
```
