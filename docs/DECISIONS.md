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

## 2026-09-11 — OPEN: GitHub plan blocks branch protection, production gate and secret scanning

**Finding.** On 2026-09-11 the GitHub API refused branch protection, rulesets,
required reviewers on the `production` environment, and secret scanning on the
private repository with "Upgrade to GitHub Pro or make this repository public".
Merge behaviour, labels, both environments and Dependabot alerts were set.

**State.** Open. Owner: Ahsan. Blocks: PROCESS G1 and G2 in full, SYN-6, and
the warden's checks 17 and 19, which will report RED at every session start
until resolved.

**Options.** GitHub Pro on the personal account (cheapest, immediate); a paid
organisation plan; or transfer to a Syngenta-owned organisation (G4 says Ahsan
executes any transfer). Making the repo public is not an option: it will hold
Syngenta-internal architecture and, later, PII-adjacent code.

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
