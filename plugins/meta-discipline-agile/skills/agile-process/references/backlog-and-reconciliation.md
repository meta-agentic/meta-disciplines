# Backlog model — `tracker: local`, `backlog-layout: per-item`

This reference describes the **per-item** layout: one small file per work item instead
of a single `backlog.json` mirror. It's what `backlog-layout: per-item` means in
`pack.yaml`, and it's the shape a `tracker: local` instance moves to once it drops an
external tracker entirely — **the mirror repo IS the tracker**, no reconciliation loop
needed because there's no second copy to drift. The one-line invariants live always-on
in `.claude/CLAUDE.md`; this is the detail. (`tracker: jira` / `backlog-layout: monolith`
instances: this file doesn't apply to you — see the monolith shape in your own
instance's config notes instead.)

## Source of truth
- **Per-item files in `<mirror-repo>`** — one Markdown file per work item at
  `<mirror-repo>/<space>/{raw,wiki,output}/<KEY>.md`, plus sprints at
  `<mirror-repo>/<space>/sprints/<SPRINT-ID>.md`. The mirror repo is the **sole
  authority** for every space it carries. Higher source wins over any tool/skill/
  ceremony that might disagree.
- If this instance is migrating off an external tracker, that tracker typically ends
  up **frozen** — a read-only historical archive that nothing in this process writes
  to anymore. Record your own instance's freeze decision as your own ADR; this pack
  doesn't assume which tracker you came from or whether you're headed toward another
  one later.
- Backlog tooling: **`<tooling>`** (the path declared in your `.packs.yaml`) —
  conventionally a small CLI exposing `query · transition · sprint · id · validate ·
  export` (or your own equivalents). This is the only writer; there is nothing to
  hand-edit and no bulk-rewrite footgun (see *Editing an item* below).
- Dashboard/report readers should consume a **derived** export, regenerable on demand,
  never authoritative. If a dashboard number looks stale, regenerate the export; don't
  chase the dashboard's own cache.
- Whatever the old monolith mirror and its reconcile script were, they're **dead** once
  you're on `per-item` — do not keep reading or writing them out of habit, and archive
  (don't delete) the old working copy for traceability.
- **Ceremony records** (retros, standups, planning, sprint history) belong at
  `<ceremony-home>` (an instance-side memory path) — **not** inside `<mirror-repo>`.
  Keeping them out of the backlog mirror keeps that repo's diff history pure
  backlog-state, not process narrative.

## System entry points (umbrella epics)
When researching/planning a system, **start from its umbrella epic** (the
program-level rollup linking that system's child epics via a "Relates to"-style
reference in the epic's body). Ask **graphify** for the entry point first — it can
index a per-item mirror directly. As a fallback, `<tooling> query --space <space>
--kind epic` and filter to items whose `labels` carry `umbrella`. A new service's
5-epic skeleton gets an `umbrella`-labelled epic.

## Tiers — the lifecycle IS the folder
An item's folder (`raw/`, `wiki/`, `output/`) is not a category, it's a **lifecycle
state** — this pack's recommended convention is to enforce it with a schema gate so
`status` and tier can't drift apart:

| Tier | Statuses | Meaning |
|---|---|---|
| `raw/` | `TO DO`, `PLANNED`, `REFINED`, `NO GO` | captured, not yet (or no longer) in flight |
| `wiki/` | `IN PROGRESS`, `IN REVIEW` | refinement/delivery underway — DoR met to get here |
| `output/` | `DONE` | delivered artifact |

`<tooling> transition <key> <status>` should move the file to the right tier **and**
stamp the sprint in one step — never hand-move a file between tiers. `NO GO` is a
deliberate terminal status (killed on purpose, lesson recorded) — not drift, never
"fixed" to a canonical status, kept in `raw/` for traceability.

## Item shape (front-matter)
An item is discoverable by declaring `kind:` in its front-matter — not by filename
shape, so a space can name its files however it likes. This pack's recommended
required set: `id`, `kind`, `status`, `title`. `kind` is one of `story · enabler ·
spike · bug · epic · action · documentation · task` (extend as your instance needs).

Common fields seen on stories/enablers/spikes (illustrative, not your real data):

```yaml
---
kind: story
space: acme
id: ACME-184
title: 'Short, clear summary of the change'
status: TO DO
project: ACME
epic: ACME-4                # parent, by id
storyPoints: 5.0
estimation:                 # both axes recorded — see story-estimation skill; a bare
  extension: 0.5            # storyPoints with no estimation: block fails DoR
  intension: -0.25
  quadrant: complicated
priority: P2
labels: [ACME]
dependencies: [ACME-21, ACME-26]  # blocking ids, this space's id scheme
usecase: As a ..., I want ..., so that ...
actors: [Some Role]
sprint: ACME-S2              # stamped by `transition`; multi-valued if it spans sprints
---

## Description
## Acceptance criteria
- ...
```

- **`id`** is a tracker-agnostic identifier — a space can declare its own shape (e.g.
  in a `<space>/_backlog-meta.yaml`: `idPolicy: {tracker: local|jira, prefix, pattern,
  next, filenames}`); a space with no policy falls back to `local` /
  `^<SPACE>-\d+$`. Mint a new one with `<tooling> id alloc <space>`, never by hand — a
  local allocator handing out an id already in use is a collision.
- **`epic`** and **`dependencies`** reference other items **by `id`**, resolved with
  `<tooling> query --epic …` / reading the target file directly — there is no separate
  link-graph store to keep in sync.
- **Status vocabulary (canonical)**: `TO DO`, `PLANNED`, `REFINED`, `IN PROGRESS`,
  `IN REVIEW`, `DONE`, plus the terminal `NO GO`.

### Editing an item — surgical, via the tool
Unlike a monolith `backlog.json`, each item is its own small file, so there's no
whole-file-reserialize footgun to guard against. Still:
- **Status / tier / sprint** → `<tooling> transition <key> <status>` (a `--sprint`
  override and a `--no-sprint` skip are worth supporting). This is the only path that
  should move the file between tiers correctly — never edit `status:` in place and
  leave the file sitting in the wrong folder; the schema gate should flag the mismatch.
- **Everything else** (AC, description, estimate, dependencies) → edit the item's
  Markdown file directly (front-matter + body).
- **New item** → allocate an id, write the file into `raw/` with the required fields,
  done — no separate "register" step.

## Reconciliation
Once you're on `per-item`, there's nothing to reconcile the mirror *against* — it's
the only copy. Two checks matter instead:

- **A schema-gate check** (`<tooling> validate [--space <space>]` or equivalent) —
  required fields present, `status` valid and matching its tier, `id` matches the
  space's id policy and filename convention, no duplicate ids, no allocator-counter
  collision. Worth wiring as the mirror repo's own pre-commit hook too, so a bad item
  never lands even from outside this tool.
- **A derived-export step** (`<tooling> export [--space <space>]` or equivalent) —
  regenerates whatever dashboards read. Run it after a batch of mutations; treat the
  export as disposable, re-run rather than hand-patch it.

## Labels (free-form, advisory)
Labels are informal tags on an item (`labels: […]`) — the project/space key is
conventionally present, plus topical/role tags. With no external label source to diff
against, treat labels as documentation, not a field a schema gate or any tool enforces.
