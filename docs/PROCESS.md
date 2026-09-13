# Synapse process rules

The operative rules for how work gets done. Read once per session before
planning. Where `docs/reference/` disagrees with this file, this file wins.

Owner: Ahsan (Digital Products Lead). He owns every product decision, every
credential, and every merge. Claude proposes; Ahsan approves.

---

## 1. Pull requests

**PR1 — One unit.** One task = one Linear issue = one branch = one PR = one
concern. Under ~400 changed lines. The reviewer flags anything larger and Ahsan
asks why.

**PR2 — Definition of Ready.** No branch is created until the Linear issue has
all five: (a) an acceptance sentence Ahsan could watch happen, (b) the files it
touches, (c) invariant IDs it wires or risks, (d) keystone yes/no, (e) no
unresolved decision. If one is missing, say so and stop.

**PR3 — Description template.** Every PR description contains, in this order:

```
Closes SYN-n

**Acceptance**   <the one observable sentence from the issue>
**Invariants**   <IDs touched, or "none">
**Evidence**     <test output with counts · screenshot · request + response>
**Review**       <which reviewer ran, what it found, what was done about it>
**Migration**    <yes + filename, or no>
**Keystone**     <yes/no>
**Deferred**     <anything in scope that was NOT built, by name — or "nothing">
```

**PR4 — Definition of Done.** CI green · evidence in the description · reviewer
run and findings addressed · diff-against-scope done · `docs/STATUS.md` updated
· `docs/DECISIONS.md` updated if a decision was made.

**PR5 — Merging, by risk tier.** Always squash. Branch deleted on merge. **Red
CI is never merged, whatever the explanation.** Never force-push. `main` is
protected.

Who merges depends on what the PR can break:

| Tier | What it is | Who merges | How |
|---|---|---|---|
| **Docs / chore** | Only `docs/**`, `.claude/**`, `.github/**`, `README`, config with no runtime effect | **Claude**, unattended | `/pr` waits for CI green, then merges. No approval needed — Ahsan's click buys nothing on a STATUS typo |
| **Normal code** | Everything else that is not a keystone | **Claude, on Ahsan's word** | `/pr` stops and shows the description, the evidence and the surviving findings *in the session*. Ahsan reads it and says "merge it". Claude merges. No browser trip |
| **Keystone** | Auth, migrations, identity resolution, consent, scoring engine, anything in PKR, `infra/`, any hotfix | **Ahsan, in the browser** | Claude prints the URL and stops. Ahsan opens the PR, reads the actual diff — not a summary of it — and merges |

Two rules that hold across all three tiers:

- **Never enable auto-merge**, on any tier. A docs PR merges because `/pr`
  watched CI and then merged; not because GitHub was told to land it whenever it
  goes green. The difference matters when a check is added later.
- **Claude never merges a keystone.** If `/pr` detects keystone content in a PR
  flagged otherwise, it corrects the flag, says so, and hands the URL to Ahsan.
  An agent merging a consent or migration change leaves no person in the
  approval record, and "who approved this?" is a question Syngenta IT will ask.

**Why the middle tier is shaped this way.** Ahsan cannot read code, so his
quality control is the automated gates plus reading the evidence. If Claude
wrote the code, reviewed the code and merged the code, the system is
self-certifying and the gates only test what Claude thought to test. The point
of the middle tier is not the click — it is the **reading**. Moving the read
into the session removes the friction without removing the check. If Ahsan finds
himself saying "merge it" without reading, the tier is not working and it should
be changed deliberately, in DECISIONS.md, rather than eroded by habit.

**PR6 — Keystone PRs.** Anything touching auth, database migrations, identity
resolution, consent, the scoring engine, anything denominated in PKR, or
`infra/` is a keystone. It gets `/review-keystone`, and Ahsan reviews it with
the file open, not only the description.

**PR7 — Migrations.** A migration that has shipped is never edited; a new
migration follows it. The path-protection hook enforces this.

---

## 2. Linear

**LIN1 — Structure.** One project, *Synapse*. Milestones M0–M8 (Act and later
scopes only once they exist).
Issues are tasks. No cycles — a solo builder does not need sprints.

**LIN2 — Labels.** `keystone` · `spike` · `bug` · `change-request` · `feedback` ·
`tech-debt` · `parked`. Priority P1–P3 on bugs only.

