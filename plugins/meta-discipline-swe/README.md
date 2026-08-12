# meta-os software-engineering pack

Software-engineering discipline for a [meta-os](https://github.com/meta-agentic/meta-os)
Agentic OS instance. Judgment, not process: what "done right" looks like and how to
check it — the half a pile of coding prompts leaves out.

**Everything in this pack is opt-in.** Mounting it enables no method. Each skill ships a
switch that defaults to `off` and stays inert until the adopter sets it in the instance's
`.packs.yaml`. That is deliberate: the practices here carry real, compounding costs, and
an agent that adopts them unprompted is a liability rather than a help.

| Skill | What it drives | Switch | Default |
|-------|----------------|--------|---------|
| `skills/constrained-generation/` | Making LLM code generation reliable by constraining **what may be emitted** — a DSL, a schema, a typed builder API — instead of by enlarging the prompt. Applies a four-condition gate whose default answer is *no*, chooses internal vs external form, and wires a deterministic validator into a bounded generate→validate→repair loop. | `dsl-generation` | `off` |

## Mount it

From your instance root (see the framework's `systems/packs.md`):

```bash
scripts/packs.sh add software-engineering
```

Skills land in the instance's union `skills/` and project-local `.claude/skills/`. This
pack ships no hooks and no agents.

## Enable it (nothing happens until you do)

Copy the block from [`config.example.yaml`](config.example.yaml) into your `.packs.yaml`
and set the switch. `scripts/packs.sh config software-engineering` prints the resolved
values; the skills read config-first.

| Key | Meaning | Default |
|-----|---------|---------|
| `dsl-generation` | `off` — the skill declines and does nothing · `advisory` — it may evaluate and recommend, never author · `on` — full method | `off` |
| `dsl-style` | `internal` (host type system enforces the grammar) \| `external` (own syntax + parser) | `internal` |
| `host-language` | language whose compiler is available to enforce an internal DSL; absent → prefer external | — |
| `validator-command` | the estate's real deterministic validator, run by the repair loop (e.g. `npm run typecheck`) | — |
| `max-repair-iterations` | bound on the repair loop; on exhaustion, fail loudly — never fall back to unconstrained generation | `3` |

**Recommended path:** leave it `off`; move to `advisory` when you have a recurring
generation problem and want the gate applied to it; move to `on` only after a candidate
has passed that gate and you can name a real validator command.

## Scope

This pack owns the **generation-reliability** question only. It does not restate domain
modelling, TDD, or debugging discipline — where the `mattpocock` or `superpowers` packs
are mounted, defer to them and cross-reference. The overlap at the gate's "cheap path"
(named types and a clean API before any new syntax) is a hand-off, not a duplication.

## Provenance

First-party, MIT. The `constrained-generation` method is grounded in published work, not
invented here — principally Unmesh Joshi's *"DSLs Enable Reliable Use of LLMs"*
(martinfowler.com, July 2026; a guest article on Fowler's site — Joshi is the author),
read alongside Fowler & Parsons' *Domain-Specific Languages*, Evans' ubiquitous language,
and the grammar-constrained decoding literature. Full attribution in
[`skills/constrained-generation/references/bibliography.md`](skills/constrained-generation/references/bibliography.md).

The skill is deliberately **stricter than its sources**: the article motivates DSLs, the
skill's gate is written to reject them, because an agent enthusiastic about building
languages produces exactly the ceremony the article itself warns against.
