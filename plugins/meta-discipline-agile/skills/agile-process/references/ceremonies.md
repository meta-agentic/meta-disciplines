# Ceremonies & story workflows

> **`tracker: local` + `backlog-layout: per-item`:** every step below that talks about
> mutating the backlog means editing the item's own file in
> `<mirror-repo>/<space>/{raw,wiki,output}/<KEY>.md`, through the CLI your `.packs.yaml`
> declares as `<tooling>`. If your instance is `backlog-layout: monolith` or
> `tracker: jira`, the ceremony *names* below still apply — swap the tool calls for
> your own mirror's edit/reconcile path. See `backlog-and-reconciliation.md` for the
> full item shape and tooling reference.

The step-by-step playbooks. Mandatory **invariants** (the must/never rules) are
summarised always-on in `.claude/CLAUDE.md`; the full procedure is here.

## Definition of Ready / Done
- **DoR** — clear acceptance criteria, value understood, dependencies identified,
  effort estimated **per `[[skills/story-estimation/SKILL|story-estimation]]` — both axis
  placements recorded, not a bare number**, no open blockers.
- **DoD** — all ACs met; code reviewed + merged; tests pass; build/deploy pipelines
  green; docs updated; no known defects; **the backlog item updated** (`<tooling>
  transition <key> DONE`).

## New story
The `id` comes from the space's `idPolicy` (see `backlog-and-reconciliation.md`),
and *when* you know it differs by tracker:

- **`tracker: local`** — mint first: `<tooling> id alloc <space>` returns the id,
  then write `<mirror-repo>/<space>/raw/<KEY>.md` under it with the required fields
  (`kind`, `id`, `status: TO DO`, `title`, plus `epic`, `storyPoints`, `estimation:
  {extension, intension, quadrant}`, `dependencies`, `usecase`,
  `acceptanceCriteria`/AC section) → `<tooling> validate --space <space>` to confirm
  the schema gate is clean. `dependencies` reference other items **by `id`**
  directly — there's no separate link type to create.
- **`tracker: jira`** — the id does not exist until the issue does. Add the fields
  (`epic`, `sprint`, `storyPoints`, `dependencies`, `status`) → `createJiraIssue`
  (clean summary, acceptance criteria, `customfield_10016`) → record the returned
  key **as the item's `id`** → for each dependency `createIssueLink` type
  **"Blocks"**. Never pre-assign a key you expect Jira to hand out.

## Implement a story
Pick one with **no open `dependencies`**, status `PLANNED`/`REFINED`, in the
current/next sprint → `<tooling> transition <key> "IN PROGRESS"` (stamps the current
active sprint and moves the file `raw/` → `wiki/` in one step) → branch
`{space}/{key}-{short-summary}` (e.g. `<SPACE>/<SPACE>-58-short-name`) → implement,
commit, push, open PR vs `main` → `<tooling> transition <key> "IN REVIEW"`.

### Sprint-on-transition rule (mandatory)
A story's `sprint` field always reflects when it was actually worked:
- **→ In Progress:** `<tooling> transition` stamps the **current active sprint**
  automatically — a story can never be In Progress with no/old sprint. Override with
  `--sprint <ID>` only for a deliberate backfill; skip stamping with `--no-sprint`.
- **→ Done:** the **current active sprint is also on** the story. `sprint:` is
  **multi-valued** — the transition *adds* the current sprint, it does **not** replace
  the In-Progress one, so a story that spanned sprints shows both the **first**
  (started) and **last** (finished) sprint. Same-sprint start/finish → the field just
  holds that one.

`<tooling> transition <key> <status>` should be a single command that sets
front-matter status, moves the tier folder, and stamps the sprint together — there's
no separate "mirror it elsewhere" step.

### One story → one branch (mandatory, all work — not just infra)
A branch carries exactly **one** story's scope. Do **not** bundle a second story's
work — or an incidental fix/enabler/refactor discovered mid-flight — onto an
in-flight feature branch: give it its own `{projectKey}/{issueKey}-…` branch, or get
explicit PO OK before piggybacking. Once a mixed branch is merged it can't be split
cleanly. When a new concern surfaces mid-implementation, **file it** (New story) and
branch it separately.

### Status transitions
`<tooling> transition <key> <status>` — drive the item to `IN REVIEW` on PR open,
`DONE` on merge. When a Story goes `IN PROGRESS`, its parent Epic should be active
too — cascade the Epic with its own `<tooling> transition <epic-key> "IN PROGRESS"`.

### Draft a PR only while a review agent is reviewing it (mandatory)
The draft flag exists to stop a PR being merged **before a background review *agent*
has finished** — it's a hold for *automated* review, so the PO doesn't merge 
mid-review. It is **not** an always-on default.
- **A review agent is (or will be) reviewing this PR** → open it as a **DRAFT**
  (`gh pr create --draft`); a draft can't be merged. Mark ready (`gh pr ready <n>`)
  when the agent's review lands green (drafting is what stops a PR merging before a
  background reviewer has actually reported).
- **The PO is the sole reviewer, no review agent running** → **open it ready
  (non-draft)**; there's nothing to wait on — the PO reviews and merges at will, so a
  draft would just be friction.
- Merging is the PO's decision — don't self-merge a PR unless explicitly told to.

Either way, `gh pr create` must be **non-interactive + bounded** (inline
`--body`/`--fill` + a ~15s timeout) — enforced by `gh-pr-create-guard.sh`.

