---
type: reference
tags: [pack/software-engineering, bibliography]
---
# Sources

The method in `SKILL.md` is not one article's opinion; it's the intersection of a
long-standing language-design literature and the recent LLM-reliability work.

## The proximate source

- **Unmesh Joshi, *"DSLs Enable Reliable Use of LLMs"*, martinfowler.com, 14 July 2026.**
  <https://martinfowler.com/articles/llm-and-dsls.html>
  A guest article **on Martin Fowler's site — Fowler is not the author**; cite Joshi.
  Supplies: the constraint-beats-prompting thesis; the four gate conditions; internal
  DSLs whose grammar is enforced by progressive interfaces ("you cannot declare a step
  before the topology"); the generate→validate→repair loop as an autonomous agent loop;
  "the DSL program, not the prompt, is the enduring artifact"; the two-phase
  design/generation split; and the explicit warning about upfront cost and the
  syntax-coupled-to-semantics tradeoff. The worked examples are a YAML-over-PlantUML
  presentation DSL, the Tickloom distributed-systems semantic model, and a scenario
  testing DSL.

## The language-design canon it rests on

- **Martin Fowler with Rebecca Parsons, *Domain-Specific Languages* (2010).** The
  internal/external taxonomy, semantic model, and the economics of building a language.
  The "prefer a clean API until it demonstrably fails" position is his, long predating
  LLMs.
- **Eric Evans, *Domain-Driven Design* (2003).** Ubiquitous language — why domain
  vocabulary in types and method names grounds *any* reader, human or model.
- **Fowler's *fluent interface* writing** — the ancestor of the progressive-interface
  technique used to make illegal call order unrepresentable.

## The mechanical half

- **Grammar-constrained / structured decoding** — constraining a model's output to a
  formal grammar or schema at sampling time (JSON-schema modes, GBNF-style grammars,
  guided-decoding libraries). Same principle one level lower: the language, not the
  prompt, is what makes the output well-formed. Worth knowing because it can remove the
  *syntactic* half of the repair loop entirely, leaving the validator to catch only
  semantic errors.

## Reading the disagreement honestly

Joshi argues design emerges through implementation and that comprehensive upfront
specification is not achievable. That is a position, not a settled fact, and it cuts
against spec-first practice. The gate in `SKILL.md` is deliberately stricter than the
article: the article motivates DSLs, the gate is written to **reject** them, because a
skill that is enthusiastic about DSLs would produce exactly the ceremony the article
itself warns about.
