# Synapse build journal

The narrative record of how Synapse came to be. **Append only.** One entry per
session, written by `/close` through the `journal-writer` agent.

This is the only record that keeps failure. `docs/STATUS.md` shows the present,
so yesterday's dead end vanishes from it. `docs/DECISIONS.md` records the choice
that was made, not the two hours spent discovering it was necessary. Linear
records work items. Without this file, the project's history reads as a clean
sequence of correct moves — which is both false and useless.

**Rules.** Never edit or delete an existing entry; if one is wrong, write a new
entry that corrects it and names the entry it corrects. Never restate a
decision's reasoning — reference it by date and title, the reasoning lives in
DECISIONS. Honest over flattering. "Learned: nothing new" is a valid line;
padding is not.

Read on demand only. This file is never auto-loaded, so its length costs
nothing.

---

## 000 · <!-- date --> · Phase 0 · seed

**Goal.** Establish the repository, the rule book, and the process that will
govern roughly a hundred pull requests.

**Shipped.** Nothing yet. This entry exists so entry 001 has a predecessor and
the numbering starts somewhere.

**What happened.** The architecture was settled on the Synapse System Canvas
v2.0. The engineering doctrine was adapted from the Prompt to Production laws
into the Build Playbook. An initial twelve-step build process was reviewed
against that playbook, and four structural gaps were found and closed: Linear
and the repo were both going to hold "what's next"; the first deployment sat
after QA rather than at the walking skeleton; adversarial review was applied
uniformly rather than tiered; and "one step, one session" was the wrong unit of
work. The corrected eleven-phase sequence became the Delivery Process.

A second review added four more: agents take their reference from `.md` files
rather than session transcripts; one agent does one job; a read-only process
warden red-flags process violations; and this journal exists.

**Went wrong.** Nothing yet — which is the only time that line will be true.

**Decisions.** See `docs/DECISIONS.md` entry 001, "Delivery process adopted".

**Learned.** The rule files and the agent definitions are worth writing *before*
the first session rather than generating in it: a first session spent
re-deriving settled rules is a first session that never looks at the product.

**Evidence seen by Ahsan.** The three source documents, the delivery process
review, and this starter folder.

**Open at close.** Everything. Phase 0, session 0.1 is next.

---

## 001 · 2026-09-11 · Phase 0, session 0.1 · planning (strongest model)

**Goal.** Run Phase 0 session 0.1 per `docs/reference/03-delivery-process.md`:
read the canvas and the rule book, correct what they got wrong, establish
`main`, configure GitHub, seed Linear, write the remaining docs, open PR #1.

**Shipped.** Nothing merged. PR #1 "docs: rule book and process" is open on
`chore/rule-book` (Closes SYN-5) — 15 files, +407 −58, commits `e902393` and
`993e72d` on top of the baseline `f2bd66e`. Ahsan merges it himself: the docs
tier needs CI green before Claude may merge, and CI does not exist until M0-T1.

**What happened.** The canvas was read first; the session answered what the
product is and named five blocking decisions, and Ahsan immediately cut two of
them (D3 is gated to M5, D6 is not in Capture at all) leaving D5, D4, D1.
Reading `CLAUDE.md`, PROCESS, INVARIANTS and 03-delivery against each other
turned up five defects in Ahsan's own documents — a false enforcement claim in
PROCESS A5, "Phase" meaning three different things, "L1" meaning three more, a
playbook that still said Ahsan clicks every merge, and M1's "v0 engine", which
Ahsan ruled intentional. He ruled on all five and fixed the vocabulary. An
eight-step plan was shown and the session stopped there, as `CLAUDE.md` requires;
before approving, Ahsan asked only for the Linear MCP registration, so
`.mcp.json` (project scope) and a minimal `STATUS.md` were written and nothing
else was touched, with the plan reported as unapproved and unexecuted. After
approval: git identity set repo-local only, baseline `f2bd66e` (34 files) pushed
to `main`, `/setup-repo` run, Linear read before it was written (nine milestones
M0–M8, six labels, exactly two issues SYN-5 and SYN-6), then 40 exact-match
doc replacements across seven files by a script that asserted each pattern
matched exactly once — grep afterwards found zero stale IDs.

