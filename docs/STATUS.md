# Synapse status

**Phase 1 audit written 2026-09-13.** `docs/notes/base44-audit.md` on
`syn-8-base44-audit`, SYN-8, PR open for Ahsan's read (docs-only tier).
Nothing runs yet; no commands until M0.

**Last merged PR:** #2, "chore: warden triage, interim push guard, incident
record", squash-merged to `main` as `ec881da` on 2026-09-13. SYN-7 moved to
Done by the GitHub integration on that merge, so the integration works;
SYN-5 was set Done by hand the same day on Ahsan's instruction (PR #1 had
merged 2026-09-11 and the integration never moved it).

**Next task:** Ahsan reads and merges the SYN-8 PR. Then Phase 2, session
2.1: draft `docs/SPEC.md` from the canvas, with the audit's §5 business
rules, §6 gap table and §7 do-not-carry-forward list as inputs; the audit's
§8 Unknowns are questions for that session, not facts. SYN-6 is parked.

**Phase 1 facts to carry.** Smart Agro Lite (Base44 app id
`69690a59f22f6e749b0986ec`, the only app on the account) is a mobile-first
web app whose back end is one scheduled WhatsApp summary; all authorisation
is client-side, there is no consent field, no scoring, no lead event, and
ingestion is a manual Excel import. Read-only mirror at
`~/synapse-reference/base44/` (outside the repo, never committed; manifest
records every Base44 call). No grower record was read. Whether the Base44
sandbox that the file tools create is isolated from the live app could not be
determined; see the audit's §8.

**Identifiers.** GitHub `pksyngentadigital-ship-it/SynApse`, private, `main`:
https://github.com/pksyngentadigital-ship-it/SynApse · shared account; repo-local
git identity Ahsan Raza · Linear workspace `syngentadigital`, project `SynApse`
(In Progress), team key **SYN**:
https://linear.app/syngentadigital/project/synapse-be473bf50d39 · MCP servers:
**Linear verified 2026-09-11**; **Base44 verified 2026-09-13 through the
desktop connector** (the `.mcp.json` entry for `https://app.base44.com/mcp`
is still unauthorised and is not the one in use). Thirteen Base44 tools that
write, run, execute or read records are denied in `.claude/settings.json`
under both server-name forms; proven on disk, not yet proven live.

**Verified done.** Squash-only, delete-on-merge · seven GitHub labels ·
`staging` and `production` environments · Dependabot alerts · Linear M0–M8,
seven labels, "In Review" status, SYN-5 and SYN-7 Done, SYN-6 Backlog and
parked, SYN-1–4 Canceled · `.githooks/pre-push` proven by a live push from
Ahsan's terminal 2026-09-12 · deny rules for pushes to `main`, seen firing ·
GitHub↔Linear integration moves an issue to Done on merge (SYN-7). A fresh
clone must run `git config core.hooksPath .githooks`.

**Not verified.** Whether the integration moves an issue to In Progress on
branch push and to In Review on PR open: watch SYN-8.

**Parked.** GitHub Pro (branch protection, production reviewer, secret
scanning). Un-park trigger: Ahsan says "Pro is connected". Not to be raised.
