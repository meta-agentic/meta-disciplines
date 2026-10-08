---
name: architecture-tradeoffs
description: "Use when choosing between architectural options or evaluating an existing architecture — monolith vs services, sync vs event-driven, which datastore, where a boundary goes, build vs buy, or 'is this architecture good'. Turns quality attributes into concrete scenarios with response measures, compares genuinely viable options against them, and surfaces the sensitivity points, tradeoff points, risks and one-way doors. Emits a trade study whose conclusion feeds an ADR. Use before committing to a structure that will be expensive to reverse, and whenever a proposal is defended with adjectives like 'scalable' or 'flexible'."
---

# Architecture Tradeoffs

An architecture is the set of decisions that are expensive to change later. Evaluating one
is therefore not about whether it is *good* — it is about **which quality attributes it
buys, which it spends, and which of those purchases are irreversible.** This skill turns
that into a trade study a reviewer can check. It ends where
[[skills/decision-records/SKILL|decision-records]] begins: the study is the analysis, the
ADR is the record.

## Method

1. **Convert quality attributes into scenarios.** "Scalable", "maintainable", "secure" are
   adjectives, and adjectives cannot be traded against each other. Write each as a
   concrete scenario: **source · stimulus · environment · artifact · response · response
   measure.** *"During Black Friday peak (environment), 40k concurrent users (source)
   submit checkout (stimulus); the order service (artifact) accepts and confirms
   (response) at p99 < 800 ms with < 0.1% rejection (measure)."* **A scenario without a
   response measure is still an adjective** — no measure, no trade study.
2. **Name the decision points and at least two genuinely viable options.** A straw man
   invalidates the study more thoroughly than no study at all, because it manufactures
   false confidence. If only one option is viable, this is not a trade study — say so and
   go straight to the ADR.
3. **Score each option against each scenario — and record why**, not just a verdict. The
   reasoning is what a future reader re-checks when the scenario changes.
4. **Find the sensitivity and tradeoff points.** A **sensitivity point** is a decision
   where a small change materially moves one attribute's measure. A **tradeoff point** is
   a decision that moves two attributes in *opposite* directions — those are the real
   architecture, and everything else is detail. Mark them explicitly.
5. **Separate risks from non-risks, and cost from reversibility.** A risk is a scenario an
   option plausibly fails. A one-way door is a decision that cannot be undone in under a
   quarter without a rewrite — a cheap decision behind a one-way door is more dangerous
   than an expensive reversible one. Score these on different axes; conflating them is how
   teams buy irreversibility for a small saving.
6. **Group risks into themes and state what they mean.** Several risks that share a root
   (all stem from a single point of coordination, all from an unbounded queue) are one
   architectural problem, not five.
7. **Conclude and hand off.** State the chosen option, the tradeoff knowingly accepted, and
   the scenario that would reverse it. Then record it via
   [[skills/decision-records/SKILL|decision-records]] — the study is the input to the ADR,
   never a substitute for it.

## The rigor standard

- **No measure, no scenario; no scenario, no claim.** Every benefit or defect asserted about
  an option must trace to a scenario with a number in it.
- **Two viable options minimum**, each defensible by someone who prefers it. A comparison
  against a straw man is a decision wearing the costume of an analysis.
- **The tradeoff point must be named.** Finding none means the scenarios are too weak to
  bind, or one option is not real. This is the single most common way a trade study fails.
- **Reversibility is scored separately from cost**, and one-way doors are called out by
  name.
- **Non-risks are recorded too.** Knowing what you deliberately stopped worrying about is
  half the value when the study is re-read a year later.
- **The study does not replace the record.** Its conclusion becomes an ADR with the
  rejected option and its reason — otherwise the analysis is re-run from scratch next time.
- **Structure judgment stays in `design-review`.** This skill chooses between architectures;
  that one judges whether a given structure absorbs the changes coming at it.

## Checkable output

A **trade-study ledger**: scenarios with measures across the top, options down the side,
each cell carrying the reasoning and not merely a verdict — then the sensitivity points,
the tradeoff points, the one-way doors, and the conclusion.

```
SCENARIOS (source · stimulus · environment → response measure)
  S1 peak-checkout   40k concurrent, Black Friday        → p99 < 800ms, <0.1% rejected
  S2 partial-outage  payment provider down 10 min        → orders still accepted, settled later
  S3 team-change     new squad ships a feature unaided   → < 2 weeks to first production change
  S4 audit           regulator asks "why was this price" → answer from stored data, < 1 day

OPTION                    S1                     S2                    S3                   S4
synchronous monolith      p99 ~1.4s at 40k       fails: checkout       1 wk: one codebase   easy: single DB
                          (single DB write path) blocks on provider                         join
event-driven + outbox      p99 ~600ms (write     survives: order       3-4 wks: must learn  easy: event log IS
                          decoupled from settle) queued, settled later async debugging      the audit trail

SENSITIVITY   outbox flush interval → S1 p99 moves ~200ms per 50ms of interval
TRADEOFF ★    async settlement buys S1 + S2, spends S3 (onboarding time doubles) — the decision
ONE-WAY DOOR  event log as system of record: reversible < 1 quarter only before backfill starts
RISK THEME    3 of 4 risks trace to one unbounded queue → bound it, or the theme stands
NON-RISK      S4 under either option; storage is not the constraint anyone feared

CONCLUSION    event-driven + outbox; accepting S3 (onboarding cost), bounded by a queue limit.
              Reverses if S3 measure is missed twice in a quarter.   → ADR 0021
```

Ship only when every scenario carries a measure, at least one **tradeoff point** is named,
and the conclusion states what is being knowingly spent. **An option that wins on every
scenario is the failing reading** — it means the scenarios do not bind, or the alternative
was never real. Go back to step 1 rather than reporting a clean sweep.

## Anti-patterns

- Adjective architecture: "more scalable", "cleaner", "future-proof" — unfalsifiable, and
  therefore unarguable in either direction.
- Comparing options on *features* ("supports GraphQL") instead of on scenarios the system
  actually faces.
- The straw-man alternative, included so the preferred option has something to beat.
- Reporting a winner on every axis and calling it a strong result.
- Treating a cheap-but-irreversible decision as low risk because the cost line is small.
- Choosing by vendor, framework fashion, or the loudest person in the room, then
  back-filling scenarios that happen to fit.
- Leaving the study in a document nobody links from an ADR, guaranteeing the whole argument
  is re-run the next time someone asks why.
