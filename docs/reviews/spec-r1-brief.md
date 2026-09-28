# SPEC.md adversarial review, round 1 — Ahsan's brief

Date: 2026-09-28 · Author: Ahsan (verbatim, filed per PROCESS.md §10 A1) ·
Document under review: `docs/SPEC.md` v0.9 · Plan: `docs/reviews/spec-r1-plan.md` ·
Findings: `docs/reviews/spec-r1.md`

The review must read `docs/SPEC.md` Appendix A.6 (disagreement register index)
first, per `docs/STATUS.md`. Nothing in this review edits SPEC.md.

## Step 1 — review plan only

Write `docs/reviews/spec-r1-plan.md` and stop for Ahsan's approval.

The plan must:

(a) Assign these lenses to 7 reviewer agents, each reading SPEC.md as that
    person and asking "what would make me reject, ignore, game, or be hurt by
    this?":

    R1 Field: Sales Officer in the field (low connectivity, Urdu, time per
       visit), call-centre agent, grower on the receiving end.
    R2 Sales leadership: RSM, Zonal Sales Manager, Head of Sales — targets,
       visibility, incentive gaming, what they'd report upward, adoption
       mandate.
    R3 Marketing: Head of Marketing, Campaign Manager — segmentation, campaign
       attribution, messaging consent, measurement of campaign ROI.
    R4 Product: Digital Product Leader — problem/value fit, success metrics,
       scope creep, adoption and change management, what makes this fail in
       month 3.
    R5 Trust: data and consent, security, privacy/legal compliance (Pakistan),
       audit trail, data retention.
    R6 Build: delivery feasibility, agronomy correctness, testability of every
       acceptance sentence, contradictions with docs/reference canvas v2.0.
    R7 Open lens: whatever R1–R6 miss (see b).

(b) List every angle NOT covered by R1–R6 — other stakeholders (e.g. IT,
    finance, dealers, support/ops, Syngenta global), and cross-cutting
    concerns (failure modes, edge cases, scale, cost, localisation,
    accessibility, operability, reversibility, dependencies, ambiguity).
    Assign them to R7 or to the closest reviewer.

(c) A coverage matrix: every numbered requirement × the reviewers who must
    check it. No requirement unreviewed.

## Step 2 — after Ahsan approves

Run the reviewers in parallel, then a skeptic on every finding that tries to
refute it against the quoted SPEC.md line. Deduplicate across lenses.

Output to `docs/reviews/spec-r1.md`, one entry per surviving finding: ID,
lens(es), severity (blocker / major / minor), quoted line, consequence,
proposed fix, skeptic verdict. End with: requirements with zero findings,
D1–D9 touched, and the top 5 findings by severity.

Do not edit SPEC.md.

## Facts the planner needs

- Numbered requirements are the rows `P1-1 … P1-43`, `P2-1 … P2-22`,
  `P3-1 … P3-20`, `P4-1 … P4-30`, `P5-1 … P5-35`, `P6-1 … P6-21`,
  `P7-1 … P7-17` — 188 rows. Every one appears in the coverage matrix.
- Decisions D1–D9 are recorded in `docs/DECISIONS.md`; a finding that
  contradicts a recorded decision is refuted by the skeptic, so the plan
  should point lenses at what a decision leaves *unspecified*, not at the
  decision itself.
- Canvas v2.0 is `docs/reference/01-product-canvas.md`; the spec's
  disagreement registers (DR-1 … DR-31) already record known departures.
- Tier A rules: `docs/PROCESS.md` §9. Invariants: `docs/INVARIANTS.md`.
