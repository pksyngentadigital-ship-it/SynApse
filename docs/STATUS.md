# Synapse status

Where we are right now. Overwritten every session by `/close`; `git log` is the
truth and `/resume` reconciles the two.

## Where we are

**Phase 0, session 0.1 — executed 2026-09-11.** `main` exists with the
baseline commit. GitHub is configured as far as the plan allows. Linear is
seeded. The rule-book corrections and the new docs are on `chore/rule-book`,
opened as PR #1 (`Closes SYN-5`). **Ahsan merges PR #1** — the docs tier needs
CI green before Claude may merge, and CI does not exist until M0-T1.

## Identifiers — never hunt for these

| What | Value |
|---|---|
| GitHub repo | `pksyngentadigital-ship-it/SynApse` — https://github.com/pksyngentadigital-ship-it/SynApse — private, default branch `main` |
| GitHub account | `pksyngentadigital-ship-it` (shared team account; see DECISIONS 2026-09-11) |
| Git identity, this repo only | Ahsan Raza <ahsanraza.us1@gmail.com> |
| Linear workspace | `syngentadigital` — https://linear.app/syngentadigital |
| Linear project | `SynApse` — https://linear.app/syngentadigital/project/synapse-be473bf50d39 — In Progress since 2026-09-11 |
| Linear team / issue prefix | Team `Syngentadigital`, key **SYN** — issues are `SYN-n` |
| Linear MCP | Project scope, `.mcp.json` at repo root, HTTP to `https://mcp.linear.app/mcp`, OAuth. Verified connected 2026-09-11 |

## Setups

| Item | State |
|---|---|
| Git repository, `main`, remote | **Done.** Baseline commit `f2bd66e` pushed |
| Merge behaviour | **Done.** Squash only, merge commits and rebase off, delete branch on merge |
| GitHub labels | **Done.** The seven from PROCESS LIN2; GitHub defaults removed |
| Environments `staging`, `production` | **Created.** `production` does **not** require a reviewer — blocked by plan |
| Dependabot alerts | **Done.** |
| Branch protection on `main` | **BLOCKED.** GitHub Free refuses protection and rulesets on a private repo. No protection exists. Warden checks 17 and 19 will report RED until Ahsan resolves the plan decision (DECISIONS 2026-09-11, OPEN) |
| Secret scanning, push protection | **BLOCKED.** Same plan limit |
| PR template | In PR #1: `.github/PULL_REQUEST_TEMPLATE.md` |
| `.gitattributes` | In PR #1. Forces LF so the bash hooks survive a Windows checkout |
| Linear milestones M0–M8 | **Done.** Nine, mirroring `docs/PLAN.md` |
| Linear labels | **Done.** Seven; Linear's `Bug` renamed to `bug`; `Improvement` and `Feature` left as found |
| Linear issues | **SYN-5** session 0.1 (In Progress) · **SYN-6** M0-T1 required check (Todo, blocked on the plan decision). Linear's own onboarding issues SYN-1–SYN-4 sit outside the project, untouched |
| Linear issue template | **NOT DONE — needs Ahsan's click.** The MCP cannot create templates. Team settings → Templates → New issue template, body = the five PR2 headings: Acceptance · Files · Invariants · Keystone · Decisions |
| Linear "In Review" status | **Missing.** PROCESS LIN3 expects PR opened → In Review. Add a started-type status "In Review" in team settings, then wire the GitHub integration (branch pushed → In Progress, PR opened → In Review, PR merged → Done) |
| Linear ↔ GitHub integration | **Unverified.** Not checkable from the MCP; verify in Linear settings in session 0.2 |
| CI | Does not exist until M0-T1 |
| Hooks and agents verified against the installed Claude Code version | Session 0.2 |
| Cropwise access request, AWS account request | Session 0.2, Ahsan, non-code. Log recipient and date in DECISIONS |

## Decisions

D5 decided (default stack). D1, D4 open with Syngenta leadership. D3 deferred
to M5. D6, D7 open, not needed in Capture. GitHub plan: open, Ahsan. Full
table in `docs/DECISIONS.md`.

## Next

1. Ahsan: merge PR #1 in the browser after reading CLAUDE.md in under two
   minutes.
2. Ahsan: decide the GitHub plan question; create the Linear issue template
   and the "In Review" status.
3. Session 0.2: `/resume`, verify hooks and agent models, `/checkpoint`, file
   the Cropwise and AWS requests, ask marketing who owns the Meta developer
   app.
4. Then Phase 1, the Base44 audit.
