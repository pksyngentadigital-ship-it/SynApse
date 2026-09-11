---
description: Generate a new source connector from the template. One connector, one folder, one PR.
---

# /add-connector <name>

You have nine sources. Nine hand-written connectors fail nine different ways;
one template audited once fails one way, fixed once. **Never hand-write a
connector because it "seemed simple".**

## Preconditions

- `packages/connectors/_template/` exists
- A Linear issue exists for this connector
- The source is listed in `docs/reference/01-product-canvas.md` §Zone 01, and
  you have read its row: method, signals, and what it feeds

## Generate

Copy `packages/connectors/_template/` to `packages/connectors/<name>/` and wire:

1. **Ingress** — the webhook handler or the poller with its watermark, per the
   canvas row for this source.
2. **Signature verification**, for any webhook. An unverified webhook is not
   done.
3. **Schema mapping** — source payload → `LeadEvent` from `packages/schema`.
   The connector knows about its source; **nothing downstream knows this source
   exists** (rule A2).
4. **Idempotency key** — the `sourceEventId` for this source, enforced by the
   database constraint, not a code check (rule A4, INV-3).
5. **Contract test** with a **real recorded payload** saved as a fixture, with
   every identifier and phone number replaced by synthetic values (PROCESS.md
   §12).
6. **A replay test** — the same event twice produces one lead (INV-3).
7. **An isolation test** — this connector failing does not stop another
   connector or the queue (INV-9).
8. **Health entry** so the connector appears on the connector-health page with
   last event received and last error.
9. **`.env.example` entries** for every credential this connector needs,
   documented. Never the values.

## Verify against the template

After generating, diff `packages/connectors/<name>/` against `_template/` and
report what is genuinely source-specific versus what drifted from the template.
Template drift is a finding: either the template should change, or this
connector should not have.

## Finish

Route through `/pr`. Connectors touch ingestion and identity, so they are
keystones — the keystone review applies.
