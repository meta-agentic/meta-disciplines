# Guardrails — why each one exists

Hard-won from a real multi-agent run. Each rule traces to a concrete failure it prevents.

## Branch & build
- **One story → one branch → one PR.** A mixed branch can't be split after merge. An incidental fix discovered mid-flight gets its *own* branch/issue, not a piggyback (or explicit PO sign-off).
- **Gate runs `clean verify`, FOREGROUND, time-bounded.**
  - *`clean`*: git branch switches do **not** wipe per-module build output. Stale compiled classes from another branch get picked up and fail (or pass!) wrongly. Always build from source.
  - *Foreground + bounded*: in a connection-bound (remote-control) session, a backgrounded build whose completion notification is lost on disconnect leaves the session idle until a human returns. Run gates in the foreground with a timeout so each turn is self-contained; offload genuinely long jobs to CI.
- **Stay current with main**: pull fresh main per session and before each story; `git fetch` periodically; rebase in-flight branches when main moves — catch drift early, not at a red gate.
- **Worktree isolation per lead** keeps agents off the human's primary checkout (no IDE collisions) and off each other's files. **But auto-isolation can SILENTLY FAIL** — a lead may land on the primary checkout instead of a worktree (observed: 3 of 4 leads isolated, the 4th didn't, twice). Defenses:
  - Every lead's brief makes step 1 **verify isolation**: `git rev-parse --show-toplevel` + `git worktree list` — if it's the primary (or the human's) checkout, **STOP and report**, run no git command.
  - **Never `git add -A` / `git add .`** — stage explicit paths only. An un-isolated lead running `git add -A` on the primary sweeps sibling worktrees (as gitlinks) and tool dirs (e.g. `.diffblue/`) into the commit. **Gitignore the worktree root and tool dirs** as belt-and-suspenders.
  - Orchestrator: after spawning, **`git worktree list` to confirm each lead got one**; if a lane's isolation didn't take, **pre-create a manual worktree** and point that lead at it rather than respawning blindly.

## Compiler / toolchain traps (language-specific, generalize the habit)
- Don't re-pin a dependency the imported platform BOM already manages — a local override shadows it and drifts.
- Some flags are mutually exclusive (e.g. `--release` vs `--add-exports` on javac). Know the per-module wiring and centralize it once (e.g. a repo-root JVM config) rather than per-module gymnastics.
- A "warnings-as-errors" gate exposes latent rot (deprecations) only on a *clean* build — fix it as a separate tracked chore, don't bundle.

## Tracker hygiene
- **Pre-set the issue/backlog state inside the code PR**; never open a standalone PR just to flip status.
- **Reconcile is read-only by default**; the designated source of truth wins. Only missing-either-side / status / estimate drift is real — label drift is informational noise.
- **PO owns sprint-close and product-affecting calls.** The orchestrator proposes and briefs; it does not decide scope, merges, or closure.

### Find the tracker's write contract BEFORE the first status change
Reading an item tells you its **shape**, not its **contract**. Never infer how to change state from how the data looks: a hand-edit that produces a perfectly plausible-looking item can still violate an invariant enforced somewhere else — a folder-is-the-state rule, a required sprint stamp, a central id allocator, a transition graph. You find out in someone else's session, hours later.

Ask the PO, or find the tool, before writing. One question up front is cheaper than a corrupted shared tracker.

| Tracker | Where state lives | How to write it |
|---|---|---|
| **Local text backlog** (`backlog-layout: monolith`) | a single `backlog.json`-style file or markdown in the repo | Edit through the repo's own tool; its convention (schema, required fields) is the contract, not the file's shape. |
| **Jira** | The Jira project | Connector/API transitions. Fetch the available transitions for a sample issue first — **transition ids are per-project**, not global. |
| **Local vault** (markdown, folder-as-state) | `vault/<space>/{raw,wiki,output}/` | The vault's **own CLI**, atomically moving file + status + sprint stamp. The folder **is** the lifecycle state, so a hand-edited `status:` desynchronises it and a schema gate rejects the commit. Never hand-edit `status:`. |
| **Linear** | Linear workspace | API/connector. |
| **In-house tracker** | Project-specific | Treat the contract as **unknown** until documented. Ask. |

**Bulk edits are where this breaks.** Read-before-write guards usually live in the file-editing tool — and a shell one-liner across N items bypasses them entirely. The pull toward scripting is strongest exactly when you're touching many items at once, which is exactly when a wrong write method does the most damage. **If a change feels tedious enough to script, that is the signal to stop and confirm you're using the tracker's own tool.**

Corollary for shared trackers: if the backlog serves several projects or sessions, assume concurrency. Hand-picking an id "that looks free" races with everyone else — use the allocator.

## Review
- **Every PR gets an INDEPENDENT review before the PO merges.** The lane lead self-reviews before opening, but a separate reviewer agent (not the author) catches what the author missed. Wire it into the monitor: when a new lane PR appears with no review yet, spawn a one-shot `reviewer-<N>` that runs `gh pr diff N`, reviews for correctness + security (auth/crypto/input) + project conventions, and posts `gh pr review N` (--approve / --request-changes / --comment). The reviewer **never merges** — the PO owns the merge; the review is a signal.
- Don't double-review: skip a PR that already has a review from `reviewer-<N>`.

## Agent discipline
- Every lead brief carries the **10-minute no-progress rule**: if no verifiable progress for 10 min, STOP and report — never retry silently. The orchestrator does liveness checks on the same cadence.
- **Don't poll** after spawning — leads message back / complete automatically.
- Leads run on the capable model and consume the real budget — scale lane count to budget; don't fan out beyond what's affordable.

## Engine plugin (only when `engines-enabled: true`)

When the plugin is off, skip this section: every lane is the lead engine end to end. When it is
on, a lane may hand work to a **worker** engine through the multiplexer (`engines-bin`, e.g.
meta-cli). Each rule below comes from a real trial.

- **The lead keeps the lane.** Only `engines-lead` writes the brief, verifies, runs the gate,
  stages explicit paths, commits, opens the PR, and makes every tracker write. A worker runs as
  a subprocess **inside the lane's worktree** (`<bin> run -p <worker> -C <worktree>`). It never
  commits, pushes, checks out, or transitions an item, and its brief says so.
- **The brief is not the guard; the lead's check is.** An implementing worker runs with
  auto-approve, so "no git writes" in its brief is a promise, not a boundary. Before each worker
  run the lead records `git rev-parse HEAD` and the branch. After the run it checks that both are
  unchanged and that `git status` touches only the paths the brief allowed. A worker commit,
  branch switch, or out-of-scope write **rejects the lane**. The lead discards the worker's
  output and re-runs the step; it does not repair the result by hand. With that check the
  single-writer rule, one-story-one-branch and PO-owned merges hold.
- **Verify by diff and gate, never by exit code.** Exit codes mislead in both directions. One
  engine exited 0 after its sandbox refused the write; another exited 1 on a quota error
  *after* delivering complete, correct work. The verdict is `git diff` against the brief, plus
  the foreground gate.
- **What may leave the lead:**
  - *Tier 0, read-only work: review and research.* A worker with the `review` or `research`
    role, run **read-only** (never with an auto-approve flag). If the worker cannot run tools
    headless, put the diff or the sources in the prompt instead. Its output is advisory. A review
    verdict is a signal to the lead and the PO, and research lands in notes the lead reads. It
    never becomes a commit or a tracker write without passing through the lead. A different model
    is a *more* independent reviewer than a second instance of the lead engine. Tier 0 needs
    nothing but the plugin being on.
  - *Tier 1, implementation.* Only items that story-estimation places low-intension (`simple`,
    or `complicated` with intension ≤ 0.3). The item must not touch auth, crypto or external
    input, and must not be cross-cutting. The PO opts in per lane at scope approval.
- **Never offloaded:** the `complex` or spike quadrants, security-flagged items, decision
  records, anything that writes the tracker, and anything that edits a default branch.
- **The reviewer is never the implementer's engine, and never the lane's lead.** The lead
  commits and opens the PR, so it is an author (§Review). If the implementer ran out of quota
  and another worker finished the fix round, the re-review goes to a third engine or to a
  separate `reviewer-<N>` agent.
- **Quota runs out mid-lane; plan for it.** Fall back down the `engines-workers` order, and
  record every hand-over in the lane ledger. A declared plan is not proof: one trial found the
  worker CLI on a free tier despite a paid subscription. `plan` is declared, and the run is
  the evidence.
- **The plugin stretches the lead's budget; it does not bypass a rate-limit freeze.** The lead
  itself spends budget. If the lead engine is rate-limited, offloaded lanes stall with it, and
  any freeze your pipeline enforces stands as written.
- **Record the cost.** For a tier-1 lane the ledger carries the worker run id and the lead's own
  token spend, so the saving is measured rather than assumed.

## Decision discipline
- Use a **single structured multi-select** to get PO scope approval before spawning.
- Reserve questions for genuinely PO-owned forks (scope, risky/irreversible mechanism choices). Otherwise pick the sensible default and proceed.
