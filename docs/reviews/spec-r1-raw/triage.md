# Triage answers (SYN-11) — Ahsan's decisions, recorded as given

Collected 2026-09-30 by AskUserQuestion, theme by theme. S-numbers are the entries in `docs/reviews/spec-r1.md`. Nothing here is applied to SPEC.md yet. When all rounds are done, the marks go onto the TRIAGE lines in spec-r1.md.

| Entries | Decision | Detail |
|---|---|---|
| S69, S70, S71, S96, S113, S114, S115, S116, S118, S119, S120, S121, S122, S125, S126 | accept | Document hygiene, accepted in chat |
| S1 | accept | Reached only: Contacted and the contact clock stop only when the SUL marks "Reached"; the rate counts reached contacts |
| S4 | accept | Add the missing states and a transition table; a reassigned lead gets fresh clocks, rejected episode stays out of the rate |
| S2 | accept | Device rules go into SPEC as P6-6a |
| S3 | accept | Leaver path with phone-data expiry after N hours unsynced (Ahsan sets N) |
| S21, S103 | park | Trigger: before the M8 build of the dashboards and rate (Act scope) |
| S5, S6, S82 | accept | Phone time: clocks start on phone receipt and stop at the phone's logged time; a synced on-time action withdraws the breach notice; a server re-score never overrides an SUL outcome |
| S17, S18, S19, S30 | accept | All four closure and gaming fixes; Admin alone still sets settings |
| S28, S29, S95 | accept | New leads only; a move up restarts clocks under the new promise, a move down keeps earlier due times |
| S7, S124 | accept | Holiday list: Admin keeps yearly pause days that clocks also skip; working week defined once; changes logged (amends 5.10 Q13) |
| S39, S40, S41, S44, S106 | accept | Outcome measure against a pre-go-live baseline, plain list = arrival order among contacted leads, signal-to-first-contact time, monthly summary contents, previous-period comparison; Ahsan sets targets |
| S42, S43, S45, S22, S101 | accept | Pilot column in A.1 plus a Pilot section: zones named before M8, training, last sync to RSMs, exit and Wave 2 gate (no duplicate of Phase 9), D2 fallback, SUL headcount, "not live" zones; Ahsan marks Pilot rows |
| S23, S24, S72, S80, S85, S86 | accept | Human moves only: Admin moves open leads on the RSM's request, logged; territory SUL optional; no-location lead goes to Hina first; bulk re-place after a bad boundary file; queues show oldest item and alert |
| S11, S55, S56, S58 | accept | One wrong-number path; Admin merge with a surviving record, logged and undoable; a typed number matching a grower with a different name or village held as a possible match; a written match rule; "verified" defined in one line; keeps D4 |
| S59, S60, S83, S117 | accept | Ambiguous or coarse addresses go to the pool with candidates; franchise change swept through 5.3, 5.9, 6.4 and 6.3.1 (Ahsan picks the serviceability test); confirm-location action with history; name the held list |
| S8, S9, S10, S73, S98, S99, S97, S77, S20 | accept | All SUL-app fixes, including the receipt duplicate check and RSM sampling |
| S15 | accept | Cross-script name and village search; Hina summary in Urdu and English; flag notes, talk tracks, product names shown as written and marked |
| S16 | accept | The tab holds this season's leads from last-season growers (P1-17 matched to P5-19) |
| S76, S105 | accept | Status = converted if any lead converted that crop year, else latest outcome; tab appears from the first season start after go-live |
| S13, S14 | accept | Fuller call-centre form and an agent role. Ahsan's words: "call center is the part of DBO; and DBO team looks after it" — so the agent access sits with DBO (see S51) rather than as a separate stakeholder |
| S61 | park | Trigger: Phase 4 — 2G/3G numbers and the DBO device survey become UX acceptance inputs |
| S123 | park | Trigger: Phase 4 — accessibility becomes a UX acceptance input |
| S25, S26, S27, S31, S100, S102 | one by one, later | Ahsan asked for these to be explained and asked one at a time once all rounds are done |
| S32–S38, S104, S107, S91 | one by one, later | Ahsan asked for these to be split and asked one at a time once all rounds are done |
| S46, S47, S89, S93, S12, S87, S84, S111 | one by one, later | Hina and third parties |
| S48–S54, S88, S90, S108–S110 | one by one, later | Security and privacy |
| S63–S65, S74, S75, S78, S92, S94, S67, S68, S112 | one by one, later | Scoring and agronomy |
| S79 | accept | Threshold compared with total acreage across crops; where only per-crop figures exist, their sum |
| S57, S62, S66, S81 | one by one, later | Build testability |
| Narrower claims N1–N13 (2.1) | one by one, later | |
| Narrower claims N14–N44 (2.2) | one by one, later | |

Grouped rounds finished 2026-09-30. One-by-one queue, in order: managers (S25, S26, S27, S31, S100, S102) · Marketing (S32–S38, S104, S107, S91) · Hina and third parties (S12, S46, S47, S84, S87, S89, S93, S111) · security and privacy (S48–S54, S88, S90, S108–S110) · scoring (S63–S65, S67, S68, S74, S75, S78, S92, S94, S112) · testability (S57, S62, S66, S81) · N1–N44.

Still to ask (old list, superseded by the queue above): SUL app; managers; Marketing; Hina and third parties; security and privacy; scoring; testability; the 44 narrower claims; park triggers.
