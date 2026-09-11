# Issue-tracker intake — external issues as backlog input

Every other reference assumes a unit of work originates **in the backlog**. This one
covers work that originates **outside it**: an issue in a public repository's tracker,
filed by us or by a stranger. It is the origination path for externally-filed work, the
way `new-service.md` is the origination path for a system — once an item is minted, the
ordinary ceremonies own it (§7). It applies under both profiles: intake is a triage and
hygiene procedure, not a sprint one.

## The boundary this procedure exists for

The public/private boundary is **asymmetric**, and the asymmetry is enforced, not polite:

- The backlog **may** cite a public issue. A public URL recorded in a private place
  discloses nothing.
- A public surface **may never** carry a backlog key. Public repositories run a hygiene
  gate that fails a PR whose title, body or added diff lines match an internal-key pattern,
  and hides a comment that does; commit messages are linted the same way. Git history is
  permanent — a force-push does not purge a leaked key, it only orphans it.

So the join between the two systems lives on **one side only**. The public side is
key-blind by construction, and every rule below follows from that.

| The public side may carry | The public side may never carry |
|---|---|
| its own issue numbers (`#N`) and labels | an item key, epic key or sprint id |
| milestones **named by release**, never by sprint | a decision-record id |
| plain-language comments stating an outcome | the mirror's path, `<tooling>`'s name, an internal note's location |
| PR references and closing keywords | an estimate, a priority, an owner, a schedule |
| the fact that something is "tracked" | *which* item tracks it |

## 1 · Triage gate — not every issue becomes an item

Triage is a **public act**: the decision is recorded on the issue itself, in the tracker's
own vocabulary, so nobody re-triages it on the next read. Open issues carrying no triage
label **are** the triage queue.

| Verdict | Public act | Backlog |
|---|---|---|
| **accepted** | label `accepted`; comment says it is tracked; stays open | mint (§3) |
| **needs-info** | label; comment names what is missing; stays open for a stated window | nothing yet |
| **declined** | close as *not planned*; label `wontfix` / `invalid`; comment states why in public-safe words | nothing |
| **duplicate** | close; label `duplicate`; comment names the surviving issue | nothing new |
| **question** | answer; close, or convert to a discussion | nothing |
| **security** | no public discussion; redirect to the private advisory channel | minted from the advisory, not the issue |

**Where a declined decision lives: on the issue.** The closed state, the reason label and
the comment are the record. `NO GO` in the backlog is for work that was *accepted into the
backlog* and later killed with a lesson; it does not apply to an issue that was never
accepted, and minting a `NO GO` per decline would import the tracker's noise and create a
second copy of the decision to drift. One exception: a decline whose **reasoning is
private** and worth remembering (a product direction, a security posture) — the reasoning
goes into a decision record or a `NO GO` item that cites the issue, and the public comment
carries only the outcome.

The triage window and the default triager are instance conventions (see *Open questions*).
An issue untriaged past the window is a standup item, not a surprise.

## 2 · Linkage — the join lives on one side

**Item → issue.** The item's front-matter carries the public URL(s):

```yaml
external:
  - tracker: github
    url: https://github.com/<owner>/<repo>/issues/<n>
    role: primary            # primary | related | advisory
```

Record the **full URL**, never a bare `#N` — the number is ambiguous across repositories.
Exactly **one** item carries a given URL as `primary` (§5), so the reverse lookup is a
function, not a search result.

**Issue → item.** Not resolvable from the public side, by design. A reader starting from
the issue can see: the `accepted` label (meaning *tracked*), any PR that references the
issue, and the close event. To find the item they need backlog access:
`<tooling> query --external <url>` where the tooling supports it; until it does, search
the mirror for the URL.

**What is not knowable from the public side:** the key, priority, estimate, sprint, epic,
dependencies, owner and schedule — and whether an *internal* note has already answered the
issue's question. That last blind spot is why §3 requires surfacing the answer.

**Branch names are public git metadata.** On a public repository a branch is named
`issue-<n>-<slug>`, never `{space}/{key}-…`; the item records the branch name so the
ledger's BRANCH column still resolves. This is a named exception to the branch convention
in `ceremonies.md`.

## 3 · Third-party issues — classify before minting

An externally-filed issue has no internal context, and its author cannot see the backlog.
Run the same steps for an issue filed by us — the procedure must not depend on who filed.

1. **Safety first.** A vulnerability report is redirected to the private advisory channel
   and the public issue is closed without detail. Stop here.
