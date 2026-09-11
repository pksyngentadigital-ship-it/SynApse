# Synapse build playbook — engineering doctrine

> **What this file is.** The engineering doctrine: the laws, the default stack,
> the repo shape, the day-one architecture rules, the Capture milestone plan, and the
> per-task build cycle. Extracted from the Synapse Build Playbook v1, which is
> built on the *Prompt to Production* laws.
>
> **Precedence.** `CLAUDE.md` and `docs/PROCESS.md` are the operative rules.
> Where `docs/reference/03-delivery-process.md` restates something here, **03
> wins** — it is the reviewed and corrected sequence. This file is the
> reasoning, the stack default, and the milestone plan.

---

## The four laws

**Law 1 — A green build is a claim, not evidence.**
Sharper form for this builder: *you cannot read the code, so evidence is the
only thing you can read.* Screenshots, test output with a non-zero count, a diff
summary against the plan. If Claude says "done" and shows nothing, it is not
done.

**Law 2 — A rule that lives only in prose will be skipped in silence.**
Prose → template → hook. Synapse has nine invariants and three hooks. The
invariants are prose until a test cites them by ID; the hooks are the only rules
that fire whether or not anyone remembers.

**Law 3 — Premature industrialization is the most expensive mistake.**
Still true. Synapse deviates on one point only: because it lives inside Syngenta
and carries grower PII, the first deploy goes to a container on AWS rather than
a hobby platform — rung 1 of the ladder, not rung 2. **Still not Kubernetes**;
that remains a payroll decision, not a gap.

**Law 4 — Your judgement is the product; Claude's output is the draft.**
You know which grower profile matters, what a Sales Officer will actually tap,
and what the country GM will ask. Never delegate a product decision to the model
because the technical framing made it look like a technical decision.

---

## The division of labour

**You:** write the spec and the invariants · approve every plan before code is
written · read every piece of evidence · merge by tier per `docs/PROCESS.md`
PR5 (say "merge it" on normal code; merge keystones yourself, in the browser) ·
own every
account, credential and publish button · make every product decision · say
"park that" and "show me it failing first."

**Claude Code:** propose the plan · write the code, tests and migrations · run
the checks and show the output · review its own work in a fresh context when
told to · open the PR with a description you can read · update the state files ·
never touch production credentials.

You are not learning to be a programmer. You are learning to be the engineering
manager of one very fast, very literal engineer who forgets everything between
shifts. Every practice follows from those two properties: *fast and literal*
means you must be precise; *forgets everything* means the memory lives in files.

---

## Vocabulary — twelve words

| Word | What it is | What you do with it |
|---|---|---|
| **Repo** | The folder with all code and its full history, on your laptop and on GitHub | You have one: `synapse` |
| **Terminal** | The text window where you type `claude` | `cd` into the repo, type `claude`. That is 90% of your terminal use |
| **Commit** | A saved snapshot with a message — the undo button and the audit trail | Claude makes them; you read the messages |
| **Branch** | A parallel line of work named after the task | One per task. Claude creates it; you never touch `main` directly |
| **Diff** | The exact lines added and removed — the truth about what changed | Ask "diff what changed against what was in scope." Read the summary |
| **PR** | Pull request — a proposal to merge, with description, diff and CI attached | Your review surface. Read the description and evidence, then Merge |
| **Merge** | Accepting a PR so its changes join `main` | Tiered, per `docs/PROCESS.md` PR5: Claude merges docs and chore PRs once CI is green; Claude merges normal code only after you read the evidence and say "merge it"; keystones you merge yourself, in the browser. Note: *close* rejects a PR — never say close when you mean merge |
| **CI** | GitHub runs your check command on every PR, green tick or red cross | Red means do not merge. Ever |
| **Migration** | A versioned file that changes database structure, run in order | Ask "does this PR include a migration?" If yes it gets the keystone review |
| **Env var** | A setting read from the environment — key, URL, flag — never in code | Documented in `.env.example`; real values in the secret manager |
| **Endpoint** | A URL the API answers on, e.g. `POST /webhooks/whatsapp` | Each connector is a few of these |
| **Hook** | A command Claude Code runs automatically at a moment | Your three enforced rules. Set once in M0, then forgotten |

