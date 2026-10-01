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
| S25 | accept | Flags on a lead (RSM → SUL) or on a territory or region (Head of Sales, ZM, PM → one level down); lead flag answered at the SUL's next action; territory flag when the receiver replies or flags down; flags passed down are linked |
| S26 | accept, widened | Targets per the recommendation, with Ahsan's additions: Admin/DBO enter targets on Head of Sales' recommendation (he does not enter them); targets also for leads converted, sales value and leads followed up; Admin can change the target rules or disable any target parameter. "Behind" measured against targets on manager views only (P2-11 stands). Needs a DECISIONS entry at apply time; check the sales-value target against D7 (no PKR linked to incentives) |
| S27 | accept | RSM/ZM breach digest at 08:00 and 14:00 (Admin settings) with counts by SUL, a push only for a breached Hot contact promise, no pushes 21:00–07:00, the manager above sees when each report last opened the breach list |
| S31 | park | Ahsan: "Synapse is not for managing SULs' own created leads; we may add this at a later stage." Trigger: if SUL-created or walk-in leads are added |
| S100 | accept, widened | Any weight change, by hand or from a proposal, notifies the same list, and Ahsan adds that all stakeholders are notified |
| S102 | accept | "Year" and "quarter" are calendar periods; a separate "Season" preset for the crop year; weeks run Monday to Sunday |
| S32 | accept, amended | Last campaign wins: the most recent campaign signal before first contact gets the credit (not the reviewer's first-touch); other campaigns listed as "also touched"; channel = the stream that carried the credited campaign |
| S33 | accept | Optional talk-track field on the campaign record, supplied when available |
| S34 | accept | SUL list shows every campaign with open leads (ended ones marked); PMs see campaigns live or active in the period; a signal after the end date still carries the campaign, labelled "after end" |
| S35 | accept, reversed | Hold it: a campaign signal whose campaign cannot be read is held until it is read; P4-11 and the D3 rows change to match (the reviewer proposed routing). Consequence to note at apply time: until D3 is agreed in M5, the Pilot's campaign leads are held |
| S37 | park + scope change | Ahsan: "let's not manage cost per lead type things at this stage; we will do later if required." Cost per lead and cost per converted lead move out of J20.2/P3-16 into 6.3.2, returning when Ahsan asks; spend can still be entered on the campaign |
| S36 | accept, reframed | After Ahsan's question (answered: "unknown" means the signal carries no readable campaign ID): Admin releases held campaign-unknown signals in one action once readable, each carrying its campaign; Marketing sees a count held per campaign stream |
| S38 | legal action, no SPEC row | Record as a Syngenta Legal check that the Facebook and TikTok form privacy notices cover follow-up by staff and by Hina; not a SPEC row |
| S107 | accept, amended | Ahsan: "there could be one or multiple campaigns running at a time; either it's NPI or just a brand campaign; we are just tagging if it's NPI." The Pilot allows one or more campaigns, NPI being a tag. Changes the 2026-09-11 "one NPI campaign" wording, so it needs a DECISIONS entry and a DR at apply time |
| S91 | accept, amended | Ahsan: no inventory threshold. All not-converted reasons are logged and reported to all stakeholders (counts by area); no alert |
| S12 | accept | Hina "wrong number" ends her attempts and the lead goes to the no-contact list; "refused" ends her attempts and the lead routes marked "Grower refused Hina's call, <date>" |
| S46 | accept, amended | Ahsan: no disclosure concern. What Hina says is controlled and approved by Marketing for campaign leads, and by Admin/DBO for non-campaign leads; approved version recorded, and they can stop it. No required disclosure line |
| S47 | accept | Vendor register in Admin: what each third party receives, where and how long it keeps it, signed processing agreement (Legal signs; recordings deleted within N days); no connection goes live without its entry |
| S87 | accept | Failure over one hour alerts the digital team's on-call contact at any hour; each third party's escalation contact and response time recorded on Connections |
| S89 | accept | Hina connection records vendor name, calls per day, time to first attempt, storage and retention, deletion on anonymisation, and an exit: Admin can turn Hina off and held leads route at once |
| S84 | accept | After a plain-language explanation: every inbound feed, Hina's included, must carry a valid signature or is rejected and counted on Connections; key storage goes to Phase 3 INFRA.md; "rotated by Admin" dropped |
| S93 | reject | Budgets are managed outside Synapse |
| S111 | accept | Hina's summary has a maximum length Ahsan sets; longer ones rejected and logged; structured answers unaffected |
| S49 | reject | Keep receipt capture from both gallery and camera |
| S50 | accept | Retention range 1–3 seasons; preview of growers affected before saving; a shorter period applies from the next season start and can be reverted until then; Admin alone decides |
| S51 | accept | Own "dbo" role: sales structure and village-to-BSA, daily lists, targets on Head of Sales' recommendation (S26), non-campaign Hina scripts (S46), call-centre access (S13/S14); no settings, exports, number undo, removals or audit trail. Needs a DECISIONS entry (eight personas) |
| S52 | reject | Ahsan: Admin manages all role changes, additions and removals, based on the communications received; no periodic review. (The canvas's access review stays dropped; whether to note it in the DR register is open for apply time) |
| S53 | accept | One audit list used everywhere, adding role, scope and active changes, merges, reassignments, removals and match confirmations; user accounts keep a change history |
| S88 | accept, as fact | Ahsan confirms every field SUL and RSM has a Syngenta email; state it in SPEC as a fact (no fallback needed) |
| S90 | accept | Ahsan: "we just need an evidence of sale in shape of receipts; no need to go into prices." Receipts are evidence only; prices never extracted, reported or used; franchisees told receipts are photographed; Legal confirms before the Pilot |
| S54 | accept, narrow | After clarification: RSMs see a grower's number only on overdue, flagged or pool leads. Changes Ahsan's 18 Sept "full card for RSM is fine", so it needs a DECISIONS entry at apply time |
| S108 | accept, amended | Consent per lead. Ahsan adds: "any incoming lead will be considered with the consent done; no need to keep and manage the consent separately." Confirmed reading: consent = the incoming contact, auto-stamped (stream and date) on every lead; no manual consent management; INV-1 holds |
| S63 | accept, deferred detail | The builder proposes the points-per-level table (including missing severity and age origin) during the build, for Ahsan's approval; SPEC records that the table is required |
| S64 | accept | Weights saved only when they total 100; final score clamped to 0–100 |
| S67 | accept | A purchase never creates a lead: timeline, history score, re-scores an open lead; streams read "9 lead streams + 1 purchase stream" |
| S68 | accept | Connections shows learning-example counts by outcome and intent examples per week; P4-12 gets a timeline example; P6-18 lists each screen's question or drops the phrase |
| S74 | accept | Intent reading tested before the Pilot on anonymised real messages labelled by the field, split by language, with accuracy and "unclear" bars Ahsan sets; gate in M4 |
| S75 | accept | Timing table gets a zone (or province) column; missing zone falls back to the national row |
| S78 | reject | Ahsan: "SULs should allow off label recommendations." No registration check on product suggestions |
| S92 | accept, amended | PMs own and approve the agronomy (treats list and timing table); DBO manages if required. No separate agronomy lead |
| S94 | accept | A season-start change applies from the next season; existing tags kept; tabs and retention use each lead's creation season |
| S112 | accept | Band edges one Admin setting (starting: under threshold · threshold–49 · 50–99 · 100+); bands already in anonymised records stay as written |
| S65 | accept | Three largest positive contributions plus the largest penalty over 10 points; fixed Urdu/English sentence per level with values filled in; Marketing or Admin owns the wording |
| S109 | accept | Keep the pull; orders from buyers who are not confirmed growers at or above the threshold are discarded on arrival, never stored or logged |
| S110 | accept | P4-27 and P6-10 read "only what the streams, Hina and the SUL gave, and coordinates converted from a given address" |
| S48 | accept | Mailbox confirmation link plus IT's list; minimum password length and mailbox reset; lockout after 5 failures; session limits (app incl. offline, portal); second factor for Admin; Ahsan sets numbers |
| S104 | accept, amended | Marketing and PMs both keep the zone → region → territory drill; nothing finer than territory (no village-level counts or exports) |
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
