# Provenance

| Skill | Origin | License |
|-------|--------|---------|
| `design-review` | first-party (mova77), authored for this pack | MIT |
| `decision-records` | first-party (mova77), authored for this pack | MIT |
| `constrained-generation` | first-party (mova77), authored for this pack | MIT |

All content is original and **public-safe by construction** — no instance data (repo
names, trackers, paths, promoted knowledge). The discipline draws on standard
software-engineering and language-design practice; no third-party code or text is
vendored.

## Selection of coverage

The pack's scope was chosen to occupy the space the coding-born skill collections leave
open rather than to restate them. Domain modelling, TDD, code review at diff altitude, and
systematic debugging are already covered by the `mattpocock` and `superpowers` packs in the
meta-os registry; sprint process and delivery cadence belong to the agile pack. This pack
cites all of them and owns what remains: **design-altitude judgment** and **generation
reliability**.

Breadth is anchored on the **SWEBOK Guide (IEEE Computer Society)** knowledge-area
taxonomy, used purely as a **map of which areas exist**, then filtered by one question —
*is there judgment here, or only process?* Areas that are pure process are out of scope by
construction. The skills, and the practice each rests on:

- **`design-review`** — coupling and cohesion (Constantine & Yourdon; Parnas on
  information hiding and on the criteria for decomposing systems into modules), the SOLID
  principles as popularised by Robert C. Martin, the GRASP responsibility patterns
  (Larman), and the design-cost argument in Ousterhout's *A Philosophy of Software
  Design*. The decisive move — grounding every finding in the system's own **change
  pattern** rather than in principle compliance — follows Parnas's original criterion
  (decompose by what is likely to change) and the co-change evidence tradition in software
  evolution research.
- **`decision-records`** — the ADR format introduced by Michael Nygard, with the MADR and
  Y-statement variants offered as `config.adr_format`. The immutability-and-supersession
  discipline, and the requirement that a record carry a reopening trigger, are stated more
  strictly here than in the common templates.
- **`constrained-generation`** — anchored on **Unmesh Joshi, *"DSLs Enable Reliable Use of
  LLMs"*, martinfowler.com, 14 July 2026** (<https://martinfowler.com/articles/llm-and-dsls.html>).
  A guest article **on Martin Fowler's site; Fowler is not the author** — cite Joshi.
  Source of: the constraint-beats-prompting thesis; the four gate conditions; internal
  DSLs whose grammar is enforced by progressive interfaces; the generate→validate→repair
  loop as an autonomous agent loop; "the DSL program, not the prompt, is the enduring
  artifact"; the two-phase design/generation split; and the warnings about upfront cost
  and about coupling syntax too tightly to execution semantics. Read alongside the
  language-design canon — Fowler with Rebecca Parsons, *Domain-Specific Languages* (2010)
  for the internal/external taxonomy and the economics of building a language; Eric Evans,
  *Domain-Driven Design* (2003) for ubiquitous language — and the
  **grammar-constrained / structured decoding** literature, which can remove the syntactic
  half of the repair loop entirely.

No book text, article text, figures, tables, or code from any of these sources is copied,
quoted, or vendored, and no source's proprietary material is reproduced. Every skill is
original prose over standard practice, and is deliberately language- and toolchain-agnostic
(`config.host_language`, `config.validator_command`, `config.adr_format`).

## Where this pack is deliberately stricter than its sources

- **Principles are diagnostics, not goals.** The SOLID literature is routinely applied as
  a checklist; `design-review` rejects any finding that cannot name the concrete future
  change it protects, and rejects abstractions with one implementation and no test seam.
- **An ADR without a rejected alternative is not an ADR**, and one without a reopening
  trigger is a belief with a date on it. Common templates treat both as optional.
- **The DSL gate's default answer is no.** Joshi's article motivates DSLs; the skill is
  written to reject them, because an agent enthusiastic about building languages produces
  exactly the ceremony the article itself warns about.

## Opt-in, per skill

The math and physics packs activate every skill on mount, and this pack does the same —
except for `constrained-generation`, whose master switch defaults to `off`. Gating is a
per-skill judgment: it applies where adopting the practice unprompted would be a
liability, and an `advisory` tier exists so a candidate can be judged without any language
being authored.
