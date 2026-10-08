---
type: reference
tags: [pack/software-engineering, patterns]
---
# Patterns — how the constraint is actually enforced

Load this once Step 1's gate has passed and you know the form. Nothing here is a
justification to build a DSL; it is only *how* to build one well.

## Internal DSLs — the host type system is the grammar

### Progressive (staged) interfaces

Each stage returns a type that exposes **only** the calls legal next. Illegal order stops
compiling, and the error names the domain concept rather than a syntax rule.

```java
// Topology must be declared before any step can exist.
Scenario s = scenario("quorum loses a replica")
    .withCluster(3)          // → returns TopologyDeclared
    .whenNodeFails(2)        // → returns FaultDeclared: only now are steps legal
    .thenExpect(WRITE_REJECTED);

scenario("bad").thenExpect(...)   // does not compile: thenExpect is not on Scenario
```

The value for generation: a model that hallucinates an out-of-order call gets a compiler
error at the exact call site, in the domain's vocabulary — the ideal repair-loop input.

**Related techniques.** Builders returning distinct interfaces per stage; phantom /
branded types in TypeScript; sealed hierarchies to make the case set closed and
exhaustively checkable; newtypes so `Millis` and `Bytes` cannot be swapped.

**Cost to watch.** Staged interfaces multiply types quickly. Stage only the ordering
constraints that actually get violated — not every conceivable rule.

## External DSLs — text in, semantic model out

Three separate things; keep them separate:

1. **Surface syntax** — YAML/JSON/custom text. Optimised for humans (and models) writing.
2. **Parser + schema validator** — rejects malformed input before anything executes.
   Owns the error messages; write them at domain level ("step declared before topology"),
   never as raw parser noise.
3. **Semantic model** — the object graph the runtime actually walks.

Coupling 1 directly to 3 is the tradeoff Joshi flags: convenient at first, painful when
either side must change. The seam is cheap to add up front and expensive to retrofit.

**Schema first.** JSON Schema (or equivalent) buys you validation, editor completion, and
— with structured-decoding backends — often syntactic correctness for free at generation
time, leaving only semantic errors to repair.

## The repair loop

```
program  = generate(spec, examples)          # 2–3 examples, not a manual
for i in 1..max_repair_iterations:           # config: max_repair_iterations, default 3
    result = run(validator_command, program) # config: validator_command
    if result.ok: return program
    program = regenerate(spec, examples, error = result.stderr)   # verbatim error
fail_loudly(result.stderr)                   # never fall back to freeform
```

Rules that make the difference:

- **Verbatim errors.** Paraphrasing loses the file/line/type detail that makes repair
  converge.
- **Bound and fail loudly.** An unbounded loop burns budget on a grammar that is wrong;
  repeated exhaustion is a signal to revisit Step 1, not to raise the bound.
- **Validator is the estate's real command** — the same one CI runs. A validator only the
  agent knows about will drift from truth.
- **Log the repair count.** Persistently needing 3 repairs means the grammar is too big
  or the examples too few; both are fixable, and neither shows up if nobody counts.

## Two phases in practice

| | Designing the abstraction | After it stabilises |
|---|---|---|
| Model's role | critic, alternatives, attacks on the model | translator: English → DSL |
| You produce | prototypes in plain code, thrown away freely | programs in the DSL, committed |
| Danger | freezing the grammar too early | never freezing; endless grammar churn |
| Signal to move on | two or three real artifacts expressed without changing the grammar | — |

## Worked examples in the wild

- **Joshi's three** (see the pack’s `PROVENANCE.md`): a YAML-over-PlantUML DSL for step-by-step
  diagram-rich presentations; the Tickloom semantic model (single-threaded tick loops,
  a `Replica` base class, fixed `Process`/`Network`/`Storage`/`Clock` abstractions) so a
  prompt yields protocol logic rather than infrastructure boilerplate; and a scenario
  testing DSL compiling to a `Scenario` of steps and cluster events.

- **In-house, if the framework is at hand.** meta-os's own `systems/ontology.yaml`,
  `systems/meta-os.config.schema.json`, and `systems/packs.yaml` are constrained grammars
  with real validators (`scripts/packs.sh config <pack>` resolves and rejects
  out-of-enum values). They are small, public-safe, and show the pattern at the scale
  most teams actually need — a schema and a validator, no parser and no new syntax.
  That scale is the honest default; the full DSL is the exception.
