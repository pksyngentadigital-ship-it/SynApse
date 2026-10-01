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

---

## 2026-09-15 — D9 decided: a healthy Crop Doctor scan is a lead only at or above the acreage threshold; D8 is unused

**Decision.** A Crop Doctor scan whose diagnosis is "healthy" becomes a lead
only when the grower's known acreage is at or above the acreage threshold
(20 acres, an Admin setting — see the 2026-09-16 entry). Below the threshold
or with acreage unknown, the scan is recorded on the grower's history and no
lead is created. The number D8 was proposed for the lost-reason code set and
withdrawn the same day by Ahsan; D8 is not used and must not be re-assigned.
Decided by Ahsan in session 2.1; recorded 2026-09-17. Source:
`docs/notes/spec-input-2026-09-16.md`.

**Why.** A healthy scan carries no need and no intent; on its own it is not
demand. On a large farm it is still worth a conversation. Tying the rule to
the same threshold as everything else keeps one number for the field to learn.

**Governs.** The Crop Doctor connector's lead-creation rule (M6) and the
ordering of the acreage follow-up before a healthy scan can become a lead.
D1 still gates whether a grower may be created from Cropwise data at all.

---

## 2026-09-15 — Three ranked segments replace the canvas's four tiers; no daily cap

**Decision.** SULs see three segments — Hot, Campaign, Potential — ranked by
score inside each, today's due leads first, low scores below a fold. There is
no Nurture tier and no daily cap per SUL. Hot is defined by three conditions
only: clear purchase intent, crop known, acreage at or above the threshold;
the score orders leads inside Hot and does not gate it. Decided by Ahsan
2026-09-15 and confirmed 2026-09-17 (`docs/notes/spec-input-2026-09-15.md`,
`-17.md`).

**Why.** Smart Agro Lite's lesson was clutter: too many buckets, no clarity on
what to tap next. Ahsan's answer is fewer, clearer segments rather than a cap
that hides leads. The canvas's Nurture tier and cap were its own anti-clutter
devices; the spec records that reasoning in its disagreement register so the
session 2.2 reviewers can challenge the choice with the argument in front of
them. Reversible: a cap or a fourth segment is an Admin setting away, and
would need a new entry here.

---

## 2026-09-15 — The lead clock stays; a breach notifies, it never reassigns

**Decision.** Every routed lead carries two promises, both Admin settings: a
contact promise (Hot within 24 hours, Campaign per the campaign's own
promise, Potential within 72 hours) and a completion promise (starting
proposal: Hot 7 days, Campaign per campaign, Potential 14 days). Both clocks
start when the lead reaches the SUL; the contact clock stops at the first
contact, the completion clock when the lead is completed or closed. When
either promise is missed, the SUL, the RSM and the Zonal Manager are all
notified, and the managers follow up with their direct report inside Synapse.
No lead is reassigned automatically or by rule. The on-time rate, reported
for both clocks, is the Pilot's headline number. Clock kept 2026-09-15;
notify-only path chosen 2026-09-17; second clock added 2026-09-18 when Ahsan
ruled the clock runs to completion, not first contact
(`docs/notes/spec-input-2026-09-17.md`, `-18.md`).

**Why.** The clock is what turns a ranked list into changed field behaviour;
without it the queue is a better-sorted list. Reassignment was rejected
because a lead moving without a human deciding punishes an SUL who was about
to visit; visibility up the line, in the product, is the pressure instead.
The canvas's "reassigned within 24 hours" is recorded as a disagreement.

---

## 2026-09-16 — One acreage threshold, 20 acres, as an Admin setting; leads below it are never routed to an SUL

**Decision.** There is one acreage threshold, 20 acres, held as an Admin
setting with every change recorded. A lead whose grower's acreage is known and
below the threshold is never shown to any sales user; it is kept in the portal
(Admin "below threshold" list), counted in Marketing and Portfolio Manager
totals labelled "below threshold", and still builds the grower's record. A
lead with unknown acreage is routed and marked unknown; when the SUL learns
the acreage they log it, it stays on the grower, and if it is below the
threshold that grower's next lead is not routed. Ahsan first wrote 15 and 20
on 2026-09-16 and settled on one threshold at 20 the same day, with the
explicit provision that the number may change after the Phase 4 stakeholder
review (`docs/notes/spec-input-2026-09-16.md`, `-17.md`).

