# Provenance

| Skill | Origin | License |
|-------|--------|---------|
| `constrained-generation` | first-party (mova77), authored for this pack | MIT |

All content is original and **public-safe by construction** — no instance data (repo
names, trackers, paths, promoted knowledge). The discipline draws on standard
language-design and software-engineering practice; no third-party code or text is
vendored.

## Selection of coverage

The pack's scope was chosen to occupy the space the coding-born skill collections leave
open rather than to restate them. Domain modelling, TDD, and systematic debugging are
already well covered by the `mattpocock` and `superpowers` packs in the meta-os registry;
this pack cites them and owns the **generation-reliability** question instead — whether
and how to constrain what a model may emit, and how to check the result deterministically.

`constrained-generation` is anchored on three bodies of published work, each used as a
**source of method**, not as content to reproduce:

- **Unmesh Joshi, *"DSLs Enable Reliable Use of LLMs"*, martinfowler.com, 14 July 2026** —
  <https://martinfowler.com/articles/llm-and-dsls.html>. A guest article **on Martin
  Fowler's site; Fowler is not the author** — cite Joshi. Source of: the
  constraint-beats-prompting thesis; the four gate conditions; internal DSLs whose grammar
  is enforced by progressive interfaces ("you cannot declare a step before the topology");
  the generate→validate→repair loop as an autonomous agent loop; "the DSL program, not the
  prompt, is the enduring artifact"; the two-phase design/generation split; and the
  explicit warnings about upfront cost and about coupling syntax too tightly to execution
  semantics.
- **The language-design canon** — Martin Fowler with Rebecca Parsons, *Domain-Specific
  Languages* (2010) for the internal/external taxonomy, the semantic model, and the
  economics of building a language; Eric Evans, *Domain-Driven Design* (2003) for
  ubiquitous language, i.e. why domain vocabulary in types and method names grounds any
  reader, human or model; and Fowler's *fluent interface* writing, ancestor of the
  staged-interface technique. The "prefer a clean API until it demonstrably fails"
  position predates LLMs and is not an invention of this pack.
- **Grammar-constrained / structured decoding** — constraining a model's output to a
  formal grammar or schema at sampling time (JSON-schema modes, GBNF-style grammars,
  guided-decoding libraries). The same principle one level lower, and worth knowing
  because it can remove the *syntactic* half of the repair loop entirely, leaving the
  validator to catch only semantic errors.

No article text, book text, figures, or code from these sources is copied or vendored.
Every skill is original prose over standard practice, and is deliberately
language- and toolchain-agnostic (`config.host_language`, `config.validator_command`).

## Where this pack is deliberately stricter than its sources

Joshi's article motivates DSLs; this pack's gate is written to **reject** them. The gate's
default answer is no, three-of-four conditions is a rejection, and the cheap path (named
types plus a clean API) must be tried and *observed* to fail before any syntax is
invented. An agent enthusiastic about building languages would produce exactly the
ceremony the article itself warns about, so the skill inverts the emphasis while keeping
the method.

The article also argues that design emerges through implementation and that comprehensive
upfront specification is not achievable. That is a position, not a settled fact, and it
cuts against spec-first practice; the skill does not depend on it.

## Opt-in, unlike the sibling discipline packs

The math and physics packs activate on mount. This one does not: every skill's master
switch defaults to `off` and the skill declines until an instance sets it. The practice
here carries a real, compounding cost — one the source article names — so silence is the
correct default, and an `advisory` tier exists so the gate can be applied to a candidate
without any language being authored.
