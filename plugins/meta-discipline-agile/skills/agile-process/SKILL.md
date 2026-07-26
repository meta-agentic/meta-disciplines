---
name: "Agile Process"
description: "Operative reference for our Scrum process: backlog.json↔Jira reconciliation (sync.py), ceremonies (new/implement story, sprint open/close, daily retro/standup, status transitions, draft-PR & one-story-one-branch rules), the new-service design swarm + 5-epic skeleton, the script & hook catalog, and the agentic operating model. Load it for ANY backlog, sprint, ceremony, reconciliation, story-transition, retrospective, or 'how do we do X in our process' task. The always-on invariants (engineering conventions, hard gates) stay in CLAUDE.md; this skill holds the procedural detail."
---

# Agile Process

The **operative playbook** for running this Agile project. CLAUDE.md is the
always-on contract (source-of-truth pointers, hard-rule one-liners, engineering
conventions); this skill is the on-demand *how* — load it whenever you do process
work and follow the relevant reference, so the ceremony isn't re-derived each time.

## Configuration & profile (read first)

This pack is **parameterised** — it carries the method, your instance carries the
choices. Before acting, resolve the config from the instance's `.packs.yaml`
(`scripts/packs.sh config agile` prints the resolved values):

- **`profile`** (`scrum` default | `kanban`) — selects the methodology. Load the active
  profile's conventions from this pack's `profiles/<profile>.md`; it sets the authority
  order, flow, gates, and cadence. **The procedures below are the `scrum` profile.** For
  `kanban`, follow `profiles/kanban.md` and use only the transition/hygiene procedures
  here, skipping the sprint/ceremony ones.
- **`tracker`** (`jira` | `local` | `none`), **`space`**, **`mirror-repo`** — resolve the
  `<space>` / `<owner>/<scrum-repo>` placeholders used throughout. With `tracker: local`
  the `backlog.json` mirror *is* the top authority (no external tracker); with
  `tracker: none` there is no backlog file.

An instance may override any convention — see "Overrides" in the pack README.

**Authority order (scrum profile):** `<tracker>` (project `<space>`) →
`<owner>/<scrum-repo>`'s `backlog.json` mirror → this skill → CLAUDE.md invariants. On
any state conflict the **tracker wins** (for `tracker: local`, the `backlog.json` is that
top authority). Platform code PRs do **not** edit the mirror.

## When to use
- Adding/refining/reconciling backlog items, or running `sync.py`.
- Implementing a story (branch/transition/Sprint-field/PR discipline).
- Opening or closing a sprint; writing a daily retro/standup.
- Architecting/seeding a new service (design swarm + 5-epic skeleton).
- Any "how do we do X in our process?" question.

For a full **parallel multi-lane sprint run**, use the companion `agile-swarm` skill.

## References — load the one you need
| File | Covers |
|------|--------|
| `references/backlog-and-reconciliation.md` | Source of truth, system entry points, `backlog.json` shape, status vocabulary (incl. `NO GO`), labels policy, full `sync.py` reconciliation procedure, scrum-doc roles. |
| `references/ceremonies.md` | DoR/DoD, new story, implement a story, **sprint-on-transition**, **one-story-one-branch**, **draft-PR**, status transitions, open/close sprint, **daily retro/standup rolling cadence**, commit rule. |
| `references/new-service.md` | Design swarm (perspectives → consensus → ADR+spike+trace) and the 5-epic microservice skeleton + mandatory tenancy-adoption story. |
| `references/scripts-and-hooks.md` | Catalog of every script (`sync.py`, `prune_ghost_sprints.py`, `miro_sync.py`, `sprint-reconcile.js`) and hook (with what each enforces + bypass), plus known drift to clean up. |
| `references/agentic-operating-model.md` | Claude Code in the loop: which agents/skills for refinement, architecture, implementation, DoD, review stewardship, long-running & local-bounded sessions, staying current with `main`. |

**Sizing lives in its own skill:** `[[skills/story-estimation/SKILL|story-estimation]]` —
the extension/intension (complicated vs complex) quadrant, one prescription per quadrant,
and an auditable estimate ledger. Load it whenever DoR asks for an estimate, or when an
item is stuck `In Progress` across sprints.

## Hard rules (mirrored always-on in CLAUDE.md — never break)
1. **Pre-push gate** — `mvn verify` green before every `git push`; a red root build
   never reaches the remote (`pre-push-verify.sh`).
2. **One story → one branch** — never bundle a second story or an incidental fix.
3. **Draft only while a review agent is reviewing** — draft a PR when a background
   review agent is in the loop (so it isn't merged mid-review); if the PO is the sole
   reviewer with no agent running, open it ready. Merge is the PO's call.
4. **Sprint-on-transition** — set/add `customfield_10020` on every status move.
5. **Jira is the only backlog write from a code PR** — code PRs touch **Jira only**, never
   `scrum/**`. The per-space mirror is Jira-derived and lives in the private **`<owner>/<scrum-repo>`**
   repo (reconciled by `sync.py --apply backlog`). *(Supersedes "sync both sides in the code PR".)*
6. **PO-only sprint close**; **multi-tenancy fail-closed** on every service.

Each rule's full rationale + procedure is in the reference files above; enforcement
is automated by the hooks in `references/scripts-and-hooks.md`.