**What "200 PRs" means:** granularity, not effort. A PR is one task, one
concern, reviewable in five minutes. Two hundred of them is a whole product
built in two hundred reviewable steps, with no step big enough to hide a mistake
in. Capture alone is roughly 80–110.

---

## Accounts and tools — in the order you need them

Set up only what the current phase needs; every account is a credential to
manage.

| What | Why | When | Cost |
|---|---|---|---|
| Laptop tooling | Git, Node LTS, pnpm, Docker Desktop, VS Code | Day one | Free |
| GitHub account + private repo | Remote copy, PRs, CI. Start personal; transfer to a Syngenta org later in one click | Day one | Free tier is enough |
| Claude Code subscription | The engineer. A subscription plan gives a predictable monthly ceiling; an API key bills per token | Day one | See §Economics |
| `gh` CLI | Lets Claude open PRs and read CI results without you copying links | Day one | Free |
| Local Postgres + Redis | `docker compose up` — same shape as production | M0 | Free |
| **Cropwise Open Platform access** | API credentials for the Pakistan tenant. **The slowest thing on this list** — an internal request that may take weeks | **Request week 1**, needed M6 | Internal |
| **AWS account** | Hosting at rung 1. Use a Syngenta-provisioned account if IT offers one | **Request week 1**, needed for staging in M1 | ~USD 120–250/mo pilot — verify at deploy |
| Meta developer app + WhatsApp Business | Cloud API webhooks (M4), later Facebook lead ads (M5). Needs a verified business; test numbers work in sandbox | M4 | Per-conversation at volume; sandbox free |
| Domain + TLS | A stable HTTPS address for webhooks. Meta refuses plain HTTP | First deploy | ~USD 15/yr; TLS free on AWS |
| Error tracking | Sentry or equivalent — a bad deploy visible in minutes, not in a WhatsApp from the field | First deploy | Free tier |
| Secret manager | AWS Secrets Manager. Every credential lives here, never in the repo, never in a chat | First deploy | Pennies |
| Expo / EAS | Builds and distributes the SO app without app stores during the Pilot | Act | Free tier |

**The split of duties, non-negotiable.** You create every account, enter every
credential, accept every terms-of-service, and press every publish button.
Claude Code never sees a production credential, never sees a real grower's phone
number in a chat, and never holds a key that can spend money. If you find
yourself pasting a secret into a session, stop — put it in `.env` (git-ignored)
or the secret manager and tell Claude the variable *name*.

---

## Default stack — pending Syngenta guidelines

The test: could you hire a human who already knows this? Everything below
passes. The one opinionated choice is **TypeScript everywhere**: the lead event
schema is defined once, in one package, and the API, the mobile app, the
dashboards and the migrations all import it. A mismatch fails typecheck before
it reaches a review. That is not a style preference — it is the mechanism by
which a non-engineer can trust a codebase they cannot read line by line.

| Layer | Choice | Why this, not the alternative |
|---|---|---|
| Language | TypeScript, strict, everywhere | One schema shared by every layer. A Python API + JS front end means two definitions of "a lead" that drift |
| Repo shape | Monorepo, pnpm workspaces | One repo, one check command, one CI. Separate repos means the schema is copied — and copies drift |
| Schema | Zod in `packages/schema` | Runtime validation and TS types from one definition. Every webhook payload validated before it becomes a lead event |
| API | Node + Fastify | Fast, boring, huge training data. NestJS fine if Syngenta prefers structure; Express fine if they prefer familiarity |
| Database | Postgres via Drizzle ORM, versioned migrations | Postgres is the portability guarantee. Drizzle keeps SQL visible, which matters when Claude writes it and you review it |
| Queue | BullMQ on Redis locally; SQS on AWS | Webhooks return 200 immediately and queue the work. This is the campaign-burst defence — 10,000 leads in twenty minutes is a queue depth, not an outage |
| Scoring engine | `packages/scoring` — pure TS, zero deps, zero I/O | Thousands of test cases in milliseconds. Replay history against a new version. Version-hash every score. This is why the engine is auditable |
| Intent extraction | Claude API from a queue worker, output validated against the schema | A model call is slow and can fail; it belongs on the queue with retries, never inline in a webhook |
| Web | Next.js | Boring. Server-rendered where dashboards read heavy queries. Same schema package |
| Mobile (Act) | Expo / React Native, SQLite on device, sync queue | Offline-first from the first screen. Flutter is a fine alternative if mandated, at the cost of a second language |
| Auth | Email + OTP for pilot; SSO (Azure AD / Okta) via OIDC later | Design the user table for SSO from day one — an `external_id` column costs nothing now and a migration later |
| Infra | Docker; Terraform in `infra/`; AWS ECS Fargate + RDS + ElastiCache + SQS | Rung 1. Auto-scaling, no servers to patch, reproducible from code |
| CI | GitHub Actions running `pnpm check` | The same command you run locally. If they differ, one of them is lying |
| Observability | JSON logs to stdout; Sentry; one CloudWatch dashboard | Request id on every log line so one grower's journey can be traced. One dashboard, not twelve |