2. **Scope.** Is it this repository's concern at all? If not, decline (§1).
3. **Class.** `bug` (confirm or reproduce first — an unreproduced bug is `needs-info`,
   not an item) · `enhancement` (a product decision) · `question` · `decision` (an
   architecture or deployment ruling, usually filed by us) · `docs/chore`.
4. **Kind.** bug → `bug`; enhancement → `story` or `enabler`; decision still open →
   `spike`; decision settled but unrecorded → `documentation`; docs/chore → `task`.
5. **Dedup** (§5) — before, not after, minting.
6. **Mint** via `<tooling> id alloc <space>`, write the item into `raw/` with the
   `external:` field and an `## Intake` section: reporter, class, the dedup call in one
   line, and what was promised publicly.
7. **Surface what is already known.** If an internal note, decision record or in-flight
   item already answers the issue's question, post the public-safe answer on the issue.
   The asymmetry otherwise leaves an issue looking open when it is settled.

**What the reporter sees:** a label within the triage window; a plain-language comment
stating the outcome (*confirmed and tracked* · *needs X* · *not planned, because Y*);
later, a PR that references the issue; then the close. Never a key, never a sprint, never
"it is scheduled for …". If milestones are used at all, they are named by release.

### What intake needs from the public surface

Issue templates, labels and a public roadmap board are **instance tooling**, not part of
this reference — but they are the surface through which intake meets a reporter, and a
template that collects the wrong things turns triage into chasing. Build them to this
contract, so the classification step above can run from the issue as filed:

| Surface | Must provide | So that |
|---|---|---|
| Every template | a banner redirecting vulnerabilities to the private advisory channel; blank issues disabled or routed to a *question* path | step 1 (safety) is decided by the form, not by the triager |
| Bug template | what happened · minimal reproduction · expected vs actual (with the spec clause where one applies) · version or commit · environment and deployment topology · logs with secrets redacted | a bug can be confirmed or sent to `needs-info` on first read |
| Feature template | problem or use case · proposed behaviour · alternatives considered · the component or area · the relevant specification | the product decision and the dedup search (§5) have their inputs |
| Labels | the tracker's defaults **plus** the triage vocabulary of §1 (`accepted`, `needs-info`) | the triage queue is visible and a verdict is recordable |
| Roadmap board, if any | curated by hand; horizons named generically (*now / next / later*) or by release — never by sprint; no automation writing to it from the backlog | the board is a public-safe view, not a mirror that leaks |

**Sequencing.** This reference does not depend on that tooling existing — triage can be
done on a bare issue — and the tooling does not depend on this reference to be built. They
are independent deliverables with one soft ordering: land the discipline **before** a batch
of curated issues is opened by the maintainers, so each of those issues is linked from its
backlog item (§2) as it is created rather than back-filled. Neither absorbs the other: the
tooling item owns the forms, labels and board; this reference owns what they must collect
and what happens next.

## 4 · Closing the loop

The cheap half, confirmed: a PR in the **same public repository** may reference the issue
freely, and `Closes #<n>` in the PR body closes the issue when the PR merges to the default
branch. A public issue number is not an internal key, so a key-pattern gate passes it —
verified on a real PR through a real gate, not assumed.

Three cases where the keyword does **not** close it, and the close is manual:

- **The work lands in a different repository** — a private infrastructure repository, or
  another public one. A cross-repository closing keyword needs `owner/repo#n` syntax and
  write access, and from a private repository it also links a private PR into a public
  timeline. Treat it as manual.
- **There is no PR** — a decision issue, an operational change, a configuration applied
  elsewhere.
- **The PR merges to a non-default branch.**

Manual means: the item's owner closes the issue with a plain-language comment at the moment
the item transitions to `DONE`. The DoD gains one line for any item carrying `external:`:
**the external issue is closed, or commented with the outcome**. A `DONE` item whose issue
is still open and silent fails DoD. The ledger records which path closed it in the GATE
column (`closes #n` or `manual close`).

## 5 · Duplication — one issue, at most one primary item

Before minting, search the backlog for (a) the issue URL, (b) the subject — the component's
umbrella epic, the title's nouns, (c) items in the same area not yet started — and search
**every space the component spans**, not only the space you happen to be working in. The
common failure is not a missed near-duplicate; it is a confident *"nothing covers this"*
from a search of one space, made independently by two people, while a refined item in a
neighbouring space already owns the question. So the intake row's DEDUP cell names **what
was searched** (`none found in <spaces>`), never a bare "none" — a wrong verdict is then
auditable instead of invisible. Then decide:

