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
