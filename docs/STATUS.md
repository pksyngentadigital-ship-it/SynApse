# Synapse status

**Phase 1 done on paper, 2026-09-13.** `docs/notes/base44-audit.md` is on
`syn-8-base44-audit` as PR #3 (SYN-8, docs-only), awaiting Ahsan's read and
merge. Nothing runs yet; no commands until M0.

**Last merged PR:** #2, "chore: warden triage, interim push guard, incident
record", squash-merged to `main` as `ec881da` on 2026-09-13.

**Next task:** Ahsan reads PR #3 — §5 business rules and §6 gap table hardest —
confirms every rule he knows is there, and merges. Then Phase 2, session 2.1:
draft `docs/SPEC.md` from the canvas with the audit's §5, §6, §7 as inputs and
§8 Unknowns as questions. SYN-6 is parked (trigger: "Pro is connected").

**Carry forward.** Smart Agro Lite (Base44 app `69690a59f22f6e749b0986ec`):
client-side authorisation, no consent field, no scoring, no lead event, manual
Excel ingestion, one scheduled WhatsApp summary. Mirror at
`~/synapse-reference/base44/`, outside the repo; no record was read. Sandbox
isolation from the live app: unknown (audit §8.1).

**Identifiers.** GitHub `pksyngentadigital-ship-it/SynApse` (private, shared
account, repo-local identity Ahsan Raza) · Linear `syngentadigital` / SynApse /
team **SYN** · Linear MCP verified 2026-09-11 · Base44 MCP verified 2026-09-13
via the desktop connector; the `.mcp.json` entry is unauthorised and unused ·
13 Base44 write/run/record tools denied in `.claude/settings.json`, on disk,
not yet proven live · fresh clone: `git config core.hooksPath .githooks`.

**Not verified.** Linear integration on PR open moved SYN-8 to In Progress,
not In Review as PROCESS LIN3 states; watch what merge does.
