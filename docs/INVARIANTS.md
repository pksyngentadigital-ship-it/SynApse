# Synapse invariants

Statements of what must never be true. Reviews gate on these. Tests cite them by
ID. Most serious defects in a "feature-complete, all-green" system are
violations of one of these — the happy path was tested, and the happy path was
fine.

| ID | Invariant |
|----|-----------|
| **INV-1** | A grower is never contacted without a recorded consent basis. |
| **INV-2** | A verified mobile number maps to at most one grower, unless an officer explicitly split it — and the split is recorded. |
| **INV-3** | A source event is never counted twice. Replaying the same `sourceEventId` never creates a second lead; it merges into the existing one. |
| **INV-4** | A lead is never tiered Hot without stated intent AND known acreage. |
| **INV-5** | A lead never changes lifecycle state except through a defined transition. |
| **INV-6** | A converted lead always carries a value, a SKU, and the officer who closed it. |
| **INV-7** | A user never sees a lead outside their hierarchy scope. |
| **INV-8** | A score never exists without an engine version hash and a factor breakdown. |
| **INV-9** | One connector failing never blocks another connector or the queue. |

## How these are used

- **In tests.** A test that guards an invariant names it in its title or a
  comment: `INV-3: replaying a sourceEventId creates no second lead`.
- **In PR descriptions.** The "Invariants touched" line lists the IDs. A PR
  touching an invariant with no test citing it is incomplete.
- **In reviews.** The reviewer agent reads this file first and reports any
  invariant at risk, by ID, with the line of code.
- **In the database where possible.** An invariant enforced by a constraint
  cannot be forgotten by a future screen. See `docs/reference/02-build-playbook.md`
  §Day-one rules: INV-3 is a unique constraint (A4), INV-1 is a NOT NULL column
  (A6), INV-7 is a query-layer function (A8).

## Changing this file

An invariant is added or changed only through a dated entry in
`docs/DECISIONS.md` explaining why. Never edited silently. An invariant that
turns out to be wrong is a significant finding, not a typo.