**Why.** Acreage is the strongest signal of sale potential Syngenta has, and a
field force of one SUL per territory cannot visit every two-acre farm. Holding
the number as a setting, not a constant, is the provision Ahsan asked for.

---

## 2026-09-16 — Eight personas, not six

**Decision.** Synapse serves eight kinds of user: Sales Unit Lead (SUL — the
canvas's "Sales Officer"), Regional Sales Manager, Zonal Manager, Head of
Sales, Country Leadership Team, Portfolio Manager (four portfolios:
insecticides, fungicides, herbicides, biologicals and seed care), Marketing,
Admin. Head of Sales sees all zones side by side plus the national on-time
rate; Country Leadership gets a read-only national dashboard and a monthly
summary. Admin is the digital team on its own login, never combined with a
sales or marketing role. The stub and the delivery process said six; the
canvas listed six dashboards. Ahsan, 2026-09-16 and 2026-09-17.

**Why.** The two added roles exist in Syngenta Pakistan today and will read
the numbers; a persona that is not specified is a dashboard designed last.

---

## 2026-09-17 — Acreage replaces "order value" as a scoring ingredient; the canvas weights stay as the starting point

**Decision.** The Pilot's scorecard uses the canvas's five ingredients and
four adjustments, changeable in Admin from day one, with one substitution:
the "opportunity value" ingredient (acreage × dose × price) is replaced by
acreage itself, carrying a high weight. Indicative PKR value is still shown on
the lead card where product and price are known, but it is not scored. The
proposed starting weights are in the spec, marked for Ahsan. Automated
WhatsApp follow-up goes only to low-scoring leads whose acreage is unknown.
Personal data is anonymised after two seasons of inactivity (an Admin
setting; every removal logged). Ahsan, 2026-09-17
(`docs/notes/spec-input-2026-09-17.md`).

**Why.** Order value depends on a product-and-price master and a dose table
that do not exist on day one and would make the first score a guess dressed
as money. Acreage is known or askable, and in Ahsan's words "tells a lot about
grower sale potential". The other two items are recorded here because they
are rules about contacting growers and keeping their data, which the canvas
leaves to a leadership position.

---

## 2026-09-18 — D1 decided: any contact with Syngenta is the consent basis for sales contact

**Decision.** A grower who contacts Syngenta through any stream — a Crop
Doctor scan, a Savera conversation, a community post, a WhatsApp or social
message, a campaign form, a call to the centre — has thereby given the consent
basis for a sales contact about that need. Every lead records which stream
and date the consent came from. There is no opt-out control for growers or
SULs in this phase (Ahsan, 2026-09-21); a grower's request to stop is a
message on the lead, left to the SUL. Cropwise-sourced growers are created and routed
from day one; the M6 gate in PLAN.md ("no grower is created from Cropwise data
until D1 is decided") is lifted. Ahsan reports this as Syngenta leadership's
position, 2026-09-18 (`docs/notes/spec-input-2026-09-18.md`). Who took it and
on what date is not recorded here; Ahsan may add it.

**Why.** The canvas held D1 open because advisory data used for a sales call
is a change of purpose that needs a leadership position, not a product
default. Leadership has now taken the position. INV-1 is unchanged: no grower
is contacted without a recorded consent basis — the basis is now the contact
itself, and it is still recorded per lead.

**Reversal cost.** If leadership later narrows this, Cropwise-sourced leads
already routed stay in the history; new ones are held. The spec's consent
row cites this entry, so the change is one row and one connector rule.

---

## 2026-09-18 — D4 decided: verified mobile number is the grower's key; one number, one grower; no split action

**Decision.** A grower is identified by their verified mobile number. One
number belongs to exactly one grower. There is no split action for shared or
family numbers in this phase; if a number is wrong or has changed, the SUL
corrects it on the grower's profile, the change is kept in the history with
who and when, and Admin can undo it. A number that already belongs to another
grower cannot be saved on a second one. A signal that arrives with no number
is never routed: it is matched to an existing grower by name, village and
crop when the match is clear, otherwise held on Admin's "no contact" list,
counted, and merged into a lead when a later signal brings a number. Ahsan,
2026-09-18 and 2026-09-21 (the no-number rule was first answered "routed
anyway" and changed the same day on re-asking).

**Why.** Ahsan's rule for the field is simpler than the canvas's split: one
grower, one number, corrected by the person who knows. The cost, recorded for
the session 2.2 reviewers: two growers on one family phone will be one record
in this phase, and INV-2's "unless an officer explicitly split it" clause has
no user path yet. INV-2 itself still holds — a verified number maps to at
most one grower.

**Un-park trigger for a split action:** the field reports shared-number
growers being merged in error; raised as a change request.

---

## 2026-09-21 — Hina, a third-party AI calling agent, fills lead gaps by phone before routing; an AI first layer of calling in phase 2

**Decision.** Hina is an AI voice agent, developed and managed by a third
party, that Synapse integrates with. In phase 1, a lead that has a number but
is missing acreage, crop or purchase intent is held for Hina before any SUL
sees it: Synapse sends Hina the leads in order (score, then age) with an
attempt limit (starting setting: 3 calls over 2 days, Admin settings); Hina
returns structured answers (acreage, crop, intent), the outcome of each
attempt, and a short plain-words summary, no recording; Synapse then scores
the lead with what Hina found and routes it into the same three segments, or
closes it below threshold; the SUL's clocks start at handover. Leads with no
gap skip Hina. Synapse no longer asks acreage by WhatsApp, and sends no
automated WhatsApp content in phase 1; Hina is the only automated contact.
In phase 2, when Hina can close sales, she becomes the first layer of calling
for every grower before an SUL — an "AI SUL" — with a separate scoring and
priority layer; that is out of scope for this specification and recorded here
so it is not forgotten. Ahsan, 2026-09-21 (`docs/notes/spec-input-2026-09-18.md`).
This was not in the canvas, the audit or Ahsan's earlier notes.

**Why.** Acreage and intent decide Hot and the threshold, and a phone call in
Urdu reaches growers a WhatsApp template does not. A third party already
builds the agent. The cost, recorded for the session 2.2 reviewers: a lead
with a gap waits up to the attempt window before an SUL sees it, which is the
"model call in the lead path" the canvas warned against; the time limit and
the "no gap → route at once" rule bound that wait. Consent for an AI call
rests on D1 (any contact is consent). Every Hina call is an automated read of
grower data and is logged.

**Un-park trigger for phase 2:** Hina can close a sale end to end on the
third party's side, proven on real calls; raised as a change request with
its own spec section.

---

## 2026-09-21 — Scoring details for the Pilot: weights, adjustments, timing table, engine proposals, score visibility

**Decision.** Starting weights, all Admin settings: purchase intent 30,
acreage 25, crop need 20, season timing 15, grower history 10. Adjustments:
minus 2 per day after 48 hours with a floor; minus 15 where the grower's
number has never been confirmed; minus 10 where no franchise is within range,
which requires a franchise list (name, location, serviceable range) kept in
Admin; repeat signals merge into the lead and raise its score. The season
timing table (crop, problem, months) is owned by Marketing and scores neutral
until a row exists. The engine's proposed weight changes are applied by Admin
and notified to Head of Sales, ZMs, RSMs and SULs; every change is logged and
reversible; the scorecard is never switched off. SULs see rank and the top
three reasons, not the number; managers and Admin see the 0–100 number.
Ahsan, 2026-09-21.

**Why.** Each of these was a canvas default that needed an owner or a number
before the walking skeleton can score; Ahsan supplied them. Hiding the number
from SULs keeps the argument on reasons, not on a 68 versus a 71.

---

## 2026-09-28 — Geo hierarchy and routing: coordinate mandatory, digitised boundaries in Punjab and Sindh, nearest franchise elsewhere

**Decision.** The sales hierarchy is village → BSA (Basic Sales Unit Area,
generally one Naya Savera franchisee) → territory (one SUL) → region (one
RSM) → zone (one Zonal Sales Manager); four zones cover Pakistan: Lahore,
Multan, Bahawalpur, Hyderabad. A lead is placed only by a coordinate; a
stream that gives none must give a complete address, which is converted to
a coordinate. Inside Punjab and Sindh (about 95% of sales area) the
coordinate is matched to a digitised village boundary, and the village's BSA
and territory give the SUL. Elsewhere, only franchise and SUL points exist:
the lead goes to the territory of the nearest franchise point within a
distance cap (starting setting 50 km, Admin); beyond it, the regional pool.
A structure gap (village in no BSA, BSA in no territory, territory with no
SUL) sends the lead to the regional pool and the gap to DBO. The grower's
location is the most recent coordinate unless an SUL confirmed one. The
franchise is a property of the BSA, replacing Part 5's separate franchise
list. DBO owns the structure (zones, regions, territories, BSAs, SUL
assignment, franchise points), edited in Admin; the digital team (Admin)
owns the boundary files, the address conversion and the SUL points. Ahsan,
2026-09-25 and 2026-09-28 (`docs/notes/spec-input-2026-09-25.md`).

**Why.** Routing by text matching was Smart Agro Lite's top cause of
misrouted leads (audit §7.17). A coordinate against a digitised boundary is
exact where the boundaries exist, and the nearest franchise is the honest
fallback where they do not, because the franchise is where the sale happens.
Ahsan proposed centroids and accepted nearest-franchise-point on being shown
that centroids misplace leads near the edges of large units.

**Reversal cost.** Low: the fallback rule, the cap and the ownership are
settings and list edits; the boundary files can be replaced.

---

## 2026-10-01 — SPEC.md review round 1 triaged: 170 decisions, recorded in the review folder

**Decision.** Ahsan decided every finding of the Tier A review of SPEC.md v0.9
(SYN-11): 126 surviving entries and 44 narrower claims. 156 are accepted
(17 with his own changes, 2 as scope or rule changes), 7 rejected, 2 out of
scope for now, 1 a Legal action with no SPEC row, 1 covered by another
decision, 1 parked. The full record, with his words where he gave them, is
`docs/reviews/spec-r1-raw/triage.md`; the findings are
`docs/reviews/spec-r1.md`. The entries below record each answer that reverses
an earlier dated decision or answer, and each park. Collected by question
from 2026-09-30 to 2026-10-01.

Rejected, so the spec keeps its current text: S49 (receipts from camera or
gallery stay), S52 (no periodic access review; Admin acts on the
communications received), S78 (no registration check on suggested products;
off-label suggestions allowed), S93 (running costs budgeted outside
Synapse), N10 (no group privacy or Syngenta IT go-live dependency), N32 (D1
stays "leadership via Ahsan"), N34 (no "shared phone" reason). Out of scope
for now, in SPEC 6.3.2, returning on Ahsan's request: S31 (leads SULs create
themselves) and S37 (cost per lead; see below). S38 is a Syngenta Legal check
of the Facebook and TikTok form privacy notices, not a SPEC row.

**Why.** PROCESS §9 Tier A: Ahsan triages every surviving finding. Answers
that only fill a gap the spec left open go into SPEC.md under C4 without an
entry of their own; answers that overturn something decided go here first,
with the reason (C3).

---

## 2026-10-01 — Contact means the grower was reached; the clocks run on the phone's time

**Decision.** A call or WhatsApp from a lead logs an attempt; the lead moves
to Contacted and the contact clock stops only when the SUL marks the attempt
"Reached" (S1). Both clocks start when the SUL's phone receives the lead and
stop at the time the action was logged on the phone; a synced action that met
its promise withdraws the breach notice already sent; a server re-score never
overrides an outcome the SUL logged, and only Admin removal or a territory
change does, sending the entry to Admin's review (S5, S6, S82). Ahsan,
2026-09-30.

**Reverses.** The 2026-09-15 clock entry's "both clocks start when the lead
reaches the SUL" (read as routed on the server) and its "contact clock stops
at the first contact" (read by J2.2 as the first dial).

**Why.** With a dial as contact, an SUL who dials and hangs up is 100% on
time, so the Pilot's headline number would measure dialling. With server
time, an SUL who works out of signal all day loses hours of every promise and
gets breach notices for calls made on time.

---

## 2026-10-01 — A settings change applies to leads that reach an SUL after it

**Decision.** A change to the threshold or to a clock promise applies to leads
that reach an SUL after the change; open leads keep their segment and due
times. A lead that moves up a segment restarts both clocks under the new
promise; a move down keeps the earlier due times (S28, S29, S95). Ahsan,
2026-09-30.

**Reverses.** The 2026-09-16 threshold entry's "a lead below the threshold is
never shown to any sales user", for leads already routed when the threshold
is raised: they stay with their SUL.

**Why.** Otherwise one threshold raise gives an open Hot lead three possible
fates, including vanishing from the SUL's phone after a visit was planned,
and one shortened promise makes every open lead overdue overnight with a
notification each.

---

## 2026-10-01 — Clocks also pause on holidays Admin lists; the working week is defined once

**Decision.** Admin keeps a yearly list of pause days (Eid and similar) that
the clocks skip as well as Sundays, and the working week used by support
hours and the monthly summary is defined once; every change is logged (S7,
S124). Ahsan, 2026-09-30.

**Reverses.** SPEC 5.10 Q13 (21 Sept): "clocks pause on Sundays only".

**Why.** With Sundays only, every lead due over a multi-day Eid either takes
a holiday call or breaches, and managers are notified during Eid.

---

## 2026-10-01 — Managers get targets, entered by Admin or DBO on Head of Sales' recommendation

**Decision.** Targets exist for the on-time rates, leads converted, sales
value and leads followed up. Head of Sales recommends them; Admin or DBO
enter them ("head of sales won't be doing the entries himself"). Admin can
change the target rules or switch any target parameter off. "Behind" is
measured against the targets on manager views only; SULs still see no
ranking (P2-11 stands). Ahsan, 2026-09-30 (S26).

**Reverses.** Nothing recorded; the spec had no targets. Recorded here
because it adds a sales-value target while D7 is open. A target is not an
incentive: D7 still forbids linking any PKR figure to incentives until it is
decided.

**Why.** Without a target, "behind" and "short" are a builder's guess, and
the Monday summary names an SUL on a rule nobody chose.

---

## 2026-10-01 — DBO has its own login role, and the call centre sits under DBO

**Decision.** A `dbo` role: edit the sales structure and village-to-BSA
assignment, work the below-threshold, rejected and pool lists, enter targets
(entry above), approve Hina's script for non-campaign leads (entry below),
and give call-centre agents the capture form. It cannot change settings,
export, undo number changes, remove leads or read the audit trail. In
Ahsan's words, "call center is the part of DBO; and DBO team looks after it".
Ahsan, 2026-09-30 and 2026-10-01 (S51, S13, S14).

**Amends.** The 2026-09-16 "Eight personas" entry, whose role list gave the
portal only to Admin, the digital team. The eight stakeholders are
unchanged; DBO and its call-centre agents get a role, not a ninth persona.

**Why.** DBO works the portal daily. Without a role it either logs in as
Admin, with settings, exports and the audit trail, or cannot do its job.

---

## 2026-10-01 — RSMs see a grower's number only on overdue, flagged or pool leads

**Decision.** An RSM opens a grower's full card with the phone number only
from an overdue, flagged or pool lead. Every opening is still logged. Ahsan,
2026-10-01, after the risk was explained (S54).

**Reverses.** SPEC P3-3 and the 18 Sept answer "full card for RSM is fine".

**Why.** With open access and a log nobody must read, an RSM could collect a
region's numbers one card at a time; Ahsan chose to narrow access rather
than add a log review.

---

## 2026-10-01 — The Pilot may run one or more campaigns; "NPI" is a tag

**Decision.** In Ahsan's words: "there could be one or multiple campaigns
running at a time; either it's NPI or just a brand campaign; we are just
tagging if it's NPI". Ahsan, 2026-09-30 (S107).

**Reverses.** The 2026-09-11 naming entry: "The Pilot is Crop Doctor +
WhatsApp + one NPI campaign, two zones, Engine v1". The Pilot is now Crop
Doctor + WhatsApp + campaigns (NPI or brand), two zones, Engine v1.

**Why.** Marketing runs brand and NPI campaigns side by side; the NPI flag
already exists on the campaign record.

---

## 2026-10-01 — A campaign signal whose campaign cannot be read is held until it can be

**Decision.** A campaign signal whose campaign Synapse cannot read is held,
not routed. When the campaign becomes readable (D3 agreed, or a mapping
fixed), Admin releases the held signals in one action, each carrying its
campaign, and Marketing sees how many are held per campaign stream. Ahsan,
2026-09-30 (S35, S36).

**Reverses.** SPEC P4-11 and the D3 rows in 3.5, 4.6 and 6.4: "the lead
still arrives, marked campaign unknown". That text came from the canvas, not
from an earlier answer of Ahsan's. D3 itself stays open, decided in M5.

**Consequence.** Until D3 is agreed in M5, campaign leads whose signal does
not carry a readable campaign reference wait instead of reaching SULs.

**Why.** A lead routed without its campaign is never credited to it, which
understates the campaign Marketing has to defend.

---

## 2026-10-01 — SULs see their leads on a Google map; village boundaries are not shown to SULs

**Decision.** In Ahsan's words: "we are not exposing villages boundaries to
SULs; instead we are giving a google map visibility so that they can see the
leads on map and navigate to them; village boundaries can be shown later if
required". The digitised boundaries stay in Synapse for routing (the
2026-09-28 entry is unchanged). Ahsan, 2026-10-01 (N7).

**Reverses.** SPEC P7-4 (25 and 28 Sept): the boundaries "are held in
Synapse and drawn on the SUL's map".

**Consequence.** The Google Maps integration is built and managed by the
team itself; it is not treated as a vendor on the register accepted as S47.
Where a lead has no location, the location may come back from Hina, whose
vendor is on that register (S47, S89). The phone no longer stores boundary
polygons, which eases the 150 MB budget. Ahsan, 2026-10-01.

---

## 2026-10-01 — A lead with no valid number is closed, not held for later matching

**Decision.** In Ahsan's words: "if there is no valid number; we won't route
and show the lead to SUL; nothing can be done on it; instead this lead will
be closed". The lead is closed as "no valid number". If the same grower later
sends a signal with a valid number, that signal becomes a normal lead
carrying the earlier history. Ahsan, 2026-10-01 (N38).

**Reverses.** The 2026-09-18 D4 entry: a signal with no number "is matched
to an existing grower by name, village and crop when the match is clear,
otherwise held on Admin's 'no contact' list, counted, and merged into a lead
when a later signal brings a number".

**Follows from it.** Hina's "wrong number" (S12) closes the lead the same
way. Closed no-number leads with no grower are deleted after the period
accepted in N4. D4's one number, one grower rule is unchanged.

---

## 2026-10-01 — What Hina says is approved by Marketing for campaign leads and by Admin or DBO for the rest

**Decision.** Hina's script and persona are controlled and approved by
Marketing for campaign leads and by Admin or DBO for non-campaign leads; the
approved version is recorded on the connection, and they can stop it. No
disclosure line is required: Ahsan, "we shouldn't have an concern on this".
Ahsan, 2026-09-30 (S46).

**Reverses.** SPEC P5-2 (21 Sept, Hina 4): "Hina decides only how she runs
each call".

**Why.** Hina speaks to growers in Syngenta's name, so Syngenta, not the
third party, decides what she says.

---

## 2026-10-01 — Portfolio Managers own and approve the agronomy lists

**Decision.** The product "treats" list and the season-timing table are
owned and approved by the Portfolio Managers; DBO maintains them if
required. Product-row notices go to the PM of that product's portfolio.
Ahsan, 2026-09-30 and 2026-10-01 (S92, N36).

**Reverses.** The 2026-09-21 scoring entry: "The season timing table (crop,
problem, months) is owned by Marketing".

