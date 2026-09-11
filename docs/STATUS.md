# Synapse status

**Phase 0 complete 2026-09-12, pending PR #2's merge.** Nothing runs yet; no
commands until M0.

**Last merged PR:** #1, "docs: rule book and process", on `main` at `337fb78`.
Merged by the incident, not by a human; Ahsan read its diff after the fact on
2026-09-12 and accepted `main` as it stands (DECISIONS 2026-09-11, INCIDENT).

**Next task:** SYN-7 — Ahsan reads and merges PR #2 (`chore/rule-book`, docs
only). Then Phase 1, the Base44 audit, once the Base44 MCP is authorised via
`/mcp` in an interactive session. SYN-6 is Todo and parked with GitHub Pro.

**Identifiers.** GitHub `pksyngentadigital-ship-it/SynApse`, private, `main`:
https://github.com/pksyngentadigital-ship-it/SynApse · shared account; repo-local
git identity Ahsan Raza · Linear workspace `syngentadigital`, project `SynApse`
(In Progress), team key **SYN**:
https://linear.app/syngentadigital/project/synapse-be473bf50d39 · MCP servers in
`.mcp.json`, project scope, OAuth: **Linear verified 2026-09-11**; **Base44
registered, loads on restart, not yet authorised** (`https://app.base44.com/mcp`).

**Verified done.** Squash-only, delete-on-merge · seven GitHub labels ·
`staging` and `production` environments · Dependabot alerts · Linear M0–M8,
seven labels, "In Review" status, SYN-5 and SYN-7 In Progress, SYN-6 Todo,
SYN-1–4 Canceled · **`.githooks/pre-push` proven by a live push from Ahsan's
terminal 2026-09-12: installed, logic correct, invoked by git** · deny rules for
pushes to `main`, seen firing. A fresh clone must run
`git config core.hooksPath .githooks`.

**Not verified.** GitHub↔Linear integration: it did not move SYN-5 on PR #1's
merge. Check the integration's repo access in Linear settings.

**Parked.** GitHub Pro (branch protection, production reviewer, secret
scanning). Un-park trigger: Ahsan says "Pro is connected". Not to be raised.
