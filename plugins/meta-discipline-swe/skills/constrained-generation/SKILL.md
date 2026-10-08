---
name: constrained-generation
description: "OPT-IN — declines unless the instance sets `dsl_generation` in packs.software-engineering.config. Use when deciding whether to make LLM code generation reliable by constraining WHAT may be emitted — a DSL, a schema, a typed builder API — rather than by enlarging the prompt: 'should we build a DSL for this', 'the model keeps getting this shape wrong', 'how do we make generation verifiable instead of reviewable', or when the same kind of artifact (scenarios, pipelines, configs, protocol logic) is generated over and over. Applies a four-condition gate whose default answer is no, picks internal vs external form, and wires a deterministic validator into a bounded generate→validate→repair loop."
---

# Constrained Generation

Most attempts to make a model emit correct code work on the **prompt**. This skill works
on the **language**: shrink the set of things the model is allowed to say, then let a
parser, type checker, or compiler — not a human reviewer — decide whether the output is
valid. It is the *reliability* sibling of ordinary domain modeling: that work names the
concepts, this one decides whether to make the naming machine-enforceable, and at what
cost.

## Activation gate — this skill ships off

**Do nothing until the adopter has turned it on.** Resolve the switch before reading
further, via `scripts/packs.sh config software-engineering dsl_generation` or
`packs.software-engineering.config.dsl_generation` in the instance `.packs.yaml`.

| Value | What you may do |
|-------|-----------------|
| *unset* / `off` **(default)** | **Nothing.** State in one line that constrained generation is available but not enabled, name the config key, and continue with ordinary design work. Do not run the Method, do not sketch a grammar, do not "just show what it would look like" — a demonstration is the method, leaked. |
| `advisory` | **Steps 1–2 only.** Run the gate, report the verdict and what a DSL would buy or cost, emit the ledger's GATE block. **Never author** a grammar, parser, builder API, or validator. |
| `on` | Full method, Steps 1–5. |

An explicit in-conversation instruction from the user outranks `advisory` for that one
task, and is the only thing that does. Nothing outranks `off`.

## Method

1. **Run the gate — all four, or stop.** (a) *Bounded domain*: the valid expressions form
   a small, enumerable set. (b) *Few examples suffice*: two or three in-context examples
   convey complete usage; if it needs a manual, the grammar is too big to be reliable.
   (c) *A deterministic validator exists or is cheap to build* — a checker that rejects
   malformed input before it runs, not "we have tests". (d) *Recurring use*: generated
   repeatedly, by more than one author or across more than one sprint. A miss on any
   condition ends the method here.
2. **Try the cheap path first and expect it to be enough.** Named types, a clean library
   API, a well-shaped schema, honest domain vocabulary — these give the model most of the
   grounding a DSL would, with none of the language-maintenance burden. New syntax is
   justified only *after* the cheap path has been tried and observed to fail, with the
   observed failure recorded. This step is where most candidates die, correctly.
3. **Choose the form** per `config.dsl_style`. **Internal** — the host type system is the
   grammar: staged/progressive interfaces so each call returns only the operations legal
   next, phantom or branded types, sealed hierarchies for closed case sets, newtypes so
   `Millis` and `Bytes` cannot be swapped. Illegal constructions stop compiling, and the
   error names the domain concept. **External** — surface syntax, a parser, and a semantic
   model, kept as three separable things. Default to internal whenever
   `config.host_language` names a compiler; it is validation for free.
4. **Wire the loop.** `generate → validate → feed the error back verbatim → regenerate`,
   running `config.validator_command`, bounded by `config.max_repair_iterations`. Feed the
   validator's real message, never a paraphrase — the file, line, and type detail is what
   makes repair converge. On exhaustion **fail loudly** with the last validator output.
   With no `validator_command` configured, say the loop cannot close rather than
   simulating a check.
5. **Commit the program, not the prompt.** The generated DSL program is the artifact that
   gets reviewed, diffed, and maintained; the prompt was scaffolding and is not a source
   of truth. Keep syntax separable from execution semantics so the program stays readable
   when the runtime changes beneath it. Then log the run in the ledger and, if repairs are
   persistently near the bound, return to Step 1 — that is the grammar telling you it is
   too big.

## The rigor standard

- **A constraint counts only if a machine can check it.** No validator → not a DSL, and
  not this method. Say so and stop.
- **The gate's default answer is no.** Four conditions, all of them, evidenced — not
  asserted. Three-of-four is a rejection.
- **The cheap path is tried before syntax is invented**, and its *observed* failure is
  recorded. "It would be cleaner" is not an observation.
- **Every generation run is logged with its repair count.** Reliability claims without
  counts are impressions.
- **Exhaustion fails loudly and never degrades to freeform.** A silent fallback to
  unconstrained generation defeats the entire method and hides the defeat.
- **Grammar stability precedes volume.** Generate at scale only against a grammar that
  survived two or three real artifacts unchanged.
- **This skill does not restate domain modelling or TDD** — cite the packs that own them.

## Checkable output

A **generation-constraint ledger**: the candidate with its four gate verdicts and the
evidence for each, the cheap path's observed failure, the chosen form and validator, and
one row per generation run with its repair count and outcome. Under `advisory` only the
GATE block is emitted; under `on` the whole ledger is mandatory.

```
GATE   candidate: scenario tests for the replication layer          verdict: PASS (4/4)
  bounded domain   ✓  12 verbs, closed set (topology · fault · delay · assert)
  few examples     ✓  3 examples covered every verb in trial generation
  validator exists ✓  tsc --noEmit; staged interfaces enforce step order
  recurring use    ✓  41 scenarios, 3 sprints, 2 authors
  cheap path       ✗  named types + builder API: 6/20 generations declared a step
                      before topology and still compiled → observed failure

FORM   internal (typescript)    validator: npm run typecheck    max_repair: 3

RUN                      REPAIRS  OUTCOME
scenario/quorum-loss        1      valid — step-before-topology, fixed from tsc error
scenario/partition-heal     0      valid
scenario/clock-skew         3      FAILED LOUDLY — no verb for clock drift; grammar gap
```

Ship only when every gate row carries evidence, the cheap path's failure is *observed*
rather than predicted, and each run's repair count is recorded. A ledger whose runs sit
at the repair bound is a rejection notice for the grammar, not a passing result.

## Anti-patterns

- Building a DSL for a one-off artifact, or because the domain "feels" structured — the
  cost is paid forever and the repeat count never arrives.
- Calling something a DSL when nothing can reject a malformed instance; a style guide
  with opinions about syntax is not a constraint.
- Skipping the cheap path because a DSL is more interesting, then discovering that named
  types and a clean API would have carried the whole load.
- Inventing a second grammar for a domain that already has one — SQL, a schema language,
  an existing config format — and maintaining both.
- Freezing the grammar while it is still moving (generating volume against an unstable
  language), or never freezing it and churning the syntax forever.
- Paraphrasing validator errors into the repair loop, or raising
  `max_repair_iterations` when runs keep hitting the bound instead of fixing the grammar.
- Falling back to unconstrained generation when the loop exhausts, and reporting the
  result as if it had been validated.
- Sketching a grammar "just to show the idea" while `dsl_generation` is `off`.

Concrete techniques — staged-interface code, the parser/semantic-model seam, repair-loop
mechanics, worked examples — are in [`references/patterns.md`](references/patterns.md).
Sourcing and attribution are in the pack's `PROVENANCE.md`.