**Went wrong.** GitHub refused branch protection, rulesets, a required reviewer
on `production`, and secret scanning: "Upgrade to GitHub Pro or make this
repository public." Rulesets were tried as a fallback and refused too. No
document anticipated this — PROCESS G1 and G2 both assume the features exist —
so the repo currently has no protection at all and warden checks 17 and 19 will
report RED every session until Ahsan resolves it. Separately, Windows git has
`core.autocrlf=true` globally and every commit warned that LF would become CRLF;
the bash hooks would have broken on a fresh Windows clone, so an unplanned
`.gitattributes` forcing LF was added and declared in the PR (the committed tree
was checked: zero CRLF files). The first attempt to run the edit script as a
bash heredoc died on a quoting error and was fixed by writing the script to a
file and running it from there — minutes lost, not recorded exactly. Two of
Ahsan's own tools, `close.md` and `journal-writer.md`, contradict PROCESS A1 by
expecting session facts pasted into the agent prompt; this session worked around
it by writing the facts to a file and passing the path. `STATUS.md` finished at
27 lines against `close.md`'s 25-line cap, because Ahsan asked it to carry the
repo and Linear identifiers and the setup states. The four Linear onboarding
issues SYN-1–SYN-4 were left untouched — outside the project, so harmless to
`/resume`, but noise.

**Decisions.** Six entries, all 2026-09-11: "Delivery process adopted";
"Naming corrections: Phase, Pilot / Wave, Engine vN, LIN, Capture / Act";
"Enforcement-precision correction"; "D5 decided: proceed on the playbook default
stack"; "Shared team account, repo-local identity, and break-glass";
"OPEN: GitHub plan blocks branch protection, production gate and secret
scanning"; plus the D1–D7 open-decisions table.

**Learned.** Opening `.claude/settings.json` before believing the sentence that
described it found the session's most important defect in under a minute —
verify the mechanism, then the prose. And a platform assumption ("branch
protection exists") can sit unexamined in a rule book until the API says no, so
every "GitHub does X for us" rule needs a first-session check.

**Evidence seen by Ahsan.** The eight-line product summary and the five
decisions; the enumerated line-by-line list of every Phase/L1 rename; the plan
with its assumptions labelled; the git identity values before they were set; and
the repo state and Linear read-back reported in-session. He has not yet opened
PR #1.

**Open at close.** PR #1 awaiting Ahsan's merge (SYN-5). The GitHub plan
decision is OPEN in DECISIONS and blocks SYN-6. Linear still needs Ahsan's click
for the issue template and an "In Review" status — the MCP cannot create either.
Session 0.2 carries: verify hooks and agent models, `/checkpoint`, file the
Cropwise and AWS access requests, ask who owns the Meta app, and correct the
`close.md` / `journal-writer.md` conflict with PROCESS A1.

---

## 002 · 2026-09-11 · Phase 0, session 0.2 · triage and setup (strongest model)

**Goal.** Triage the process warden's first run, park the GitHub Pro question,
install an interim pre-push hook and prove it bites, make the warden
proportionate, and finish the Linear and MCP setup left open by session 0.1
(SYN-5).

**Shipped.** Nothing merged. PR #1 is still open on `chore/rule-book`; this
session's work is nine files uncommitted at close (+238 −41): `.githooks/pre-push`,
warden / `pr.md` / `resume.md` / `settings.json` / `.mcp.json` changes, and
PROCESS, DECISIONS and STATUS edits.

**What happened.** The warden ran for the first time via `/checkpoint` and
returned RED G1 (no branch protection), RED G2 (no production reviewer), AMBER
PR3 (PR #1's Evidence line said 15 files/+407/−58 while the branch was
16/+456/−68 — the `/close` commit landed after the description was written),
AMBER PR1 (524 lines, no reviewer ran) and AMBER LIN3; checks 5–7 and 18 could
not run at all. Ahsan ranked the stale-evidence finding first and ruled that the
Evidence line is written last, against the diff actually being merged. The two
RED gates were then reclassified rather than chased: Pro was parked with a
single un-park trigger, and the warden itself was made proportionate. Linear was
finished — "In Review" verified present, GitHub integration connected, SYN-1–4
Canceled because the MCP has no delete tool — and the Base44 MCP was registered
in `.mcp.json` at project scope over OAuth PKCE, unverified until next session.
Then the hook probe went wrong.

**Went wrong.** The probe intended to prove the pre-push hook pushed session
0.1's commits to `main` instead. Claude chained the hook wiring and the probe
into one command; `git update-index --chmod=+x` failed on an unstaged file, the
`&&` chain stopped before `git config core.hooksPath .githooks` ran, and
`git push origin chore/rule-book:main` then executed with no hook installed. It
succeeded. `origin/main` moved from the baseline `f2bd66e` to `337fb78`: three
commits reached `main` with no merged PR and no read by Ahsan, while PR #1 was
open for exactly that content. The second probe, `git push origin --delete main`,
was rejected — but by GitHub, which refuses to delete a default branch on any
plan, not by the hook; for a few minutes that rejection looked like the hook
working. No restore was attempted: it is a history rewrite, G4 makes it Ahsan's,
and `settings.json` denies force pushes. The second attempt wired the hook
first, verified `core.hooksPath` and the `100755` index mode with read-only
commands, then tried a dry-run push to `main` — and was refused before git ran
by the deny rule (`Bash(git push*:main*)`) Claude had added to `settings.json`
minutes earlier. So the git-level probe could not be run by Claude at all
without routing around a deny, which it did not do; what was proven instead is
the script's logic, fed the three cases on stdin: refuses an update of `main`
(exit 1), refuses a deletion of `main` (exit 1), passes another branch (exit 0).
Ahsan runs the real probe from his own terminal. Separately, `STATUS.md` broke
the 25-line cap again (about 33 lines), and `close.md` and `journal-writer.md`
still expect pasted context in contradiction of PROCESS A1 — worked around with
a facts file for the second session running.

**Decisions.** All 2026-09-11: "PARKED: GitHub Pro for branch protection and the
production gate" (replacing the OPEN entry recorded in entry 001, which never
reached `main`); "PR #1 size accepted as a one-off Phase 0 exception";
"Docs-only PRs are reviewed by Ahsan reading them"; "Warden proportionality: G1
three-state, G2 phase-aware, Linear checks move to /resume"; "INCIDENT: `main`
received a direct push during the pre-push hook probe".

