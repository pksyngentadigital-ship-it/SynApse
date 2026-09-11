---
description: One-time GitHub repository configuration via gh and gh api. Run once in Phase 0, session 0.2. Reports everything it changed so Ahsan can verify it in the browser.
---

# /setup-repo

Configure the `synapse` repository so the process rules are enforced by GitHub
rather than remembered by people. Run once. Idempotent — safe to re-run to check
state.

Read `docs/PROCESS.md` §2b before starting. Plan, show Ahsan the plan, wait for
"Approved", then execute.

## What you configure

**1. Merge behaviour**

```
gh repo edit --enable-squash-merge --enable-merge-commit=false \
             --enable-rebase-merge=false --delete-branch-on-merge
```

**2. Branch protection on `main`** — a pull request required, the `check` status
check required, no force pushes, no deletions. Use `gh api` against
`/repos/{owner}/{repo}/branches/main/protection` with the PUT shape the current
API expects.

Required status check context: the job name from `.github/workflows/ci.yml`. If
that workflow does not exist yet, set protection **without** a required check
now, say so, and create a Linear issue to add the check in M0-T1 when CI exists.
Never invent a check name — a required check that never reports blocks every PR
permanently.

**3. Labels** — the seven from PROCESS.md L2: `keystone`, `spike`, `bug`,
`change-request`, `feedback`, `tech-debt`, `parked`. Delete GitHub's defaults
that we will not use.

**4. PR template** — `.github/PULL_REQUEST_TEMPLATE.md`, with exactly the PR3
headings: `Closes`, Acceptance, Invariants, Evidence, Review, Migration,
Keystone, Deferred.

**5. Security** — secret scanning and push protection on; Dependabot alerts on.
Via `gh api` on the repo's security-and-analysis settings. If any of these
require a setting the API cannot reach on this plan, say which, and give Ahsan
the exact click path.

**6. Environments** — create `staging` and `production`. Set `production` to
**require reviewers**, with Ahsan as the reviewer. This is the human gate in
front of every production deploy.

## Must not

- **No secrets.** No `gh secret set`, no repository or environment secrets, not
  even a placeholder. Ahsan enters every credential himself (PROCESS.md G3).
- **Nothing destructive.** No repo delete, no transfer, no visibility change, no
  history rewrite (G4).
- **Do not loosen anything.** If a setting is already stricter than this
  document asks for, leave it and report it.

## Report

Print a table: setting · before · after · how Ahsan verifies it in the browser.

Then this line:

`Verify branch protection and the production environment in Settings yourself — those two are the ones that matter. Everything else is convenience.`

Finally, note in one line that from now on the process warden checks at every
session start that branch protection is still on with its required checks, and
that any change to it needs a DECISIONS.md entry written first.