## Open a sprint
`<tooling> sprint open <space> <SPACE>-S{n} --goal "…" --start YYYY-MM-DD --end
YYYY-MM-DD --commit KEY1,KEY2,…` — writes `<mirror-repo>/<space>/sprints/<SPACE>-S{n}.md`
with the committed-plan snapshot in front-matter (`state: active`); live membership
after that is each item's own `sprint:` field, kept current by `transition`. Pre-plan
a **diverse basket of independent stories** across distinct projects/vertical slices
(one infra · one backend · one frontend) so N swarms run in N worktrees with no
cross-blocking — pull `PLANNED`/`REFINED` candidates with `<tooling> query --space
<space> --status PLANNED`/`REFINED` and check each against DoR before committing it.
Lead proposes the basket; **PO approves scope**.

## Close a sprint  *(PO-only by convention)*
`<tooling> sprint close <space> <SPACE>-S{n}` — flips `state: closed`, stamps
`closed:`, and computes delivered SP/items from the items actually carrying that
sprint. Append a close-out note to the live sprint-history register at
`<ceremony-home>` (velocity, increment narrative, retro highlights). Sprint
**closure** is the Product Owner's exclusive authority as a process rule — if your
instance doesn't yet have a mechanical gate for this (a `PreToolUse` hook matching
your sprint-close command), treat it as convention enforced by discipline, and add
the gate when it's worth the effort.

### Tag the close — the release-changelog anchor

After the sprint is closed and the backlog is consistent, create an **annotated** git
tag `<space>-sprint-<n>` on the **code repo**, at the commit that is the sprint
boundary, and push it:

```bash
git tag -a <space>-sprint-<n> -m "<SPACE> Sprint <n> close (<dates>) — <headline>"
git push origin <space>-sprint-<n>
```

One annotated tag per space per sprint. **Why it matters:** once releases begin, the
curated change list is generated *from these anchors* — the code diff between adjacent
sprint tags (`<space>-sprint-{n}..<space>-sprint-{n+1}`) plus the stories delivered in
that sprint. Without the tag there is no anchor and the changelog cannot be
reconstructed later.

**Never delete or move a pushed sprint tag once a release references it.** A moved
anchor silently rewrites history for every changelog derived from it.

*(Instances that generate changelogs should run their generator at close and commit the
output alongside the tag; the generator is instance tooling, not part of this pack.)*

### Retro Actions carry forward until closed or codified

Every retrospective produces **Action** items — *an action to improve the process and
capitalize the lesson learnt*. Each Action is **scheduled into the next sprint** and
**carried sprint-to-sprint until it is either done or codified into the process pack**,
so a lesson learnt is capitalized rather than quietly dropped. Do not close a retro
without its Actions committed to sprint N+1.

**Carrying is not a resting state.** An Action untouched across two consecutive sprints
is a signal, not a backlog item: in the third, close it as *overtaken by events* or
codify it into the process — deliberately, with the reason recorded. An Action that
rolls indefinitely is a decision nobody is making.

## Daily retro / standup (rolling cadence)
The daily notes live at `<ceremony-home>/YYYY-MM-DD-{retro,standup}.md` — ceremony
records are instance-side, kept out of the backlog mirror so the mirror's diff
history stays pure backlog-state. They are a **rolling log** — each retro covers
*"since the last retro through now"*, not a fixed calendar window, so it never
overlaps or leaves a gap. Don't rediscover this each day:
- **Name** the file `<ceremony-home>/YYYY-MM-DD-{retro,standup}.md` by the **date
  it's written**. A retro written today about yesterday's work is dated *today*; if
  the day's earlier note was only a morning snapshot, the next note picks up where it
  stopped (state the explicit window in the header, e.g. "since the 06-20 ~07:30Z
  retro through ~01:26 local 06-21") rather than editing the old one — daily notes
  are **never deleted/clobbered**.
- **Reconstruct from ground truth**, not memory: `git log` across **all active
  repos** (your platform repos) for the window
  (`--since`/the prior retro's commit), the merged-PR list, and the matching
  standup/plan note — then map commits → `<SPACE>-` keys.
- **Sections** (a retro carries all; a standup is the forward-looking subset):
  **What landed** (merged to `main`; table keyed by `<SPACE>-NN` + PR + state) ·
  **Backlog & refinement** (new/refined/split items) · **Process** (rules banked into
  CLAUDE.md/this skill) · **Impediments & incidents** (what blocked/broke, with root
  cause) · **Discoveries** (insights, decisions surfaced) · **Retro — keep/change**
  (went-well / banked-lessons / **watch items carried** forward). A *standup* instead
  leads with *Since last note / Today's basket / lanes*.
- **Cadence vs sprint docs**: daily notes are ephemeral and **absorbed into the
  sprint-history register at sprint close** (service-milestone highlights can stay as
  their own dated retro note alongside the dailies rather than a separate `retros/`
  folder). A docs-only daily note may go straight to `main` (or ride the active story
  branch) — don't open a dedicated PR for it. Carry unresolved **watch items** into
  the next note until they close.

## Commit rule
A backlog change is an item edit or a `<tooling> transition`, not a separate sync
step. **Don't open a dedicated PR just to change item state** — embed the
`<tooling> transition` in the related code PR (a feature PR may also carry catch-up
`DONE` flips for already-merged items). If the mirror is a separate repo from the
platform code, "embed" means committing the item change alongside, or immediately
around, the platform-repo PR — not a standalone PR just for the state flip. Standalone
backlog *additions* (new items, refinements) may go directly to the mirror repo's
`main`. Code changes go via the story branch + PR in the platform repo.