---

## Repo shape

```
synapse/
├── CLAUDE.md                    ← the constitution, at most 45 lines
├── docs/
│   ├── SPEC.md                  ← what, for whom, v1 capabilities, out of scope
│   ├── INVARIANTS.md            ← INV-1 … INV-9, cited by ID in tests and PRs
│   ├── PROCESS.md               ← the operative process rules
│   ├── PLAN.md                  ← milestones + acceptance, links to Linear
│   ├── DECISIONS.md             ← dated, with reasons; parks have un-park triggers
│   ├── STATUS.md                ← where we are, how to run it, what's next
│   ├── ARCHITECTURE.md          ← the day-one rules below
│   ├── INFRA.md                 ← three environments, pipeline, cost
│   ├── UX.md                    ← journeys, screen inventory, states
│   ├── RUNBOOK.md               ← deploy, rollback, restore, on-call
│   ├── reference/               ← this folder: source material, never auto-loaded
│   ├── reviews/                 ← adversarial review findings, with triage
│   └── notes/                   ← per-domain notes, read on demand
├── .claude/
│   ├── settings.json            ← permissions allowlist + the three hooks
│   ├── commands/                ← /resume /add-connector /review-keystone
│   │                              /health-pass /adversarial-review
│   ├── agents/                  ← reviewer · review-planner · lens-reviewer · skeptic
│   └── hooks/                   ← protect-paths.sh, stop-if-red.sh
├── packages/
│   ├── schema/                  ← zod: LeadEvent, Grower, Lead, Score — SOURCE OF TRUTH
│   ├── scoring/                 ← pure functions, zero deps, zero I/O
│   ├── db/                      ← drizzle schema, migrations, lead transitions
│   └── connectors/
│       ├── _template/           ← what /add-connector copies
│       └── whatsapp/ …
├── apps/
│   ├── api/                     ← fastify: webhooks, REST, health
│   ├── worker/                  ← queue consumers: extraction, enrichment, scoring
│   ├── web/                     ← next.js: dashboards, admin
│   └── mobile/                  ← expo (Act)
├── infra/                       ← terraform (from M1 staging)
├── docker-compose.yml           ← postgres + redis locally
├── .env.example                 ← every variable that exists, documented
└── .github/workflows/ci.yml     ← runs pnpm check on every PR
```

---

## The three hooks

Hooks are the only rules that are actually enforced. Keep them to what must
never be skipped. Ask Claude to write the exact file for the current Claude Code
version; the shape is:

```json
{
  "permissions": {
    "allow": ["Bash(pnpm *)", "Bash(git status)", "Bash(git diff *)",
              "Bash(git log *)", "Bash(gh pr *)", "Bash(docker compose *)",
              "Read", "Glob", "Grep"],
    "deny":  ["Bash(git push --force *)", "Bash(rm -rf *)",
              "Read(.env)", "Read(**/*.pem)"]
  },
  "hooks": {
    "PostToolUse": [{ "matcher": "Edit|Write",
      "hooks": [{ "type": "command",
        "command": "pnpm lint:fix --silent && pnpm typecheck --silent" }] }],
    "PreToolUse":  [{ "matcher": "Edit|Write",
      "hooks": [{ "type": "command", "command": ".claude/hooks/protect-paths.sh" }] }],
    "Stop":        [{ "hooks": [{ "type": "command",
        "command": ".claude/hooks/stop-if-red.sh" }] }]
  }
}
```

1. **After every edit: lint-fix and typecheck.** Cheap, fast, catches drift
   immediately rather than at PR time.
