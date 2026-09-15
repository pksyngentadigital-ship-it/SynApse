# Synapse decisions

Dated, with reasons. Append-only: a reversal is a new entry that names the one
it reverses. Parks carry an un-park trigger. `/resume` loads titles only; the
bodies are read on demand. The reasons are the only part worth anything in six
months.

---

## 2026-09-11 — Delivery process adopted

**Decision.** Synapse is built under `CLAUDE.md`, `docs/PROCESS.md` and the
eleven-phase sequence in `docs/reference/03-delivery-process.md`, with
`docs/INVARIANTS.md` as the test and review gate. Linear holds work; the repo
holds knowledge; `docs/JOURNAL.md` holds what happened.

**Why.** Ahsan cannot read code, so the only quality control available to him
is evidence plus gates that fire without anyone remembering. The process puts
every rule that matters into a hook, a gated command or an audit, tiers review
by what a wrong sentence or a wrong line costs, and keeps the memory in files
because the engineer forgets everything between sessions. A weaker process
would be cheaper per session and far more expensive per mistake.

---

## 2026-09-11 — Naming corrections: Phase, Pilot / Wave, Engine vN, LIN, Capture / Act

**Decision.**
- "Phase" means a delivery phase 0–11 and nothing else.
- The product rollout is **Pilot**, then **Wave 2**, **Wave 3**. The Pilot is
  Crop Doctor + WhatsApp + one NPI campaign, two zones, Engine v1.
- The scoring engine's maturity ladder is **Engine v1 / v2 / v3**. M1's **v0**
  is a deliberate stub below v1: five weights, no modifiers, threshold-only tier.
- The Linear rule IDs in PROCESS §2 are **LIN1–LIN6**.
- Build scopes take the canvas zone they deliver: **Capture** is M0–M8, **Act**
  is the Sales Officer app. Later scopes are not named until they exist.
- Canvas layers **L1–L9** are architecture and are never used for scope.
- **Capture is not the Pilot.** Capture is all nine connectors plus Grower 360;
  the Pilot is the go-live subset.

**Why.** Before this, "Phase 1" meant three different things across the docs
(delivery phase, product rollout, engine maturity) and "L1" meant three more
(canvas layer, Linear rule, build scope). PLAN.md, SPEC.md and every Linear
milestone would have inherited that ambiguity, and a builder reading "Phase 1"
or "L1" in a task would have had to guess. The docs are the smallest they will
ever be, so the rename was done now rather than parked.

---

## 2026-09-11 — Enforcement-precision correction

**Decision.** PROCESS §10 A5 now states exactly what `.claude/settings.json`
denies, and PROCESS §13 names three enforcement strengths: permissions and
hooks (cannot be talked around), gated commands (bypassed by not using them),
audits (report afterwards). "Claude never merges a keystone" is a gated-command
rule, audited by warden check 18. The playbook's three claims that Ahsan clicks
every merge were corrected to the PR5 tiers, citing PROCESS PR5 as authority.

**Why.** A5 claimed `gh pr merge` was denied. It is not; the allowlist grants
`gh pr merge --squash` because PR5 needs Claude to merge docs and normal-code
PRs, and only `--admin` is denied. A document that asserts an enforcement that
does not exist is worse than no document, because Ahsan stops checking. The
same defect class applied to the playbook's merge lines, which PR5 superseded.
The rule going forward: before writing "X is denied" or "X cannot happen", find
the line in settings.json or the hook that makes it true.

---

## 2026-09-11 — D5 decided: proceed on the playbook default stack

**Decision.** Build on the default stack in `docs/reference/02-build-playbook.md`
§Default stack: TypeScript everywhere, pnpm monorepo, Zod schema package, Node
+ Fastify, Postgres via Drizzle with versioned migrations, BullMQ locally and
SQS on AWS, a pure-TS scoring package, Next.js, Expo for Act, Docker and
Terraform on AWS ECS Fargate. Revisit at Phase 3 when Syngenta's guidelines
land; a substitution is logged as a new entry here, not an edit to this one.

**Why.** The rules that survive any substitution — one schema package, a pure
scoring engine, Postgres, versioned migrations — are the expensive ones, and
they hold on any stack. What a substitution rewrites is the framework wrapper,
which is thin. Waiting for the guidelines would have blocked Phases 3–6 for a
decision whose cost of being wrong is small.

**Consequence.** CLAUDE.md's Stack section stays "PENDING" until Phase 3 fills
it; no scaffold before M0 regardless.

---

## 2026-09-11 — Shared team account, repo-local identity, and break-glass

