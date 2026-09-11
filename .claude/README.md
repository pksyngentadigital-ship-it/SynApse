# .claude — the enforcement layer

Not product. This folder is tooling: it constrains how Synapse gets built and
appears nowhere in `docs/ARCHITECTURE.md`.

## settings.json

**Verify this against your installed Claude Code version in session 0.2.** The
hook event names and the JSON shape have changed between versions, and a hook
that silently does not fire is worse than no hook at all. Ask Claude: "check
.claude/settings.json against the hook schema for the version I'm running, and
fix it if the shape is wrong." Then self-test all three (Phase 6, M0-T3).

`deny` is the important half. `gh pr merge --admin` is denied so no merge can
bypass a required check. `gh secret` is denied because Ahsan enters every
credential. `terraform apply` and `aws` are denied because no agent touches
infrastructure directly. `gh repo delete`/`transfer` and history-rewriting git
commands are denied outright. `.env` and key files are unreadable so a secret
cannot reach a transcript.

Plain `gh pr merge` **is** allowed, because merging is now tiered — see
`docs/PROCESS.md` PR5. Claude merges docs and chore PRs on its own, merges
normal code PRs only when Ahsan says so after reading the evidence in-session,
and never merges a keystone. That last rule is not enforced by permissions; it
is enforced by `/pr` refusing, and audited by the warden checking who merged.

## hooks/

| Hook | Fires | Does |
|---|---|---|
| `protect-paths.sh` | before every Edit/Write | Blocks writes to `packages/scoring/`, `packages/schema/`, `infra/` unless the task allow-lists the prefix in `.claude/allow-protected`; always blocks editing a migration that already exists on `main` |
| `stop-if-red.sh` | when Claude tries to end a turn | Blocks while `pnpm check` is red; fails open after 3 blocks and writes `UNRESOLVED:` into `docs/STATUS.md` |
| post-edit lint+typecheck | after every Edit/Write | Catches drift immediately instead of at PR time. Silent no-op until the M0 scaffold exists |

Both scripts no-op safely before the M0 scaffold exists, so they can be
installed from day one.

`.claude/allow-protected` is the visible escape hatch: to write to a protected
path, the task appends that prefix to it. The process warden flags the file if
it is left behind, and `/close` reports it. A rule you can bypass silently is
not a rule; a rule you can bypass loudly is a rule with an audit trail.

## agents/ — one agent, one job

Every agent declares what it reads, what it outputs, and what it must not do.
**Agents read files, never conversations.** An agent prompt may contain file
paths and one task ID; it may not contain pasted context.

| Agent | Its one job | Writes? |
|---|---|---|
| `process-warden` | Audit repo state against `docs/PROCESS.md` and report deviations — including that branch protection is still on and that no agent merged a keystone | No |
| `reviewer` | Review one diff against one issue + invariants (Tier C) | No |
| `security-reviewer` | One diff, security lens only | No |
| `data-integrity-reviewer` | One diff, data lens only | No |
| `review-planner` | Write the attack plan for a document review | Plan file only |
| `lens-reviewer` | Execute exactly one lens against one document | No |
| `skeptic` | Try to refute exactly one finding | No |
| `scope-differ` | Compare the diff against the issue's stated scope | No |
| `explorer` | Answer one question about the codebase; return the conclusion, not the files | No |
| `journal-writer` | Append one entry to `docs/JOURNAL.md` | Journal only, append-only |

**`model:` values.** `opus` where a strong execution model is wanted; `inherit`
on `review-planner` and `skeptic` because those run inside planning sessions
and should take that session's stronger model. Check the values your version
accepts with `/agents`, and if a stronger alias is available, set it on those
two.

## commands/

| Command | When |
|---|---|
| `/resume` | First thing in every session. Loads state, reconciles, runs the warden, proposes the next task |
| `/pr` | The gated path to a PR: preconditions → scope-differ → the right review tier → open the PR. Refuses to skip a step |
| `/close` | Last thing in every session. STATUS + DECISIONS + JOURNAL, then it tells you to clear |
| `/checkpoint` | On demand: run the warden, change nothing |
| `/adversarial-review` | Tier A, documents only |
| `/review-keystone` | Tier B, high-risk diffs |
| `/health-pass` | End of every milestone |
| `/add-connector` | Every new source. Never hand-write one |
| `/setup-repo` | Once, in Phase 0. Configures GitHub: merge behaviour, branch protection, labels, PR template, security, environments |

The three you will type most are `/resume`, `/pr`, `/close`. Between them they
make the task loop hard to shortcut.