2. **Before every edit: protect paths.** Refuses writes to `packages/scoring`
   unless the task explicitly names it, to `infra/` outside an infra task, and
   to any migration that already shipped. This is how "the agent quietly rewrote
   the engine" never happens.
3. **On stop: refuse to end the turn while `pnpm check` is red** — with a
   fail-open after three consecutive blocks that writes an `UNRESOLVED:` line
   into `STATUS.md` rather than looping until your limits burn.

**Self-test all three when you build them** (M0-T3). A hook that has never
blocked anything is a hook you are assuming works.

## The slash commands

| Command | What it does | Why it exists |
|---|---|---|
| `/resume` | Reads STATUS, PLAN, INVARIANTS, DECISIONS titles, and the open milestone's Todo issues in Linear. Reconciles STATUS against `git log`. Two sentences on where we stand, then proposes the next task | Every session starts here. It replaces re-explaining the project, the single largest token leak |
| `/add-connector <name>` | Copies `packages/connectors/_template`, wires the webhook or poller, schema mapping, idempotency key, a contract test with a recorded real payload, and a health entry. Opens a PR | Nine hand-written connectors fail nine different ways. One template audited once fails one way, fixed once |
| `/review-keystone` | Fresh-context reviewer plus security and data-integrity lenses, with per-finding skeptics that try to refute each finding against the real code | For PRs touching auth, migrations, identity, consent, scoring, or PKR |
| `/health-pass` | Dead code, debug output, stale TODOs, vulnerable dependencies, test files with zero assertions, STATUS drift | End of every milestone. Fifteen minutes that keeps the codebase readable |
| `/adversarial-review <files>` | Review planner → parallel lens reviewers → skeptics → findings file with a triage column. Never edits the reviewed file | Tier A document review. See 03-delivery-process §Review tiers |

## The reviewer agent — essence

> You are reviewing a diff you did not write. You have not seen the reasoning
> behind it and must not infer good intent.
> Read `docs/INVARIANTS.md` and the task's Linear issue. Then read the diff.
> Report: (1) any invariant at risk, by ID, with the line; (2) any behaviour
> outside the task's stated scope; (3) any check that could pass while the
> feature is broken; (4) any swallowed error.
> For each finding, first try to refute it against the actual code. Only report
> what survives.
> If you find nothing, say what you looked for and where. "No findings" without
> that list is a hole, not a pass.

---

## Day-one architecture rules (A1–A10)

The *Prompt to Production* server-side rules apply in full — env-only config,
stateless processes, JSON logs, `/health`, Postgres, versioned migrations. These
are the rules specific to *this* product that turn "make it production-grade"
into an upgrade rather than a rewrite.

**A1 — The scoring engine is a pure function.**
`score(enrichedLead, weights) → { score, tier, factors[], engineVersion }`. No
database, no network, no clock — the timestamp is passed in. This makes INV-8
testable, lets you replay a season against a new version before shipping it, and
makes model lift a number rather than a hope.

**A2 — One Lead Event schema, and every connector emits it.**
Connectors know about their source; nothing downstream knows about any source.
Adding the ninth connector changes zero lines outside its own folder.

**A3 — Webhooks return 200 in under 100ms and queue the work.**
Extraction, enrichment and scoring happen in workers with retries and a
dead-letter queue. A campaign burst is a queue-depth number on a dashboard, not
a page at 3 a.m.

**A4 — Idempotent on `sourceEventId` at the write.**
A unique constraint in the database, not a check in code. Meta will redeliver
webhooks; the constraint makes INV-3 physically impossible to violate.

**A5 — Lifecycle states are an enum; transitions live in one function.**
`transition(lead, event)` is the only way a lead changes state, and it is where
INV-5 and INV-6 are enforced. Every dashboard count is trustworthy because there
is exactly one path.

**A6 — Every grower row carries a consent basis from the first migration.**
Not nullable. A connector that cannot state where permission came from cannot
create a grower — INV-1 as a database constraint.

**A7 — PII columns are tagged in the schema** so logs, exports and the warehouse
redact by rule rather than by memory. Phone numbers never appear in a log line.

**A8 — Territory scope is enforced in the query layer, not the UI.**
`scopedLeads(user)` is the only way to read leads and it applies the hierarchy
filter. INV-7 cannot be bypassed by a new screen that forgot.

