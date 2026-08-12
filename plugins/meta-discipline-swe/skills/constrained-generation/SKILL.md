---
name: constrained-generation
description: "OPT-IN — off unless the instance sets packs.software-engineering.config.dsl-generation; when unset this skill declines in one line and hands back to ordinary design. Use when deciding whether to make LLM code generation reliable by constraining WHAT the model may emit — a DSL, a schema, a typed builder API — rather than by improving the prompt: 'should we build a DSL for this', 'the model keeps getting this shape wrong', 'how do we make generation verifiable instead of reviewable', or when the same kind of artifact (scenarios, pipelines, configs, protocol logic, presentations) is generated over and over. Applies a four-condition gate whose default answer is NO, picks internal vs external form, and wires a deterministic validator into a bounded generate→validate→repair loop."
---

# constrained-generation — reliability by restricting the target language

Most attempts to make an LLM emit correct code work on the **prompt**. This skill works
on the **language**: shrink the space of things the model is allowed to say, then let a
parser, type checker, or compiler — not a human reviewer — decide whether the output is
valid.

## 0 · Activation gate — this skill is opt-in

**This skill does nothing until the adopter turns it on.** Building a DSL is a real,
compounding cost, and an agent that reaches for one unprompted is a liability. Resolve
the switch before anything else:

```bash
scripts/packs.sh config software-engineering dsl-generation   # from the instance root
```

or read `packs.software-engineering.config.dsl-generation` in the instance `.packs.yaml`.

| Value | What you may do |
|-------|-----------------|
| *unset* / `off` **(default)** | **Nothing.** Say in one line that DSL-constrained generation is available but not enabled, name the config key, and continue with ordinary design work. Do not run the gate, do not sketch a grammar, do not "just show what it would look like". |
| `advisory` | **Evaluate and recommend only.** Run Step 1, report the verdict and what a DSL would buy or cost. **Never author** a grammar, parser, builder API, or validator — that needs `on`, or an explicit in-conversation instruction from the user for this one task. |
| `on` | Full method — Steps 1 → 5. |

An explicit user instruction in the conversation ("build me a DSL for this") outranks
`advisory`, and is the only thing that does. `off` means the skill stays silent.

## The one rule

> **Reliability comes from shrinking the set of valid outputs, not from enlarging the
> prompt.** A constraint only counts if a machine can check it. If no deterministic
> validator exists, you have a style guide, not a DSL.

## Step 1 · The gate — does this justify a DSL? (default answer: no)

All four must hold. Any miss → stop and take the cheap path below.

1. **Bounded domain.** The valid expressions form a genuinely small, well-understood
   set. If you can't enumerate the concepts, the domain isn't ready — the DSL will
   ossify a wrong model.
2. **Few examples suffice.** Two or three in-context examples convey complete usage. If
   you need a manual, the grammar is too big to be reliable.
3. **A deterministic validator exists or is cheap to build.** Parser, type checker,
   compiler, schema validator. Not "tests exist" — a checker that rejects *malformed*
   input before it runs.
4. **Recurring use.** The artifact gets generated repeatedly, by more than one person or
   over more than one sprint. A one-off never repays the grammar.

**The cheap path — try this first, and expect it to be enough.** Named types, a clean
library API, a well-shaped schema, and honest domain vocabulary already give the model
most of the grounding a DSL would, with none of the language-maintenance burden. Reach
for new syntax only when the cheap path has been tried and demonstrably failed. Record
*why* it failed — that's the justification the pack expects when the choice is reviewed.

## Step 2 · Choose the form

| | **Internal** (host language) | **External** (own syntax) |
|---|---|---|
| Grammar enforced by | the host type system — progressive/staged interfaces, builders that make illegal order unrepresentable | a parser you own, over YAML/JSON/text |
| Errors | compiler errors in domain vocabulary, at the exact call | parse/schema errors, need good messages written by you |
| Cost | low — no toolchain | parser + validator + editor story |
| Prefer when | a compiler is in the loop (`host-language` is set) | the artifact is data-shaped, or read by non-programmers |

**Default to internal** when a compiler is available: validation is free and the error
message lands in the domain's own words. See `references/patterns.md` for the concrete
techniques and worked examples.

## Step 3 · Wire the loop

```
generate  →  validate (deterministic)  →  feed the error back verbatim  →  regenerate
```

- **Bound it.** `max-repair-iterations` (default 3). On exhaustion **fail loudly** with
  the last validator output. Never fall back to unconstrained generation — a silent
  degradation to freeform is the failure mode this whole method exists to prevent.
- **Feed the validator's real message**, not your paraphrase. Domain-level errors are
  what make the loop self-correcting.
- **Validator command comes from config** (`validator-command`), so the loop is the
  estate's real toolchain, not a guess.

## Step 4 · The artifact is the program, not the prompt

The generated DSL program is what gets committed, reviewed, diffed, and maintained. The
prompt was scaffolding — do not treat it as a source of truth, and do not store it as
one. Corollary: keep **syntax separable from execution semantics**, so the program stays
readable when the runtime changes underneath it.

## Step 5 · Two phases — don't mix them

- **Designing the abstraction** (grammar still moving): the model is a *critic and
  brainstorming partner* — alternatives, edge cases, attacks on your model. Do not
  generate volume against a grammar that isn't stable yet.
- **After it stabilises**: the model is a *translator* — English in, DSL out, validator
  closing the loop. Freezing too early is the more common mistake; freezing never is the
  other one.

## Rejection criteria — say no and mean it

- **No validator** → not a DSL. Stop.
- **One-off artifact** → use the cheap path.
- **The domain is still being discovered** → design in code first; a DSL built on a
  half-understood model hardens the misunderstanding and is expensive to unwind.
- **A DSL already exists** (SQL, a schema language, an existing config format) → use it.
  A second grammar for the same domain is worse than either alone.
- **"It would be elegant"** → not a reason. The gate is about failure rates and repeat
  count, not aesthetics.

## Scope boundaries

Owns the **generation-reliability** question only: whether and how to constrain what a
model emits. It does **not** restate domain modelling, TDD, or debugging discipline —
if the `mattpocock` pack (`domain-modeling`, `codebase-design`) or `superpowers` (TDD)
is mounted, defer to them for those and cross-reference. Step 1's cheap path overlaps
domain modelling deliberately: that's the hand-off point, not a duplication.

## References

- `references/patterns.md` — internal/external techniques, the repair loop in practice,
  worked examples (including in-house ones).
- `references/bibliography.md` — sources and correct attribution.
