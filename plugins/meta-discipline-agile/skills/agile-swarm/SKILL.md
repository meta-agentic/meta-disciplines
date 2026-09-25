---
name: agile-swarm
description: "Use when orchestrating multiple stories in parallel, planning a sprint swarm, running multi-agent backlog execution, or whenever asked to 'spawn a swarm', run 'multi-lane' / 'parallel lanes', or 'burn' through a sprint. Groups dependency-free backlog items into independent vertical-slice lanes across distinct codebases, spawns worktree-isolated leads as one team, persists the batch across sessions, and enforces the discipline gates (one-story-one-branch, foreground clean-verify, tracker sync, independent review, PO-owned merges); emits a lane ledger. The per-story ceremony rules are agile-process's; sizing a lane is story-estimation's."
---

# Agile Swarm Orchestration

Turning a sprint backlog into **N independent parallel lanes** is a discipline, not a
throughput trick: the practitioner's real work is proving *before spawning* that the lanes
cannot collide, and proving *after spawning* that each lead actually got the isolation it
was promised. Distilled from a real platform run, where both of those checks caught
failures that would otherwise have corrupted a shared checkout.

**Pipeline model.** Each lane is an independent *development pipeline* — a story flows
through fixed stages (branch → implement → clean-verify → review → PR → merge) and N lanes
run concurrently like the parallel pipelines of a superscalar CPU. Disjoint codebases keep
lanes **hazard-free** (no shared-file "data hazards"); cross-cutting work that would touch
many lanes is the hazard you serialize.

Each lane still runs [[skills/agile-process/SKILL|agile-process]]'s ceremony and transition
rules — that skill owns the per-story harness, this one owns the parallelism around it.
Lane sizing uses [[skills/story-estimation/SKILL|story-estimation]]'s axes: a lane must be
**low-intension at its boundary**, or the lanes interlock however disjoint their files are.

## Method

1. **Pre-flight before transitioning or spawning anything.** Pull a fresh `main` and
   `git fetch`; branch every lane off the latest. Reconcile tracker ↔ backlog read-only
   (the source of truth wins; treat only missing-either-side / status / estimate drift as
   real — label drift is noise). **Establish the tracker's write contract** — which
   tracker, and what tool writes to it (`config.tooling`, a connector, a vault CLI):
   reading an item shows its shape, not its rules. Refresh the code graph so leads query
   current structure, and ready the coordination layer if one is used.
2. **Plan the lanes** (`docs/LANE-PLANNING.md`). Pull the sprint's non-done items with
   status, priority and dependencies; keep the **dependency-ready** ones (verify stale or
   legacy dependency keys before trusting "blocked"); group them into lanes, one per
   distinct codebase, priority-ordered. **Present the proposal and get PO scope approval**
   as a single multi-select question — never auto-spawn.
3. **Persist the batch** (`resources/active-batch.template.md`) to a durable memory file
   with per-item checkboxes, so the run survives across sessions. Tick items as PRs merge;
   when all lanes are green, assemble the next batch from the remaining ready items.
4. **Spawn the leads** (`resources/lead-brief.template.md`) — **all in one message** so
   they form one team addressable by name, each `run_in_background` with worktree
   isolation, each lane's lead story transitioned to In-Progress first. Every brief's first
   step is to verify its own isolation and STOP if it is on a shared checkout, and to never
   `git add -A`. **Then run `git worktree list` yourself** — auto-isolation can silently
   fail and land a lead on the primary; pre-create a manual worktree for any lane that
   missed one. Then **stop and let them work — never poll**; they report back.
5. **Auto-review, steward, roll.** When a lane PR appears unreviewed, spawn a one-shot
   `reviewer-<N>` (never the author) that reviews the diff for correctness, security and
   conventions and posts its verdict; it never merges. Relay each PR to the PO, flip
   tracker states (In-Review on open, Done on merge) through the sanctioned write path,
   tick the batch on merge, and roll to the next batch — recording every lane in the ledger
   below.

**Optional engine plugin.** With `engines-enabled: true` in the pack config, a lane may hand
review, or low-intension implementation, to a worker engine through a multiplexer such as
meta-cli. The lead still owns the lane, verifies by diff and gate, and makes every commit and
tracker write. The rules are in `docs/GUARDRAILS.md` §Engine plugin. When the plugin is off,
none of this applies.

## The rigor standard

Full list and rationale in **`docs/GUARDRAILS.md`**. What this discipline *rejects*:

- **Parallelism is safe only when lanes don't touch the same files.** Group by distinct
  codebase/service, never by dependent chains inside one module. **Two candidate items
  sharing a module belong in the same lane** (one lead, sequential) — a shared file is a
  planning rejection, not a merge conflict to resolve later.
