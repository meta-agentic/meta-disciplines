---
name: decision-records
description: "Use when an architectural or technical decision is being made, revisited, or has quietly happened without being written down — choosing a datastore, a protocol, a framework, a boundary, a migration path, or reversing one of those. Records it as an ADR with the forces, at least two genuinely considered alternatives and why each lost, the consequences including accepted costs, and the observation that would reopen it. Also use when asked 'why is it built this way', when a decision keeps being re-litigated, or when superseding an earlier record. Not for reversible or local choices — most choices are not decisions."
---

# Decision Records

A decision record exists so a future reader — often the author, two years on — can tell
whether a choice is still valid **without re-running the argument**. That requires three
things most write-ups omit: the alternatives that lost and why, the costs knowingly
accepted, and the observation that would make the decision wrong. A record with none of
those is an announcement.

## Method

1. **Decide whether this is a decision at all.** Record it only if it is **hard to
   reverse**, **crosses a team or service boundary**, or is **expensive to re-litigate**
   (it has come up twice already). Everything else is a choice: make it, and move on. A
   log that records every choice is a log nobody reads, which is the same as no log.
2. **Write the context as forces, not narrative.** The constraints in tension — latency
   budget, team skills, operational burden, compliance, deadline, existing estate. A
   reader must be able to see *why the decision was hard*. If nothing is in tension,
   return to step 1.
3. **Record at least two real alternatives, each with the reason it lost.** Real means it
   was genuinely viable — a straw man weakens the record and misleads the future reader.
   The losing reason must reference a force from step 2, not a preference. **An ADR with
   no rejected alternative is not an ADR.**
4. **State consequences, including what you are accepting as cost.** What becomes easy,
   what becomes hard, what is now irreversible, what operational load is taken on. A
   consequences section with only benefits means the analysis stopped early.
5. **Name the reopening trigger.** The concrete observation that would invalidate this
   decision: a load threshold crossed, a vendor exit, a team size change, a benchmark
   regressing. Without one, the record is a belief with a date on it — and nobody will
   ever know when to revisit it.
6. **Set status and keep the history immutable.** `proposed → accepted → superseded`
   (or `rejected`). **Never edit the decision in an accepted record** — write a new one
   that supersedes it and link both ways. The value of the log is that it shows how
   thinking changed; editing destroys exactly that.
7. **File and link it.** Store under `config.adr_home` in `config.adr_format`, numbered
   sequentially, and link it from the code or component it governs so a reader arrives at
   the record from the thing that puzzled them. Then emit the ledger row.

## The rigor standard

- **No rejected alternative, no record.** The alternatives are the content; the decision
  is the conclusion.
- **Consequences must include a cost.** A record listing only upside was written to
  justify, not to inform.
- **Accepted records are immutable.** Corrections supersede; they never rewrite. Status
  changes are the only permitted edit.
- **Every record carries a reopening trigger** — an observation, not a review date. "Revisit
  in 6 months" is a calendar entry, not a trigger.
- **Written when the decision is made**, not reconstructed after shipping. A retroactive
  ADR must say so in its status; laundering a fait accompli as deliberation is the failure
  mode that discredits the whole log.
- **Reachable from the code it governs.** An unlinked record is a record nobody finds at
  the moment they need it.
- **Scarcity is the discipline.** If the log grows faster than roughly one record a
  fortnight on an ordinary team, step 1 is not being applied.

## Checkable output

A **decision ledger**: one row per record with its status, the alternatives that lost, the
cost accepted, the reopening trigger, and the supersession chain. The individual ADRs are
the artifact; the ledger is what makes the set auditable — it is where a decision with no
trigger, or a superseded record still cited, becomes visible.

```
ID    STATUS      DECISION                 ALTERNATIVES REJECTED (why)          ACCEPTED COST            REOPENING TRIGGER
0007  superseded  Postgres for event log   Kafka (ops burden, 2 eng team)       write amplification      >5k events/s sustained
                  → superseded by 0019     DynamoDB (no rich query)
0012  accepted    gRPC between core svcs   REST/JSON (payload size at 12kB)     no browser calls without  a browser client needs
                                           GraphQL (no streaming)               a proxy layer             direct access
0019  accepted    Kafka for event log      stay on Postgres (0007 trigger hit   ops burden: on-call now   sustained <1k events/s
                  supersedes 0007          at 6.2k/s), Kinesis (vendor lock)    owns a broker             for two quarters
0021  proposed    Split billing service    keep monolith (deploy coupling),     distributed transactions  reviewed at design
                                           shared library (version skew)        across two stores         review, not yet accepted

INTEGRITY   records without a rejected alternative: 0   ·   without a reopening trigger: 0
            accepted records edited after acceptance: 0 ·   superseded records still referenced in code: 1 → fix
```

Ship a record only when its alternatives, cost, and trigger are all present. The INTEGRITY
line is the failing reading: **any non-zero count is a defect in the log**, not a
statistic — including the last one, where code still points at a decision that has been
replaced.

## Anti-patterns

- The ADR as design document: pages of description, no alternatives, no cost, nothing a
  future reader can act on.
- Retroactive records written to make a decision already shipped look deliberate.
- "We chose X because it is better" — better than what, against which force?
- Editing an accepted record when the decision changes, erasing the reasoning that a
  reader most needs.
- A review date instead of a reopening trigger; the date passes, nobody knows what to
  check, the record stands forever.
- Recording every technology choice until the log is unreadable and the real decisions are
  buried among them.
- Records filed where the code never points, discovered only by someone already searching
  for them.