**Learned.** A probe that can do damage must be preceded by a read-only check
that the guard is actually in place — chaining setup and probe with `&&` turns a
setup failure into the exact event the guard exists to prevent. In Ahsan's
words, "a hook that has never blocked anything is a hook I'm assuming works";
the first probe proved the inverse, that a hook assumed wired was not wired. The
one enforcement claim tested against reality this session, the permission deny,
held.

**Evidence seen by Ahsan.** The warden's first report verbatim, relayed through
`/checkpoint`, and his five rulings on it. He has not yet seen the incident, the
hook's stdin test output, or PR #1 itself; those reach him through this entry,
DECISIONS and STATUS.

**Open at close.** The incident decision (a) restore or (b) accept — Ahsan,
before merging PR #1. The hook probe from Ahsan's terminal (command in STATUS).
PR #1's Evidence line, to be rewritten by Claude once `main` is settled, then
read and merged by Ahsan. Deleting the Canceled SYN-1–4 if he wants them gone.
Base44 MCP verification at next session start. Still carried from entry 001 and
not done: `close.md` / `journal-writer.md` vs PROCESS A1, and the STATUS length
cap, which now conflicts with the "never hunt for these" requirement — Ahsan
settles which wins. Session 0.1's other carry-overs (Cropwise and AWS access
requests, the Meta app owner) were not touched this session.

---

## 003 · 2026-09-11 · Phase 0, session 0.2 · correction

**Corrects entry 002.** Entry 002 says "PR #1 is still open on `chore/rule-book`"
and reports the incident as `main` moving. Both were already false when written.

**Goal.** Record what was established about the incident after entry 002 was
appended (SYN-5).

**Shipped.** Nothing merged by a human. `gh pr view 1` reports PR #1 **MERGED**,
`mergedAt` 2026-09-11T13:02:13Z, `mergedBy` `pksyngentadigital-ship-it` — the
shared account — with merge commit `337fb78`. GitHub treated the incident push
as the merge. No human read the PR before it merged; the merge time is the time
of the bad push. Session 0.2's own work is one commit, `58b5deb`, on
`chore/rule-book`, with no PR open for it.

**What happened.** Three further consequences surfaced after entry 002 was
written. Delete-branch-on-merge removed `chore/rule-book` on the remote, so
Claude's next push recreated it ("[new branch]") and this was noticed only when
reading the push output afterwards. Linear did not move SYN-5 to Done: the
GitHub↔Linear integration Ahsan reported connected did not fire on this merge,
and STATUS now carries it as not verified. Local `main` was fast-forwarded to
`origin/main` (`337fb78`) so `/resume`'s reconcile does not report a false
disagreement. Opening PR #2 for `58b5deb` needs a Linear issue, and Ahsan capped
the session at two, so Claude stopped and asked rather than creating one.

**Went wrong.** Entry 002 itself: it understated the incident by reporting only
the branch move, having never checked the PR's state. Nothing else in entry 002
changes.

**Decisions.** The same-day update to "INCIDENT: `main` received a direct push
during the pre-push hook probe" (2026-09-11), which withdraws option (a) restore
and recommends (b′) accept.

**Learned.** After an unintended push, check what the push did to everything
downstream of it — the PR, the branch, the integration — not just the ref that
moved. A journal entry that understates an incident is exactly the fiction the
journal exists to prevent, which is why this entry exists at all.

**Evidence seen by Ahsan.** The `gh pr view 1` output above and the DECISIONS
update built from it. He has still not read PR #1's diff.

**Open at close.** Ahsan's ruling on (b′) accept, and his after-the-fact read of
PR #1's diff. One Linear issue to authorise so `58b5deb` can go in as PR #2. The
GitHub↔Linear integration's repo access to check. Everything else carries
forward unchanged from entry 002's "Open at close".

