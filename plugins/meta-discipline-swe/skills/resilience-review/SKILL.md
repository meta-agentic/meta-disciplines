---
name: resilience-review
description: "Use when deciding or reviewing what a system does when something it depends on is slow, down, or wrong — adding a retry, a timeout, a circuit breaker, a cache fallback, a queue; reviewing a service before it takes production traffic; after an incident where one failure cascaded; or when asked 'is this resilient'. Declares a degradation contract per dependency, bounds everything that waits or grows, checks idempotency before permitting any retry, maps blast radius, and requires each contract to be exercised by injected failure rather than assumed. Not a pattern catalogue: the judgment is what degraded behaviour is intended, and proving it happens."
---

# Resilience Review

Resilience is not a library. Adding a circuit breaker to a call that had no declared
behaviour just moves an unowned decision behind an abstraction. The discipline is
narrower and harder: **for every dependency, decide what the system does when it is
unavailable — then prove that is what actually happens.** The characteristic failure is
not a missing pattern; it is a dependency whose failure behaviour nobody ever decided, so
the default took over, and the default is cascade.

## Method

1. **Enumerate every out-of-process dependency and what its loss costs.** Databases,
   brokers, third-party APIs, other services — and the ones that go unlisted until they
   fail: config server, auth provider, secrets store, DNS, object storage, disk, the
   clock. A dependency absent from this list has an implicit contract of "cascade".
2. **Declare a degradation contract for each.** When it is slow, down, or returning
   nonsense, does the caller *fail fast*, *serve stale*, *queue and settle later*,
   *shed the feature*, or *block*? **"Unspecified" is the defect** — write it down as a
   finding, not as a gap to fill in later. Serving stale additionally requires a staleness
   bound and a signal, or degraded becomes indistinguishable from correct.
3. **Bound everything that waits or grows.** Timeouts, retries, queues, connection and
   thread pools. **Timeout budgets must strictly decrease down the call chain** — a caller
   whose timeout exceeds its callee's guarantees threads pile up under the exact conditions
   the timeout existed to survive. An unbounded queue is not a buffer; it is a deferred
   outage with worse latency.
4. **Check idempotency before permitting any retry.** Retrying a non-idempotent operation
   converts an availability problem into a **correctness** problem — the money moves twice.
   Retry only where the operation is naturally idempotent or carries a deduplication key,
   and always with a budget and jitter; synchronised retries are how a blip becomes an
   outage.
5. **Map the blast radius — what shares fate?** A shared pool, database, thread pool, or
   deploy unit means one dependency's failure is several features' failure. Bulkheads
   exist to make fate-sharing a decision rather than an accident. State which failures are
   *contained* and which are *shared*, explicitly.
6. **Exercise it, or it is a hypothesis.** Inject the failure — kill it, partition it, add
   latency — and observe. Run `config.fault_injection_command` where the estate has one;
   where it does not, say plainly that the contracts are unexercised rather than reporting
   them as verified. **The degraded state must be visible in monitoring**, or nobody on
   call can tell degraded from broken, and the fallback hides the incident instead of
   surviving it.
7. **Record and hand off.** Contracts that are expensive to reverse become ADRs via
   [[skills/decision-records/SKILL|decision-records]]; measurable availability scenarios
   belong in [[skills/architecture-tradeoffs/SKILL|architecture-tradeoffs]]; the level at
   which each failure test runs is [[skills/test-strategy/SKILL|test-strategy]]'s call.

## The rigor standard

- **Every dependency carries a declared contract.** Unspecified is a finding, and the
  finding is "this cascades", because that is what will happen.
- **Timeout budgets decrease along the call chain**, and the ledger shows the arithmetic.
- **No retry without idempotency evidence**, a budget, and jitter. Evidence means a dedup
  key or a genuinely idempotent operation — not an assurance that it is "probably safe".
- **Nothing that waits or grows is unbounded.** Queues, pools, and retry loops all name
  their limit and what happens at it.
- **A contract that has never been exercised is a hypothesis** and must be labelled as
  one. Resilience is a claim about behaviour, and behaviour is observed, not designed.
- **Degraded must be observable.** A fallback with no signal converts an outage into
  silent wrongness, which is worse.
- **Claims name a failure.** "The system is resilient" is unfalsifiable; "survives the
  payment provider being down for 10 minutes, with orders queued and settled after" is
  reviewable.

## Checkable output

A **failure-mode ledger**: one row per dependency with its declared behaviour, its bounds,
whether retry is permitted and why, what shares its fate, and whether the contract has
actually been exercised and is visible when it fires.

```
TIMEOUT BUDGET   edge 3000ms > api 2500ms > orders 2000ms > payments 800ms > db 400ms   ✓ decreasing

DEPENDENCY      LOSS COSTS      DECLARED BEHAVIOUR        BOUNDS              RETRY?           BLAST RADIUS      EXERCISED
payment gw      money, visible  queue + settle later      800ms, q≤10k        yes: dedup key   contained         ✓ 10-min kill,
                                                          3 tries, jitter     on order id      (own pool)          orders queued
order db        total outage    fail fast, 503            400ms, pool 20      no: writes not   shared: orders    ✓ failover, 8s
                                                                              idempotent       + admin read        of 503s
auth provider   total outage    serve cached token        60s cache, ≤5min    no               SHARED: every     ✗ never tested
                                until staleness bound     stale                                feature           → hypothesis
config server   silent drift    last-known-good on disk   n/a                 no               contained         ✓ startup w/o it
search index    degraded UX     shed feature, show        1200ms              no               contained         ✓ latency inject
                                "search unavailable"

INTEGRITY  unspecified contracts: 0 · retries without idempotency evidence: 0 · unbounded: 0
           unexercised contracts: 1 (auth provider — and it is the one with the widest
           blast radius) → not resilient to it; it is a plan
```

Ship only when every dependency has a row, the timeout budget decreases, and each retry
cites its idempotency evidence. **The failing readings:** any `UNSPECIFIED` behaviour, any
unbounded queue or pool, any retry on a non-idempotent operation, and any unexercised
contract — which is a hypothesis wearing a contract's clothes, and most dangerous exactly
where the blast radius is widest.

## Anti-patterns

- Wrapping a call in a circuit breaker without deciding what the open state should *do*,
  so the library returns an error nobody designed and the caller cascades anyway.
- Retrying a non-idempotent write, converting a brief outage into duplicate charges — an
  availability fix that creates a correctness incident.
- Uniform retries with no jitter and no budget, so every client retries in lockstep and a
  recovering dependency is knocked over again by its own traffic.
- A caller timeout longer than its callee's, guaranteeing thread exhaustion under the
  conditions the timeout was added to survive.
- Calling an unbounded queue a buffer. It converts a short outage into a long one and adds
  a latency cliff nobody predicted.
- A silent stale-cache fallback with no staleness bound and no signal, so wrong answers
  look exactly like right ones and the incident is discovered by customers.
- Chaos experiments only in an environment that lacks the failure modes production has,
  then reporting the contracts as verified.
- "We're resilient" as a property of the system rather than a claim about a named failure
  that somebody has actually caused on purpose.
