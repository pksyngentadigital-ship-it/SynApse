---
description: The gated path to a pull request. Runs scope-differ, then the right reviewer for the task's tier, then opens the PR with the full template.
---

# /pr

The purpose of this command is that the review steps **cannot be skipped**,
because skipping them is what a tired human does at 6pm.

Refuse to continue past any step that fails. Say which step failed and stop.

## Step 1 — Preconditions

Check all of these. Any failure stops the command.

- The current branch is not `main`
- There is a Linear issue for this branch
- `pnpm check` (or the project's check command) passes — run it and show the
  tail of the output including the test count
- The working tree is committed

## Step 2 — Scope

Launch `scope-differ` with the issue key. Relay its verdict.

If the verdict is DRIFT, **stop**. Report it and ask Ahsan whether to remove the
out-of-scope work or to widen the issue. Do not decide this yourself.

## Step 3 — Review, by tier

Read the issue's Keystone flag, and check the diff yourself against the keystone
list in PROCESS.md PR6 — auth, migrations, identity, consent, scoring, PKR,
`infra/`. If the diff is a keystone and the flag says no, correct the flag and
say so.

- **Not a keystone:** launch `reviewer`.
- **Keystone:** launch `reviewer`, `security-reviewer` and
  `data-integrity-reviewer` in parallel. Then for every finding any of them
  returned, launch a `skeptic` on that one finding. Report only findings that
  survive.

Relay all surviving findings. For each, say what you did about it or that you
did nothing and why.

A reviewer that returns no findings **and does not say what it looked for** has
crashed. Re-run it once. If it does the same again, report that and stop.

## Step 4 — Open the PR

Only once steps 1–3 are clean or their findings are explicitly addressed.

`gh pr create` with this body, every heading filled:

```
Closes SYN-n

**Acceptance**   <the observable sentence from the issue>
**Invariants**   <IDs touched, or "none">
**Evidence**     <test output with counts · screenshot path · request + response>
**Review**       <which agents ran, what survived, what was done>
**Migration**    <yes + filename, or no>
**Keystone**     <yes/no>
**Deferred**     <anything in scope not built, by name — or "nothing">
```

Rules for the body:
- **Evidence** must contain real evidence. "Works as expected" is not evidence
  and must not be written. If you have no evidence, stop and get some.
- **Deferred** must never say "nothing" if `scope-differ` found something
  missing.

## Step 5 — Classify the merge tier

Decide the tier from the **files the diff touches**, not from what the issue
claims:

- **Keystone** — anything under `infra/`, any migration, or any change to auth,
  identity resolution, consent, the scoring engine, or code handling PKR. Also
  any hotfix.
- **Docs / chore** — the diff touches *only* `docs/**`, `.claude/**`,
  `.github/**`, `README*`, or config with no runtime effect.
- **Normal code** — everything else.

State the tier and why, in one line.

## Step 6 — Merge, by tier

**Never enable auto-merge, on any tier.**

### Docs / chore → merge it yourself

```
gh pr checks <n> --watch
```

When every check is green: `gh pr merge <n> --squash --delete-branch`. Then
report the merge in one line. If a check fails, stop and report it — do not
merge, do not retry.

### Normal code → stop and wait for Ahsan's word

Print, in the session:

- the PR URL
- the acceptance sentence
- the evidence, in full — test counts, the screenshot path, the request and
  response. Not a summary of the evidence; the evidence.
- every surviving review finding and what was done about it
- the scope verdict
- the CI state

Then this line and nothing more:

`Tier: normal code. Read the evidence above. Say "merge it" and I'll squash-merge, or tell me what to change.`

**Then stop.** On "merge it": wait for CI green with `gh pr checks <n> --watch`,
then `gh pr merge <n> --squash --delete-branch`, and report it.

Do not merge on any other phrasing that is not clearly an instruction to merge.
Ambiguity means ask.

### Keystone → hand it over

Print the PR URL and this line:

`Tier: keystone. Open it, read the diff itself — not my summary — and merge it yourself.`

**Never merge a keystone**, whatever Ahsan says in the session. If he asks you
to, say that PROCESS.md PR5 reserves keystone merges for him in the browser, and
that changing it needs a DECISIONS.md entry first. An agent merging a consent or
migration change leaves no person in the approval record.

If Step 5 found keystone content in a PR the issue flagged as normal: correct
the `Keystone` line in the PR body, say so plainly, and treat it as a keystone
from here.

## Step 7 — After any merge

Remind Ahsan in one line: `Merged. Run /close before you clear.`

Do not run `/close` yourself — it is a separate, deliberate step.
