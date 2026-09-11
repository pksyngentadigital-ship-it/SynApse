# Synapse status

**Phase 0, session 0.2 done 2026-09-11.** Nothing runs yet; no commands until M0.

**UNRESOLVED: PR #1 is recorded MERGED by an incident, not by Ahsan.** A hook
probe pushed session 0.1's commits straight to `main` (`337fb78`); GitHub
marked PR #1 merged by the shared account, no human read it, and deleted the
branch (DECISIONS 2026-09-11, INCIDENT, with its same-day update). Session
0.2's work is one unmerged commit `58b5deb` on the recreated `chore/rule-book`.
No PR is open for it.

**Next task, Ahsan's, in order:** (1) decide (b′) accept or (a) restore per the
DECISIONS entry; (2) read PR #1's diff after the fact; (3) authorise one new
Linear issue for session 0.2 so `58b5deb` can go in as PR #2, or tell Claude
otherwise; (4) run the hook probe below. Then Phase 1, the Base44 audit, once
the Base44 MCP is verified. SYN-6 is Todo and parked with GitHub Pro.

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
seven labels, "In Review" status, SYN-5 In Progress, SYN-6 Todo, onboarding
SYN-1–4 Canceled · `.githooks/pre-push` wired via `core.hooksPath`, logic
tested · deny rules for pushes to `main`, seen firing.

**Not verified.** GitHub↔Linear integration: it did not move SYN-5 on PR #1's
merge. Check the integration's repo access in Linear settings.

**Parked.** GitHub Pro (branch protection, production reviewer, secret
scanning). Un-park trigger: Ahsan says "Pro is connected". Not to be raised.
