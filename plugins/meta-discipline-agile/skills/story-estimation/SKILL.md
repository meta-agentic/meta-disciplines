---
name: story-estimation
description: "Use when sizing, pointing, re-pointing, or challenging an estimate on any backlog item — story, enabler, spike, or bug — and whenever a DoR check asks whether effort is estimated. Sizes on two axes, extension (how complicated) and intension (how complex), instead of time or gut feel, and prescribes an action per quadrant: do it, split by extension, time-box as a spike, or refuse to commit until the intension is split out. Emits an auditable estimate ledger. Load it before naming a number, and when an item is stuck In Progress across sprints."
---

# Story estimation — the complicated/complex quadrant

Estimation is where a backlog stops being a wish list. This skill makes a number
**re-derivable by someone else** instead of an opinion you have to trust.

**Story points are not time.** Not hours, not days, not "how long for me". Time is at
best a downstream consequence of size, and it says nothing about *why* an item is big —
which is the only part of an estimate that is actionable. Relative comparison ("this is
like that other one") helps, but on its own it just defers the question to whichever
anchor you happened to pick.

Size on **two axes**. They are the classical **extension / intension** pair from logic,
and they map onto **complicated vs complex** — two words routinely used as synonyms that
mean opposite things.

## Method

### Axis 1 — Extension: how *complicated*

**How many parts.** A complicated system has many parts, but they are **independent** —
remove a car seat and the car still drives. Cause and effect are knowable by analysis:
**known unknowns**, resolved by *sense → analyse → respond*. **Divide-and-conquer works.**

In estimation terms: how many files, modules, services, repos, or backlog spaces must
change. **Countable, additive, and safe to decompose.**

### Axis 2 — Intension: how *complex*

**How much is undefined.** A complex system has **interconnected** parts — remove the
engine belt and nothing works; interactions grow exponentially with the number of parts.
Cause and effect are visible only in retrospect: **unknown unknowns**, resolved by
*probe → sense → respond*. **Divide-and-conquer fails.**

In estimation terms: how much of the *definition* is still open — contracts to invent,
semantics to decide, irreversible choices, feedback loops with other in-flight work.
**Not additive — it multiplies risk.**

> The logical roots are the same distinction. A concept's **extension** is the class of
> things it covers (broad, shallow — "Entity" covers everything and tells you nothing
> about anything); its **intension** is the defining content (narrow, deep). A backlog
> item is the same object: how *wide* it reaches versus how much *meaning* is still
> undetermined.

### The quadrant

Both axes run **−1 → +1** (low → high), origin at the centre, so a placement is a point,
not a bucket: *"moderately complicated, very complex"* is expressible and
`(+0.9, +0.2)` is visibly not `(+0.2, +0.9)`. Bands below are the `fibonacci` default;
see **Configure**.

| | **Low extension** (x < 0) | **High extension** (x > 0) |
|---|---|---|
| **High intension** (y > 0) | **Complex** — one place, answer unknown → **5** | **Complex + broad** → **8** |
| **Low intension** (y < 0) | **Simple** — known change, one place → **1–2** | **Complicated** — known change, many places → **3–5** |

Within a cell, position sets the band: intension carries roughly **twice** the weight of
extension, because that is what delivery history shows (see *Calibrate*). The derived
number is **advisory** — the team sets the points. The plot's job is to make the reasoning
auditable, not to compute an answer.

### The prescription (why a quadrant beats a number)

Each cell says **what to do**, not just what to write in the field:

- **Simple** — just do it. If it needs a discussion, it isn't simple.
- **Complicated** — a large number here means **split by extension**, not estimate up.
  Divide-and-conquer is valid in this quadrant; use it. *An 8 that is purely extensional
  is a planning failure, not a big item.*
- **Complex** — **time-box it as a spike.** The deliverable is a decision or a discovery,
  not a feature. Never commit an open-ended complex item to a sprint.
- **Complex + broad** — **do not commit unsplit.** Split the intension out first (usually
  a design pass or an ADR); once the definition is settled, the remainder is *merely
  complicated* and decomposes by extension.

**Predicted failure mode.** An item in the complex+broad cell that is committed unsplit
sits `In Progress` across sprint boundaries with real commits landing and no completion —
its extension keeps moving while its intension is still being decided. **An item stuck
across two sprints is a re-estimation trigger, not a nagging trigger.**

### The pass — one item, in order

1. **Place it on both axes before naming a number**, and write the placement into the
   item: *"high extension (4 repos), low intension (known pattern)"*. An estimate whose
   axis placement isn't recorded is not auditable and cannot be re-derived later.
2. **Read the band off the quadrant**, then sanity-check against the nearest local anchor
   (see *Calibrate*).
3. **Apply the prescription.** High extension → split. High intension → spike. Both →
   split the intension out and do not commit the whole.
4. **Record the number** in the tracker's points field, mirrored into the backlog item.
5. **Point enablers, spikes and bugs too.** Unpointed work is invisible to velocity, and
   a handful of unpointed deliveries is enough to fake a downward velocity trend.

### Calibrate

The quadrant gives bands; **local anchors** give precision. Keep a short table of already-
delivered items with agreed points, placed on both axes, and estimate against it. Re-derive
it each sprint close — it drifts as the estate matures.

**Never proxy size by lines changed or file count.** Both correlate with extension only,
and extension is the axis that matters *least* once intension is high. A 100-line item
that invents a protocol routinely outweighs an 800-line item that applies a known pattern
in many places. Churn is a weak sanity check; it is never an input.

### Team estimation — planning & refinement

Planning poker with a two-axis ballot instead of a card deck. Same ceremony, strictly more
information: a card tells you *that* people disagree, a placement tells you **on which
axis**.

1. **Place blind, reveal together.** Each participant places one point; placements stay
   hidden until everyone is in. Anti-anchoring is the whole reason poker uses face-down
   cards — don't lose it.
2. **Consensus is the median *per axis*, then derive the number from the median point.**
   **Never take the median of the story points.** The same SP arises from different
   quadrants — one person's "complex, narrow", another's "complicated, broad" — so an SP
   median manufactures agreement out of two people who disagree about the nature of the
   work. Median (not mean) per axis, so one outlier can't drag the estimate.
3. **Different quadrants → mandatory repoint**, however close the numbers. The quadrants
   prescribe *different actions* — do it, split, spike, don't commit — and there is no
   useful average of "split it" and "spike it". Quadrant disagreement is a disagreement
   about what the work *is*, and it must be talked out before a number means anything.
4. **Same quadrant, wide spread on one axis → repoint that axis**, and say which:
   *"we agree it's broad, we disagree on how much is undefined."* That is an actionable
   prompt; *"you said 3, they said 8"* is not. Default trigger: range > **1.0** on either
   axis (half the full span) — see `estimation-repoint-threshold`.
5. **The two most distant placements on the disputed axis speak first**, then everyone
   re-places. Classic poker's high-and-low-explain rule, aimed at the axis that actually
   diverged.
6. **Record every round** — who placed where, per round, with the final agreed point. That
   *is* the estimate ledger below, multi-user: an estimate whose axis placements aren't
   recorded is not auditable, whoever produced it.

Converging on the point, not the number, is the reason to run it this way: the artefact of
the session is a shared *model of the work*, and the story points fall out of it.

## The rigor standard

- **Points are not time**, and time is never an input. An estimate expressed in days is a
  schedule guess wearing an estimate's clothes.
- **An estimate without a recorded axis placement does not exist.** The number is only the
  visible end of the reasoning; unrecorded, it cannot be re-derived or challenged.
- **The quadrant prescribes an action, and the action is binding**: complicated → split by
  extension; complex → time-box a spike; complex + broad → do not commit unsplit. An
  estimate that names a number but skips the prescription is half done.
- **Never proxy size by lines changed or file count** — both track extension only, which is
  the axis that matters least once intension is high. Churn is a weak sanity check, never
  an input.
- **Team consensus is per axis, never on the points.** An SP median manufactures agreement
  between people who disagree about the nature of the work; different quadrants force a
  repoint however close the numbers.
- **Everything sized, including enablers, spikes and bugs.** Unpointed deliveries fake a
  downward velocity trend.
- **Out of scope:** when an estimate is demanded, how it is recorded in the backlog of
  record, and what a stuck item triggers procedurally — that is
  [[skills/agile-process/SKILL|agile-process]]'s harness; this skill only produces the
  number and its audit trail.

## Checkable output

An estimation pass ships an **estimate ledger** a reviewer can audit:

```
ITEM    EXTENSION                 INTENSION                    QUADRANT       SP  PRESCRIPTION
A-12    low (1 module)            low (known pattern)          simple          2  do it
A-40    high (4 repos, 1 schema)  low (mechanical migration)   complicated     5  SPLIT by extension → 3 items
A-51    med (3 config levels)     high (contract undefined)    complex+broad   8  DO NOT COMMIT — spike the contract first
A-77    low (1 doc)               high (discovery is the goal) complex         5  time-box: 2 days
```

Under team estimation the ledger gains a round-by-round section — who placed where, per
round, with the final agreed point — so a multi-person estimate is auditable by whoever
wasn't in the room.

An estimate is **not done**, and the row is a **rejection**, while it:

- carries an **SP with a missing axis placement** (unauditable — the number is an opinion);
- sits in **complex+broad with a bare number** and no split/spike prescription;
- sits in **complicated with an 8** (should have been split);
- is an **enabler, spike or bug left unpointed**.

## Anti-patterns

- **Naming the number first and back-filling the axes** to justify it. The placement stops
  being evidence and becomes decoration.
- **Estimating up instead of splitting** a purely extensional item — an 8 in the
  complicated cell is a planning failure, not a big story.
- **Committing a complex+broad item because the sprint has room.** Its extension will move
  all sprint while its intension is still being decided, and it will not finish.
- **Averaging story points to reach agreement** — it hides a disagreement about what the
  work *is*.
- **Revealing placements as people go**, losing the anti-anchoring that face-down cards
  exist to provide.
- **Nagging a stuck item instead of re-estimating it.** Two sprints `In Progress` is the
  signal the original placement was wrong.

## Configure

Reads `packs.agile.config` (`scripts/packs.sh config agile`), config-first with these
fallbacks:

| Key | Meaning | Default |
|-----|---------|---------|
| `estimation-scale` | `fibonacci` (1·2·3·5·8) \| `t-shirt` (S·M·L·XL ≈ the four cells) \| `linear` (1–5) | `fibonacci` |
| `estimation-consensus` | `median` (per axis) \| `strict` (unanimous quadrant required) | `median` |
| `estimation-repoint-threshold` | per-axis range above which a repoint is called (axis span is 2.0) | `1.0` |

Under `profile: kanban` the bands still apply, but the *prescriptions* carry the weight —
there is no sprint to protect, so "do not commit unsplit" becomes "do not pull unsplit".

## Related

`[[skills/agile-process/SKILL|agile-process]]` — DoR requires an estimate; this skill is
how that estimate is produced. `[[skills/agile-swarm/SKILL|agile-swarm]]` — lane sizing
uses the same axes: a lane must be low-intension at the boundary, or the lanes interlock.

*Grounding:* [Cynefin framework](https://en.wikipedia.org/wiki/Cynefin_framework) ·
[Complexity](https://en.wikipedia.org/wiki/Complexity) ·
[Extension & intension](https://philosophy.institute/logic/logic-dynamics-extension-intension/) ·
[Mountain Goat — it's effort, not complexity](https://www.mountaingoatsoftware.com/blog/its-effort-not-complexity)
