# Synapse delivery process — the phase sequence

> **What this file is.** The reviewed and corrected sequence from vision to
> production: eleven phases, what each produces, how many sessions, which model
> does which job, and where Ahsan stops to review. The *rules* live in
> `docs/PROCESS.md`; this file is the *order of operations* and the reasoning.
>
> **Precedence.** `CLAUDE.md` and `docs/PROCESS.md` win over this file. This
> file wins over `02-build-playbook.md` wherever they describe the same thing —
> it is the corrected version.

---

## The seven structural decisions everything follows from

**1. Linear is the tracker. The repo is the memory. Never both for the same
thing.** Two lists of "what's next" drift within a week, so the split is by
kind: Linear holds *work* (every task, bug, change request, feedback item, its
status, priority and milestone). The repo holds *knowledge* (spec, invariants,
architecture, decisions and their reasons, the status narrative). `PLAN.md`
shrinks to the milestone list with acceptance criteria and links to Linear.
`/resume` reads both.

**2. A session is one unit of work that ends on disk.** Not one step, not one
milestone. If a session ends with nothing on disk, its work did not happen.

**3. Planning and building are different sessions, on different models, handed
over through files.** The strongest model plans, reviews and decides; the
execution model implements a task that is already well specified. The handover
is the Linear issue and `PLAN.md`, never a conversation — that is what gives the
builder a clean context and makes what it was told auditable.

**4. Review is tiered.** Multi-agent adversarial review goes where a wrong
*sentence* is expensive — documents. Keystone PRs get three lenses. Everything
else gets one fresh-context reviewer. A group of agents on a forty-line PR costs
more than the PR and finds nothing the single reviewer would not.

**5. Staging exists from the walking skeleton. Production is a promotion.**
Deploying for the first time after QA is the most expensive place to find a
deployment problem. The AWS account is requested in Phase 0, Terraform and
staging go up when M1's thin pipe exists, every milestone after that is
demonstrated on staging, QA runs on staging, and production is the same pipeline
pointed at a third environment with a human approval in front of it.

**6. Nothing is built before it is on paper and approved.** Plan mode before
every task. A milestone plan before every milestone. A decision entry before
every change. A Linear issue before every branch. "Approved" is a word Ahsan
types. This is not a rule in prose — it is the order of operations.

**7. Evidence, not claims — and the diff is the truth.** The click was never the
control; the **reading** was. So merging is tiered by what a PR can break:
Claude merges docs and chore PRs unattended, merges normal code PRs only after
showing Ahsan the full evidence in-session and hearing "merge it", and never
merges a keystone — those Ahsan opens in the browser and merges himself, because
an agent merging a consent or migration change leaves no person in the approval
record. Claude also owns repository *configuration*, but branch protection, once
set, is audited at every session start rather than trusted.

**8. Agents read files, one agent does one job, and three layers catch mistakes.**
An agent's reference point is a `.md` file on disk, never a session transcript:
an agent prompt may carry file paths, one task ID and one parameter, never
pasted context — because pasted context is unauditable and a paraphrase is
lossy in a way nobody can see. Each of the ten agents does exactly one kind of
work, with declared inputs, a declared output and a must-not list, because a
broad agent returns impressions where a narrow one returns a file and a line
number. And mistakes are caught in three layers, in this order of reliability:
**hooks** (the only real guarantee — they fire whether or not anyone
remembers), **gated commands** (`/pr` and `/close` make the correct path the
easy one), and the **process warden** (a read-only auditor wired into
`/resume`). Everything that happens gets recorded in an append-only build
journal, because it is the only record that keeps failure.

---

## Phase 0 — Foundation: vision, rule book, trackers

*2 sessions · PR #1 and #2, docs only*

**Before the first session, Ahsan alone:** unpack the starter folder as
`synapse/`; install Git, Node LTS, pnpm, Docker Desktop, VS Code and the `gh`
CLI, then `gh auth login`; create the empty private GitHub repo `synapse`.

The starter already contains the rule files (`CLAUDE.md`, `docs/PROCESS.md`,
`docs/INVARIANTS.md`), the seeded `docs/JOURNAL.md`, the markdown reference set
with its routing index, and the whole `.claude/` enforcement layer — ten
single-job agents, eight commands, three hooks and the permissions allowlist.
Session 0.1 therefore **reads** the rules rather than writing them, and spends
its context on the product instead. Session 0.2 **verifies** the hooks against
the installed Claude Code version rather than authoring them.

### Session 0.1 — Vision first, then the rules (strongest model)

