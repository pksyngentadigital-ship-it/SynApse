# Synapse plan — Capture in milestones

The milestone list with one line of purpose each. Acceptance sentences, task
decomposition and PR estimates arrive in Phase 5 from
`docs/reference/02-build-playbook.md` §Capture in milestones, adjusted for
SPEC v1.0, ARCHITECTURE, INFRA and UX. Tasks live in Linear, not here.

**Scope:** Capture — nine sources, the ingestion layer, Grower 360 — as nine
milestones. Capture is not the Pilot; see the canvas. ~80–110 PRs.

**Linear:** project *SynApse* — https://linear.app/syngentadigital/project/synapse-be473bf50d39
— team key `SYN`. Milestones below exist there with the same names.

## M0 — Set the table
Repo, rule book, hooks, commands, docker compose, `pnpm check` green on a
hello-world, CI green on the first PR, three hooks seen refusing. No product
code.

## M1 — Walking skeleton
One synthetic lead event posted to one endpoint, validated, queued, stored,
scored by the v0 stub engine, shown in a one-page list with its factor
breakdown, then deployed to staging. Wires INV-3 and INV-8.

## M2 — The riskiest assumption
A spike, not a feature: one real external payload (Cropwise Crop Doctor, or
WhatsApp sandbox if Cropwise access is pending) becomes one Lead Event in the
M1 pipe. Throwaway code allowed. Findings to `docs/notes/`.

## M3 — Grower 360
Identity resolution on the verified mobile number, non-nullable consent basis,
match-or-create on every event, explicit split for shared numbers, append-only
interaction history. Every PR is a keystone. Wires INV-1 and INV-2. Depends on
D4.

## M4 — First real connector: WhatsApp
WhatsApp inbound for real: webhook, signature verification, idempotency,
intent extraction on the queue, contract test with recorded payloads, health
entry. The connector template and `/add-connector` are born here. Wires INV-9.
The biggest milestone in Capture.

## M5 — Second connector via the template: Facebook
Meta lead ads and page DMs generated from the template; campaign and ad ID
carried through to the Lead Event. Exists to prove the template. D3, the
campaign ID convention, is decided here and signed by marketing.

## M6 — Cropwise Grower connectors
Crop Doctor scans, in-app community and Savera AI Agent transcripts from the
template, one shared Cropwise auth module. Depends on D2 access. Consent gate:
no grower is created from Cropwise data until D1 is decided; events are stored
and STATUS says so.

## M7 — Remaining connectors
TikTok lead forms, NPI campaigns, brand campaigns, call-centre capture, all
from the template using the M5 attribution convention. Nine connectors on a
health page. The one place parallel agents are safe. Then, after the Pilot
streams, the e-commerce purchase stream: a signal-only connector that never
creates a lead (SPEC P4-27a; added from the SPEC r1 review, N29).

## M8 — Harden Capture
Production-shaped synthetic data, the 10,000-event burst with zero loss and p95
under 100ms, dead-letter replay, the acreage cascade with WhatsApp callback, a
timed restore drill, a security pass on every webhook. Gate: Capture is done
and STATUS says what Act starts from.