---

## 004 · 2026-09-12 · Phase 0, session 0.2 continuation · decision and evidence

**Goal.** Get Ahsan's ruling on the incident and his own proof that the pre-push
guard works, then turn both into written rules and open PR #2 for session 0.2's
work (SYN-7).

**Shipped.** Nothing merged. Session 0.2's earlier commits (`58b5deb`,
`973b37c`) sit on `chore/rule-book`; this continuation's edits — PROCESS §13,
the two DECISIONS updates, STATUS, warden check 17 — were still uncommitted when
this entry was written, and go to Ahsan as PR #2, "Closes SYN-7", docs only.
SYN-7 was created after Ahsan authorised it as the one issue beyond his
two-issue cap.

**What happened.** Ahsan ruled first: accept `main` as it stands, no restore —
"a force-push to fix a bookkeeping problem is worse than an honest record" — and
he read PR #1's diff after the fact, which is the PR5 control that PR #1 never
got at merge time. He then proved the hook from his own terminal in three steps:
`core.hooksPath` → `.githooks`, the hook at mode `100755`, and a **live**
`git push origin chore/rule-book:main` — the exact action that caused the
incident — refused with "pre-push: REFUSED … nothing was pushed". All three
links verified: installed, logic correct, invoked by git. That output is quoted
in the INCIDENT entry rather than paraphrased. The incident then became rules:
PROCESS §13 gained "Proving a guard" — never prove a guard by performing the
dangerous action against the real thing while it is unverified, and installation
and verification are two separate steps with two visible outputs, never chained
with `&&`. The parked GitHub Pro entry gained the measured cost: an unprotected
`main` lets a direct push silently mark every open PR whose commits it contains
as merged. It stays parked. Warden check 17's AMBER wording was tightened to
"substitute verified".

**Went wrong.** Nothing new this continuation. The Base44 MCP loaded on restart
— its tools appeared — but is not authorised; OAuth needs `/mcp` in an
interactive session, so STATUS records it as registered, loads, not yet
authorised.

**Decisions.** "INCIDENT: `main` received a direct push during the pre-push hook
probe" (2026-09-11), closed 2026-09-12 with accept (b′) plus the guard-proven
evidence. "PARKED: GitHub Pro for branch protection and the production gate"
(2026-09-11), amended with the measured cost.

**Learned.** A guard proven by the person it protects, with the live dangerous
action, is a different kind of fact from one Claude reports as wired: Ahsan's
terminal output is the evidence, Claude's read-back was only the precondition.
The other half is that the three-layer design held where it was supposed to —
the weakest layer, an assumed hook, is what failed; the `settings.json` deny
caught Claude's next attempt, and the hook now catches Ahsan's.

**Evidence seen by Ahsan.** PR #1's full diff, read after the fact. His own
terminal output for all three hook checks and the live refused push — produced
by him, not reported to him. The PROCESS §13 and DECISIONS text built from it,
which he reads again in PR #2.

**Open at close.** PR #2: Ahsan reads and merges. Linear should then move SYN-7
to Done; if it does not, the GitHub↔Linear integration is confirmed broken
rather than merely unverified. Base44 OAuth via `/mcp`, Ahsan, interactive
session. Still carried and still not done: `close.md` / `journal-writer.md`
vs PROCESS A1, and the STATUS length cap. Session 0.1's carry-overs (Cropwise
and AWS access, the Meta app owner) were not touched again.

---

## 005 · 2026-09-13 · Phase 0 close · checkpoint and phase close

**Goal.** Run the warden a second time, clear its one actionable finding, and
close Phase 0 (SYN-7).

**Shipped.** Nothing merged. PR #2, "chore: warden triage, interim push guard,
incident record" (`chore/rule-book` → `main`, Closes SYN-7), is still open and
now carries four commits, 10 files, +519 −41. This session added `b967d80`
(DECISIONS, the Phase 0 PR-size class) and an uncommitted STATUS rewrite
declaring the phase complete.

**What happened.** `/checkpoint` ran the process warden a second time. No RED.
Two AMBER: G1 — no branch protection, substitute verified, parked, nothing to
do — and PR1, PR #2 over the ~400-line ceiling with a size note but no
DECISIONS entry backing it, because PR #1's exception had been scoped "one-off".
The two checks rewritten after the last warden run behaved as designed: the new
three-state check 17 reported AMBER-with-substitute rather than a false RED, and
the phase-aware check 19 emitted a single informational line. Ahsan ruled on
PR1 by widening the exception to a class rather than to everything, and PR #2's
Evidence line and size note were then updated to the current numbers and to
cite that entry. Phase 0 was declared complete, pending his read and merge.