```
Read docs/reference/01-product-canvas.md. This is Synapse. Don't summarise it
back to me. In eight lines, tell me what the product is, who it is for, and
what a Sales Officer does with it on a Tuesday. Then list the five things
you'd most need me to decide before planning. Then wait.
```

```
Good. Now read CLAUDE.md, docs/PROCESS.md, docs/INVARIANTS.md and
docs/reference/03-delivery-process.md. These are already written — do not
rewrite them. Confirm in five lines: the memory structure you'll follow, when
you'll stop and ask me, what you do at the end of every task, and the one
thing in these files you think is wrong. Then wait.
```

```
Create the remaining docs: docs/SPEC.md as a stub with headings only (Phase 2
fills it), docs/PLAN.md with M0-M8 as headings and one line of purpose each
from docs/reference/02-build-playbook.md, docs/DECISIONS.md with today's first
entry (process adopted, with reason), docs/STATUS.md, and an empty docs/notes/
and docs/reviews/. Then .gitignore. Plan first.
```

```
Approved. Write the files. git init, push to the GitHub repo `synapse`, open
PR #1 "docs: rule book and process" from branch chore/rule-book. Give me the
link.
```

**Evidence:** PR #1 on GitHub listing every file. You open `CLAUDE.md` and read
it in under two minutes — if it takes longer, it is too long. You merge.

### Session 0.2 — Linear, GitHub, and the review harness (strongest model)

```
/resume
```

```
Set up Linear through the MCP per docs/PROCESS.md section 2: project "Synapse",
milestones M0-M8 as placeholders with one line of purpose each from
docs/reference/02-build-playbook.md, the seven labels, and an issue template
with the five Definition-of-Ready headings from PR2. Plan first.
```

```
Approved. Now verify the enforcement layer, don't rewrite it. Check
.claude/settings.json against the hook schema for the Claude Code version I'm
running and fix the shape if it's wrong. Run /agents and tell me whether every
model: value in .claude/agents/*.md is valid on my plan. Then list the ten
agents with their one job each in one line, so I can see nothing overlaps.
Report what you changed and why.
```

```
Then PR #2 with whatever you corrected. If nothing needed correcting, say so
and we skip the PR.
```

```
/setup-repo
```

Claude configures GitHub itself — squash-only merges, delete-branch-on-merge,
branch protection on `main`, the seven labels, the PR template, secret scanning
and push protection, Dependabot, and the `staging` and `production`
environments with `production` requiring your review. It reports a table of
what changed and how to verify each item.

**Then verify two things in the browser yourself**, because these are the two
that matter: branch protection is on `main` with a required check, and the
`production` environment requires a reviewer. Everything else on that list is
convenience. From here the process warden checks at every session start that
protection is still on — loosening it to land a red build is the worst thing
that could happen to this process, so it is audited rather than trusted.

**Non-code, this week:**
- Send the Cropwise Open Platform access request to Syngenta digital, naming
  the Pakistan tenant and listing what you need: Crop Doctor scans, community
  posts, Savera AI Agent transcripts. Log who received it and the date in
  DECISIONS.md — this is open decision D2.
- **Request the AWS account from Syngenta IT now.** It is on the critical path
  for staging in M1 and it is as slow as Cropwise.
- Ask marketing who owns the Meta developer app.
- Keep a private note, outside the repo, of every account created and where its
  credential lives. This is the list you hand to IT one day.

**Gate:** PR #1 merged (and PR #2 if the enforcement layer needed correcting).
Linear shows the project with nine milestones and no issues. `/checkpoint` runs
and reports clear, or reports only findings you have chosen to accept. The
journal has entry 001. Cropwise and AWS requests logged with a date and a name.

---

## Phase 1 — Understand the existing product: the Base44 audit

*1–2 sessions · 1 PR*

Export the Base44 app's code and data schema to a folder **outside the repo** —
`~/synapse-reference/base44/`. It stays there for the life of the project.

**The rule: the export is reference, never source.** The audit note goes in the
repo; the export never does; no code is carried across. Base44 tells you what
was tried and what users touched; the canvas tells you what to build.

```
/resume
```

```
Read ~/synapse-reference/base44/ — delegate the wide read to a subagent.
Write docs/notes/base44-audit.md: every screen and what it shows; every entity
and its fields; every workflow end to end; every business rule you can find,
one sentence each; integrations attempted. Then a gap table against
docs/reference/01-product-canvas.md — built / partly built / missing /
contradicts the canvas. End with a "Do not carry forward" section: patterns in
the export that would violate INV-1 to INV-9 or the A1-A10 rules. PR when done.
```