**A9 — The mobile app is offline-first from its first screen.**
Local SQLite, an outbox of actions, sync on reconnect, server timestamp wins,
officer entry never discarded. Retrofitting offline is a rewrite; starting
offline is a pattern.

**A10 — Weights live in the database, versioned, changed only through admin.**
Every weight change writes a row with who, when, and the previous value. The
engine reads the active version; the audit trail is free.

---

## Capture in milestones

Build scopes take the name of the canvas zone they deliver. **Capture** is
Zone 01 — nine sources, the ingestion layer, and Grower 360 — built as nine
milestones M0–M8, each a walking, demonstrable step. **Act** is the Sales
Officer app. Later scopes are not named until they exist. The canvas's layer
labels L1–L9 are architecture, never scope.

**Capture is not the Pilot.** Capture is all nine connectors plus Grower 360.
The Pilot is the go-live subset: Crop Doctor, WhatsApp and one NPI campaign in
two zones, on Engine v1.

Capture cannot be built "alone" — a source that emits events into nothing proves
nothing. So M1 lays a thin pipe all the way through to a minimal score and a
minimal list, and every later milestone widens the intake.

### M0 — Set the table
Repo, CLAUDE.md, the docs, hooks, commands, docker compose, `pnpm check` green
on a hello-world, CI green on the first PR. No product code.
- **Acceptance:** you watched `pnpm check` go green in your terminal; you watched
  CI go green on GitHub; you merged PR #1; you watched three hooks refuse.
- Also this week: file the Cropwise access request **and the AWS account
  request**. Both are on the critical path and both are slow.
- *~4–6 PRs · 3–4 sessions*

### M1 — Walking skeleton
One synthetic lead event posted to one endpoint → validated against the schema →
queued → stored → scored by a v0 engine with the five weights → shown in a
one-page web list with its factor breakdown. No real source. No auth. Every
layer touched once. **Then deployed to staging.**
- **Acceptance:** post a JSON event with curl; within five seconds it appears in
  the list with a score, a tier, and three factors; the engine version hash is
  visible. Same thing works on staging.
- **Invariants wired:** INV-3 (unique constraint — post the same event twice, see
  one lead), INV-8 (no score without version and factors).
- **v0 is deliberate, not an error.** It is the walking-skeleton stub: the five
  weights only, no modifiers, no tier logic beyond a single threshold. It sits
  below Engine v1 by design. Engine v1 — the full rules scorecard with the four
  modifiers and the tier rules — is the Pilot engine and arrives with the
  scoring milestones, not here.
- **Gate:** this proves the architecture while changing it is still cheap. If the
  queue, the schema package or the scoring package feel wrong, change them now.
- *~8–12 PRs · 4–6 sessions*

### M2 — The riskiest assumption
A spike, not a feature. Do whichever you can get access to first.
**(a) Cropwise Open Platform:** authenticate, pull one real Crop Doctor scan for
the Pakistan tenant, map it to a Lead Event.
**(b) If Cropwise access is still pending — WhatsApp Cloud API in sandbox:**
receive one real inbound message via webhook on a public URL, run it through
Claude for intent extraction, get a structured result.
- **Acceptance:** one real external payload, recorded to a fixture file, becomes
  one Lead Event in the M1 pipe. Findings in `docs/notes/spike-<source>.md`.
- If it fails, the plan changes now, while the plan is small. That is the point
  of doing it second.
- *~3–5 PRs · 2–4 sessions · throwaway code allowed here*

### M3 — Grower 360, identity resolution
The load-bearing layer. Grower table with mobile number as key and non-nullable
consent basis. Match-or-create on every incoming event. Merge and survivorship
rules. The explicit split for shared numbers. Interaction history as an
append-only timeline.
- **Acceptance:** three events with the same number from three "sources" produce
  one grower with three history entries. A split produces two growers with the
  history correctly divided.
- **Invariants wired:** INV-1, INV-2. **Every PR in this milestone is a keystone.**
- *~10–14 PRs · 5–7 sessions*

### M4 — First real connector
WhatsApp inbound, for real: the connector template is born here. Webhook,
signature verification, idempotency, Claude-based intent extraction on the
queue, mapping to Lead Event, contract test with recorded payloads, health entry.
- **Acceptance:** you send a WhatsApp message from your own phone to the business
  number; it appears as a scored lead on the deployed web list within a minute.
