# Resume state — SPEC.md adversarial review r1 (SYN-11)

Updated 2026-09-29. **Fable 5.1 work is finished and logged. Nothing is in flight. Everything below the cut-off runs on Opus 5.5, at Ahsan's instruction.**

## Branch and files
- Branch `pksyngentadigital/syn-11-session-22-adversarial-review-of-specmd-round-1`. Commit 996e1ab holds the brief and the approved plan.
- Committed in 0fe7a9e, not yet pushed, all in `docs/reviews/spec-r1-raw/`: R1.md … R7.md (raw lens reports, 208 findings), merges.md, verdicts.md, STATE.md.
- `docs/SPEC.md` has not been edited and must not be.

## The cut-off
| Work | Model |
|---|---|
| Plan, seven lens reviewers, merge list | Fable 5.1 (lens reviewers are pinned to Opus-class in `.claude/agents/lens-reviewer.md`) |
| Skeptics on R1, R2, R3, R4, R5, R6 and on F-R7-2, 3, 5, 6, 7, 9, 11 | Fable 5.1 |
| Skeptics on F-R7-12 … F-R7-34 (23 findings) | **Opus 5.5** |
| Writing `docs/reviews/spec-r1.md` | **Opus 5.5** |

`.claude/agents/skeptic.md` has `model: inherit`, so the skeptics follow the session model. No agent file needs editing.

**Process note.** PROCESS.md §8 assigns document-review skeptics to the strongest model. Running the last 23 on Opus 5.5 is Ahsan's decision (usage limits stopped the run four times). The triage file must say which findings were judged on which model. PROCESS.md §8 also says a model change is a new session, not a mid-conversation switch: start a fresh session and read this file.

## Status of verdicts
`verdicts.md` is the source of truth: one row per finding, verdict, one-line reason, narrower claim. Count the rows; do not trust any tally quoted in chat.

Counted 2026-09-29 after the last Fable skeptic landed: **166 rows, 123 SURVIVES, 43 REFUTED, no duplicate IDs.** Every finding in R1 to R6 has a row or is merged (see merges.md). R7 rows logged: F-R7-2, 3, 5, 6, 7, 9, 11. 166 logged + 23 to run = 189 distinct claims.

## Opus 5.5 progress (2026-09-29, second session)
All 23 Opus 5.5 skeptics (F-R7-12 to F-R7-34) have landed and are logged. Counted after the last one: **189 rows, 136 SURVIVES, 53 REFUTED, no duplicate IDs, no finding without a row or a merge.** Of the 23: 13 SURVIVES, 10 REFUTED.

`docs/reviews/spec-r1.md` is written (Opus 5.5): 126 surviving entries after deduplication (4 blocker, 92 major, 30 minor), 44 narrower claims from refuted findings with triage lines, 8 more carried inside surviving entries, 27 rows with zero findings. Committed and pushed on this branch.

**Triage done (2026-10-01).** Ahsan's decisions on all 126 entries and 44 narrower claims are in `docs/reviews/spec-r1-raw/triage.md` (collected by AskUserQuestion). Several answers change earlier decisions and need DECISIONS entries when applied (S26, S35, S54, S107, N7, N38, the DBO role in S51).

**Next:** on Ahsan's go-ahead, apply triage.md to SPEC.md (separate session, with the v1.0 bump). `/pr` and `/close` only when he says so.

## Still to run (Opus 5.5)
F-R7-12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34.
(F-R7-1, 4, 8, 10, 35 are merged into other findings; see merges.md.)

One skeptic per finding, at most 20 concurrent. Prompt, with k replaced:

"Task SYN-11. Refute finding F-R7-k in docs/reviews/spec-r1-raw/R7.md against docs/SPEC.md. Also read docs/reviews/spec-r1-plan.md §0 (rules 2 and 3: a finding that argues against a recorded decision D1–D9, or merely restates a disagreement register entry DR-1…DR-33, is refuted), docs/DECISIONS.md and docs/INVARIANTS.md. Report in your output format."

Append each verdict to verdicts.md in the existing row format as it lands.

