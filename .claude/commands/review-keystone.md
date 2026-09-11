---
description: Tier B review for a high-risk diff. Three lenses in parallel, then a skeptic per finding. Use for auth, migrations, identity, consent, scoring, PKR, infra and every hotfix.
---

# /review-keystone

For a diff that could lose data, leak data, or make money wrong.

`/pr` runs this automatically for keystone tasks. Use it standalone when you
want the review before you are ready to open a PR.

## Step 1 — Three lenses, in parallel

Launch these in a single message so they run concurrently:

- `reviewer` — correctness, scope, invariants, swallowed errors
- `security-reviewer` — secrets, signatures, validation, authorisation, PII
- `data-integrity-reviewer` — idempotency, migrations, transitions, money, time

Each gets the issue key and reads the diff itself. Do not paste the diff into
their prompts — they read files, not conversations.

## Step 2 — A skeptic per finding

For every finding from every lens, launch a `skeptic` on that one finding.
Batch them in parallel. Keep only what survives.

## Step 3 — Report

```
KEYSTONE REVIEW — <issue key>
Raised: <n>  ·  Survived: <m>  ·  Blockers: <k>

SURVIVING
<severity> [<lens>] <claim>
  Where: <file>:<line>
  Breaks when: <the concrete case>
  Fix: <one sentence>
  Skeptic: survived — <why refutation failed>

REFUTED: <n> — <one line each>

COVERAGE: <what each lens verified and where>
NOT COVERED: <anything none of the three lenses looked at>
```

## Step 4 — Stop

Do not fix the findings in the same turn. Report, then let Ahsan decide the
order. A keystone diff being edited in the same breath as its review is how a
review becomes theatre.

If any lens returns nothing without saying what it looked for, re-run that lens
once, then report the failure.