- **Isolation is verified, never assumed.** Auto-isolation fails silently; a lead on the
  primary checkout is stopped and re-spawned, not allowed to continue carefully.
- **The gate is `clean verify` (or equivalent), run FOREGROUND and time-bounded.** `clean`
  because branch switches don't wipe build output and stale cross-branch artifacts cause
  spurious failures. Never end a turn parked on a background build in a
  connection-bound session.
- **The host is shared, so every build is bounded.** A hard timeout and a free-disk floor
  kill the build's *whole* process tree, forks included, never just the launcher. Nothing
  waits on a background notifier. A Docker-free step is enforced below the config. Only one
  lane uses Docker at a time, and no lane starts or stops the container runtime
  (`docs/GUARDRAILS.md` §Lane runtime).
- **One story → one branch → one PR**, and the tracker state is pre-set in the code PR —
  never a standalone PR just to change issue state.
- **Independent review on every PR before merge** — a reviewer that is not the author,
  plus security review for auth/crypto/external-input changes. **The PO owns merges and
  sprint-close**; the orchestrator proposes scope and briefs, and does not make
  product-affecting calls.
- **Never `git add -A`** in a lane (explicit paths only), and gitignore the worktree root
  and tool dirs.
- **Stay current with `main`** — rebase in-flight lanes when it advances; don't discover
  drift at a red gate.
- **Out of scope:** per-story ceremony and transition mechanics
  ([[skills/agile-process/SKILL|agile-process]]) and item sizing
  ([[skills/story-estimation/SKILL|story-estimation]]).

## Checkable output

A **lane ledger**: one row per lane, recording what it owns, whether its isolation was
*verified* (not assumed), whether it overlaps any other lane's files, and the gate, review
and merge state. It is written at spawn time with the last three columns open, and closed
out as lanes land.

```
LANE  CODEBASE      ITEM  WORKTREE (verified)   OVERLAP           GATE (fg)       REVIEW        PR    VERDICT
1     svc-billing   A-40  ../wt/lane-1     ✓    none              clean verify ✓  reviewer-1 ✓  #212  merged (PO)
2     svc-identity  A-51  ../wt/lane-2     ✓    none              clean verify ✓  reviewer-2 …  #213  open — awaiting review
3     web-console   A-58  primary          ✗    none              —               —             —     REJECT — no worktree; re-spawn isolated
4     svc-billing   A-61  ../wt/lane-4     ✓    2 files w/ lane 1  —              —             —     REJECT — hazard; fold into lane 1
5     shared-libs   A-63  ../wt/lane-5     ✓    touches all lanes  —              —             —     SERIALIZE — cross-cutting; run after the batch
```

A batch ships only when every row reads `merged (PO)` and the batch file is ticked. A row
is a **rejection** when the worktree column is anything but a verified isolated path, when
OVERLAP is non-empty, when a gate was backgrounded rather than run foreground, or when the
reviewer is the lane's own lead — and a rejected lane is re-planned or re-spawned, never
waved through.

With the engine plugin on, the ledger gains `ENGINE` (worker and tier, or `—`), `RUN` (the worker
run id or ids) and `LEAD TOK` (the lead's own spend for the lane). A row is also a **rejection**
when a worker committed or moved HEAD, when the only evidence of success is a worker exit code,
or when the reviewer ran on the implementer's engine or was the lane's lead.

## When NOT to use this

A single story, a 1–2 line fix, or dependent work that all lives in one module — do it
directly with one lead under [[skills/agile-process/SKILL|agile-process]]. The swarm pays
off only with **3+ genuinely independent slices**.

**Cost note.** N parallel leads each run full gate cycles — token- and time-heavy. Scale
lane count to the budget; offer to start with the top-priority 2 and add lanes once
they're moving.

## Anti-patterns

- **Spawning before scope approval**, or spawning leads in separate messages — they stop
  being one team and can no longer address each other.
- **Assuming isolation held** because the spawn reported success. Verify with
  `git worktree list`; a silent failure puts two leads on one checkout.
- **Backgrounding the gate to keep lanes moving** — the run ends parked on an unfinished
  build and the lane's verdict is unprovable.
- **Splitting a shared module into two lanes** "carefully". The hazard is structural; care
  is not a substitute for disjointness.
- **The lead reviewing its own PR**, or the orchestrator merging — both collapse the
  independence the gates exist to create.
- **Polling the leads.** It burns budget and changes nothing; they report on completion or
  at the 10-minute no-progress STOP-and-report rule.

See also: `docs/GUARDRAILS.md` · `docs/LANE-PLANNING.md` · `resources/lead-brief.template.md`
· `resources/active-batch.template.md`.
