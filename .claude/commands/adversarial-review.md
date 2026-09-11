---
description: Tier A document review. Planner writes the attack plan, lens reviewers execute it in parallel, skeptics filter every finding, output is a triage file for Ahsan.
---

# /adversarial-review <files> [— lenses: a, b, c]

For documents, not code: SPEC, ARCHITECTURE, INFRA, UX, PLAN, QA-PLAN, release
readiness. A wrong sentence in these becomes twenty wrong PRs, which is why this
is worth its cost here and nowhere else.

**Never edit the document under review in this command.** Output is a findings
file. Applying findings is a separate, explicit turn.

## Step 1 — Plan

If Ahsan named lenses, use exactly those. If he did not, propose a lens list
first and wait for approval — the lens list determines what the review can
possibly find, so it is his call.

Launch `review-planner` with the documents and the lens list. It writes
`docs/reviews/<doc>-r<n>-plan.md`.

Show Ahsan the lens list and one line per lens on what it will attack. Wait for
"go".

## Step 2 — Execute lenses in parallel

Launch one `lens-reviewer` per lens, **in a single message so they run
concurrently**. Each gets: the plan path, its own lens name, and the document.

One lens per agent. Never give one agent two lenses.

## Step 3 — Skeptics

For **every** finding returned by every lens, launch a `skeptic` on that one
finding. Batch them in parallel.

Discard every REFUTED finding. Keep the refutation reasoning — Ahsan may want to
see what was thrown out and why.

## Step 4 — Write the triage file

Write `docs/reviews/<doc>-r<n>.md`:

```markdown
# <Document> — adversarial review, round <n>
Date · Lenses · Findings raised: <n> · Survived skeptics: <m>

## Surviving findings

### F1 · <BLOCKER|MAJOR|MINOR> · <lens>
**Claim.** <one sentence>
**Quoted.** "<the line from the document>"
**Consequence.** <what breaks downstream>
**Proposed fix.** <one sentence>
**Skeptic.** Survived — <why the refutation failed>
**TRIAGE:** ( ) accept  ( ) reject — reason:  ( ) park — trigger:

...

## Refuted, and why
<one line each — F-number, the claim, and which of the four refutations killed it>

## Coverage
<per lens: attacks attempted, and what came back empty>
<what this review did not look at>
```

## Step 5 — Hand over

```
Round <n>: <n> raised, <m> survived, <k> blockers.
File: docs/reviews/<doc>-r<n>.md
Mark each finding accept / reject / park in that file, then tell me to apply.
```

Then stop.

## Rounds

Maximum two rounds per document. A second round only if round one produced an
accepted finding that changed a whole section.

**If a third round feels necessary, the problem is a missing decision, not a
missing review.** Say that to Ahsan instead of running it.