- Also: `/add-connector` is written by extracting the template from this
  connector. Test it by regenerating WhatsApp from the template and diffing.
- **Invariant wired:** INV-9 — kill the WhatsApp worker; the M1 synthetic
  endpoint still works.
- *~14–18 PRs · 7–10 sessions · the biggest milestone in Capture*

### M5 — Second connector via the template: Facebook
Meta lead ads webhook plus page DMs, generated with `/add-connector facebook`.
Campaign and ad ID carried through to the Lead Event. **This milestone exists to
prove the template; if it takes as long as M4, the template is wrong.**
- **Acceptance:** a test lead through a Meta lead form appears as a
  Campaign-attributed lead with the campaign ID intact.
- Also: the campaign ID convention is decided and written into DECISIONS.md.
  Marketing signs it.
- *~5–7 PRs · 2–3 sessions*

### M6 — Cropwise Grower connectors
Crop Doctor scans (API poll with watermark), in-app community (API +
extraction), Savera AI Agent transcripts (API + extraction). Three connectors
from the template, one shared Cropwise auth module, one shared extraction prompt
with per-source variants. Depends on the access requested in M0.
- **Acceptance:** a scan performed in the real app appears as a High-Potential
  lead with crop, diagnosis and severity populated; a community post with a
  price question appears with stated intent.
- **Consent gate:** no grower is created from Cropwise data until D1 is decided.
  If leadership has not decided, this milestone stores events but does not create
  growers — and says so in STATUS.
- *~10–14 PRs · 5–7 sessions*