**Decision.** The GitHub account `pksyngentadigital-ship-it` and the Linear
sign-in "Syngenta Digital" are a shared team account. Commits and merges made
through them attribute to it. Inside this repository only, git identity is set
to Ahsan Raza <ahsanraza.us1@gmail.com>; nothing global was changed. **If a
second person joins the build, identities must split into named accounts before
any keystone work.**

Enforce-for-admins on `main` stays on once branch protection exists.
**Break-glass:** if protection must be disabled, it is disabled temporarily, the
reason is written into this file the same day, and the process warden flags the
change at the next session start under check 17.

**Why.** PR5 reserves keystone merges for a named human because "who approved
this?" is a question Syngenta IT will ask. A shared account weakens that record
to a shared inbox: it proves a merge happened, not who did it. The repo-local
identity gives commits a name today without touching the account; the split
rule keeps the approval record honest once there are two people.

---

## 2026-09-11 — PARKED: GitHub Pro for branch protection and the production gate

**Finding.** On 2026-09-11 the GitHub API refused branch protection, rulesets,
required reviewers on the `production` environment, and secret scanning on the
private repository with "Upgrade to GitHub Pro or make this repository public".
Merge behaviour, labels, both environments and Dependabot alerts were set.

**Decision.** We stay on GitHub, this repository, this account. **GitHub Pro is
the fix.** It is deferred solely because Ahsan's payment method is failing. It
is not rejected, and no alternative is being evaluated.

**Un-park trigger, the only one:** Ahsan says "Pro is connected". Until he says
those words: do not raise it, do not propose workarounds, do not ask about it,
do not add related tasks. It is parked.

**When he says it:** set branch protection on `main` — pull request required,
status check required once CI exists, no force push, no deletion, enforced for
admins — set the required-reviewer rule on the `production` environment with
Ahsan as the only reviewer, then close SYN-6.

**Interim, not a replacement:** `.githooks/pre-push` refuses any push to `main`
from this clone, wired by `core.hooksPath`, plus a deny rule in
`.claude/settings.json`. It protects this clone only and cannot require a
status check. See the warden proportionality entry below for how it is audited.

**Cost, measured 2026-09-11, not theoretical.** With `main` unprotected, a
direct push silently marks every open PR whose commits it contains as merged,
bypassing every review gate: PR #1 was recorded MERGED by the shared account
with no human read (INCIDENT entry below). Kept parked; the cost is now named.

---

## 2026-09-11 — Open product decisions D1–D7: state, owner, what each blocks

| ID | Decision | State | Owner | Blocks |
|---|---|---|---|---|
| **D1** | Consent basis for advisory-captured data used for sales contact | Open | Syngenta leadership, via Ahsan | Creating growers from Cropwise data in M6; the consent-basis semantics in M3's schema |
| **D2** | Who owns Cropwise Open Platform access for the Pakistan tenant | Action, not a decision: Ahsan files the access request in session 0.2 and logs recipient and date here | Ahsan | M6 timeline; M2 option (a) |
| **D3** | Campaign ID convention | Open, deliberately deferred to M5 | Marketing, via Ahsan | The second campaign connector (M5) and every marketing dashboard |
| **D4** | Mobile number as golden key, and the shared-number rule | Open | Syngenta leadership, via Ahsan | M3 identity resolution; INV-2 |
| **D5** | Syngenta's recommended stack | **Decided 2026-09-11** (entry above): default stack, revisit Phase 3 | Ahsan | Nothing now |
| **D6** | Territory vs franchise catchment conflict rule | Open, not needed in Capture | Sales leadership, via Ahsan | Act routing; confirm before rollout |
| **D7** | Conversion value: declared or reconciled | Open | Ahsan with finance | Linking conversion value to officer incentives; nothing in Capture |

**Why recorded this way.** The Phase 2 gate allows an open decision to stay open
if it has an owner and a date. What must never happen is a build assuming an
answer: D1 in particular is a leadership position, not a product default.

---

## 2026-09-11 — PR #1 size accepted as a one-off Phase 0 exception

**Decision.** PR #1 exceeds the ~400-line ceiling in PR1 (16 files, over 500
changed lines). Accepted explicitly; not split.

**Why.** Phase 0 seed, docs only, no product code exists. The ceiling exists so
no code step is big enough to hide a mistake in; a docs seed that lands the
rule book and its corrections together means `main` has never held the
ambiguous or untrue versions. Splitting would have cost a review cycle and
bought nothing.

---

