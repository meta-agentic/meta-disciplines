---
name: agile-process
description: "Use for ANY backlog, sprint, ceremony, story-transition, retrospective, or 'how do we do X in our process' task — adding or refining items, implementing a story under the branch/PR gates, opening or closing a sprint, writing a daily retro, seeding a new service, taking in an issue filed in a public repository's tracker. Carries the backlog model (a monolith mirror or a per-item store, driven by a declared <tooling> CLI), the ceremony procedures, the script & hook catalog, and the agentic operating model, and emits a transition ledger. Sizing belongs to story-estimation; running several stories at once belongs to agile-swarm."
---

# Agile Process

The **harness**: the discipline that keeps a backlog of record trustworthy when agents,
not only people, move items through it. A practitioner here does not "update the ticket" —
they make each state change *evidenced*: written through the one sanctioned write path,
stamped with the sprint, tied to exactly one branch, and reconcilable afterwards by
someone who wasn't there. Load it whenever you do process work, and follow the relevant
reference so the ceremony isn't re-derived each time.

Sizing is [[skills/story-estimation/SKILL|story-estimation]]'s (it owns the number and its
audit trail; this skill only demands one at DoR). Running N stories concurrently is
[[skills/agile-swarm/SKILL|agile-swarm]]'s (it owns lane planning and isolation; every lane
still obeys the rules below).

## Configuration & profile (read first)

This pack is **parameterised** — it carries the method, your instance carries the choices.
Resolve config from the instance's `.packs.yaml` before acting (`scripts/packs.sh config
agile` prints the resolved values):

- **`config.profile`** (`scrum` default | `kanban`) — selects the methodology. Load the
  active profile's conventions from `profiles/<profile>.md`; it sets the authority order,
  flow, gates, and cadence. **The procedures below are the `scrum` profile.** Under
  `kanban`, follow `profiles/kanban.md` and use only the transition/hygiene procedures
  here, skipping the sprint/ceremony ones.
- **`config.tracker`** (`jira` | `local` | `none`), **`config.space`**,
  **`config.mirror-repo`** — resolve the `<space>` / mirror-repo placeholders. With
  `tracker: local` the mirror *is* the top authority (no external tracker); with
  `tracker: none` there is no backlog file. `tracker: local` splits further on
  **`config.backlog-layout`**: `monolith` (one tracker-derived file) or `per-item` (one
  file per work item, e.g. `<mirror-repo>/<space>/{raw,wiki,output}/<KEY>.md`). **The
  procedures in `references/ceremonies.md` and `references/backlog-and-reconciliation.md`
  describe `per-item`**; a `monolith` instance keeps the ceremony *names* and adapts the
  tool calls to whatever `config.tooling` points at.
- **`config.sprint-files`**, **`config.tooling`**, **`config.ceremony-home`**,
  **`config.spaces`** — `per-item`-only keys: the sprint-record path template, the CLI
  that mutates the backlog, where retro/standup/planning records live, and the space keys.

An instance may override any single convention without switching profiles — see
"Overrides" in the pack README.

## Method

1. **Resolve config and the active profile, then read the state — don't assume it.**
   Query the item through `config.tooling` (or the tracker) rather than a memory of it;
   `<tooling> validate` before trusting a backlog file you are about to act on.
2. **Establish the write contract before any state change.** Which authority owns this
   item, and what tool writes to it. Reading an item shows its shape, not its rules;
   inferring the write method from the data is how a shared backlog gets corrupted.
3. **Work that originates outside the backlog enters only through intake.** An issue in
   a public repository's tracker — filed by us or by a stranger — is triaged on the public
   side, deduplicated against the backlog, and only then minted
   (`references/issue-intake.md`). The public side never carries a key; the item carries
   the issue's URL, so the join lives on one side by construction.
4. **Run the ceremony from its reference, not from memory** — new story, implement a
   story, transition, open/close sprint, daily retro/standup (`references/ceremonies.md`).
   Under `kanban`, the sprint-bounded ones don't exist; the transition ones still do.
5. **Move the story through the gates in order** — one branch for one story, the pre-push
   gate green before the push, the PR drafted only while a review agent is in the loop,
   and every status move stamped with the current sprint through `config.tooling`.
6. **Record the transition in the ledger below**, then reconcile: tracker and mirror agree,
   or the tracker wins. An item stuck `In Progress` across two sprints is a re-estimation
   trigger — hand it to [[skills/story-estimation/SKILL|story-estimation]], not a nag.

## References — load the one you need

| File | Covers |
|------|--------|
| `references/backlog-and-reconciliation.md` | Source of truth, system entry points, the per-item shape + tiers, status vocabulary (incl. `NO GO`), labels policy, `<tooling>` reference. |
| `references/ceremonies.md` | DoR/DoD, new story, implement a story, **sprint-on-transition**, **one-story-one-branch**, **draft-PR**, status transitions, open/close sprint, **daily retro/standup rolling cadence**, commit rule. |
| `references/new-service.md` | Design swarm (perspectives → consensus → ADR+spike+trace) and the 5-epic microservice skeleton + mandatory tenancy-adoption story. |
| `references/scripts-and-hooks.md` | Catalog of `<tooling>` + the per-item schema gate, remaining Bash/PreToolUse hooks (what each enforces + bypass), and what a monolith→per-item migration retires. |
| `references/agentic-operating-model.md` | Claude Code in the loop: which agents/skills for refinement, architecture, implementation, DoD, review stewardship, long-running & local-bounded sessions, staying current with `main`. |
| `references/issue-intake.md` | Work that originates in a **public repository's tracker**: the asymmetric public/private boundary, the triage gate and where a decline lives, one-sided linkage (`external:` on the item, nothing on the issue), classifying third-party issues, closing the loop (`Closes #n` vs manual), the dedup rule, and the named exceptions to the ordinary ceremony (public branch names, key-free PRs, the DoD line). Adds the **intake row** to the ledger. |