### M7 — Remaining connectors
TikTok lead forms, NPI campaigns, brand-specific campaigns, call-centre capture
(an authenticated form or CSV upload if the centre's platform has no API). All
from the template, using the M5 campaign attribution convention.
- **Acceptance:** nine connectors on a connector-health page, each showing last
  event received and last error.
- **The one place parallel agents are safe and worth it** — connectors are
  independent by construction, one per worktree.
- *~10–14 PRs · 4–6 sessions*

### M8 — Harden Capture
Realistic-data pass with production-shaped growers — Urdu names, shared numbers,
40-acre and 2-acre farms, sparse and overflowing rows. The burst test: 10,000
synthetic webhooks in twenty minutes, queue depth watched, nothing dropped.
Dead-letter replay. The acreage cascade with the WhatsApp callback. Restore
drill on RDS, timed. Security pass on every webhook.
- **Acceptance:** the burst test passes with zero lost events and p95 webhook
  latency under 100ms; a restore from snapshot into a scratch environment passes
  the smoke test; the vacuity sweep is done and each critical check has a named
  broken state it catches.
- **Gate:** Capture is done. Monthly cost estimate approved. STATUS says exactly
  what Act starts from.
- *~12–16 PRs · 6–8 sessions*

### From milestone to task to PR
A milestone is 4 to 18 tasks. A task is one PR. **The decomposition rule: a task
is small enough that its acceptance check is one observable sentence** —
"posting a duplicate sourceEventId returns 200 and creates no second lead." If
you cannot write that sentence, the task is two tasks.

---

## The task cycle

*Superseded in detail by `03-delivery-process.md` §Phase 7, which adds the
Linear steps. The value is entirely in steps 5 and 6 — exactly where the
temptation to skip lives.*

1. **Start a session.** `cd synapse`, `claude`, then always `/resume`. If its two
   sentences do not match what you remember, reconcile before anything else — a
   stale STATUS builds the wrong thing confidently.
2. **Name the task and enter plan mode.** Shift+Tab. Your prompt is the issue
   key and nothing else — the plan is on disk. If the plan touches files outside
   scope, say so. Then approve.
3. **Branch and implement.** Small commits. The post-edit hook lint-fixes and
   typechecks each step. You do not need to watch this part.
4. **Red then green,** for anything that fixes or guards. Ask by name: "show me
   the check failing before the fix, then passing after." *A test that never ran
   red may be pinning the bug in place as intended behaviour.*
5. **Evidence.** Test output with a non-zero count. A screenshot for anything
   visual. A curl and its response for an endpoint. Look at it.
6. **Fresh-context review.** If the reviewer returns nothing and does not say
   what it looked for, that is a crashed reviewer, not a clean one.
7. **Diff against scope.** Agents build deferred things optimistically and leave
   them out of the report. The diff is the truth.
8. **Open the PR.** You read the description and evidence on GitHub — not every
   line of code.
9. **Merge.** Green CI, evidence seen, findings addressed → merged by tier per
   `docs/PROCESS.md` PR5: docs and chore by Claude, normal code by Claude on
   your "merge it", keystones by you in the browser.
10. **Close the task.** STATUS.md, DECISIONS.md if needed, then `/clear`.

**When you are stuck:** after about two genuine attempts, stop. Write what was
tried into `docs/notes/stuck-<topic>.md`. `/clear`. Start again with only the
symptom and the relevant file names. A long session of failed attempts poisons
every subsequent answer — the model is now reasoning around its own dead ends.
This is the most reliable unstick move there is, and it feels like giving up,
which is why people do not do it.

---

## Multiple agents — the calculation

A subagent costs a fixed spawn overhead, but its reads never enter your main
window. So: **wide reads always delegate; small edits never; parallel work only
when independent by construction.**

| Situation | Approach | Why |
|---|---|---|
| Every review | Subagent, always | Fresh context is the entire point |
| Codebase exploration, log digging, research | Subagent | The reads stay out of your main window; only the conclusion returns |
| Keystone review | Three parallel subagents — general, security, data integrity — then per-finding skeptics | One lens misses what another catches. Skeptics that default to refute keep findings honest |
| A ten-line fix | Never a subagent | The spawn costs more than it saves |
| M7's four connectors; QA persona suites | Parallel builders in separate git worktrees off a committed `main` | Independent by construction — each lives in its own folder and touches nothing shared |
| Anything touching `packages/schema` or `packages/db` | One agent, sequential, never parallel | Shared files. Two agents editing them costs every minute the parallelism saved, plus interest |
| Unattended runs | Only with a hard iteration cap and a spend cap set before the run | A runaway loop is a cost incident discovered in the morning |

**The report is a claim; the diff is the truth.** After any agent-built work,
especially parallel work, diff the changed files against the intended scope.
Parallel executors have silently built explicitly-deferred features and left
them out of their reports — not maliciously, optimistically. Hand work off
through files, not conversational paraphrase.

---

## Economics

**Plan choice.** A subscription plan gives a fixed monthly cost with usage
windows that reset — the right choice for a solo builder in build phase, because
a bad session cannot become a bad invoice. API billing is per token: better for
unattended pipelines later, worse for a human learning the tool. Move specific
automated workloads (the extraction worker's Claude calls) to an API key with a
spend cap when they exist — those are *product* costs, not build costs, and
should be accounted separately.

**What burns tokens:** long sessions that never clear · re-explaining the
project instead of `/resume` · letting Claude explore to find a file you could
have named · side questions in the build session · fighting the same bug past
two attempts · a fat CLAUDE.md · tools loaded into context the task never uses ·
large files read whole when a section would do.

**What saves them:** state on disk and `/resume` · `/clear` between tasks · plan
mode before editing (a wrong plan costs a paragraph; wrong code costs a session)
· naming the file · small tasks with one acceptance sentence · subagents for
wide reads · side questions elsewhere · the stuck note and a fresh start.

| Unit | Typical | Signal something is wrong |
|---|---|---|
| One task | One session, one PR, one `/clear` | Same task across three sessions — decompose it or write the stuck note |
| One milestone | 4–18 PRs, 2–10 sessions | PR count doubles the plan — scope crept mid-milestone |
| Capture as scoped | 80–110 PRs, 40–55 sessions, ~3–4 months part-time | Month two with M3 not done — M2's spike found something and the plan was not updated |
| Reviews | ~15–20% of total usage | Zero — reviews are being skipped, and Law 1 is being violated |

**Product cost, separately.** Once deployed: AWS at rung 1 (~USD 120–250/month
for a pilot, verified at deploy), WhatsApp conversation fees at volume, and
Claude API calls for intent extraction — a few thousand short extractions a day
is small money, but it is a per-lead cost and belongs in the cost-per-converted-
lead number marketing will eventually read. Budget alerts at 50/80/100% on every
account **before** the first deploy, tagged resources, and a ten-minute monthly
review of the top five bill lines.

---

## The closing rule

Decide on paper. Build in thin end-to-end slices. Never believe a check you have
not seen fail. And keep the memory in files, because the engineer forgets
everything between shifts and you are the one who does not.