| Situation | Call |
|---|---|
| An existing item covers the same scope and has not started | **Fold**: attach the URL as `primary` to that item; no new item; comment on the issue |
| An existing item overlaps, and the issue's extra scope would change that item's **estimate quadrant or DoD** | **New item**, with a dependency edge in the direction delivery requires; the URL goes `primary` on the item that delivers the reporter's outcome, `related` on the other |
| The issue invalidates an existing item's premise | **Supersede**: the existing item goes `NO GO` with the lesson (or is rewritten if not started — a PO call); the URL attaches to the replacement |
| The existing item is already `IN PROGRESS` | **Never widen it** — new item and a dependency, unless the PO explicitly rescopes |
| Two issues describe one problem | Close the later as `duplicate` pointing at the earlier; one item |

**Who:** the triager, at accept time, and the call is written in the item's `## Intake`
section in one line so the next reader does not redo it. A fold that adds scope to a
**sprint-committed** item changes the sprint, so it is the PO's call, not the triager's.

## 6 · Where this lives

This is a reference under `agile-process`, not a section of an existing one and not a skill
of its own. `backlog-and-reconciliation.md` describes the store's shape, `ceremonies.md`
the procedures for items already in the backlog, `new-service.md` how a *system* enters it,
`scripts-and-hooks.md` what enforces the rules, `agentic-operating-model.md` who executes
them. Intake is a second origination path with a boundary none of those files owns. It is
not a skill because it emits no ledger of its own — it adds an intake row to the transition
ledger — and four of its seven answers are citations of ceremony rules, which the pack's
no-restatement rule forbids duplicating.

## 7 · Sprint and lane integration

Once minted, an issue-derived item is an **ordinary backlog item**: DoR with both estimation
axes, planning, sprint stamping on transition, one story → one branch, lanes, review, PO
merge — all unchanged. The named exceptions, and only these:

- **Branch naming** on a public repository (§2).
- **PR text and commits carry no key.** The "embed the transition in the code PR" rule in
  `ceremonies.md` means *alongside* — the transition is written only through `<tooling>`
  in the mirror, never mentioned in the PR.
- **DoD** gains the close-or-comment line (§4).
- **An external stakeholder exists.** A third-party reporter is told outcomes through the
  issue, in public-safe words; ceremony records may cite the issue URL, the reporter is
  never pointed at them.
- **Advisory-derived items.** The fix PR must not reference the advisory or describe the
  vulnerability before coordinated disclosure; the item carries the advisory URL with
  `role: advisory`, and the loop closes by publishing the advisory, not by a keyword.

## Checkable output — the intake row

One row per accepted issue, appended to the transition ledger:

```
ISSUE                          → ITEM   CLASS      DEDUP                    PUBLIC ACT           VERDICT
<owner>/<repo>#42              → A-31   bug        none found (a, b)        accepted + comment   ok
<owner>/<repo>#43              → A-19   enhancement fold into A-19 (not started)  accepted + comment   ok
<owner>/<repo>#44              → A-32   decision   new; A-20 depends on it  accepted + comment   ok
<owner>/<repo>#45              → A-33   bug        —                        accepted             REJECT — no dedup line
<owner>/<repo>#46              → A-34   bug        none found (a, b)        (none)               REJECT — issue carries no triage label
<owner>/<repo>#47              → A-35   decision   none found               accepted + comment   REJECT — searched spaces not named
```

A row is a **rejection** when the dedup cell is empty or does not name the spaces searched,
when the issue carries no triage label, when two items claim the same URL as `primary`, when a public branch, PR, commit or
comment carries a key, or when a `DONE` item's issue is still open and silent.

## Anti-patterns

- **Writing the key into the issue "just this once".** The gate may not scan issue bodies;
  the rule holds anyway, because the reason is permanence, not the gate.
- **Naming the public branch by key** — the same leak through git metadata.
- **Milestones as sprint mirrors.** A milestone named after a sprint id is a key.
- **Closing from another repository with a keyword** — it either fails or links a private
  PR into a public timeline. Close manually with a comment.
- **Minting an item per declined issue.** The tracker is the record for what was never
  accepted.
- **Answering internally and leaving the issue silent.** The reporter cannot see the note.
- **Re-triaging on every read** because the verdict was never written on the issue.

## Open questions — instance conventions, not decided here

- The **triage window** and the **default triager** (the PO, or a named maintainer).
- Whether `<tooling>` gains `query --external <url>`; until then the mirror is searched.
- Whether the hygiene gate also scans issue **titles and bodies**. Gates commonly scan PR
  text, added diff lines and comments only — verify yours; the rule holds regardless.
- Whether a `needs-info` issue auto-closes after its window, and who reopens it.
- How an **advisory-derived** item is estimated and scheduled without describing the
  vulnerability in ceremony records that more people can read than the advisory.