**LIN3 — Status moves itself** through the GitHub integration: branch pushed →
In Progress; PR opened → In Review; PR merged → Done. Claude never sets Done by
hand. If a status looks wrong, the branch or the PR is wrong — fix that, not the
status.

**LIN4 — Who writes issues.** Claude creates and updates issues through the
Linear MCP in *planning and triage sessions only*. A build session touches only
the one issue it is working on.

**LIN5 — Order.** Order inside a milestone is execution order. `/resume` proposes
the top Todo issue in the open milestone. Ahsan may override by naming a key.

**LIN6 — Parking.** Parked = Backlog + `parked` label + an un-park trigger in the
description + a `DECISIONS.md` entry. A park without a named trigger is a
deletion that has not admitted it yet. "Revisit later" is not a trigger.

---

## 2b. GitHub repository management

**Claude configures the repository.** Not Ahsan clicking through settings menus.
Use `gh` and `gh api`, set it up once in `/setup-repo`, and report what was
changed so Ahsan can verify it in the browser in two minutes.

Claude owns: creating the repo · squash-only merges · delete-branch-on-merge ·
labels · the PR template · secret scanning and push protection · Dependabot
alerts · the CI workflow · the `staging` and `production` environments · branch
protection on `main`.

**G1 — Branch protection is set once and never loosened.** `main` requires a
pull request, requires the `pnpm check` status check, and forbids force pushes
and deletion. Claude may set it in `/setup-repo`. After that, **any change to
branch protection requires a dated `DECISIONS.md` entry written first**, and the
process warden verifies at every session start that protection is still on with
its required checks intact. Loosening protection to get a red build merged is
the single worst thing that could happen to this process, and it is the reason
the warden checks it rather than trusting it.

**G2 — Environments hold the production gate.** The `production` environment
requires Ahsan's review before any deployment job runs. Claude may create the
environment; **only Ahsan may approve a deployment through it**, on his own
account.

**G3 — Claude never touches secrets.** No `gh secret set`, no repository or
environment secrets, ever. Ahsan enters every credential. Claude asks for the
variable *name* and documents it in `.env.example`.

**G4 — Destructive repository operations are Ahsan's.** Deleting the repo,
transferring it to an organisation, changing visibility, deleting a branch other
than a merged PR's own head, rewriting history. Claude proposes; Ahsan executes.

---

## 3. Change control

Every change follows these five steps, whatever its size. Decide on paper, then
build.

**C1 — Capture.** A Linear issue labelled `change-request`, in Backlog, saying
what and why. A build session parks it in one line and continues its task —
never absorbs it.

**C2 — Triage** in a planning session, never mid-task. Claude assesses: which
SPEC requirement it changes, which invariant, which milestone, what it costs,
and what it displaces.

**C3 — Decide.** Ahsan. The decision is a dated entry in `docs/DECISIONS.md`
with the reason — accepted, rejected, or parked with a trigger. Reversals are
appended with their reasoning, never quietly erased; the record of why he
changed his mind is the most valuable thing in the file.

**C4 — Update the paper before any code.** `SPEC.md` if scope changed ·
`ARCHITECTURE.md` if a rule changed · `UX.md` if a journey changed · `PLAN.md`
if a milestone changed · this file if the process changed. One PR.

**C5 — Then tasks.** New Linear issues under the right milestone, each with an
acceptance sentence, built through the normal loop. A change is never applied
inside an unrelated task's PR.

**Three changes always trigger an architecture review** with Ahsan, plan open:
anything touching the schema package, database migrations, or `infra/`. These
are the reversals that cost weeks.

---

## 4. Side questions

A question that does not produce code does not belong in a build session.

| Question type | Where it goes |
|---|---|
| Product, architecture, "should we…", "what would IT ask" | The advisory session in the Claude app (canvas + playbook + delivery process in context, no repo) |
| "Explain this to me", learning the mechanics | A second terminal tab, `claude` started in an **empty folder**. No repo, no CLAUDE.md, pennies per question |
| About this codebase | The build session, as a read-only ask **before** the task is planned: "Before we plan SYN-42, explain in five lines how the worker handles retries" |

A build session that starts producing discussion instead of a PR is the signal
to stop and move the question.

---

## 5. Context

**X1** — `/clear` between every task. Non-negotiable. Failed attempts from one
task must not shape the next.

