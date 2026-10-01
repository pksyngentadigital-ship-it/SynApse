# Triage answers (SYN-11) — Ahsan's decisions, recorded as given

Collected 2026-09-30 to 2026-10-01 by AskUserQuestion, theme by theme. S-numbers are the entries in `docs/reviews/spec-r1.md`. Nothing here is applied to SPEC.md yet. When all rounds are done, the marks go onto the TRIAGE lines in spec-r1.md.

| Entries | Decision | Detail |
|---|---|---|
| S69, S70, S71, S96, S113, S114, S115, S116, S118, S119, S120, S121, S122, S125, S126 | accept | Document hygiene, accepted in chat |
| S1 | accept | Reached only: Contacted and the contact clock stop only when the SUL marks "Reached"; the rate counts reached contacts |
| S4 | accept | Add the missing states and a transition table; a reassigned lead gets fresh clocks, rejected episode stays out of the rate |
| S2 | accept | Device rules go into SPEC as P6-6a |
| S3 | accept | Leaver path with phone-data expiry after N hours unsynced (Ahsan sets N) |
| S21, S103 | accept (unparked 2026-10-01) | One formula in P5-31: of the leads whose deadline fell in the period or that were finished in it, the share finished on time; Closed: unreachable counts as finished; follow-up dates don't count; P1-43 points to it; J14.2, J16.1 and J22.1 add "completed on time" |
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
| S61 | park (confirmed 2026-10-01) | Trigger: Phase 4 — 2G/3G numbers and the DBO device survey become UX acceptance inputs |
| S123 | accept (unparked 2026-10-01) | One SPEC row now: SUL app readable at the phone's largest text size, clear in bright sunlight, usable one-handed, voice typing in text boxes |
| S25 | accept | Flags on a lead (RSM → SUL) or on a territory or region (Head of Sales, ZM, PM → one level down); lead flag answered at the SUL's next action; territory flag when the receiver replies or flags down; flags passed down are linked |
| S26 | accept, widened | Targets per the recommendation, with Ahsan's additions: Admin/DBO enter targets on Head of Sales' recommendation (he does not enter them); targets also for leads converted, sales value and leads followed up; Admin can change the target rules or disable any target parameter. "Behind" measured against targets on manager views only (P2-11 stands). Needs a DECISIONS entry at apply time; check the sales-value target against D7 (no PKR linked to incentives) |
| S27 | accept | RSM/ZM breach digest at 08:00 and 14:00 (Admin settings) with counts by SUL, a push only for a breached Hot contact promise, no pushes 21:00–07:00, the manager above sees when each report last opened the breach list |
| S31 | out of scope (cleared 2026-10-01) | Ahsan: "Synapse is not for managing SULs' own created leads; we may add this at a later stage." Listed in 6.3.2 as out of scope, returning on Ahsan's request |
| S100 | accept, widened | Any weight change, by hand or from a proposal, notifies the same list, and Ahsan adds that all stakeholders are notified |
| S102 | accept | "Year" and "quarter" are calendar periods; a separate "Season" preset for the crop year; weeks run Monday to Sunday |
| S32 | accept, amended | Last campaign wins: the most recent campaign signal before first contact gets the credit (not the reviewer's first-touch); other campaigns listed as "also touched"; channel = the stream that carried the credited campaign |
| S33 | accept | Optional talk-track field on the campaign record, supplied when available |
| S34 | accept | SUL list shows every campaign with open leads (ended ones marked); PMs see campaigns live or active in the period; a signal after the end date still carries the campaign, labelled "after end" |
| S35 | accept, reversed | Hold it: a campaign signal whose campaign cannot be read is held until it is read; P4-11 and the D3 rows change to match (the reviewer proposed routing). Consequence to note at apply time: until D3 is agreed in M5, the Pilot's campaign leads are held |
| S37 | out of scope (cleared 2026-10-01) | Ahsan: "let's not manage cost per lead type things at this stage; we will do later if required." Cost per lead and cost per converted lead move out of J20.2/P3-16 into 6.3.2, returning when Ahsan asks; spend can still be entered on the campaign |
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
| S79 | accept | Threshold compared with total acreage across crops; where only per-crop figures exist, their sum |
| S57 | accept | Pushed no-gap leads within N minutes; pulled streams checked every M minutes (Admin setting per stream), arriving within one check plus N; gap leads arrive at Hina handover; Ahsan sets N and M |
| S62 | accept | During a burst, no-gap leads reach the SUL within N minutes and the app stays as fast as normal; each SUL's leads appear in the order growers acted; Ahsan sets N |
| S66 | accept (unparked 2026-10-01) | After clarification (export = download as spreadsheet): data is incomplete when a connected feed is failing or dashboard figures are older than N hours (Ahsan sets N); the dashboard warning names the cause; downloads stay allowed but the file carries the same warning (P3-8's "export off" changes) |
| N1 | accept, amended | Ahsan: if the grower's earlier scan and Hina call already meet the handover criteria, Hina does not call again; the new lead goes straight to its segment with the latest activity |
| N2 | accept | Two lines: window expiry hands the lead over whatever the attempt count; Synapse works with Hina off |
| N4 | accept | Unmatched no-number messages deleted after N months (Ahsan sets N); Admin "remove" deletes the lead's personal data and keeps only the technical ID that prevents duplicates |
| N5 | accept | Admin setting for the minimum confidence for "buy"; starting value proposed with the S74 test |
| N6 | accept | Weekly WhatsApp summary provided for: sending service and approved template on Connections, staff mobile field, P1-42 names it as the one exception |
| N7 | scope change | Ahsan: village boundaries are not shown to SULs; SULs get a Google map showing their leads with navigation; boundaries may be shown later if required. Boundaries stay server-side for routing. Changes P7-4 ("drawn on the SUL's map") and the offline map budget; needs a DECISIONS entry at apply time |
| N8 | accept | Address service health on Connections; unplaced addresses labelled "no match" or "service unavailable, retrying" |
| N9 | accept, to Phase 3 | Restore requirements (anonymisations stay, audit trail intact, synced phone actions kept) and an uptime target go to the Phase 3 infrastructure document; one SPEC line points there |
| N10 | reject | No group privacy check or IT sign-off dependency added |
| N11 | accept | Franchise name and location are business data (public point of sale) owned by DBO |
| N12 | accept | Every setting gets a minimum and maximum in the spec; a change to Hina's limits applies to leads sent after the change |
| N13 | accept, amended | Ahsan: Hina always calls in Urdu; the record and summary for the SUL are in English and Urdu |
| N14 | accept | One journey line showing a late completion counts as completed, but late |
| N15 | accept | Lead-card rule reworded to "on one screen, without opening another" |
| N16 | accept | P2-16 reworded: period views are on My summary (managers: P3-7) |
| N17 | accept | P4-25 reworded: "takes no opt-out action; the message is scored like any other"; D1 unchanged |
| N18 | accept | J8.2 points to P1-35 and J21.6 (reject as duplicate, Admin merges) |
| N19 | accept | Unsent receipt photos count inside the 150 MB, compressed to fit |
| N20 | accept | Pool-assigned lead takes the chosen SUL's territory; village and BSA optional for pool leads |
| N21 | accept | AR-14 "retried, never dropped" limited to the SUL app; dashboards show a failed action as failed |
| N22 | accept | "By product" means the lead's recommended product, listed as a derived field on the lead |
| N23 | accept | One-line note: channel = stream |
| N24 | accept | Every export carries a definitions sheet or footer for its numbers |
| N25 | accept | Marketing can split campaign figures by last-season status (bands per S112, geography per S104) |
| N26 | accept | A reply to Marketing's own WhatsApp campaign is filed under WhatsApp and credited to the campaign; detail settled with D3 in M5 |
| N27 | accept | One line: Marketing's campaigns use the number its owner names in 4.2; that owner handles opt-out requests outside Synapse; D1 unchanged |
| N28 | accept | Campaign figures show "closed: below threshold" and "closed: unreachable"; definitions page separates below threshold on arrival from closed below threshold later |
| N29 | accept, PLAN change | E-commerce purchase stream gets a build milestone in PLAN.md after the Pilot streams |
| N30 | covered | Answered by the S42 Pilot column; no separate change |
| N31 | accept | Remove the unused "whether they messaged first" field from the WhatsApp stream |
| N32 | reject | Ahsan, on being asked for the name and date: "Leadership via Ahsan" is enough |
| N43 | accept | One line each: the weekly summary is in English; the language setting applies to the SUL app only |
| N44 | accept, at v1.0 | At the v1.0 cut, "How to mark" becomes "every row was approved with its part; changes after v1.0 are change requests"; P1-27 marked R |
| N33 | accept (unparked 2026-10-01) | One neutral line in P6-12: the hosting that meets Pakistan storage is decided in tech.md from Syngenta's recommended stack; no hosting choice made now |
| N34 | reject | No "shared phone" reason; field feedback outside Synapse is enough |
| N35 | accept | Flagged, overdue and due-today leads are never hidden behind "More leads", even past 20; the four old "low scores below the fold" sentences are tidied |
| N36 | accept | Product-row notices go to the PM of that product's portfolio; P4-28 reads "each part of a list has one named owner" |
| N37 | accept | 5.1: a lead is scored on arrival (for Hina's order) and re-scored after Hina |
| N38 | rule change | Ahsan: "if there is no valid number; we won't route and show the lead to SUL; nothing can be done on it; instead this lead will be closed." Confirmed: the lead is closed as "no valid number" and never routed; a later signal from the same grower with a valid number becomes a normal lead carrying the earlier history. Replaces P4-18's "no contact" hold; at apply time reconcile with S12 (Hina wrong number) and N4(a) (deletion of unmatched messages) |
| N40 | accept | Lakh grouping (PKR 12,50,000); calculated amounts rounded half up to whole rupees |
| N41 | accept (unparked 2026-10-01) | The 6.4 D5 row points to P6-12 with the same neutral line (hosting decided in tech.md) |
| N42 | accept, amended | Ahsan: "same english style everywhere; no urdu style." Western digits and English-style dates and times in both languages |
| N39 | accept | A.4 K6 uses "reconciliation view" |
| N3 | accept | Signal.raw marked personal: name and number removed at anonymisation, never in exports |
| S81 | accept | Lead created at once; routing waits at most N seconds for the intent read, then treats intent as unclear; P4-10 wording corrected; Ahsan sets N |

All rounds finished 2026-10-01: every S1–S126 entry and every narrower claim N1–N44 has a decision. Applying them to SPEC.md is a separate step, on Ahsan's go-ahead.

Parked items reviewed 2026-10-01: S21/S103, S66, S123, N33 and N41 decided; S31 and S37 cleared as out of scope (6.3.2); only S61 stays parked, to Phase 4 by Ahsan's choice. N9 (restore and uptime) goes to the Phase 3 infrastructure document as accepted.