## Then write docs/reviews/spec-r1.md
Follow the brief (`docs/reviews/spec-r1-brief.md`, Step 2) and the `/adversarial-review` §4 template.

1. **Header.** Date, lenses, findings raised (208), distinct claims after merges, survived, refuted, which model judged what.
2. **Surviving findings**, one entry each: ID, lens(es) including merged lenses from merges.md, severity (blocker / major / minor), quoted line, consequence, proposed fix, skeptic verdict with its caveats, and the TRIAGE line `( ) accept ( ) reject — reason: ( ) park — trigger:`. Take claim, quote, consequence and fix from the raw lens file; take verdict and caveats from verdicts.md.
   - Where the skeptic corrected the finding (overstated consequence, wrong label, fix that needs Ahsan's decision), carry the correction into the entry. Do not reproduce a sentence the skeptic showed to be false.
   - Where the skeptic questioned severity, state the filed severity and the skeptic's view; do not silently regrade.
   - Deduplicate across lenses: findings that survive on the same defect and the same rows become one entry listing every lens. Candidates flagged by skeptics: F-R1-11 + F-R4-5's narrower claim · F-R6-1 + F-R6-25 (one edit to P4-3) · F-R6-13 + F-R6-26 · F-R6-14 + F-R6-16 · F-R6-3 + F-R6-37 · F-R6-7 + F-R6-41 · F-R6-4 + F-R6-23 + F-R6-27 (Part 7 landed without sweeping earlier parts) · F-R5-18 + F-R7-22 (retention bounds) · F-R6-15's language half into F-R1-20 · F-R5-3 + F-R7-12 (Hina script) · F-R6-47 + F-R6-48 + F-R6-49 (state model) · F-R7-6 + F-R4-3 with merged F-R7-4 (same out-of-hours scenario, different defect; check before merging) · F-R7-11 data-handling half against R5 findings on seam S18 · F-R6-65 Hina-inbound half against F-R7-11.
3. **Narrower claims from refuted findings.** A refuted finding stays refuted. Where its skeptic recorded a narrower claim worth acting on, list it in its own section with the parent ID, so Ahsan can accept it as a smaller item. Several are substantive: F-R5-16 (Signal.raw unmarked PII), F-R5-17 (no-contact signals never expire; Admin "removal" undefined), F-R6-10 (no intent-confidence cut-off), F-R6-20 (no provision for the outbound weekly WhatsApp), F-R4-13 / F-R6-38 (window expiry is not literally a Hina handover trigger; Synapse-without-Hina unstated), F-R1-13 (no per-grower cap on Hina calls across leads), F-R4-15 (no go-live readiness gate; merge into F-R4-9), F-R7-2 (address conversion has no health line on Connections; "no match" and "service unavailable" not told apart in P7-17), F-R7-7 (what a restore must preserve: P6-11 anonymisations, P6-15 audit trail, synced phone actions; no availability target; carry to INFRA.md).
4. **Refuted, and why.** One line each: ID, claim, which of the four refutations killed it. A refuted canonical finding refutes the findings merged into it (F-R4-13 → F-R6-51, F-R7-1).
5. **Coverage.** Per lens: attacks attempted and what came back empty (from each raw file's ledger). What the review did not look at. Plan defects found on the way: §3.6 says R3 is required on 31 rows, §11 lists 25; R7-A4 repeats "six promises"; the plan said "PECA s.20-class" where the unsubscribe clause is s.25.
6. **Requirements with zero findings.** All 189 numbered rows (P1-1 … P7-17 plus P4-27a) minus every row cited in the "Rows" field of a surviving finding.
7. **D1–D9 touched.** For each decision, the surviving findings whose "Decision check" names it, and what each says the decision leaves unspecified.
8. **Top 5 by severity.** Surviving blockers first, then the majors with the widest consequence. Surviving blockers so far: F-R2-1, F-R5-12, F-R5-13, F-R6-47.

Hand-over message per the skill's Step 5, then stop. Ahsan triages in the file. Applying findings and the v1.0 bump are a separate session.

## After the file is written
Commit the raw folder and spec-r1.md on this branch. Open the PR with `/pr` ("Closes SYN-11"; docs-only, Review line "Ahsan read it"). Then `/close`.