**X2** — Two failed corrections on the same problem → write
`docs/notes/stuck-<topic>.md` → `/clear` → re-prompt with the symptom and the
file names only. Not three attempts, not five. This feels like giving up, which
is why people skip it; it is the most reliable unstick move there is.

**X3** — Wide reads are delegated to subagents. The conclusion comes back into
the main window; the reads do not.

**X4** — Name the file. "Look at `packages/db/leads/transition.ts`" costs
nothing; "find where leads change state" costs a tour of the repo.

**X5** — `/compact` only mid-task when the alternative is losing the work. It is
a half-measure; the real one is update STATUS.md, then `/clear`.

**X6** — Reviewers always run in a fresh context. That is the entire value of a
review. A reviewer that has seen the implementer's reasoning is a second opinion
from the same brain.

**X7** — Anything Ahsan would otherwise paste into chat becomes a file first, in
the right memory layer, and the prompt names the file.

---

## 6. Memory structure

Four layers, defined by *when they load*, not by how useful they are. The
instinct to build rich always-on memory is backwards for this tool: context is
the scarce resource and answer quality degrades as it fills. Small always-true
core, large indexed periphery.

| Layer | Files | Loads | Rule |
|---|---|---|---|
| **0 · Always on** | `CLAUDE.md` | Every turn, every session | At most 45 lines. Rules only, no product narrative — every line is rent paid forever. If it needs more room it belongs in PROCESS.md and gets referenced. |
| **1 · On resume** | `docs/STATUS.md` · `docs/PLAN.md` (milestone level) · `docs/INVARIANTS.md` · **titles only** from `docs/DECISIONS.md` · the open milestone's Todo issues from Linear | Once, by `/resume` | Enough to continue without re-interviewing Ahsan. STATUS is reconciled against `git log`; Linear against STATUS. |
| **2 · On demand** | `docs/PROCESS.md` · `SPEC.md` · `ARCHITECTURE.md` · `INFRA.md` · `UX.md` · `RUNBOOK.md` · `docs/JOURNAL.md` · `docs/notes/*` · `docs/reviews/*` · full DECISIONS bodies | Only when a task names the topic, or a command reads it | Unbounded — write freely. A builder reads only the sections its issue names. The journal is never auto-loaded, so its length costs nothing. |
| **3 · Reference** | `docs/reference/*` · `~/synapse-reference/base44/` (outside the repo) | Only when Ahsan says "read docs/reference/…" | Source material, not memory. Nothing in the build loop should need it after Phase 5. |
| **Scratch** | Claude Code's auto-memory | Automatically | A scratchpad, never the record. If something there matters, move it into a docs file where it can be diffed. |

`docs/STATUS.md` is a claim about the past; `git log` is the truth. `/resume`
reconciles them and reports disagreement. After a week away, read that
reconciliation carefully before approving anything.

---

## 7. Sessions

A **session is one unit of work that ends with something on disk** — not one
step, not one milestone. A build session ends with a merged PR. A planning
session ends with a document that went through a PR and issues in Linear. A
review session ends with a findings file. If a session ends with nothing on
disk, its work did not happen: the next session cannot see it.

**Starting one.** `cd synapse` · `claude` · `/model` (confirm it is the model
this session needs) · `/resume` · then either an issue key (`SYN-42`) or a
planning intent (`Open M3`, `Triage intake`). Nothing else. New information
goes into a file first and the prompt names the file.

**Ending one.** `/close` — it updates STATUS, records any decision, appends the
journal entry, and reports whether anything is still uncommitted. Then Ahsan
`/clear`s. A session that ends without `/close` is a session whose work the next
one cannot see.

---

## 8. Models

| Job | Model | Set by |
|---|---|---|
| Planning sessions, milestone open, triage, review design, architecture, specs | Strongest available (Fable-class) | `/model` in the session |
| Build sessions on a well-specified task; M0 scaffold; QA execution; deployment | Opus-class | `/model` in the session |
| Fresh-context reviewer; lens reviewers | Opus-class | `model:` in `.claude/agents/reviewer.md`, `lens-reviewer.md` |
| Review planner; skeptics on keystone and document reviews | Strongest available | `model:` in `.claude/agents/review-planner.md`, `skeptic.md` |
| "Explain this" in the empty-folder tab | Sonnet-class | `/model` |

Run `/model` once to see the exact names this subscription offers; the *roles*
above hold whatever the names are. Planning and building are **different
sessions**, handed over through the Linear issue and files — never a `/model`
switch mid-conversation, because the builder must start from a clean context.