**Phase 0 in total.** Three calendar days (2026-09-11 to 2026-09-13), three
sessions plus one continuation, five journal entries of which two were
corrections, two PRs (#1 merged by the incident, #2 open), eleven DECISIONS
entries, one incident. The plan budgeted two sessions and two docs-only PRs.
The overrun came from the incident and from enforcement claims in the starter's
own documents that turned out to be untrue and had to be corrected before
anything downstream could rest on them.

**The incident, in one place.** On 2026-09-11 a hook probe pushed session 0.1's
commits straight to `main` before the hook was wired, and GitHub marked PR #1
merged by the shared account with no human read. On 2026-09-12 Ahsan accepted
`main` as it stands rather than force-push a fix, read PR #1's diff after the
fact, and proved the guard himself: `core.hooksPath` and the `100755` mode
confirmed first, then a live `git push origin chore/rule-book:main` from his
own terminal **refused by the hook** — installed, logic correct, invoked by
git, all three links verified. Two rules came out of it in PROCESS §13,
"Proving a guard". The three-layer design held: the weakest layer, an assumed
hook, is the one that failed; the deny rule caught Claude's next attempt and
the hook caught Ahsan's.

**Went wrong.** Nothing this session — the warden's finding was correct and
cheap to clear. The honest entry for the phase is in entries 002 to 004, not
here.

**Decisions.** "Phase 0 documentation PRs may exceed the ~400-line ceiling"
(2026-09-13), which supersedes the "one-off" scope of "PR #1 size accepted as a
one-off Phase 0 exception" (2026-09-11) without contradicting its reasoning.

**Learned.** A finding resolved as a bounded class beats a one-off exception:
it clears the warden for the rest of the phase in one entry, and the M0-T1
boundary stops it drifting into the code era where the ceiling actually earns
its keep.

**Evidence seen by Ahsan.** The warden's second report verbatim. PR #2 is his
to read next.

**Open at close.** PR #2: Ahsan reads and merges; SYN-7 should then move to Done
via the GitHub↔Linear integration, and if it does not, the integration is
confirmed broken rather than merely unverified. Base44 OAuth via `/mcp` in an
interactive session, before Phase 1. Carried and still open: `close.md` and
`journal-writer.md` contradict PROCESS A1 on pasted context; STATUS exceeds its
25-line cap because Ahsan asked it to carry the identifiers; the Cropwise and
AWS access requests and the Meta app-owner question are not yet filed. Phase 1
next: the Base44 audit.

---

## 006 · 2026-09-13 · Phase 1, session 1.1 · audit (Base44 read-only)

**Goal.** Audit the live Base44 product "Smart Agro Lite" (app
`69690a59f22f6e749b0986ec`) read-only and turn it into
`docs/notes/base44-audit.md`.

**Shipped.** PR #3 — Phase 1 Base44 audit of Smart Agro Lite plus deny rules for
the thirteen forbidden Base44 tools; open, awaiting Ahsan's read and merge.
946 lines of audit (22 screens, 11 forms, data model, 177 business rules flagged
UI-ONLY/DATA-ONLY/BOTH, a 74-row gap table, 22 do-not-carry-forward patterns,
11 unknowns), `.claude/settings.json`, `docs/DECISIONS.md`, `docs/STATUS.md`.
Nothing merged this session; the last merged PR is still #2. Outside the repo, a
reference mirror at `~/synapse-reference/base44/` — 150/150 files, 8/8 entity
schemas, MANIFEST.md carrying the full call log.

**What happened.** `/resume` opened on drift: PR #2 had merged after session
005's close, STATUS did not know it, and the checkout was sitting on the merged
branch — warden reported no RED and three AMBER, all housekeeping, all cleared.
Base44 auth turned out to already work through the desktop connector despite the
banner saying the `.mcp.json` server needed authorising; two registrations
exist, one of them live. `list_user_apps` returned exactly one app, which
removed any question of which product to audit. The plan had to route around a
hard limit — the explorer agent type has only Read/Grep/Glob/Bash and cannot
call MCP tools at all — so it proposed exporting first with a general-purpose
agent limited to seven read tools, denying the thirteen forbidden tools in
settings, then pointing explorers at the on-disk mirror. Ahsan approved with
three additions: widen the existing size decision rather than open a new one,
fix SYN-5 and SYN-6 by hand, and record the sandbox-isolation question honestly
rather than bury it. The export ran about nine minutes, 24 Base44 calls, zero
forbidden, zero failures; seven explorers then ran in parallel with one question
each and their answers became the audit. scope-differ came back CLEAN, PR #3
opened, and Linear attached it.

**Went wrong.** One `list_directory` call at the repo root ran during planning,
before "Approved", just to size the job — read-only and permitted, but it spun
up a Base44 sandbox from the app's last commit, so the first touch of the live
product's platform happened before the plan was approved; whether that sandbox
is isolated from the live app cannot be determined, and the question is recorded
as audit §8.1 at Ahsan's request. The deny rules are on disk and valid JSON but
unproven live, because proving them means attempting a forbidden tool. The
reference doc's Phase 1 assumes `~/synapse-reference/base44/` already exists; it
did not, and inventing the export step cost a decision round. Seven `read_file`
responses blew past the MCP client's inline display cap and the export agent had
to pull the saved JSON off disk by script — verified at 0 mismatches, but a
workaround nobody designed. Linear's integration moved SYN-8 to In Progress on
PR open, not In Review as PROCESS LIN3 claims. The size exception and the PR it
excuses ride in the same PR, which is self-authorising; scope-differ flagged it,
Ahsan instructed it anyway, and it is named here so it stays visible. PR4's
"`pnpm check` before a PR" is vacuous before M0 because no `package.json`
exists. And the `/close` skill still says to paste the session narrative into
the journal-writer's prompt, which PROCESS A1 forbids — worked around this
session by writing a facts file and passing only its path.

**Decisions.** "Docs-only PRs before M0-T1 may exceed the ~400-line ceiling"
(2026-09-13, the same entry widened from "Phase 0 documentation PRs"). "Base44
is read-only reference, enforced by deny rules" (2026-09-13).

**Learned.** A wide read over an MCP source needs an on-disk mirror before any
explorer can touch it — budget an export step into every audit-shaped task — and
"read-only" is not the same as "no side effects": a listing call created platform
state, so size a live target from the plan text, not from a call. Two smaller
ones: a deny list is strength-1 enforcement for one edit where a prompt-level
tool ban is only strength 3, and the product's own documentation is a claim, not
evidence — it asserted a mutation-tested harness that does not exist.

**Evidence seen by Ahsan.** Nothing yet on the deliverable; PR #3 is his to read.
In session he saw the `list_user_apps` result (one app), the settings.json
valid-JSON check at 49 deny entries, the DECISIONS and settings diff stat, a
phone-pattern grep returning 0 in both the audit and the diff, the section
listing (12 headings, 946 lines), the export manifest counts, and scope-differ's
CLEAN verdict. He read the plan and the `/resume` block and returned three
additions.

**Open at close.** PR #3 merge, by Ahsan, after reading §5 and §6 and confirming
the business-rules list — that confirmation is SYN-8's acceptance. Deny rules to
be proven live at the next session start at the earliest. Phase 2, session 2.1:
the SPEC draft, with audit §5–§8 as inputs. The `/close` skill text still
contradicts PROCESS A1; a small fix for a later docs PR. SYN-6 parked, trigger
unchanged ("Ahsan says Pro is connected"). SYN-5 was set Done by hand this
session — an instructed exception to LIN3, since PR #1 merged on 2026-09-11 and
the integration never moved it.

---

## 007 · 2026-09-28 · Phase 2, session 2.1 · specification draft (2026-09-15 to 2026-09-28)

**Goal.** Draft `docs/SPEC.md` from the canvas, the Base44 audit and
INVARIANTS, per `docs/reference/03-delivery-process.md` §Session 2.1 (SYN-9).

**Shipped.** PR #4, "docs: SPEC.md v0.9 — seven parts approved by Ahsan
(SYN-9)", squash-merged as `5c1bcde` on 2026-09-28: SPEC v0.9 in seven
plain-language parts plus a technical appendix, five verbatim input notes
(`docs/notes/spec-input-2026-09-15.md`, `-16`, `-17`, `-18`, `-25`), eleven
DECISIONS entries, STATUS. Docs-only, 8 files, +2064 −47; scope-differ CLEAN.
Recorded here because no entry did at the time: PR #3 (the Base44 audit)
merged between sessions as `304a3be` on 2026-09-15.

**What happened.** `/resume` opened on drift again: PR #3 had merged but STATUS
still said awaiting merge and no journal entry recorded the merge; the warden
caught both. The first plan was rejected, and so were the next three, as Ahsan
reshaped what he wanted — plain language rather than a technical spec, the
document split into parts he could review one at a time, and every open point
put to him as a question with options. The fifth plan was approved. After that
the loop settled: one question at a time, a recommended option and two
alternatives, his answer saved to a dated note, the rows rewritten, the part
shown with counts, his approval by name. Parts 1 to 6 were approved on
2026-09-21. Hina, a third-party AI calling agent that fills lead gaps by phone
before routing, was in no document before the session and first surfaced in
the middle of Part 5; the geo hierarchy and routing rules arrived after Part 6
in Ahsan's 2026-09-25 note. Part 7 was therefore drafted after PR #4 was
opened — the branch is still named `...-in-six-parts` — and its questions were
re-asked from the start on 2026-09-28 at his request before he approved it.
He then said "merge it".

**Went wrong.** The session opened a session behind, as entry 006 had: STATUS
stale and a merge with no journal record. Four rejected plans cost most of
15–17 September. Ahsan's raw input came in as chat pastes, against PROCESS X7,
and was written to `docs/notes/` after the fact rather than before. Answers
changed on re-asking: the no-number signal went from "routed anyway" to held
and matched; the outside-data answer, first pressed by accident, was re-asked
and gained the e-commerce stream; the map answer was revised the same day
after he read the applied change; list owners were re-asked; and Part 7 was
re-asked from zero. Each change was cheap to record but meant rewriting rows
across several parts and the appendix. Two scope facts, Hina and geo routing,
reached the spec late because they existed only in Ahsan's head; the canvas
and audit held neither. The 21 September answers were appended to the
18 September note instead of a new dated file, so that note's filename no
longer dates all of its contents. Bash heredocs with long single-quoted lines
failed twice, and the scripts had to go through scratch files. `/pr`'s
docs-tier merge waits on CI, but no workflow exists before M0-T1, so there
was nothing to watch; Ahsan's "merge it" stood in for the check.

**Decisions.** 2026-09-15 "D9 decided: a healthy Crop Doctor scan is a lead
only at or above the acreage threshold; D8 is unused" · 2026-09-15 "Three
ranked segments replace the canvas's four tiers; no daily cap" · 2026-09-15
"The lead clock stays; a breach notifies, it never reassigns" (two clocks
added 2026-09-18) · 2026-09-16 "One acreage threshold, 20 acres, as an Admin
setting" · 2026-09-16 "Eight personas, not six" · 2026-09-17 "Acreage replaces
'order value' as a scoring ingredient" · 2026-09-18 "D1 decided" · 2026-09-18
"D4 decided" · 2026-09-21 "Hina, a third-party AI calling agent, fills lead
gaps by phone before routing" · 2026-09-21 "Scoring details for the Pilot" ·
2026-09-28 "Geo hierarchy and routing".

**Learned.** Asking one question at a time, with a recommended option and two
alternatives, gave 76 recorded answers and eleven decisions with very little
drift. A plain-language body with a separate technical appendix let the product
owner mark every row himself, and keeping each input in a dated file made
every reversal traceable. The cost: scope that lives only in the product
owner's head, as Hina and geo routing did, turns up late. Ask "what is not in
the canvas?" before Part 1, not after Part 6.

**Evidence seen by Ahsan.** Each part in session, with its counts: rows,
assumptions, banned technical words, phone-shaped strings. He approved all
seven parts by name. The PR #4 body carried the whole-document counts: 275 rows,
275 traceability rows, 11/11 keepers, 25/25 mistakes, 0 assumptions open. He
told us to merge PR #4 without a CI run, because no workflow exists yet.

**Open at close.** Session 2.2, the adversarial review to v1.0; its Linear
issue has not been created. `docs/PLAN.md` M8 still describes the acreage
cascade that Hina replaces; to change in Phase 5. D2 still needs its recipient
and date recorded in DECISIONS. Ahsan still has to name the address-conversion
service (SPEC P7-14). At
close, the post-merge STATUS rewrite and this entry are uncommitted on `main`.
Carried from 006 with no record of progress: live proof of the Base44 deny
rules, and the `/close` skill's conflict with PROCESS A1.

---

## 008 · 2026-10-01 · Phase 2, session 2.2 · adversarial review and SPEC v1.0 (2026-09-28 to 2026-10-01)

**Goal.** Run the round 1 Tier A adversarial review of `docs/SPEC.md` v0.9
(attack plan, seven lens reviewers, a skeptic per finding, a triage file,
Ahsan's triage), then apply what he accepted as SPEC v1.0 (SYN-11).

**Shipped.** PR #5 (SYN-10, the session 2.1 close: STATUS and entry 007),
squash-merged as `f000743` on 2026-10-01 on Ahsan's approval. The SYN-11
branch is not merged. It holds eleven commits plus one merge of `main`
(17 files, +8614 −597 against `f000743`). Its PR is opened after this entry,
and Ahsan merges it when he says so.

**What happened.** The session ran over four sittings. On 2026-09-28 the brief
was filed and the attack plan approved. Seven lens reviewers raised 208
findings. Merging duplicates left 189 claims, and the skeptics started on
Fable 5.1. On 2026-09-29 usage limits stopped the skeptic run four times, and
Ahsan had the last 23 skeptics (F-R7-12 to F-R7-34) run on Opus 5.5. The
write-up, `docs/reviews/spec-r1.md`, followed: 136 claims survived and 53 were
refuted, giving 126 entries after deduplication, 4 of them blockers. Triage on
2026-09-30 grouped findings by theme into rounds. On 2026-10-01 it went one
finding at a time and finished all 126 entries and the 44 narrower claims,
then cleared every park except S61. The rest of that day:

- `/checkpoint` (0 RED, 4 AMBER).
- PR #5 merged, and `main` merged into the branch.
- 18 DECISIONS entries written and approved before SPEC was touched.
- SYN-12 and SYN-13 created for the parks.
- SPEC v1.0 applied: 22 rows added, 163 changed, none removed; DR-34 to
  DR-39; new sections 6.7 (open items) and 6.8 (the Pilot); A.1 regenerated by
  script to 297 rows.
- PLAN M7 gained the e-commerce purchase stream.

**Went wrong.**

- **Model change mid-review.** Usage limits split the skeptic pass across two
  models, Fable 5.1 then Opus 5.5 for the last 23. That breaks PROCESS §8's
  strongest-model rule. Ahsan decided it, and the split is stated in the
  `spec-r1.md` header.
- **App quits.** The desktop app quit twice during triage. After the first
  quit, answers were saved to `triage.md` before every round. Nothing was
  lost, but one round had to be asked again.
- **Shell failures.** For a while the Bash safety check kept failing. A large
  heredoc hit the Windows shell limit: a DECISIONS append wrote nothing and
  was redone from a file.
- **Generator bugs.** The first version of the `spec-r1.md` generator wrote
  markdown in which a list field swallowed the next field, and its parser
  dropped blank lines inside fields. Both were fixed before commit.
- **Stray file.** A script run from the wrong folder left a stray `verd.json`
  in the repo root. It was removed before any commit.
- **No `/close`.** The first three sittings ended without `/close`, and STATUS
  on `main` stayed stale until PR #5 merged. The warden flagged it as AMBER
  §6 and §14. This entry covers those sittings.
- **Reversals without DECISIONS entries.** Seven triage answers reversed
  earlier decisions with no DECISIONS entry, and the warden flagged it as C3.
  The entries were written and approved before SPEC was edited.
- **Dense questions.** Many triage questions were too dense, and Ahsan asked
  more than once for them to be split, explained or simplified.
- **S22 half applied.** The second half of S22 (a "not worked" outcome) was
  not applied, because the question as asked covered only the SUL headcount.

**Decisions.** All dated 2026-10-01:

- "SPEC.md review round 1 triaged: 170 decisions, recorded in the review
  folder"
- "Contact means the grower was reached; the clocks run on the phone's time"
- "A settings change applies to leads that reach an SUL after it"
- "Clocks also pause on holidays Admin lists; the working week is defined
  once"
- "Managers get targets, entered by Admin or DBO on Head of Sales'
  recommendation"
- "DBO has its own login role, and the call centre sits under DBO"
- "RSMs see a grower's number only on overdue, flagged or pool leads"
- "The Pilot may run one or more campaigns; 'NPI' is a tag"
- "A campaign signal whose campaign cannot be read is held until it can be"
- "SULs see their leads on a Google map; village boundaries are not shown to
  SULs"
- "A lead with no valid number is closed, not held for later matching"
- "What Hina says is approved by Marketing for campaign leads and by Admin or
  DBO for the rest"
- "Portfolio Managers own and approve the agronomy lists"
- "Every scoring-weight change notifies every stakeholder"
- "Cost per lead leaves the Pilot"
- "The 'Last season' tab holds this season's leads from last season's
  growers"
- "PARKED: SUL app 2G/3G numbers and the field phone survey (S61)"
- "PARKED: restore rules, uptime target and secrets storage go to INFRA.md
  (N9, S84)"

**Learned.** Ahsan decides quickly when each question covers one finding, in
plain words, with the recommendation first. Grouped questions came back
unanswered. Save each answer to disk before asking the next round, and count
tallies by script from the verdict and triage files rather than quoting them
from memory.

**Evidence seen by Ahsan.** He saw:

- the `spec-r1.md` hand-over and a plain summary of all 126 findings;
- the triage questions, which he answered (170 decisions);
- the 18 DECISIONS entries, which he approved with one correction: Google Maps
  is built in-house, not bought from a vendor;
- the `/checkpoint` report;
- the SPEC v1.0 diff summary, as counts.

He had not read the SYN-11 PR at the time of writing.

**Open at close.**

- The SYN-11 PR is open and unmerged. The post-PR process check runs in this
  same session.
- SPEC 6.7 has 24 open items. Decisions D2, D3, D6 and D7 are open.
- Parked: SYN-6, SYN-12 (Phase 4) and SYN-13 (Phase 3).
- PLAN M8 ("WhatsApp callback") and M6 (the lifted D1 gate) are out of date.
- The `merges.md` header still says 20 merged and 188 claims. `spec-r1.md`
  corrects this to 19 and 189.
- At the time of writing, the STATUS rewrite and this entry were uncommitted
  on the branch. The local `main` ref was still at `5c1bcde` behind
  `origin/main`.

---
