---
name: test-strategy
description: "Use when deciding WHAT to test and at WHICH level — designing a suite for a new service, judging an existing one, reacting to a defect that escaped to production, arguing about coverage targets, or when a suite is slow, flaky, or passing while bugs ship. Works risk-first: enumerate what can fail and what it costs, then buy evidence at the cheapest level that actually provides it, state explicitly what each level does NOT cover, and require an oracle per test. Not TDD — that is how to drive code from tests; this is which tests should exist at all."
---

# Test Strategy

A test suite is a purchase of evidence, and evidence has a price. The question is never
"do we have enough tests" but **which failures are we buying protection against, at the
cheapest level that genuinely provides it, and what are we knowingly leaving uncovered.**
Coverage percentages answer none of that. This skill sits above `tdd`: where that pack is
mounted it owns *how* to drive code from tests; this owns *which tests should exist*.

## Method

1. **Enumerate failures, not features.** List what can go wrong and what each occurrence
   costs: wrong money, corrupted data, silent data loss, an outage, an embarrassing but
   harmless glitch. Cost drives everything downstream — protection against a cosmetic
   defect and protection against silent financial corruption should not receive the same
   investment, and a strategy that treats them alike is miscalibrated by construction.
2. **For each failure, pick the cheapest level that yields real evidence.** Unit ·
   integration · contract · end-to-end · production (canary, shadow traffic, monitoring).
   "Cheapest" spans writing, running, *and* diagnosing: a failing unit test names the
   defect, a failing end-to-end test names a symptom and starts an investigation. **Push
   each failure down until the level stops being able to see it** — and no further, because
   a unit test cannot see an integration failure no matter how many you write.
3. **Name the oracle.** How does this test know it passed? An assertion on a real
   invariant, a golden value, a property, a comparison against a reference implementation.
   Where the domain has worked examples, let the key examples *be* the specification, so
   the test and the requirement cannot drift apart. **A test that only checks "no exception
   thrown" is smoke, and must be labelled as such** rather than counted as evidence.
4. **Write down what you are not testing, and why.** Every level has a blind spot, and the
   blind spots are where escaped defects come from. An unstated blind spot is
   indistinguishable from an oversight when the incident review happens.
5. **Set the release signal.** Which suite result permits a release; what happens on a
   flake; what the flakiness budget is. **A flaky test is either fixed or deleted** —
   retrying it converts the suite from evidence into ritual, and everyone learns to ignore
   red.
6. **Close the loop on escapes.** Every defect that reaches production is assigned to the
   level that should have caught it, and the strategy is amended there. A suite that never
   changes after an escape is not a strategy; it is a habit.

## The rigor standard

- **Risk-first, never coverage-first.** A coverage number is an input to a conversation, not
  a target; a suite at 90% that never exercises the money path is worse than an honest 50%.
- **Every test names its oracle.** No oracle, no evidence — label it smoke and stop counting
  it.
- **Every level states what it does not cover.** This is the part teams skip, and it is the
  part incident reviews need.
- **The pyramid is a consequence, not a goal.** Shape follows from pushing each failure to
  the cheapest level that can see it; if that yields a diamond or an hourglass for a
  particular system, that is the honest answer.
- **Flaky tests are defects.** Fixed or deleted, never retried, never annotated away.
- **Every escape updates the strategy** — a named level takes ownership, or the strategy has
  an admitted hole.
- **`tdd` and `diagnosing-bugs` are cited, not restated**, where the packs that own them are
  mounted.

## Checkable output

A **test-strategy ledger**: one row per failure with its cost, the level bought, why that
level is the cheapest that can see it, the oracle, and the blind spot accepted — followed
by the release signal and an escapes line.

```
FAILURE                        COST          LEVEL         WHY CHEAPEST                ORACLE                       NOT COVERED
tax rounded wrong              money, silent unit          pure fn, no I/O needed      42 worked examples from      rates changing upstream
                                                                                        finance = the spec
order accepted, never settled  money, silent integration   needs real outbox + broker  invariant: every accepted    broker partition >30s
                                                             semantics                   order settles within 5m
checkout 500s under peak       outage        production    load shape unreproducible   p99 < 800ms on canary,       cold-cache first minute
                                                             in CI at honest cost        auto-rollback on breach      after deploy
partner API contract drift     outage        contract      e2e would need their env    pact verified both sides     their undocumented
                                                                                                                     rate limit
button misaligned on mobile    cosmetic      none          cost < detection cost       —                            all of it, deliberately

RELEASE SIGNAL   unit+integration+contract green, canary clean 20 min. Flake budget: 0 —
                 quarantine deletes after 7 days unfixed.
ESCAPES (90d)    2 · both partition-related, both in the "broker partition >30s" blind spot
                 → integration level takes ownership; add a partition case. Strategy amended.
```

Ship only when every row has an oracle or is explicitly labelled smoke, and every level
names a blind spot. **Two failing readings:** a strategy where nothing is deliberately
untested is not a strategy but a wish; and an escape that no level will own means the hole
is still open — recording it is not closing it.

## Anti-patterns

- Chasing a coverage target, which reliably produces tests written to touch lines rather
  than to detect failures.
- End-to-end tests standing in for unit tests because they "test it properly" — slow,
  flaky, and they name a symptom instead of a defect.
- Unit tests over mocks so thorough that they verify the mocks, and pass while the
  integration is broken.
- Tests with no oracle beyond "it didn't throw", counted as evidence in a coverage report.
- Retrying, quarantining indefinitely, or `@Ignore`-ing flaky tests until red means nothing.
- Testing what is easy to test — the pure formatting helper — while the money path is
  covered only by hope.
- Filing an escaped defect as a one-off fix and never asking which level should have caught
  it.
- Copying another team's pyramid shape as a target rather than deriving it from this
  system's own failures.