**Why.** The lists drive every lead card's suggestion and the timing score;
the PMs own the portfolios they describe.

---

## 2026-10-01 — Every scoring-weight change notifies every stakeholder

**Decision.** A change to the scoring weights, whether Admin types it or
applies an engine proposal, notifies all stakeholders. Ahsan, 2026-09-30
(S100).

**Amends.** The 2026-09-21 scoring entry, under which proposals notified
Head of Sales, ZMs, RSMs and SULs, and hand-made changes (P5-14) notified
Head of Sales only.

---

## 2026-10-01 — Cost per lead leaves the Pilot

**Decision.** In Ahsan's words: "let's not manage cost per lead type things
at this stage; we will do later if required". Cost per lead and cost per
converted lead leave J20.2 and P3-16 and are listed in 6.3.2; Marketing can
still enter spend on a campaign. Ahsan, 2026-09-30 and 2026-10-01 (S37).

**Reverses.** SPEC 3.6 Q6 (18 Sept): "cost per lead shown".

---

## 2026-10-01 — The "Last season" tab holds this season's leads from last season's growers

**Decision.** The tab lists this season's leads from growers who converted
or were never reached last season; it lists no grower without a lead this
season. It appears from the first season start after go-live. Ahsan,
2026-09-30 (S16, S105).