## 2026-09-11 — Docs-only PRs are reviewed by Ahsan reading them

**Decision.** PROCESS §9 gains a docs-only tier: a PR touching only `docs/**`,
`.claude/**`, `.github/**`, README or runtime-neutral config is reviewed by
Ahsan reading it, not by the reviewer agent. "Review: Ahsan read it" is the
correct entry, not a gap. `/pr` launches no reviewer for these.

**Why.** The warden flagged "Review: none ran" on PR #1. That is a rule gap, not
a miss: the reviewer agent is built for code diffs against invariants and would
produce noise on prose. Without this rule the same finding recurs on every docs
PR and trains Ahsan to skim the warden.

---

## 2026-09-11 — Warden proportionality: G1 three-state, G2 phase-aware, Linear checks move to /resume

**Decision.**
- **Check 17 (G1)** reports RED only while no mitigation exists. With
  `.githooks/pre-push` present and `core.hooksPath` set to `.githooks`, it
  reports AMBER, names the substitute, and quotes the un-park trigger. It
  returns to RED the moment the hook is missing or hooksPath is unset.
- **Check 19 (G2)**, the production reviewer, is informational before Phase 9
  and RED from Phase 9 onward, reading the current phase from `docs/STATUS.md`.
- **Checks 5, 6 and 7** (PR2 readiness, LIN3 status mismatches, LIN6 parks)
  need Linear. The warden's tools are not widened; `/resume` performs them and
  the warden states that Linear checks are performed by the caller.

**Why.** A warden that reports RED every session for a parked item is a warden
Ahsan will start ignoring, and an ignored warden is worse than none because it
creates the feeling of oversight without the fact. The production reviewer
protects a deployment that cannot happen before Phase 9. The Linear checks were
coming back NOT CHECKED every run; moving them to the command that has the tool
makes them real without giving a read-only auditor a write-capable MCP. The
softening is recorded here so it is on the record, not silent.

---

## 2026-09-11 — INCIDENT: `main` received a direct push during the pre-push hook probe

**What happened.** While proving the interim pre-push hook, Claude chained the
hook wiring and the probe in one command. The wiring step failed
(`git update-index --chmod=+x` on an unstaged file), the chain stopped before
`core.hooksPath` was set, and the probe `git push origin chore/rule-book:main`
ran unprotected. It succeeded. `origin/main` moved from `f2bd66e` to `337fb78`:
the three session-0.1 commits landed on `main` without a merged PR, without
Ahsan's read, and while PR #1 was open for exactly that content.

**Why it is recorded as a decision.** Restoring `main` to `f2bd66e` is a history
rewrite. G4 makes that Ahsan's action; PR5 forbids Claude force-pushing, and
`settings.json` denies it. **Ahsan decides:**

- **(a) Restore, recommended.** Ahsan runs, on his own account:
  `gh api -X PATCH repos/pksyngentadigital-ship-it/SynApse/git/refs/heads/main -f sha=f2bd66e868c889ad5449196a6b0ef32d584f68c0 -F force=true`.
  PR #1 then shows its full diff again and merges through the normal path.
  The audit trail reads as it should: every commit on `main` came from a PR.
- **(b) Accept.** `main` keeps the three commits. PR #1 carries only session
  0.2's diff. The journal records that session 0.1's content reached `main`
  unreviewed.

**What changed because of it.** The permission deny for pushes to `main` in
`.claude/settings.json` was added in the same session and fired on Claude's
next push-to-main attempt, so the second probe was refused by the permission
layer before git ran. Claude therefore cannot run the git-level probe at all;
Ahsan runs it from his own terminal (see STATUS). Rule for the future: **wire,
verify the wiring with a read command, then probe — never in one chain.**

**Update, same day, after the entry above was written.** GitHub treated the
direct push as the merge of PR #1: the PR is **MERGED**, `mergedAt`
2026-09-11T13:02:13Z, `mergedBy` the shared account, merge commit `337fb78`,
no human read it. Delete-branch-on-merge then removed `chore/rule-book`;
Claude's next push recreated it without noticing. Linear did **not** move
SYN-5 to Done, so the GitHub↔Linear integration did not fire on this merge and
is not yet verified. This changes the options:

- **(a) Restore** now leaves GitHub showing a merged PR whose commits are not
  on `main`. A contradictory record. No longer recommended.
- **(b′) Accept, recommended.** `main` stays at `337fb78`. PR #1 is recorded as
  merged by the incident, not by Ahsan. The control PR5 cares about is the
  *read*: Ahsan reads PR #1's diff after the fact and says so in the journal.
  Session 0.2's commit (`58b5deb`, on `chore/rule-book`) goes in as PR #2
  under a new issue, which Ahsan authorises because he capped this session at
  two issues.