## The rigor standard

Mirrored always-on in the instance's CLAUDE.md — these are what the harness *rejects*, not
advice:

- **Authority order is absolute:** `<tracker>` (project `<space>`) → the backlog mirror →
  this skill → CLAUDE.md invariants. On any state conflict the **tracker wins** (under
  `tracker: local`, the mirror is that top authority). A skill or a note never overrules it.
- **The declared `config.tooling` is the only backlog write from a code PR.** A
  hand-edited mirror file is a rejection *even when the resulting state is correct* — an
  unwritten-through change is unreconcilable later.
- **Sprint-on-transition.** Every status move stamps the current sprint (the `sprint`
  field, `customfield_10020` under `tracker: jira`). An unstamped move is not a transition.
- **One story → one branch.** Never bundle a second story, or an incidental fix found
  mid-flight — file it and branch it separately.
- **A public surface never carries a key.** Issue text, PR title and body, commits, branch
  names, comments: an item key, sprint id or decision-record id in any of them is a
  rejection, and history makes the leak permanent. The join lives in the item's `external:`
  field (`references/issue-intake.md`).
- **Pre-push gate green before every push** (`mvn verify` or the estate's equivalent); a
  red root build never reaches the remote.
- **Draft only while a review agent is reviewing** — so it isn't merged mid-review; with
  the PO as sole reviewer and no agent running, open it ready.
- **PO-only sprint close**, and **multi-tenancy fail-closed** on every service.
- **Out of scope:** the estimate itself ([[skills/story-estimation/SKILL|story-estimation]])
  and parallel lane execution ([[skills/agile-swarm/SKILL|agile-swarm]]) — cite them, don't
  restate them.

## Checkable output

A **transition ledger**: one row per state change, recording what moved, whether the sprint
was stamped, the branch it belongs to, the path the write actually took, and the gate that
authorised it. Mandatory under `profile: scrum`; under `kanban` the SPRINT column drops and
the rest still applies.

```
ITEM   FROM → TO          SPRINT  BRANCH                 WRITE PATH             GATE            VERDICT
A-21   Ready → InProg     S-14 ✓  feat/A-21-quota-api    <tooling> transition   n/a (start)     ok
A-22   InProg → InReview  S-14 ✓  feat/A-22-tenant-hdr   <tooling> transition   verify green    ok
A-23   InReview → Done    S-14 ✓  feat/A-23-cache-ttl    mirror hand-edited     verify green    REJECT — written outside <tooling>
A-24   Ready → InProg     — ✗     feat/A-21-quota-api    <tooling> transition   n/a             REJECT — no sprint stamp; second story on A-21's branch
A-19   InProg → InProg    S-14 ✓  feat/A-19-billing      <tooling> transition   verify green    REPOINT — carried a second sprint (→ story-estimation)
```

Ship the ceremony only when every row reads `ok`. A row is a **rejection** when the write
path is anything but `config.tooling`, when the sprint cell is empty under `scrum`, or when
a branch appears against two items — and the ledger records the rejection rather than the
corrected state, so the reconciliation is auditable afterwards.

## Anti-patterns

- **Editing the mirror by hand because the tool is slower.** It produces the right state
  and an unreconcilable history; the next reconciliation cannot tell your edit from drift.
- **Transitioning first and branching later** — the sprint stamp then belongs to no branch,
  and one-story-one-branch cannot be checked after the fact.
- **Carrying an incidental fix on the story's branch** "since it's tiny". It makes the PR
  unreviewable against its item and the ledger row untrue.
- **Re-deriving a ceremony from memory** instead of loading its reference — the drift is
  silent and lands in the backlog of record.
- **Nagging a stuck item.** Two sprints `In Progress` is an estimation signal; asking for a
  status update produces a status update, not a smaller item.
- **Restating sizing or swarm rules here** instead of citing the sibling skill — a second
  copy of a discipline diverges, and the divergence is silent.