**Reverses.** SPEC P1-17 (17 Sept): a tab of "last season's growers" so the
SUL can "start the season from known ground", in favour of P5-19 (21 Sept).

**Why.** SULs cannot create leads (J12.2), so a grower with no lead this
season would sit on a list with nothing to act on.

---

## 2026-10-01 — PARKED: SUL app 2G/3G numbers and the field phone survey (S61)

**Decision.** P2-10 and P6-8 keep the principle ("usable on 2G/3G", "the
field's current phones"). The numbers (action send time, first-sync size,
daily sync size) and a DBO survey of the Pilot zones' phones become Phase 4
UX acceptance inputs. Ahsan, 2026-09-30, confirmed 2026-10-01. Linear SYN-12.

**Un-park trigger:** Phase 4 starts writing docs/UX.md, or a Phase 4 session
sets the low-end Android constraints, whichever comes first.

---

## 2026-10-01 — PARKED: restore rules, uptime target and secrets storage go to INFRA.md (N9, S84)

**Decision.** After any restore, anonymised growers stay anonymised, the
audit trail stays intact and phone actions already synced are kept; an
uptime target is named; each inbound feed's signing keys are stored in a
secrets vault. These are Phase 3 infrastructure requirements, and SPEC.md
carries one line pointing to INFRA.md. The SPEC half of S84, that every
inbound feed including Hina's must carry a valid signature, is accepted into
SPEC. Ahsan, 2026-10-01. Linear SYN-13.

**Un-park trigger:** Phase 3 begins drafting docs/ARCHITECTURE.md and
docs/INFRA.md.

---

## 2026-10-01 — Until PLAN.md has a calendar, a milestone or phase is an open item's due date

**Decision.** The open items in SPEC 6.7 carry an owner and a due point that
is a milestone or phase (for example "before M8", "Phase 3"), which stands in
for a calendar date until PLAN.md gets a calendar in Phase 3. D7 is due before
any PKR figure is linked to incentives, and is reviewed at the Pilot exit.
Ahsan, 2026-10-01, on the SYN-11 scope check.

**Why.** The Phase 2 gate asks every open item for an owner and a date, and
PLAN.md has no dates yet; inventing calendar dates would be a guess.
