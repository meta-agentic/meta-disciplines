---
name: performance-engineering
description: "Use when something is too slow, won't scale, or a latency/throughput target must be met or proven — sizing before launch, diagnosing a regression, judging whether an optimization is worth keeping, reading a load test, or answering 'can this handle N users'. Requires a workload model and a percentile target before any number means anything, locates the saturated resource by measurement rather than intuition, does the Little's-law and Amdahl arithmetic before profiling because it often ends the investigation, reads utilization through queueing rather than linearly, and reverts any optimization that did not move the target measure."
---

# Performance Engineering

Performance work goes wrong in a consistent way: someone optimizes the part of the system
they find interesting, ships it, and reports that it is faster — with no workload model, no
saturated resource identified, and no measurement that the target moved. The discipline is
mostly **arithmetic and measurement discipline applied before any code changes**, and it
frequently ends with the conclusion that the code was never the problem.

## Method

1. **State the goal as a workload plus a percentile.** Arrival rate, request mix,
   concurrency, duration — then the target: *"p99 < 800 ms at 2,000 req/s sustained for 30
   minutes, with the production request mix."* **A mean-latency target is not a target**:
   averages hide precisely the tail that users experience and that queues produce. Without
   a workload model, any number that follows is unfalsifiable.
2. **Locate the saturated resource by measurement.** Walk resources with **USE**
   (utilization, saturation, errors) and services with **RED** (rate, errors, duration).
   CPU, memory, disk, network, locks, connection pools, thread pools, and the downstream
   services each count as a resource. **Optimization only pays at the saturated resource**;
   everywhere else it buys nothing and costs complexity.
3. **Do the arithmetic before profiling — it often ends the investigation.**
   **Little's law**, `L = λW`: concurrency in flight equals throughput × latency. Needing
   2,000 req/s at 800 ms means ~1,600 requests in flight; if the pool caps at 200, the pool
   is the answer and no profiler was required. **Amdahl** bounds the payoff: a component
   that is 20% of total time caps the whole speedup at 1.25× even if you make it
   instantaneous. Compute the ceiling first, and abandon work whose ceiling is not worth
   having.
4. **Read utilization through queueing, not linearly.** Waiting time grows non-linearly as
   utilization approaches saturation — the knee is real, and it is why "CPU is only 80%, we
   have headroom" is wrong. A resource at 80% carries several times the queueing delay of
   the same resource at 50%. **Variability matters as much as the mean**: bursty arrivals
   and high service-time variance produce queues at utilizations that look comfortable in a
   dashboard.
5. **Change one thing, with a predicted magnitude.** Every optimization is a hypothesis
   carrying a number from step 3 — *"this should take p99 from 1.4 s to ~900 ms"*. Then
   measure against the same workload. Running `config.load_test_command` where the estate
   has one; where it does not, report the numbers as unvalidated rather than presenting a
   local benchmark as a production result.
6. **Keep only what moved the target; revert the rest.** An optimization that did not shift
   the measure is reverted even when it "should" have helped — that is how the code stays
   comprehensible, and how the ledger stays honest. A prediction that missed badly is
   information: the model of the system was wrong, so return to step 2.
7. **State what the speed cost.** Memory, complexity, cache staleness, correctness risk,
   operational surface. Then record: measurable targets become scenarios for
   [[skills/architecture-tradeoffs/SKILL|architecture-tradeoffs]], irreversible choices
   become ADRs via [[skills/decision-records/SKILL|decision-records]], and a cache
   introduced as a fallback is a degradation contract for
   [[skills/resilience-review/SKILL|resilience-review]].

## The rigor standard

- **No workload model, no number.** A latency figure without arrival rate, mix, and
  duration describes nothing reproducible.
- **Percentiles, never means**, and the tail is reported — p99 and p99.9, not p50.
- **The saturated resource is identified by measurement before any code is edited.**
  Intuition about bottlenecks is wrong often enough that acting on it is a coin flip with
  a maintenance bill.
- **Ceiling arithmetic precedes profiling.** Little's law and Amdahl are cheap and
  frequently decisive; skipping them is how weeks go into a 1.25×-capped component.
- **Every change carries a predicted magnitude** before it is measured. Prediction is what
  makes the result falsifiable rather than decorative.
- **Unmeasured or unmoved optimizations are reverted**, not kept on the grounds that they
  ought to help.
- **The measurement environment is stated**, along with how it differs from production —
  warm caches, absent neighbours, uniform arrivals. An unstated environment invalidates the
  comparison rather than merely weakening it.
- **Utilization is never read linearly**; a headroom claim that ignores the queueing knee is
  a finding.

## Checkable output

A **performance ledger**: the workload and target, the saturated resource with its
evidence, the ceiling arithmetic, then one row per change with its prediction, its measured
result, the keep-or-revert verdict, and what the speed cost.

```
TARGET     p99 < 800ms @ 2,000 req/s sustained 30min, production mix (70% read / 30% write)
ENVIRONMENT  4× c6i.2xlarge, prod-shaped data, bursty arrivals replayed from prod trace.
             Differs from prod: no cross-region reads, no noisy neighbours.

BOTTLENECK  USE walk → db connection pool: utilization 99%, saturation 340 queued, errors 0
            RED → orders p99 1,420ms, rate 2,000/s, errors 0.02%   (CPU 41%, net 12% — not it)

CEILING     Little's law: 2,000/s × 0.8s ⇒ ~1,600 in flight; pool = 200 ⇒ hard cap ~250/s
            Amdahl: JSON serialization is 6% of time ⇒ max whole-system gain 1.06×, ignore it

CHANGE                        PREDICTED        MEASURED           VERDICT   COST PAID
pool 200 → 800                p99 ~900ms       p99 880ms ✓        KEEP      +2.4GB db conns,
                                                                             db CPU 38%→71%
batch the settle-writes       p99 ~800ms       p99 790ms ✓        KEEP      settle lag 0→1.5s
                                                                             (see resilience)
hand-rolled JSON serializer   p99 ~830ms       p99 878ms (noise)  REVERT    would have added
                                                                             400 lines, Amdahl said so
read replica for reports      p99 ~700ms       p99 881ms ✗        REVERT    prediction wrong →
                                                                             model was off, back to step 2

HEADROOM   pool now 71% utilized — NOT 29% spare. At the queueing knee, arrival +15% is
           projected to put p99 back over target. Next constraint is db CPU, not the pool.
```

Ship only when the workload and environment are stated, the saturated resource is evidenced,
the ceiling arithmetic appears, and every row has a prediction *and* a measurement. **The
failing readings:** an optimization kept with no measured delta; a target expressed as a
mean; profiling that started before the arithmetic; and a headroom claim computed linearly
from utilization.

## Anti-patterns

- Optimizing the component that is interesting to work on rather than the one that is
  saturated — the most common form of performance work, and the least effective.
- A mean-latency SLO, which is satisfied by a system that is unusable for the slowest 5% of
  requests.
- Skipping the arithmetic and profiling straight into a component Amdahl caps at 1.06×.
- "We're only at 80% utilization, so we have 20% headroom" — the queueing knee makes that
  claim wrong in the direction that hurts.
- Benchmarking with warm caches, uniform arrivals, no competing traffic, and reporting the
  result as a production capacity figure.
- Adding a cache before locating the bottleneck: it buys an unmeasured speedup and spends
  staleness, and it is usually the thing that later fails silently.
- Keeping an optimization that showed no measured improvement because it "must" be faster.
- Treating a badly missed prediction as noise rather than as evidence that the model of the
  system is wrong.
