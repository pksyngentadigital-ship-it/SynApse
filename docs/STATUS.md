# Synapse status

**Phase 2, session 2.1 done on paper, 2026-09-21.** `docs/SPEC.md` v0.9 —
six parts, all approved by Ahsan row by row, plus a technical appendix — is on
`syn-9-session-21-draft-specmd-v09-in-six-parts` (SYN-9, docs-only) as a PR
awaiting Ahsan's read and merge. Nothing runs yet; no commands until M0.

**Last merged PR:** #3, "docs: Phase 1 Base44 audit of Smart Agro Lite",
squash-merged to `main` as `304a3be` on 2026-09-15.

**Next task:** Ahsan merges the SPEC PR. Then Phase 2, session 2.2:
`/adversarial-review docs/SPEC.md` with the lenses in
`docs/reference/03-delivery-process.md` §Session 2.2; findings to
`docs/reviews/spec-r1.md`; Ahsan triages; accepted findings applied; v1.0.
The review should read the disagreement register index (Appendix A.6) first.
SYN-6 is parked (trigger: "Pro is connected").

**Decided this session** (all in `docs/DECISIONS.md`, dated): D1 (any contact
is consent, leadership's position; no opt-out this phase) · D4 (one number,
one grower, no split) · D9 (healthy scan is a lead only at or above the
threshold) · three ranked segments, no cap · two clocks, notify-only · acreage
threshold 20 as an Admin setting · eight personas · acreage replaces order
value · Hina, a third-party AI calling agent, fills lead gaps by phone before
routing (phase 1); AI-SUL role out of scope · scoring details. D8 is unused.
Ahsan's words are verbatim in `docs/notes/spec-input-2026-09-15.md` to `-18.md`.

**Open decisions:** D2 (Cropwise access — filed, awaiting reply; recipient and
date to add) · D3 (campaign convention, M5) · D6 (territory vs franchise) ·
D7 (conversion value; POS is the intended path).

**Carry forward.** Hina was in no document before 2026-09-21; the M8
"acreage cascade with WhatsApp callback" in `docs/PLAN.md` is now a Hina
connection and the plan needs that line changed in Phase 5. The M6 gate on
Cropwise-sourced growers is lifted by D1. Smart Agro Lite mirror at
`~/synapse-reference/base44/`, outside the repo.

**Identifiers.** GitHub `pksyngentadigital-ship-it/SynApse` (private, shared
account, repo-local identity Ahsan Raza) · Linear `syngentadigital` / SynApse /
team **SYN** · Linear MCP verified 2026-09-11 · Base44 MCP verified 2026-09-13
via the desktop connector; the `.mcp.json` entry is unauthorised and unused ·
13 Base44 write/run/record tools denied in `.claude/settings.json`, on disk,
not yet proven live · fresh clone: `git config core.hooksPath .githooks`.

**Not verified.** Linear integration on PR open moved SYN-8 to In Progress,
not In Review as PROCESS LIN3 states; PR #3's merge moved it to Done. Watch
SYN-9.