Warden check 18 will see PR #1 merged by a non-human on a non-keystone PR: not
a RED under PR5, but the journal names it so nobody reads it as a clean merge.

**Decided 2026-09-12 — accept (b′).** Ahsan: "accept main as it stands. Do not
restore. The content is correct and was going to be merged; a force-push to fix
a bookkeeping problem is worse than an honest record." **Ahsan read PR #1's
diff after the fact on 2026-09-12.** That read is the PR5 control for PR #1.

**Guard proven 2026-09-12.** All three links verified from Ahsan's own
terminal: installed (`git config --get core.hooksPath` → `.githooks`;
`git ls-files -s .githooks/pre-push` → `100755`), logic correct, and invoked
by git on a **live** push — the exact action that caused the incident:

```
PS C:\Users\Abdullah\SynApse> git push origin chore/rule-book:main
pre-push: REFUSED — this push would update main on 'origin' directly
          (refs/heads/chore/rule-book -> refs/heads/main).
pre-push: main changes only through a merged pull request (docs/PROCESS.md PR5, G1).
pre-push: nothing was pushed.
error: failed to push some refs to 'https://github.com/pksyngentadigital-ship-it/SynApse.git'
```

**What went right.** The three-layer design in PROCESS §13 worked as intended.
The weakest layer, an assumed-but-unwired hook, failed. The stronger layers
caught it: the `settings.json` deny rule blocked Claude's next push-to-main
attempt before git ran, and the pre-push hook now blocks Ahsan's. The incident
cost one unreviewed docs merge and produced two rules (PROCESS §13, *Proving a
guard*) worth more than it cost.

---

## 2026-09-13 — Docs-only PRs before M0-T1 may exceed the ~400-line ceiling

**Decision.** Docs-only PRs before M0-T1 may exceed the ~400 changed-line
ceiling in PROCESS PR1. The ceiling applies strictly from M0-T1 onward, when
product code begins. PR #2 (538 lines, docs and enforcement layer only) is
accepted under this rule.

*Widened 2026-09-13, same day, by Ahsan:* the class was first written as
"Phase 0 documentation PRs". It now covers every docs-only PR before M0-T1 —
Phase 1's Base44 audit note included — for the same reason. One edit to the
class, not a new precedent per phase.

**Why.** The ceiling exists so that no code step is big enough to hide a
mistake in. PRs before M0-T1 are docs-only with no product code: the rule book,
its corrections, the record of how they came to be, and the audit of what
existed before. Splitting them adds
churn — more PRs to read, the same words to review — without adding safety,
because the risk the ceiling guards against is not present. Scoped as a class
so the warden stops raising it on every Phase 0 PR, and bounded at M0-T1 so it
cannot quietly become the norm once code exists.

**Supersedes,** without contradicting, the wording of the 2026-09-11 entry "PR
#1 size accepted as a one-off Phase 0 exception". PR #1 was the first instance
of this class; that entry's reasoning stands and its "one-off" scope is
replaced by this one.

---

## 2026-09-13 — Base44 is read-only reference, enforced by deny rules; the mirror lives outside the repo

**Decision.** Smart Agro Lite on Base44 is read through seven tools only
(`base44_readme`, `list_user_apps`, `list_directory`, `read_file`, `grep`,
`list_entity_schemas`, `describe_api`, `list_api_catalog`). The thirteen tools
that write, run, checkpoint, deploy, execute, mutate schemas or read entity
records are denied in `.claude/settings.json` under both server-name forms.
`query_entities` is denied because it returns real grower records (PROCESS
§12). The source mirror lives at `~/synapse-reference/base44/`, outside the
repo, and is never committed; the audit note is the only artefact that
enters `main`. No code is carried across.

**Why.** Smart Agro Lite is a live product with people using it. A prompt
rule is enforcement strength 3 (PROCESS §13); a deny rule is strength 1.
The `explorer` agent cannot call MCP tools, so a wide read over Base44 needs
an on-disk mirror first — which is also what `03-delivery-process.md` Phase 1
prescribes. Read-only on the Base44 side was proven by the export manifest's
call log (24 calls, zero forbidden, zero writes). Whether the deny rules took
effect in the session that wrote them is unproven, deliberately: proving
them would have meant attempting a forbidden tool.

**Un-park trigger for any change:** none expected. Loosening these rules needs
a dated entry here first, like G1.