**Evidence:** you read the gap table and the business-rules list. Every rule you
know is in there; any rule you do not recognise is a question for Phase 2, not a
fact.

**Gate:** the audit is merged and you have marked in the file which Base44
behaviours are keepers and which were mistakes. That marked list is an input to
the spec.

---

## Phase 2 — Specification, and its adversarial review

*2–3 sessions · 2 PRs · Tier A review*

### Session 2.1 — Draft (strongest model)

```
/resume
```

```
Plan mode. Draft docs/SPEC.md from docs/reference/01-product-canvas.md, the
Base44 audit and INVARIANTS. Structure: purpose and users (six personas);
capabilities by zone - Capture, Decide, Act, See, Platform - each as a
numbered requirement with one acceptance sentence; entities at field level;
non-functionals (offline, Urdu, low-end Android, burst of 10,000 events,
PII, audit); explicitly out of scope for Capture; and the open decisions D1-D7 from
the canvas, left unresolved. Where the canvas is silent, ask me - one question
at a time, with your recommendation. Do not assume.
```

Read the draft as the product lead. Mark every requirement right, wrong, or "not
sure — ask the field." Approve into a PR as `SPEC.md v0.9`.

### Session 2.2 — Adversarial review (strongest model plans, execution model reviews)

```
/adversarial-review docs/SPEC.md — lenses: Sales Officer in the field, RSM,
Marketing, data & consent, security, agronomy, delivery feasibility, and
"what is missing". Findings to docs/reviews/spec-r1.md with severity, evidence
(quote the line), and a proposed fix. Skeptics first. Don't edit SPEC.md.
```

You triage every finding in the same file: **accept**, **reject** (with one line
why), or **park** (to Linear, with a trigger). Then:

```
Apply the accepted findings from docs/reviews/spec-r1.md to SPEC.md. Show me
the diff summary. Bump to v1.0. PR.
```

A second round only if round one produced an accepted finding that changed a
whole section. Never a third — at that point the problem is a missing decision.

**Gate — you sign the spec.** SPEC.md v1.0 merged. Every open decision is either
decided in DECISIONS.md or listed as open with an owner and a date. From here, a
change to the spec is a change request, not an edit.

---

## Phase 3 — Stack, architecture, and environments

*2–3 sessions · 2 PRs · Tier A review · **Architecture Checkpoint 1***

Save Syngenta's recommended stack as `docs/notes/syngenta-stack.md` before the
session.

### Session 3.1 — Substitutions and the architecture docs (strongest model)

```
/resume
```

```
Read docs/notes/syngenta-stack.md against the default stack in
docs/reference/02-build-playbook.md and against INVARIANTS. Propose the
minimum set of substitutions that satisfies the guidelines, one line each with
cost and what it changes. Stop for my approval. Don't edit anything.
```

```
Approved with those changes. Now write docs/ARCHITECTURE.md — rules A1-A10 from
the playbook plus anything the stack changes, and the component diagram in
words — and docs/INFRA.md: three environments (dev on my laptop, staging,
production), the AWS services per environment, network boundaries, where every
secret lives, backup and restore, the deploy pipeline with a manual approval
before production, and a monthly cost estimate per environment. Log the stack
decision in DECISIONS.md. Fill CLAUDE.md's Stack and Commands sections. PR.
```

### Session 3.2 — Adversarial review

```
/adversarial-review docs/ARCHITECTURE.md docs/INFRA.md — lenses: security,
scale and the campaign burst, data residency and consent, operations and cost,
what Syngenta IT will ask, and simplicity ("what could be removed and nothing
breaks"). Findings to docs/reviews/arch-r1.md.
```

### Architecture Checkpoint 1 — Ahsan's review, the main one

Read ARCHITECTURE.md and INFRA.md once, slowly, with these questions:

- Can one grower's journey be traced end to end through the components named?
- Is there exactly one place a lead changes state, one place it is scored, one
  place it is read?
- Where does a phone number appear, and where is it forbidden?
- What happens when Meta sends 10,000 webhooks in twenty minutes?
- What does it cost per month at pilot scale, and who gets the bill?
- Which decision here would be expensive to reverse after M3?

Anything you cannot answer from the doc is a finding. Triage, apply, merge.

**Gate:** ARCHITECTURE.md, INFRA.md and the stack decision merged. CLAUDE.md's
Stack section is filled. You can explain the environment model to IT in three
sentences.