---

## 9. Review tiers

| Tier | Applies to | Who reviews | Command | Rounds |
|---|---|---|---|---|
| **A · Document** | SPEC, ARCHITECTURE + INFRA, UX, PLAN, QA-PLAN, release readiness | Review planner writes the lens list and attack plan → 4–6 lens reviewers in parallel → a skeptic per finding tries to refute it against the source → Ahsan triages accept / reject / park | `/adversarial-review <files>` | Max 2 |
| **B · Keystone PR** | Auth, migrations, identity, consent, scoring, PKR, infra, any hotfix | General + security + data-integrity reviewers in parallel, then skeptics | `/review-keystone` | Until findings are addressed |
| **C · Normal PR** | Everything else that is code | One fresh-context reviewer against the issue and INVARIANTS | `/pr` runs it | 1 |
| **Docs-only PR** | Only `docs/**`, `.claude/**`, `.github/**`, README, config with no runtime effect | **Ahsan, by reading it.** Not the reviewer agent | none — the Review line reads `Ahsan read it` | 1 |

**Why docs-only PRs skip the reviewer agent.** The agent is built to check a
code diff against the issue and the invariants. On prose it produces noise, and
a noise finding costs the same attention as a real one. Ahsan reading the diff
is the review; "Review: Ahsan read it" is the correct entry, not a gap. The
warden does not flag it.

`/pr` picks the tier itself from the issue's keystone flag *and* from the diff,
and refuses to reach `gh pr create` if a step failed. Use it rather than running
the reviewers by hand — the point of a gated command is that the correct path is
also the easy one.

Every tier ends the same way: **the reviewer's report is a claim; the diff
against scope is the truth.** A reviewer that reports "no findings" without
saying what it looked for and where has crashed, not passed — run it again.

A third review round on the same document means the problem is a missing
decision, not a missing review. Escalate to Ahsan instead.

---

## 10. The agent charter

Ten agents live in `.claude/agents/`. The charter is what keeps them useful
rather than vague.

### A1 — Agents read files, never conversations

**An agent's reference point is a `.md` file on disk, never a session
transcript.** Every agent definition carries a `Reads:` list of exact paths, and
it reads those paths itself.

An agent prompt may contain: **file paths, one task ID, and one parameter** (the
lens name, the finding to refute, the question to answer). It may **not** contain
pasted context, a summary of an earlier session, a paraphrase of a decision, or
a copy of the diff.

Two reasons this is a hard rule, not a preference. Pasted context is unauditable
— nobody can later check what the agent was actually told. And a paraphrase is
lossy in a way that is invisible: the agent behaves confidently on a distorted
version of the truth, and the distortion is untraceable.

The corollary for Ahsan: **anything he would paste into a prompt becomes a file
first**, and the prompt names the file. Syngenta's stack guidelines, a decision
from the advisory session, a screenshot's findings — file, then reference.

### A2 — One agent, one job

Each agent does exactly one kind of work. Not "review the PR" but "review this
diff through the security lens." Not "check everything" but "audit repo state
against PROCESS.md."

Every agent definition states four things: **its one job**, the **files it
reads**, its **output** (a report shape or exactly one file path it may write),
and a **must-not list**.

Why this matters more than it sounds: a broad agent produces broad output. An
agent asked to "review this" returns a paragraph of impressions; an agent asked
to "find a place where a phone number reaches a log line" returns a file and a
line number. Narrow scope is what makes an agent's output actionable rather than
decorative.

Never give one agent two lenses. Never give a skeptic two findings. If the work
splits, spawn two agents.

### A3 — Only two agents may write, and only to one file each

`review-planner` writes its plan file. `journal-writer` appends to
`docs/JOURNAL.md`. **Every other agent is read-only.** Reviewers report;
the main session acts.

This is deliberate: an agent that both finds a problem and fixes it has no
independent check on whether its fix was right, and its report becomes a
description of what it already did rather than a finding Ahsan can rule on.

### A4 — Delegation economics

**Delegate wide reads always** — their reads stay out of the main window, and
only the conclusion returns. That is what `explorer` is for.

**Never delegate a ten-line fix** — the spawn costs more than it saves.

**Parallel agents only for work independent by construction**, each in its own
git worktree off a committed `main`: the QA persona suites, and M7's connectors.
Anything touching the schema or db packages is one agent, sequential, never
parallel.

