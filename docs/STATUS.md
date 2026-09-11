# Synapse status

**Phase 0, session 0.2 done 2026-09-11.** PR #1 open on `chore/rule-book`,
`Closes SYN-5`. Nothing merged through a PR yet. Nothing runs yet; no commands
until M0.

**UNRESOLVED: `origin/main` is at `337fb78`, not the baseline `f2bd66e`.** A
hook probe pushed session 0.1's three commits straight to `main` (DECISIONS
2026-09-11, INCIDENT). Ahsan decides restore (a) or accept (b) before merging
PR #1. Until then PR #1 shows only session 0.2's diff.

**Next task:** Ahsan resolves the incident, runs the hook probe below from his
own terminal, reads and merges PR #1. Then Phase 1, the Base44 audit, once the
Base44 MCP is verified. SYN-6 is Todo and parked with GitHub Pro.

**Hook probe, Ahsan's terminal, from the repo:**
`git push origin chore/rule-book:main` — expect "pre-push: REFUSED" and an
unchanged `main`. A fresh clone must first run
`git config core.hooksPath .githooks`.

**Identifiers.** GitHub `pksyngentadigital-ship-it/SynApse`, private, `main`:
https://github.com/pksyngentadigital-ship-it/SynApse · shared account; repo-local
git identity Ahsan Raza · Linear workspace `syngentadigital`, project `SynApse`
(In Progress), team key **SYN**:
https://linear.app/syngentadigital/project/synapse-be473bf50d39 · MCP servers in
`.mcp.json`, project scope, OAuth: **Linear verified 2026-09-11**; **Base44
registered, unverified until next session** (`https://app.base44.com/mcp`).

**Verified done.** Squash-only, delete-on-merge · seven GitHub labels ·
`staging` and `production` environments · Dependabot alerts · Linear M0–M8,
seven labels, "In Review" status, GitHub integration connected, SYN-5 In
Progress, SYN-6 Todo, onboarding SYN-1–4 Canceled · `.githooks/pre-push` wired
via `core.hooksPath`, logic tested · deny rules for pushes to `main`.

**Parked.** GitHub Pro (branch protection, production reviewer, secret
scanning). Un-park trigger: Ahsan says "Pro is connected". Not to be raised.