---

## Phase 4 — User journeys and UX

*2 sessions · 1–2 PRs · Tier A review with persona lenses*

### Session 4.1 — Journeys, screens, prototype (strongest model)

```
/resume
```

```
Plan mode. Write docs/UX.md: one journey per persona (SO, RSM, ZM, Portfolio
Manager, Marketing, Admin) as numbered steps with the screen at each step; a
screen inventory where every screen lists its offline, empty, loading and
error states; Urdu/English rules; the two-tap logging rule; low-end Android
constraints. Then a low-fidelity clickable HTML prototype of the SO app's core
loop in docs/ux/prototype/. Structure and tokens, not visual design — grey
boxes are fine.
```

### Session 4.2 — Review with the field

Run `/adversarial-review docs/UX.md` with persona lenses — an SO with no signal
at 2pm, an RSM at month-end, a marketing manager who needs one number. Then sit
with **two real Sales Officers** and the prototype for thirty minutes. Their
confusion is the finding. Apply, merge.

*If you want visual design rather than wireframes, this is the one phase better
done in the Claude app's design canvas than in Claude Code — export the screens
as images into `docs/ux/`. Claude Code is the wrong tool for pixels.*

**Gate:** UX.md merged, prototype walked through by two officers, findings
applied. The SO's core loop is under two taps to log a normal outcome.

---

## Phase 5 — The plan: milestones on paper, tasks in Linear

*1–2 sessions · 1 PR + ~90 Linear issues · **the scope gate***

```
/resume
```

```
Plan mode. Start from M0-M8 in docs/reference/02-build-playbook.md. Adjust for
SPEC.md v1.0, ARCHITECTURE.md, INFRA.md and UX.md — including a staging deploy
at the end of M1. For each milestone: purpose, acceptance sentences, invariants
wired, PR estimate. For each task: name, files touched, one observable
acceptance sentence, invariant IDs, keystone yes/no, decisions it depends on.
Show me the milestone list first. Stop.
```

```
Approved. Write milestones into docs/PLAN.md. Create every task in Linear under
its milestone through the MCP, in execution order, using the issue template.
Then /adversarial-review docs/PLAN.md — lenses: dependency order, hidden scope,
missing acceptance sentences, anything not traceable to a SPEC requirement.
Apply. PR.
```

**How to read the task list:** can you watch each acceptance sentence happen? Is
anything in the list not in the spec? Does M1 wire INV-3 and INV-8? Push back
until it is right — approving the plan approves building all of it.

**Gate — scope.** PLAN.md merged; Linear shows every task under a milestone with
an acceptance sentence. Total in the range 80–110 PRs for Capture. From here, a new
task is a change request.

---

## Phase 6 — M0: set the table

*3–4 sessions · 3–4 PRs · execution model, except the last session*

1. **M0-T1** — scaffold and `pnpm check` green; CI green on a PR; you merge.
2. **M0-T2** — the remaining commands (`/resume` refined, `/add-connector`,
   `/review-keystone`, `/health-pass`) and `packages/connectors/_template` as an
   empty workspace with a README stating what a connector must export.
3. **M0-T3 — prove the hooks bite.** Three deliberate breaks, three refusals:
   a type error in the schema package and try to end the turn (the Stop hook
   must refuse); an edit inside `packages/scoring` that the task did not name
   (the path hook must refuse); a test file with zero tests (`pnpm check` must
   fail on the zero count). Commit none of the breaks. **This task feels
   pointless because nothing gets built. It is the difference between rules that
   exist and rules that are assumed to exist. Do it.**
4. **M0-T4** — refine M1's Linear tasks against the scaffold that now exists
   (strongest model, plan mode).

**Gate:** four PRs merged with green CI. You watched three hook refusals. M1's
tasks are refined. STATUS says "M0 complete, next M1-T1."

---

## Phase 7 — The build loop: M1 to M8, one task per session

*40–55 sessions · 80–110 PRs · ~3–4 months part-time*

Each milestone has three kinds of session. The middle one repeats.

### Milestone open — one session, strongest model

```
/resume
```

```
Plan mode. Milestone M3 is next. Re-read its Linear tasks against the codebase
as it now exists. Refine: split anything whose acceptance sentence is two
sentences, fix the order, flag keystones, and list the decisions I must make
before T1. Update the Linear issues. Don't edit code.
```

Resolve the listed decisions (in DECISIONS.md, via a one-line prompt), then say
"M3 is open."

### Task — one session each, execution model