### A5 — No agent touches anything that can spend money

**No agent ever holds a credential that reaches staging, production, or any
billable service.** Ahsan enters every credential and presses every publish
button. If Claude finds itself needing a secret, it asks for the variable *name*
and reads it from env.

`.claude/settings.json` denies `gh pr merge --admin`, `gh secret`, `gh repo
delete`, `gh repo transfer`, DELETE calls through `gh api`, `terraform apply`,
`aws`, force pushes, hard resets, history rewrites, and reads of `.env` and key
files — so this rule is enforced, not remembered. It does **not** deny
`gh pr merge --squash`: PR5 needs Claude to merge docs and normal-code PRs.
"Claude never merges a keystone" is therefore a gated-command rule, not a
permission — see §13, *Three enforcement strengths*.

**Unattended runs** ("keep going until green", overnight) only with a hard
iteration cap and a spend cap set *before* the run. A runaway loop is a cost
incident discovered in the morning.

### A6 — Dev-support agents are not product

`process-warden`, `journal-writer`, `explorer` and `scope-differ` support the
*building* of Synapse. They are not part of Synapse. They never appear in
`docs/ARCHITECTURE.md`, they are never deployed, they have no opinion about
growers or leads, and nothing in the product may depend on them.

---

## 11. Code health

Enforced by CI on every PR: `pnpm check` green (identical locally and in CI) ·
test run count asserted non-zero · schema package 100% type coverage · scoring
package 100% test coverage · dependency and secret scanning · PR size flagged
over ~400 lines.

`/health-pass` at the end of every milestone: dead code, leftover debug output,
TODOs older than one milestone, test files with zero assertions, dependencies
with known issues, STATUS drift against git, and one paragraph of "what would I
restructure if I had a day."

Dependencies pinned to exact versions. Updated monthly in one dedicated PR,
never mixed with feature work.

---

## 12. Data

No real grower's name or phone number in a fixture, a test, a seed, a
screenshot, a log line, or a chat message. Ever.

Production-shaped synthetic data — Urdu names, transliterated names, shared
numbers, two-acre and forty-acre farms, sparse rows and overflowing rows — is
generated once in M8 and reused in QA.

PII columns are tagged in the schema so logs, exports and the warehouse redact
by rule rather than by memory.

---

## 13. The red-flag protocol

Ahsan will skip steps. Everyone does — at 6pm, on the fourth task of the day,
when something nearly works. This section is what catches it.

### Three enforcement strengths — name the one you mean

Every rule in this file is enforced at exactly one of three strengths. A
sentence that claims a stronger one than exists is a defect, not a typo.

1. **Permissions and hooks — cannot be talked around.** The `deny` list in
   `.claude/settings.json` and the three hooks fire whether or not anyone
   remembers, and no prompt changes that.
2. **Gated commands — bypassed by not using them.** `/pr` refuses to merge a
   keystone, but nothing stops a raw `gh pr merge --squash` typed outside `/pr`.
   "Claude never merges a keystone" is this kind. It is *audited*, not
   *prevented*: warden check 18 reads `mergedBy` on every merged keystone PR.
3. **Audits — tell you afterwards.** The process warden reports at the next
   session start. It catches the violation; it does not stop it.

A document that claims an enforcement that does not exist is worse than no
document, because Ahsan stops checking. Before writing "X is denied" or "X
cannot happen", find the line in `settings.json` or the hook that makes it
true. If there is none, write which strength actually applies.

### Proving a guard — two rules, written after the 2026-09-11 incident

**Never prove a guard by performing the dangerous action against the real
thing while the guard is unverified.** Verify the guard is *active* first, with
a read command whose output Ahsan can see; only then test it. A push-blocking
hook is tested by `git push --dry-run`, or by invoking the script directly with
the refs on stdin — never by a live push to `main` on the assumption that the
hook will catch it. This was the direct cause of the incident: the probe push
ran before the hook was wired, succeeded, and marked PR #1 merged with no human
read (DECISIONS 2026-09-11, INCIDENT).

**Installation and verification are two separate steps with two outputs Ahsan
can see.** Never chain them with `&&`. A failed `chmod` silently stopped the
chain before `core.hooksPath` was set, and the probe ran against an inactive
hook. Install; show the read-back; then, in a separate command, test.

### Three layers, in order of reliability

