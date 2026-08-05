# Scripts & hooks catalog

Every script and hook that automates the process, with what it enforces and how to
bypass it. Hooks are wired in `.claude/settings.json` → version-controlled
`.claude/hooks/*.sh` (manage with `/update-config` or `/hooks`). They make the gates
**deterministic** instead of relying on an agent to remember them.

> **`backlog-layout: per-item` instances:** if you migrated off a `monolith` mirror +
> external-tracker reconcile script, retire that script and its guard hooks rather
> than porting them — a per-item mirror has nothing left to reconcile against. Keep
> the retired copies somewhere for traceability (an instance memory path, not deleted
> outright) and don't re-wire them. What typically replaces each is noted inline below.

## Scripts

| Script | What it does | Mode |
|--------|--------------|------|
| `<tooling>` (path declared in your `.packs.yaml`) | The backlog CLI — `query · transition · sprint · id · validate · export` (or your own equivalents) over the per-item mirror. Replaces any external-tracker reconcile script and the monolith-file edit path outright — there's no second side left to sync. Full reference in `backlog-and-reconciliation.md`. | Writes on `transition`/`sprint open|close`; `query`/`validate`/`export`/`id` are read-only or additive-only. |
| A schema-gate script in `<mirror-repo>` | Required fields (`id`, `kind`, `status`, `title`), `status` valid **and** matching its tier folder, `id` matches the space's id policy + filename convention, no duplicate ids, no allocator-counter collision. Worth running both standalone (called by `<tooling> validate`) and as the mirror repo's own pre-commit hook. | Read-only check; exits non-zero on any schema violation. |

A ghost-sprint pruner and a board-sync script (Miro/Jira-board-style) are common in a
`monolith` + external-tracker setup; neither has an obvious `per-item` equivalent —
ghost sprints are a tracker-API artifact that doesn't exist once the tracker is frozen,
and a board view would need to read the mirror directly if you still want one.

## Hooks

| Hook | Event | Enforces | Bypass |
|------|-------|----------|--------|
| Mirror repo's own pre-commit hook | pre-commit (mirror repo only) | Runs the schema-gate script before a commit lands in the mirror repo — a hard gate on the actual per-item files, stronger than an advisory JSON-shape check on a monolith file. | — (hard-fails the commit; fix the flagged item) |
| `pre-push-verify.sh` | PreToolUse·Bash | Runs `mvn clean verify` before a `git push` **only when Java/POM files changed**; blocks a red build (exit 2). `clean` is deliberate — branch switches don't wipe `target/`, so stale cross-branch test classes would cause spurious failures. **Do not** add `-Djava.util.logging.manager` to this Maven JVM (breaks Quarkus augmentation; already set per test-fork in the root-pom surefire config). Skips docs/backlog-only pushes. | `CLAUDE_SKIP_VERIFY=1` |
| `agent-long-task-timeout.sh` | PreToolUse·Bash | Blocks an unbounded long-runner (`mvn`/`gradle`/`npm`/`docker build`/`curl`…) or `while/until/--retry` poll loop unless bounded by a `timeout` wrapper or the Bash `timeout` field (300s default; `mvn verify` ≈10% over last build). Pairs with the soft 10-min no-progress STOP-and-report rule. | `NO_TIMEOUT_GUARD` marker / `CLAUDE_SKIP_TIMEOUT_GUARD=1` |
| `gh-pr-create-guard.sh` | PreToolUse·Bash | Blocks `gh pr create` unless it is **non-interactive** (inline `--body`/`--body-file`/`-F`/`--fill*`) **and bounded** (~15s `timeout`/Bash `timeout` field) — a bodiless `gh pr create` opens `$EDITOR` and hangs forever, stalling a swarm lead. | `NO_GH_PR_GUARD` marker / `CLAUDE_SKIP_GH_PR_GUARD=1` |
| `story-pickup-preflight.sh` | UserPromptSubmit | On a "pick up / tackle a story" prompt, injects a pre-flight relevant to your swarm/coordination setup plus a codebase-index sync. Drop any step that reconciled a monolith mirror against an external tracker — a per-item mirror has nothing to reconcile before a transition. | — |
| `provision-jdk.sh` | SessionStart | Auto-provisions the toolchain (e.g. a specific JDK) in the remote/web env so it matches. | — |
| `session-start.sh` | SessionStart | Prints a toolchain/readiness summary (build command, backlog source-of-truth) into context. | — |

> Two inline (non-file) PreToolUse hooks in `settings.json` also enforce the
> **graphify-first** rule: before `grep`/`find`/raw file reads when
> `graphify-out/graph.json` exists, run `graphify query` first.

> The Story→Epic progress cascade (when a Story goes `IN PROGRESS`, its parent Epic
> should too) is an agent responsibility documented in `ceremonies.md` → *Status
> transitions*, not a hook — the agent runs both `<tooling> transition` calls itself.

## Known gap
Sprint closure is PO-only **by convention** in most instances, not by a mechanical
gate — a `monolith` setup may have had a hook blocking any command that flips a
sprint to `CLOSED`; a fresh `per-item` instance often has no equivalent yet, so
`<tooling> sprint close` runs for whoever calls it. If this needs re-enforcing, it's a
new `PreToolUse·Bash` hook matching your sprint-close command.