| # | Step | Who |
|---|---|---|
| 1 | `cd synapse` · `claude` · `/model` shows the execution model · `/resume`. It reconciles STATUS with `git log` and names the next Linear issue in Todo. If they disagree, fix that first | Ahsan |
| 2 | Type the issue key: `SYN-42. Plan it. Don't edit.` Read the plan — files, acceptance sentence, invariants. Anything outside scope, say so. Then `Approved.` | Ahsan |
| 3 | Branch, using Linear's branch name. Linear moves the issue to In Progress. Small commits; the post-edit hook lint-fixes and typechecks | Claude |
| 4 | For anything that fixes or guards: `Show me the check failing before, passing after.` | Ahsan asks |
| 5 | Evidence: test output with counts, screenshot, request and response. Look at it | Claude shows |
| 6 | `/pr` — one command, and it refuses to skip a step. It runs the check, then `scope-differ` against the issue, then the right review tier (one reviewer, or three lenses plus skeptics for a keystone), then opens the PR with every template heading filled. If scope drifted it stops and asks you | Ahsan types it; agents do it |
| 7 | Read what `/pr` relayed: the scope verdict, the surviving findings, and what was done about each. This is the review you actually perform | Ahsan |
| 8 | Merge, by tier. **Docs/chore:** `/pr` already merged it. **Normal code:** it printed the evidence in-session and stopped — read it, say "merge it", Claude squash-merges. **Keystone:** open the PR in the browser, read the actual diff, merge it yourself. Branch self-deletes; Linear marks the issue Done | Ahsan decides; Claude merges except on keystones |
| 9 | `/close` — updates STATUS, records any decision, and appends the journal entry through `journal-writer`. It reports whether anything is still uncommitted | Ahsan types it |
| 10 | `/clear` | Ahsan |

The next session starts at step 1, and `/resume` names the next issue — that is
how you always know what is next.

`/resume` also runs the **process warden** — a read-only agent that audits the
repo against `docs/PROCESS.md` and reports RED and AMBER deviations before you
start. You do not have to remember to check; it fires at every session start.
Run `/checkpoint` any time you want it again. It reports and never fixes, and it
catches structural violations only — a missing issue, a thin PR description, a
stale STATUS, an unlogged session. It cannot catch a bad product decision. That
stays yours.

**Stuck** after two genuine attempts: `Write what was tried to
docs/notes/stuck-<topic>.md`, `/clear`, start again with the symptom and file
names only. Third time: bring the exact error text to the advisory session.

### Milestone close — one session

```
/resume
```

```
M3's tasks are all Done. Run /health-pass and open its PR. Then deploy main to
staging through the pipeline and walk me through M3's acceptance sentences on
staging, one by one, with evidence for each.
```

```
/close — and in the journal entry, cover the whole milestone: what M3 cost
against its estimate, what we got wrong in the plan, and what I should do
differently in M4.
```

Then return to the advisory session with the PR links and the acceptance
evidence; the next milestone's session sheet is written from those.

### Architecture Checkpoint 2 — end of M1

The walking skeleton *is* the architecture in code, and this is the last cheap
moment to change it. Does the queue feel right? Is the schema package the only
place a lead is defined? Did deploying to staging take a day or a week? Change
now what feels wrong; log it in DECISIONS.md.

**Gate — Capture done:** burst test passed on staging, restore drill timed, cost
estimate approved, STATUS says exactly what Act starts from.

---

## Phase 8 — Quality assurance: journeys that stay in CI

*4–6 sessions · 1 plan PR + fix PRs · against staging*

Continuous QA already happened — every milestone closed on staging with
acceptance evidence and a health pass. Final QA adds two things: end-to-end
journeys per persona that become **permanent regression tests**, and a
code-health sweep with several lenses at once.

### Session 8.1 — The QA plan (strongest model)

```
/resume
```

```
Plan mode. Write docs/QA-PLAN.md: for each persona in UX.md, the journeys to
automate as end-to-end tests against staging (Playwright for web; the SO app
via its web build, or Maestro if we have a device farm); seed data that is
production-shaped and contains no real person; the code-health lenses —
security, dependencies, error handling, data integrity, performance under the
burst; and exit criteria — zero open P1/P2, all journeys green in CI. Run a
short /adversarial-review on it. Stop for approval.
```

### Sessions 8.2+ — Execution (execution model, one agent per persona)

