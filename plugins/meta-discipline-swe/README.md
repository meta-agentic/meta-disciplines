# meta-discipline-swe

A first-party [meta-os](https://github.com/meta-agentic/meta-os) **skill pack** codifying
**software engineering as judgment** — not a pile of coding prompts, but a *method + a
standard of rigor* that turns an agent into a competent practitioner of the questions the
coding-born skill collections leave unanswered.

> A pack = a codified discipline: a repeatable **method** + a **standard of rigor** +
> **portability** across estates.

## Opt-in, unlike the sibling discipline packs

The math and physics packs activate on mount. **This one does not.** Every skill here
ships a master switch that defaults to `off`; the skill declines, in one line, until an
instance sets it in `.packs.yaml`. The practices codified here carry real, compounding
cost, so silence — not enthusiasm — is the correct default, and an `advisory` tier exists
so a candidate can be judged without any language being authored.

## Skills

| Skill | Discipline it codifies | Switch (default) | Checkable output |
|-------|------------------------|------------------|------------------|
| [`constrained-generation`](skills/constrained-generation/SKILL.md) | Generation reliability — constrain *what may be emitted* (a DSL, a schema, a typed builder API) instead of enlarging the prompt; a four-condition gate whose default answer is no; internal vs external form; a deterministic validator closing a bounded generate→validate→repair loop. | `dsl_generation` (`off`) | A generation-constraint ledger: four gate verdicts with evidence, the cheap path's *observed* failure, chosen form and validator, and one row per run with its repair count. |

Design principles applied in review context (SOLID/GRASP, composition), ADR discipline,
and design reviews follow as further skills.

## The three-part test (why this is a pack)

1. **Recognizable** — a practitioner would call it "how we actually work": try the clean
   API first, constrain the language when generation keeps failing, let the compiler
   decide, commit the artifact rather than the prompt.
2. **Portable** — parameterized by `pack.yaml` config (host language, validator command,
   form, repair bound); welded to no single estate or toolchain.
3. **Checkable** — unusually so. The discipline's rigor standard *is* a deterministic
   validator: the output either parses, type-checks, and compiles, or it does not.

## Configure

Set the pack's knobs in the instance's `.packs.yaml` `config:` block (see
`config.example.yaml`). Skills read config-first and fall back to documented defaults.

```yaml
packs:
  software-engineering:
    config:
      dsl_generation: "off"            # off | advisory | on   ← nothing runs until this moves
      dsl_style: internal              # internal | external
      host_language: typescript        # whose compiler enforces an internal DSL
      validator_command: npm run typecheck
      max_repair_iterations: 3
```

**Recommended path:** leave it `off`; move to `advisory` when you have a recurring
generation problem you want the gate applied to; move to `on` only once a candidate has
passed that gate and you can name a real validator command. Without
`validator_command` the repair loop cannot close, and the skill says so rather than
simulating a check.

No profiles: this discipline has no alternative methodologies to bundle (the `pure` /
`applied` split the math and physics packs ship has no analogue here). The opt-in tier is
the only methodology choice an adopter makes.

## Install

```bash
# in a meta-os instance
scripts/packs.sh add software-engineering https://github.com/meta-agentic/meta-discipline-swe
scripts/packs.sh config software-engineering      # resolve/validate config
```

Skills land in the instance's union `skills/` and project-local `.claude/skills/`. This
pack ships no hooks and no agents. Mounting it enables no method.

## Scope

This pack owns the **generation-reliability** question only. Domain modelling, TDD, and
debugging discipline belong to the `mattpocock` and `superpowers` packs where those are
mounted — the skill cites them rather than restating them. The overlap at the gate's cheap
path (named types and a clean API before any new syntax) is a hand-off, not a duplication.

## Provenance & license

First-party (mova77). MIT — see `LICENSE` and `PROVENANCE.md`. Public-safe by
construction: no instance data. The method is grounded in published work — principally
Unmesh Joshi's *"DSLs Enable Reliable Use of LLMs"* (martinfowler.com, July 2026; a guest
article on Fowler's site — Joshi is the author), read alongside Fowler & Parsons'
*Domain-Specific Languages*, Evans' ubiquitous language, and the grammar-constrained
decoding literature — and is deliberately **stricter than its sources**: the article
motivates DSLs, the gate is written to reject them.

## Registry entry (`meta-os/systems/packs.yaml`)

```yaml
  software-engineering:
    repo: https://github.com/meta-agentic/meta-discipline-swe
    ref: main
    description: "Software-engineering discipline as judgment, not process. Ships constrained-generation (make LLM generation reliable by restricting what may be emitted — DSL/schema/typed API — behind a four-condition gate whose default answer is no, plus a validator-closed repair loop); design principles applied in review context, ADR discipline and design reviews follow. First-party."
    provenance: first-party
    license: MIT
    status: available # every skill is opt-in — mounting enables nothing
```
