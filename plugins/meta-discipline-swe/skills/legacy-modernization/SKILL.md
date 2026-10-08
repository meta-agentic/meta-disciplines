---
name: legacy-modernization
description: "Use when deciding what to do with a system that already exists and is hard to change — 'should we rewrite this', 'can we migrate off it', planning a strangler migration, replatforming, breaking a monolith apart, or scoping work in code nobody wants to touch. Names the change the legacy system actually blocks, measures before judging, decides a disposition per component (leave · refactor · strangle · rewrite) rather than one verdict for the whole system, applies a rewrite gate whose default is no, and requires a freeze-or-mirror policy for the old system during migration. Also use when a modernization already underway is slipping."
---

# Legacy Modernization

Legacy code is not code that is old or ugly; it is code you are **afraid to change**. The
discipline is not cleaning it — it is deciding, per component, whether to leave it,
refactor it, strangle it, or rewrite it, knowing that the last of those is a one-way door
that has killed more systems than the code it replaced. The characteristic failure is a
modernization that begins with a verdict on the whole system and no named change it is
meant to unblock.

## Method

1. **Name the change the system blocks — before judging the code.** Which concrete
   business or engineering change is currently impossible, or costs disproportionately?
   What does that cost, per month? **"It's legacy", "the stack is old" and "the code is
   ugly" are not drivers**, and a modernization launched without one is a rewrite that has
   not admitted it yet.
2. **Measure before you judge.** Combine **churn with complexity**: components that are
   complex *and* change constantly are the pain; complex and stable ones are usually fine
   left alone. Read the history — who changes what, together — the same evidence
   [[skills/design-review/SKILL|design-review]] uses. Judging by reading the code alone
   reliably indicts whatever is merely unfamiliar.
3. **Build the safety net at the seam you will touch.** Characterization tests pin *what
   the system does*, not what it should do — they are how you find out whether a
   transformation preserved behaviour. **Transforming code with no characterization net is
   not refactoring; it is editing and hoping.** Where the seam is untestable, making it
   testable *is* the first piece of work.
4. **Decide a disposition per component, not per system.** Four options: **leave alone**
   (works, rarely changes — the correct answer more often than teams like), **refactor in
   place**, **strangle** (route traffic through a facade and replace behind it,
   incrementally), **rewrite** (bounded, last resort). A single verdict covering the whole
   system is the signature of an analysis that did not happen.
5. **Apply the rewrite gate — all four, or strangle instead.** (a) The behaviour is
   **knowable**, or the parts being dropped are named deliberately. (b) The old system can
   be **frozen, or its changes mirrored** into the new one for the duration. (c) There is a
   **cutover plan with a rollback**. (d) The team accepts **running and staffing both
   systems** until cutover completes. The Big Rewrite does not fail because the new code is
   bad; it fails because the old system keeps gaining features while the new one is being
   built, and the gap never closes.
6. **Decide which quirks are load-bearing.** Undocumented behaviour is still behaviour, and
   somebody has built on it. Split it explicitly: bugs **preserved** because callers depend
   on them, bugs **fixed** as a deliberate, announced change. A rewrite that silently
   "corrects" a quirk breaks its consumers, and does so at the worst possible moment.
7. **Sequence so every step ships and can be reversed.** Each increment is independently
   valuable and independently revertible. **A plan that only pays off at the end is a
   rewrite wearing a migration's clothes** — and it will be cancelled at 70%, leaving two
   half-systems. Record the disposition and gate verdict via
   [[skills/decision-records/SKILL|decision-records]]; the irreversibility analysis belongs
   to [[skills/architecture-tradeoffs/SKILL|architecture-tradeoffs]].

## The rigor standard

- **Every modernization names the blocked change and its cost.** No driver, no work.
- **Disposition is per component.** One verdict for the whole system is a finding against
  the analysis, not a conclusion.
- **No transformation without a characterization net** at the seam being touched.
- **The rewrite gate's default is no.** Three of four conditions is a rejection; strangle
  instead.
- **The freeze-or-mirror policy is stated before the first line is written.** What happens
  to changes landing in the old system during the migration is the question that decides
  whether the migration finishes.
- **Preserved quirks are listed, and dropped ones are announced.** Silence about behaviour
  is a decision to break somebody.
- **Every step ships and reverses.** Value that arrives only at cutover is not value; it is
  exposure.
- **"Leave alone" is a first-class outcome** and must appear in the ledger where it applies.

## Checkable output

A **modernization ledger**: one row per component with the change it blocks, its
churn-and-complexity evidence, the disposition chosen, the safety net, and the reversible
increment — preceded by the driver and, where a rewrite is proposed, the gate.

```
DRIVER   per-region VAT cannot be added: touches 4 packages, ~6 wks/change, blocked 3 quarters
         cost of not acting: ~€40k/quarter in manual workarounds

REWRITE GATE (billing-core, proposed)                                   VERDICT: FAIL 2/4 → strangle
  (a) behaviour knowable          ✓  312 characterization tests pin current output
  (b) old system frozen/mirrored  ✗  4 teams still ship to it weekly; no freeze agreed
  (c) cutover + rollback plan     ✓  dual-write, shadow-read, flag per region
  (d) both systems staffed        ✗  one team, no headroom for parallel run

COMPONENT       BLOCKS      CHURN×CPLX   DISPOSITION   SAFETY NET            REVERSIBLE INCREMENT
tax-rules       VAT change  high × high  strangle      312 char. tests       one region behind flag,
                                                        pinned at seam        revert = flip flag
billing-core    VAT change  high × high  strangle      same net              facade first, no data move
invoice-pdf     —           low × high   LEAVE ALONE   none needed           n/a — complex but stable,
                                                                              4 commits in 3 years
legacy-import   —           high × low   refactor      integration tests     extract adapter, in place
report-engine   VAT change  med × high   rewrite       spec + char. tests    bounded: 3 reports, then stop

BEHAVIOUR   preserved: rounding half-up on line items (3 downstream consumers depend on it);
                       negative-quantity credit notes (used by returns)
            dropped:   silent truncation of names >64 chars → now rejected, announced 2 releases ahead

INTEGRITY   components with no disposition: 0 · transformations without a net: 0
            whole-system verdicts: 0 · freeze/mirror policy: MISSING for billing-core → gate fails
```

Ship only when the driver is named with a cost, every touched component carries a
disposition and a safety net, and any rewrite passes all four gate conditions. **The
failing readings:** one disposition covering the whole system; a rewrite passing on three
of four; no freeze-or-mirror policy (the single most reliable predictor that a migration
will not finish); and a ledger with no `LEAVE ALONE` row anywhere, which usually means the
analysis was an appetite rather than an assessment.

## Anti-patterns

- Rewriting because the stack is old or the code is unpleasant, with no change that the
  current system actually blocks.
- The Big Rewrite with no freeze or mirror: the old system gains features faster than the
  new one catches up, and the project is cancelled at 70% with two half-systems to run.
- Calling it refactoring when there is no characterization net — that is editing, and the
  regressions arrive later, attributed to something else.
- Preserving every quirk indiscriminately, doubling the work to reproduce bugs nobody
  depends on; or the mirror image, silently fixing one that three consumers rely on.
- A big-bang cutover with no rollback, scheduled for a weekend, on the assumption that
  parity was achieved.
- Replatforming without moving a single boundary: a new framework wrapped around the same
  tangle, sold as modernization.
- One verdict for the whole system, which is how a component that should have been left
  alone ends up in the migration's critical path.
- A plan whose increments deliver nothing until the last one.