**Layer 1 — hooks. The only real guarantee.** They fire whether or not anyone
remembers. Three of them: lint and typecheck after every edit; protected paths
before every edit; refuse to end a turn while the gate is red. A rule that is
not wired into a hook or a CI check is a rule that will eventually be skipped in
silence.

**Layer 2 — gated commands.** `/pr` refuses to reach `gh pr create` without
passing the check, the scope diff and the right review tier. `/close` will not
report "safe to clear" with work unrecorded. The gate is in the command, so the
happy path is also the correct path.

**Layer 3 — the process warden.** A read-only agent that audits repo state
against this file and reports deviations. It runs automatically inside
`/resume` — so it fires at every session start without Ahsan remembering — and
on demand via `/checkpoint`.

### What the warden is, and is not

It **reports**. It does not fix, cannot edit any file, cannot run any
state-changing command, and has no opinion about the product. It is not part of
Synapse's architecture. Its whole job is to say *what is wrong and how to fix
it*, and then stop.

Its checklist is in `.claude/agents/process-warden.md`: STATUS drift, branch
without an issue, Definition of Ready gaps, Linear status mismatches, PR
template gaps, evidence that is not evidence, oversized diffs, unflagged
keystones, edited migrations, decisions made without a DECISIONS entry, paper
changed in the same PR as code, unlogged journal sessions, and anything shaped
like a real phone number.

**Severity:** RED means a rule protecting the product or the audit trail is
being violated now — clear it before the next action. AMBER means drift — clear
it before the milestone closes.

**Cap:** at most five findings per report, most severe first, each citing a rule
ID. A warden that reports twenty things gets ignored, and an ignored warden is
worse than none because it creates the feeling of oversight without the fact.

### The honest limitation

The warden catches **structural** violations: a missing issue, a thin PR
description, a stale STATUS, an unlogged session. It cannot catch a bad product
decision, an acceptance sentence that describes the wrong thing, or a plan Ahsan
approved too quickly. **Those remain his job, and no agent replaces them.**

Do not let the presence of a warden create false confidence. The hooks are the
guarantee; the warden is a second pair of eyes; Ahsan's judgement is still the
product.

---

## 14. The build journal

`docs/JOURNAL.md` is the narrative record of how Synapse came to be. Append-only,
one entry per session, written by `/close` through the `journal-writer` agent.

### The four records, and why none of them is this one

| Record | Tense | Overwritten? | Answers |
|---|---|---|---|
| **Linear** | present | continuously | What is to be done, and what state is it in |
| `docs/STATUS.md` | present | every session | Where are we right now, and how do I run it |
| `docs/DECISIONS.md` | past | never — appended | What did we decide, and why |
| **`docs/JOURNAL.md`** | past | **never — appended** | **What actually happened, and what did we learn** |

The journal is the only one that records *failure*. STATUS shows the current
state, so yesterday's dead end vanishes from it. DECISIONS records the choice
that was made, not the two hours spent discovering it was necessary. Without a
journal, the project's history is a clean sequence of correct moves — which is
both false and, as a record, useless.

### What each entry contains

Goal · what shipped (PR numbers) · what happened, as narrative · **what went
wrong** · decisions made (title and date only — the reasoning stays in
DECISIONS) · **what was learned** · what evidence Ahsan actually looked at ·
what is open at close. The template is in `.claude/agents/journal-writer.md`.

### The rules

- **Append only.** An existing entry is never edited or deleted. If a past
  entry is wrong, a new entry corrects it and names the entry it corrects.
- **Never duplicate DECISIONS or STATUS.** Reference a decision by date and
  title. If an entry restates reasoning, it is too long.
- **Honest over flattering.** "The Stop hook did not fire and we did not notice
  for two tasks" is exactly the kind of line the journal exists for. A journal
  recording only successes is obvious as a fiction and worthless as a record.
- **"Learned: nothing new" is a valid entry.** Padding is worse than brevity.
- It is **Layer 2 memory** — read on demand, never auto-loaded. It costs nothing
  until someone needs it, so length is not a problem here the way it is in
  STATUS.

### What it is for

Three real uses, in order of likelihood. **Handover:** when a Syngenta
engineering team inherits this repo, the journal is the difference between
reading code and understanding a system. **Your own retro:** the "Learned" lines
across forty sessions are the actual content of the forward-deployed-engineer
case you are building. **Audit:** when someone asks how a consent rule came to
be enforced the way it is, the journal points at the session and the decision.

---