```
Approved. Journey suites: one agent per persona, each in its own worktree, each
writing its suite under apps/web/e2e/<persona>/ and running it against staging.
Every failure becomes a Linear issue labelled bug with P1-P3, the failing step,
and a screenshot. Then the code-health lenses, same pattern, findings to
docs/reviews/qa-health.md and to Linear.
```

Bugs go through the Phase 7 loop — they are tasks. The journey suites are added
to `pnpm check` or a nightly CI job, **so QA is a state, not an event.**

**What agents cannot do: UAT.** Put staging on the phones of two or three real
Sales Officers for a week with synthetic leads. Their feedback goes into Linear
labelled `feedback`. This is the only test of "would an officer open this app on
a Tuesday."

**Gate:** exit criteria met. Journey suites in CI and green. UAT feedback
triaged. Nothing labelled P1 or P2 open.

---

## Phase 9 — Production readiness

*1–2 sessions · 1–2 PRs · **Architecture Checkpoint 3***

```
/resume
```

```
Plan mode. Read docs/INFRA.md against what staging actually is. Write the
production environment in Terraform (not applied), docs/RUNBOOK.md — deploy,
rollback, restore, on-call, who to call — and a go/no-go checklist: backups
tested, restore timed, alerts wired, budgets at 50/80/100%, secrets in the
manager, no agent credential can reach production, monitoring dashboard, TLS,
data residency confirmed. Then /adversarial-review with lenses: failure modes,
cost, security, and "what does IT ask on day one". Stop.
```

**Architecture Checkpoint 3 — operational.** Different questions from
Checkpoint 1: what happens at 3 a.m. when the database fails over? Who gets the
Sentry alert? How long is a restore? What is the monthly bill and where are the
alerts? What is the rollback command, and has it been run once on staging? Every
answer must be in the runbook.

**Gate — go/no-go:** checklist all green, signed by Ahsan and, if Syngenta IT is
involved, by them. Cost approved in writing.

---

## Phase 10 — Release

*1 session · 1 PR + a tag*

The agent applies the production Terraform through the pipeline's approval step
— **Ahsan presses approve, on his account, with his credentials; the agent never
sees them.** Smoke test on production with a synthetic event. Tag `v1.0.0`.
STATUS says "v1.0.0 in production, next: operate."

**Gate:** a synthetic lead posted to production appears scored in the deployed
web list. The rollback was rehearsed on staging that week. Budget alerts fired a
test.

---

## Phase 11 — Operate and improve: the same loop, different labels

*Recurring*

**Intake.** Every piece of user feedback, every bug, every idea is a Linear
issue with a label — `feedback`, `bug`, `change-request` — and nothing else.

**Weekly triage session** (strongest model, plan mode): read the intake, propose
priority and milestone, propose which items need a decision. Ahsan decides.
Issues move to Todo or Backlog.

**Fixes** go through the Phase 7 task loop with the same review tiers.

**Hotfix path** for a P1 in production: branch from `main`, one PR, keystone
review regardless of size, deploy through the same pipeline with Ahsan's
approval, then a Linear issue for the root cause.

**Monthly:** one dependency-update PR alone; a health pass; the model-lift
number reported to leadership, even when unflattering.

---

## Session budget

| Phase | Sessions | PRs | Signal something is wrong |
|---|---|---|---|
| 0 · Foundation | 2 | 2 | CLAUDE.md over 45 lines |
| 1 · Base44 audit | 1–2 | 1 | Base44 code appearing in the repo |
| 2 · Specification | 2–3 | 2 | A third review round |
| 3 · Architecture | 2–3 | 2 | You cannot trace one grower end to end from the doc |
| 4 · UX | 2 | 1–2 | No real officer has touched the prototype |
| 5 · Plan | 1–2 | 1 | A task without an acceptance sentence |
| 6 · M0 | 3–4 | 3–4 | A hook that did not refuse |
| 7 · Build M1–M8 | 40–55 | 80–110 | Same task across three sessions; PR count double the plan |
| 8 · QA | 4–6 | 1 + fixes | Journeys not in CI a week later |
| 9 · Readiness | 1–2 | 1–2 | A runbook question you cannot answer |
| 10 · Release | 1 | 1 | An agent asking for a production credential |
| 11 · Operate | weekly | ongoing | Feedback arriving anywhere other than Linear |
| **Total to v1.0** | **~60–80** | **~95–130** | Reviews under 15% of usage — they are being skipped |

Phases 0–5 are roughly two to three weeks part-time and produce no product code.
That is the point: they are the cheapest weeks of the project, and every hour in
them removes a day from Phase 7.
