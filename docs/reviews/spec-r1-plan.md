# SPEC.md adversarial review — round 1 attack plan

Date: 2026-09-28 · Document: `docs/SPEC.md` **v0.9** (seven parts + Appendix, approved by Ahsan 2026-09-21 and 2026-09-28) · Round: **1 of max 2** (PROCESS.md §9, Tier A) · Brief: `docs/reviews/spec-r1-brief.md` · Findings go to: `docs/reviews/spec-r1.md` (Step 2, after Ahsan approves this plan)

This plan designs the review. It reports no findings. Anything the planner noticed while reading is written below as an attack a lens must run, not as a result.

## 0. Rules every lens follows

1. **Read Appendix A.6 first**, then the decision tables (1.7, 2.5, 3.5, 4.6, 5.9, 6.4, 7.4), then `docs/DECISIONS.md` entries dated 2026-09-15 to 2026-09-28. Then read only the sections your lens lists.
2. **Decisions D1–D9 are settled.** A finding that argues against a decision is refuted by the skeptic. Attack what the decision *leaves unspecified*: the user path it needs but does not name, the number it needs but does not give, the case it does not cover.
3. **Disagreement registers DR-1 … DR-33 are known.** A finding that restates a DR is refuted. A finding that shows the spec's own position in a DR is *internally* inconsistent, or that a canvas departure has no DR, stands.
4. **Every attack is answered.** Your report ends with an attack ledger: one line per attack (R*n*-A*k*), the rows you read, and either the finding IDs it produced or "attempted — nothing found, because …". PROCESS.md §9: a reviewer that reports "no findings" without saying what it looked for and where has crashed.
5. **Quote verbatim.** Every finding carries the exact line (row ID plus the words). A finding with no quoted line is refuted.
6. **One defect, one finding.** If two lenses would find the same thing, the "must ignore" list says who owns it; the other lens does not file it.
7. **Row count.** The brief says 188 numbered rows. The spec has **189**: the brief's ranges plus `P4-27a` (4.4). All 189 are in the matrix (§6). Also note `P2-22` appears before `P2-21` in 2.4 — R7-A6 owns that.
8. **No lens edits SPEC.md.**

---

## 1. Lens R1 — Field

**1. Persona.** Three people the spec is done *to*: the Sales Unit Lead on a 2 GB Android with one bar of signal, working in Urdu, with perhaps six farm visits in a day; the call-centre agent who has ninety seconds per call; and the grower who scanned a leaf and did not ask to be sold anything. Ask of every row: would I reject this, ignore it, game it, or be hurt by it?

**2. Attacks.**

- **R1-A1 — Break the clock against a field day.** Show a Hot lead that is overdue before the SUL could have seen it. Use P1-39 / P5-27 ("start when the lead reaches the SUL") against J1.1 (counts from "last night's sync") and J9 (offline all day). Decide whether "reaches the SUL" means the server routed it or the phone received it, and show the two readings give different on-time rates. Then run P5-30 (pause on Sundays only, "public holidays count") through Eid (three to four days) and a Friday half-day; find the Hot lead routed the evening before Eid.
- **R1-A2 — Break J3 at the farm.** The sale happens at the franchise, usually after the visit. Find the step in J3.1–J3.3 where the required receipt photo (P1-30, J3.2) does not exist yet, and say what the SUL logs instead: "Follow-up needed" (J3.1), and then the 7-day completion promise (P1-38) runs out while the grower has not bought. Name what the SUL taps on day 7 to stay on time.
- **R1-A3 — Count the taps.** For every outcome in J2–J7, J11 and J13, count the taps on a real screen including the required pick-lists (product, quantity, reason, acreage per crop in J7.2, new/existing). Find each that breaks P2-3 "two taps" and each that P2-3 exempts without saying so. Include the lead card of P1-10 / J2.1 (about fifteen items "without scrolling to another screen") on a 5-inch phone.
- **R1-A4 — Hurt the grower.** Trace one Crop Doctor scan through P5-1 (held for Hina because intent is a gap for every scan) → P5-2 (up to three calls in two days) → J2.2 SUL call → J2.3 SUL WhatsApp. Count the contacts a grower who wanted a diagnosis receives. Then find what happens to the grower who says "band karo" (P4-25) — who calls next, and what the SUL is told to say about how they got the number (P2-7 shows the consent line to the SUL, not to the grower). Then break J8.2 for the family phone: the grower's new number "already belongs to another grower" — the SUL is refused; find the path left to them. Then find where a Hina outcome "wrong number" or "refused" (P5-3) is routed to an SUL anyway (P5-6) and what the SUL is expected to do with it.
- **R1-A5 — Break the call-centre agent's path.** P4-14: find what the agent types, when in the call, how long it takes, and whether the callback case in 4.2 ("or was called back") gives the agent a consent line to read. Find whether the agent ever sees an outcome. Find the "short Synapse form" fields versus what a lead needs to be Hot (P1-14: intent, crop, acreage) — if the form lacks intent, every call-centre lead goes to Hina (P5-1) to be asked again.
- **R1-A6 — Break the language and the phone.** List every string the SUL sees that P2-9 / P6-7 leave in English: product names (pick-list), campaign names, Hina's summary (P5-3 — which language?), village names, reasons (P5-11 says ur and en — on the RSM's card, which?). Then add up what P2-10's 150 MB must hold: every lead card and grower profile in the territory (J9.1), the base map (J13.5), the village boundaries drawn on the map (P7-4), and the receipt photos in the outbox (J9.2, no size limit stated). Find the number that does not fit, or the row that would have to give a limit and does not.

**3. Sections to read.** 1.2 (stakeholder table only), 1.4, 1.5, 1.6; all of Part 2 (2.1–2.4, journeys J1–J13); 4.2 (WhatsApp, call-centre rows), P4-9, P4-14, P4-17, P4-23–P4-25; 5.2 (P5-1–P5-10), P5-11, P5-12, P5-20, P5-30; P6-6–P6-8, P6-18; P7-5, P7-6, P7-10, P7-13. Skip Part 3 except J14.3 and J14.4 (what the SUL sees when flagged).

**4. Evidence.** A named scenario with times ("routed Monday 09:00, phone synced Tuesday 19:00, badge shows overdue at 09:01"); a tap count against a quoted two-tap line; a quoted line that names a required field the field cannot supply at that moment; a pair of quoted lines that give the SUL two different instructions.

**5. Must ignore.** Gaming of the on-time rate (R2-A1 owns; R1 reports only what the field would do *honestly* and still fail). Consent law and platform policy (R5). Whether Hina is affordable (R7-A3). Whether the spec contradicts itself in the abstract (R6-A2) — R1 files a contradiction only if it produces two different instructions on the SUL's screen. Marketing screens (R3).

**6. Rows owned.** See §6; R1 is a required reviewer on 63 rows, mostly Parts 1 and 2 and 5.2.

**7. Seams owned.** S23 (P1-17 vs P5-19: is "Last season" a proactive list or signal-driven?).

---

## 2. Lens R2 — Sales leadership

**1. Persona.** The RSM with eight SULs, the Zonal Sales Manager with three regions, the Head of Sales who must report a number upward every Monday. Targets, visibility, what gets gamed, what they mandate. They are not the SUL; they will use the numbers to manage people whether or not the spec links anything to incentives.

**2. Attacks.**

- **R2-A1 — Game the on-time rate as an SUL would.** For each of these, find the line that permits it and the absent line that would detect it: tap Call and hang up (J2.2 moves to Contacted on dial; P5-27 stops the contact clock); tap "No answer" three times in ten minutes then "Close as unreachable" (J2.4, P1-33 — no spacing rule); tap "Not a valid lead — not my territory" (P5-27 "Rejected stops both"; P1-35 counts rejections per *source*, never per SUL); log 12 acres (P1-22 closes the lead at once; no undo named; the grower is never routed again); log "Converted" with a photo of any receipt (D7 open — attack what it leaves unspecified: who compares receipt to value, P6-14 lets the RSM open the photo but names no check). Then compare J2.2 with J2.4 and P1-28 ("each attempt, successful or not") and say which one the on-time rate believes.
- **R2-A2 — Break the 14-day completion promise on Potential.** P1-38 gives every Crop Doctor scan a completion clock. At P6-9's 1,000 leads a day over the Pilot's two zones, work out completions per SUL per day; then say what an SUL with 80 open scans does on day 13 and which reason from P1-32 they pick. Say what P5-32 / P5-34 learn from a season of "not converted: no need". Find whether "Closed: unreachable" counts as "completed on time" in P5-31 (it stops the clock per P5-27 but is not "Completed").
- **R2-A3 — Break "nothing is reassigned" on what it leaves open.** DR-3 and the 2026-09-15 decision forbid automatic and rule-based reassignment. Find the human path for: an SUL on two weeks' leave; an SUL who resigns holding sixty open leads (P7-11 "open leads stay with their SUL"; P7-2 shows a gap; P1-29 only the owning SUL or Admin can move a lead; P3-4 gives managers only a flag). If Admin can reassign (P1-35 / J21.6 do it for rejected leads only), find the row; if none, name the section where it belongs and what the clocks do on reassignment (P5-27 is silent).
- **R2-A4 — Reject the dashboards.** Find where a manager sets a target or sees a quota, a pipeline value, or a forecast — none of J14–J17 has one; say whether an RSM will manage from a screen with no target. Count the notifications P3-14 / P5-29 send an RSM with eight SULs and forty overdue leads a day, and a ZM who receives every breach in three regions; find the line that stops them switching notifications off. Find what J16's ZM reports upward when the Pilot has two zones and regions are few. Find whether an RSM "phone first" (1.2) can read J14 on the road given P3-20 "nothing is cached for offline use". Find where J22.1 "the one SUL most behind" sits against P2-11 / DR-11.
- **R2-A5 — Break the adoption mandate.** Find the line that makes an SUL open the app when their real sales happen outside it: J12.2 forbids a hand-made lead, P1-30 needs a receipt; an SUL who converts thirty walk-in growers a month looks idle on J14.2. Say what the RSM concludes and what they mandate. Find whether "leads received" (J14.2) is something the SUL controls; find what a good SUL in a territory with few digital growers looks like to their ZM.
- **R2-A6 — Break the settings as levers.** Admin raises the threshold 20 → 25 (P1-19 "from then on"; P5-14 "for new scores"; P5-13 notifies only on a move *up*): find what happens to an SUL's current Hot leads at 22 acres and whether anyone is told. Then find who owns the SLA numbers: P3-16 / J20.3 have Marketing set the contact and completion promises for the sales force, and P3-10 lets Admin change any promise with Head of Sales merely notified — find the sales sign-off, or its absence.

**3. Sections to read.** 1.2 (RSM, ZM, Head of Sales rows), 1.5, 1.6; J2.2, J2.4, J3, J5, J10, J11; all of Part 3 (3.1–3.4, J14–J22); P4-29; 5.4 (P5-20), 5.5 (P5-22–P5-26), 5.6 (P5-27–P5-31), P5-12–P5-14, P5-34; P6-13, P6-14, P6-19; P7-2, P7-8, P7-9, P7-11, P7-17.

**4. Evidence.** A named gaming sequence, each step with the row that allows it; a computed number (completions per SUL per day) from quoted volumes; a quoted line promising a manager something and the absence of the row that delivers it; two quoted lines giving different denominators or different owners for the same number.

**5. Must ignore.** The SUL's honest difficulty (R1). Marketing's attribution (R3). Legal and consent (R5). Whether reassignment is technically feasible (R6). Notification *cost* (R7). Do not re-argue DR-3, DR-4 or DR-11 — attack only their unspecified consequences.

**6. Rows owned.** See §6; R2 is required on 62 rows, concentrated in 1.5, 1.6, Part 3, 5.4–5.7.

**7. Seams owned.** S11 (J2.2 vs J2.4 vs P1-28), S12 (P1-43 vs P5-31 denominators), S14 (P1-41 / P1-29 vs P7-11 / P7-2 vs P1-35 / J21.6), S24 (P5-14 vs P1-19 vs P5-13 on a threshold change), S29 (P2-11 vs J22.1).

---

## 3. Lens R3 — Marketing

**1. Persona.** Head of Marketing and a Campaign Manager who will be asked in March "did the launch spend become sales?" They own the WhatsApp Business number, the Meta and TikTok ad accounts, and the campaign names. They need attribution they can defend, consent they can show Meta, and a number they can put next to spend.

**2. Attacks.**

- **R3-A1 — Break attribution across merged signals.** A grower fills a campaign form on Facebook, then messages WhatsApp two days later; P1-8 makes one lead; A.2 Lead has `stream (first signal's)` and one optional `campaign`. Find the rule that decides which campaign and which channel get the conversion; find the rule when the second signal carries a *different* campaign; find the rule when a Potential lead's grower later responds to a campaign (P1-24 "move up a segment" — into Campaign?). Then find the rule when a campaign lead's grower buys a product other than the campaign's (P3-16 gives a campaign one product; P1-15 groups its leads "by product").
- **R3-A2 — Break the campaign record.** P3-16 and A.2 Campaign hold one `product` and one `crop`; P1-15 says a campaign may be "a full crop programme" with leads grouped by product. NPI is a stream in P1-7 and 4.2 but not a `kind` in A.2 (`brand`, `crop_programme`, plus an `npi` flag). J6.3 shows "its talk track where Marketing supplied one" — find the field in P3-16 / A.2 (there is none listed). J6.1 shows "live" campaigns — find where the leads of a campaign past its end date go on the SUL's phone and on J19.2. D3 is open by decision; attack what that leaves: P4-11 lands the Pilot's one campaign as "campaign unknown" in Hot or Potential — find the row that moves it into Campaign when D3 is agreed, and the row that tells Marketing how many leads were misfiled meanwhile.
- **R3-A3 — Break the ROI numbers.** J20.2 cost per lead: find the denominator — routed only, or also below-threshold (P1-20) and "no contact" (P4-18)? Cost per converted lead uses self-declared PKR (D7 open) — find where the Marketing screen says so (P3-8 says "as of" and count, not "self-declared"). Then find Marketing's geography: 1.2 says Marketing decides "where next season's campaign spend goes"; J20.1 breaks down by portfolio, brand and channel only; P1-4 forbids village, not district or zone — find the row that gives Marketing a zone/region/district cut, or its absence.
- **R3-A4 — Break messaging consent from the marketing side.** P5-9 lets Marketing "run its own WhatsApp campaigns outside Synapse"; a reply arrives as a signal whose consent basis is "WhatsApp message, <date>" (P4-23). Find whether a reply to an outbound blast is "the grower's own contact with Syngenta" (P1-12). Then take P4-25 (STOP is ignored) to the WhatsApp Business / Meta messaging policy the Marketing-owned number is bound by, and to Meta lead-ads terms for form data: find the consequence for the number and the ad account, and the row that would have to say who bears it. Do not argue D1; argue the platform.
- **R3-A5 — Break segmentation.** Find what Marketing can segment next season's spend by: crop, acreage band, district, last-season status. J20.1 has none of these; P5-33 watches "by crop, by acreage band and by district" but for the engine and Leadership. Find whether any aggregate view gives Marketing a crop × acreage band × zone table, and whether P3-9 "aggregate only" export can produce a campaign audience (it cannot name growers — find whether it can name villages, and whether P1-4 forbids that).
- **R3-A6 — Break the summaries.** J22.1 gives each PM "the one brand most behind" by WhatsApp — find the definition of "behind" (P3-2 demands one definition per number). P1-20's "campaign produced 300 below-threshold leads": find whether Marketing can tell a campaign that attracted small farmers from a campaign whose form had no acreage field (P1-21: unknown goes to Hina, not below-threshold) — the two land in different counts with no label saying why.

**3. Sections to read.** 1.2 (Marketing, PM rows), P1-4, P1-7, P1-8, P1-15, P1-18, P1-20, P1-24; J6; 3.1, 3.2 (Marketing analytics, Portfolio dashboard), J19, J20, J22, P3-2, P3-8, P3-9, P3-12, P3-16, P3-17; 4.2 (Facebook, TikTok, NPI, Brand campaign rows), P4-11, P4-23–P4-25, P4-27; P5-9, P5-16, P5-17, P5-28, P5-33; 6.1 Campaign record; A.2 Campaign and Lead.

**4. Evidence.** A named two-signal scenario and the two rows that give it two answers or none; a quoted field list (P3-16 / A.2) against a quoted screen that needs a field not in it; a quoted denominator ambiguity; a platform policy clause named alongside the quoted spec line.

**5. Must ignore.** Pakistan law and the grower's rights (R5 — R3 argues platform policy and marketing consequence only). SUL experience of campaigns (R1). Whether attribution is technically buildable (R6). Do not re-argue D3 or DR-19.

**6. Rows owned.** See §6; R3 is required on 31 rows.

**7. Seams owned.** S15 (P3-16 / A.2 Campaign vs P1-15 / J6.2 / J6.3).

---

## 4. Lens R4 — Product

**1. Persona.** The Digital Product Leader who signs off the Pilot and has to explain in month 3 why SULs stopped opening the app, or why leadership thinks the funnel is the business. Problem/value fit, success metrics, scope, adoption, what kills it.

**2. Attacks.**

- **R4-A1 — Break the value proposition.** The headline number is on-time rate (P1-43), a process metric. Find where the spec ties Synapse to a sales outcome with a baseline (PKR per SUL before/after, conversion of digital leads today). Find the "plain list" that J18.1 / P5-33 compare the engine against — is it defined anywhere (a random order? arrival order? the Smart Agro Lite list?). Say whether top-decile-vs-bottom-decile conversion can be honest when the bottom decile sits under the fold (P5-20) and gets less attention by design.
- **R4-A2 — Model month 3.** Take one SUL in a Pilot zone at P6-9's 1,000 leads a day nationally. Because every Crop Doctor scan lacks stated intent, every one is a gap for P5-1 and waits for Hina; find whether the Pilot's highest-volume stream is 100% Hina-delayed and what P4-3 "within minutes" then means for it. Then estimate the SUL's open Potential count after 90 days with no cap (P1-23) and 14-day completion (P1-38), and say at what count the list stops being worked (the canvas's DR-4 argument, now applied to the spec's own numbers).
- **R4-A3 — Find the scope creep.** List every capability that is in this phase and was not in the canvas or the Pilot definition (1.1): the working map "for understanding and analytics" (P2-20), e-commerce stream (P4-27a), last-season tab (P1-17), follow-up date (P2-21), BSAs and digitised boundaries (Part 7), address geocoding built now (P7-14), Hina (5.2), weekly WhatsApp and monthly email summaries (P3-17, P3-18), reconciliation view and definitions page (P3-2), map pins by category, "no contact" matching by hand (J21.5a). For each, say whether Crop Doctor + WhatsApp + one campaign in two zones needs it, and name the row that would move it to 6.3.2 if not.
- **R4-A4 — Break adoption and change management.** Find the rows on training, rollout order, which two zones, Pilot exit criteria, the Wave 2 gate, who owns adoption, and what an SUL gains (P2-11: no points; no targets; no recognition). Find what an RSM is asked to *do* differently and where the spec says how they learn it. If absent, name the part where they belong.
- **R4-A5 — Test every stakeholder's goal.** For each of the eight rows in the 1.2 table, take the "Goal in one sentence" and find the screen row that answers it *and* the number that says whether it is met. Country Leadership's "whether the engine beats a plain list" and Marketing's "where next season's spend goes" are the two to press hardest.
- **R4-A6 — Walk the critical path.** D2 open (Cropwise access) blocks the Pilot's main stream; 6.4 says "the M2 spike may use WhatsApp instead" — find what the Pilot is without Crop Doctor. D3 open blocks its one campaign. Hina's vendor is unnamed with no SLA (5.2). Boundary files (P7-4) are assumed to exist. Geocoder choice pending (P7-14). Call-centre platform unknown (P4-14). A.1 marks the SUL app "Post-Capture" while the Pilot needs it. For each, find the row that says what ships without it, or name the gap.

**3. Sections to read.** 1.1, 1.2, 1.4 (P1-13–P1-26), P1-43; 2.1, 2.2, P2-1, P2-11, P2-20, P2-21; 3.1, 3.2, J18, P3-1, P3-2, P3-6, P3-18; 4.1, P4-1–P4-3, P4-12, P4-13, P4-27a; 5.1, P5-1, P5-5, P5-15, P5-24, P5-31, P5-33, P5-34, 5.8; 6.2 (P6-9, P6-18, P6-21), 6.3, 6.4; A.1 milestone column (skim), A.3.

**4. Evidence.** A computed count from quoted volumes and promises; a quoted stakeholder goal with no row that answers it; a quoted capability with no Pilot stream that needs it; a quoted dependency with no fallback row.

**5. Must ignore.** SUL screen detail (R1). Gaming (R2). Attribution mechanics (R3). Law (R5). Whether a thing is buildable (R6) — R4 asks whether it is *needed*. Cost in rupees (R7-A3) — R4 may say "expensive" only as a scope argument.

**6. Rows owned.** See §6; R4 is required on 32 rows.

**7. Seams owned.** S28 (1.1 Pilot definition vs 6.4 D2 "may use WhatsApp instead" vs P4-1; and A.1 "Post-Capture" SUL app vs the Pilot).

---

## 5. Lens R5 — Trust

**1. Persona.** Data protection and consent, security, privacy and legal compliance in Pakistan, audit trail and retention. The person Syngenta Legal and Country IT will send to read this before go-live. D1 and D4 are decided; this lens attacks what they leave open, the third parties, the device, and the audit trail's own integrity.

**2. Attacks.**

- **R5-A1 — Attack what D1 leaves unspecified.** Not "any contact is consent" — decided. Find: (a) signals the grower did not initiate — the call-centre "or was called back" (4.2), replies to Marketing's outbound WhatsApp campaigns (P5-9), DMs to a Facebook ad — and whether P1-12 / P4-23 "the grower's own contact" covers them; (b) Hina's script — disclosure that she is an AI, what she says about where the number came from (P5-2 "Hina decides only how she runs each call"); (c) a Hina outcome "refused" (P5-3) that P5-6 routes to an SUL anyway; (d) P4-25's ignored STOP against PECA 2016 s.20-class unsolicited-communication rules, PTA's regulations on unsolicited calls/messages, the Personal Data Protection Bill's withdrawal-of-consent clause, and Meta's WhatsApp Business messaging policy. For each, quote the spec line and name the missing rule and the section it belongs in.
- **R5-A2 — Break residency and the third parties.** P6-12 "stored in Pakistan" (a Phase 3 hosting rule) against: Hina, a third party — P5-3 says no recording *enters Synapse*, not that none exists; P7-14 sends address text (personal data per P7-13) to "an outside mapping service"; the monthly page by email (P3-18); the weekly summary through WhatsApp/Meta (P3-17, no grower named but SUL and territory names); Cropwise global tenant (D2). Find a processor/DPA requirement or a "where the third party keeps it" row; find who signs it. Also: the D5 stack is AWS (DECISIONS 2026-09-11); AWS has no Pakistan region — R5 files only the *rule* gap (P6-12 has no fallback), R7-A3 files the cost.
- **R5-A3 — Break the device and the login.** 2.1: "the SUL's own Android phone" holds every lead and grower in the territory offline (P2-8, P6-6). Find encryption at rest, app lock, remote wipe on P2-17 (territory change) and on offboarding, the lost-phone procedure, the screenshot risk on J14.3. Find password rules, MFA, session length for P6-16 (email + Synapse password, SSO deferred by decision — attack what that leaves: no rule at all). Find the offboarding row: who deactivates (IT or Admin, P1-6 / J21.1), and what purges the phone.
- **R5-A4 — Break the audit trail against retention.** P6-15: "nothing in the audit trail can be edited or deleted". P6-11: after two seasons the name, number, location and receipts are removed. A.2 Grower carries a change history of old and new numbers; Audit entries record a number change and its undo; Hina call `summary` is PII; receipts are photos. Find the rule that anonymises inside an append-only trail, or the contradiction. Then find retention for: audit entries, held signals (P4-5), the "no contact" list (P4-18 — a name and village with no number, held how long?), rejected leads, below-threshold growers who never get a lead (P4-26 — "keep a profile" indefinitely?), receipt photos as finance evidence (R7-A2 files the finance side; R5 files the data side).
- **R5-A5 — Break access and roles.** P1-5: Admin is "the digital team on its own login". P6-17 / P7-15 / 4.5: DBO edits the sales structure "in the Admin portal" and works the below-threshold, no-contact, rejected and pool lists. A.2 User roles: sul, rsm, zm, head_of_sales, leadership, pm, marketing, admin — no DBO. Find who DBO logs in as and whether that breaks P1-5. Find the access-review row (canvas Z00 has one; the spec — find it). Find whether Admin's undo of a number change (P4-17) is itself an audit entry. Find the limit on an RSM opening any grower's number in the region (P3-3, J14.3 — logged, but no need-to-know rule).
- **R5-A6 — Break identity integrity beyond D4.** DR-13 records the family-phone cost. Find any signal that detects a merge in error (Hina "wrong number", a name mismatch on a scan) and any counter that feeds the un-park trigger ("the field reports shared-number growers merged in error"). Then P1-35 / J21.6: Admin "merges" a rejected duplicate — find the merge rule when both growers have numbers (P4-16: one number one grower; P4-17: a number on another grower "cannot be saved") and who chooses which history survives. Then read INVARIANTS.md INV-2 ("unless an officer explicitly split it — and the split is recorded") against 6.3.2 "no split": find whether INVARIANTS.md needs a dated DECISIONS entry (INVARIANTS.md: "never edited silently").

**3. Sections to read.** 1.2 table, P1-1, P1-2, P1-5, P1-6, P1-8, P1-9, P1-12, P1-20–P1-22, P1-35, P1-36; 2.1, P2-8, P2-12, P2-13, P2-17, P2-19; P3-3, P3-9, P3-10, P3-12, P3-13, P3-17, P3-18, J14.3, J21.1, J21.6, J21.8, J22; all of 4.2–4.5 (P4-8, P4-16–P4-27a especially), 4.8; P5-3, P5-7, P5-8, P5-9, P5-32, P5-35; all of 6.1, P6-3, P6-10–P6-17, 6.3.2, 6.3.4 (AR-1–AR-5, AR-18); P7-10, P7-12–P7-16; A.2, A.3.

**4. Evidence.** A quoted spec line plus the named statute, regulation or platform policy clause it meets; two quoted lines that cannot both hold (append-only vs removal); a quoted role list against a quoted duty with no role; a named scenario (lost phone, resigned SUL) with the absent row named.

**5. Must ignore.** Whether D1 or D4 were right (decided). The grower's *experience* of being called (R1-A4). Marketing's platform-account consequences (R3-A4 — R5 files the legal side only, R3 the commercial side). Cost of DPAs and hosting (R7). Testability wording (R6-A1).

**6. Rows owned.** See §6; R5 is required on 68 rows.

**7. Seams owned.** S16 (P4-23 / P1-12 vs 4.2 call-back and P5-9 outbound), S17 (P6-11 vs P6-15 / A.2 histories), S18 (P6-12 vs P7-14, P5-3, P3-17, P3-18), S19 (P1-5 vs P6-17 / P7-15 vs A.2 User), S31 (P1-35 / J21.6 merge vs P4-16 / P4-17).

---

## 6. Lens R6 — Build

**1. Persona.** The engineer and the agronomist who must turn every row into a test, a migration or a screen, and the reviewer who checks the spec against canvas v2.0. Testability of every acceptance sentence, delivery feasibility, agronomic correctness, internal contradiction, undeclared canvas departures.

**2. Attacks.**

- **R6-A1 — Testability sweep.** For every row in Parts 4–7 and 6.2 whose "What you would see" is "—", a bare cross-reference, or contains an unmeasured word, write the missing number or name it untestable. Named targets: P4-3 "within minutes"; P4-19 "only when it is clear"; P7-5 "records how sure the conversion is" (no threshold for route vs pool); the 5.3 serviceability adjustment "within serviceable range" (the range lived on the franchise list of the 2026-09-21 decision; P7-3 replaced that list with name + coordinate and no range); P2-10 "usable on 2G/3G"; P6-9 "slows nothing the SUL sees"; P5-3 "short plain-words summary"; P5-11 "plain words"; P5-32 "Nothing visible" against P6-21 "proven by something Ahsan can watch"; P1-14 "clear purchase intent" (three examples, no rule — "asked for the nearest franchise" to buy what?).
- **R6-A2 — Contradiction sweep (R6 owns these seams).** Check each pair and file only where both lines are quoted: P1-2 ("or by an automated WhatsApp message under the rules in Part 5") vs P5-9 (none in phase 1); P1-42 (no WhatsApp to staff) vs P3-17 / J22 (weekly WhatsApp to managers); 1.7 and 2.5 decision tables (D1 "Open", D4 "Open", "a split action exists for shared numbers (Part 4)") vs 4.6 / 6.4 (decided, no split); P1-3 ("every territory has exactly one SUL") vs P7-2 / J14.5 (gaps); P4-3 ("within minutes") vs P5-24 / P5-1 (routed after Hina); P1-7 / P4-1 ("nine") vs 4.2 and A.2 Signal ("the ten in 4.2"); 6.3.1 ("franchise list and serviceability" built after Capture) vs A.1 P5-25 / P7-3 ("Capture: M3"); A.1 "Came from (as written)" column vs the body (P6-16 A.1 says "keep SSO", body says SSO out); 1.5 diagram (Rejected → Admin review) vs P1-27 (eight states, Rejected absent — a rejected lead Admin reassigns re-enters as what?); P1-43 "÷ leads due" vs P5-31 "÷ leads that reached the SUL"; P5-20 order (flagged, then due) vs P2-2 (due first, flagged above) vs P1-23 (score, due first).
- **R6-A3 — Feasibility.** Digitised village boundaries for Punjab and Sindh (P7-4): find the row that says they exist, who supplies them, in what format and licence, and what the Pilot does if they arrive late — or file the assumption. Geocoding "Chak 12, tehsil Sahiwal" (P7-6 example): Chak numbers repeat across tehsils — find the disambiguation rule. Hina throughput: P6-9's 10,000-lead burst, most with an acreage gap, × P5-2's three attempts in two days — find any capacity row. P4-9 intent reading in regional and transliterated Urdu with no accuracy target or sample-test row (canvas flagged it as the risk). P2-10 (see R1-A6 for the 150 MB sum — R6 files the technical finding, R1 the field consequence). Android 9+ against the field's actual phones — find the survey row.
- **R6-A4 — Agronomy correctness.** The 5.3 "Crop need" scale reads severity and confidence from Crop Doctor — check the 4.2 Crop Doctor row lists both and find whether Cropwise actually returns severity. Season timing by "months" per crop and problem with no sowing date or region (P6-13 one crop-year season; DR-30 notes the field runs Kharif and Rabi) — find what "last season's status" means for a grower who buys in both. P1-25 puts a healthy 40-acre scan in Potential — find what the SUL is expected to sell and whether the crop-need ingredient scores it "healthy or preventive" while P1-38 gives it a 14-day completion clock. P2-7 "Suggested: <product> for <problem>" from a Product record of `treats (crop, problem)` — find any registration/label check (a product recommended for a crop it is not registered for in Pakistan is a regulatory exposure; R5 files the legal side if R6 finds the gap). Acreage "per crop" (J7.2, A.2) against a threshold applied to what — total or per crop (P1-19, P1-22 do not say).
- **R6-A5 — Sequencing and state.** Order of hold-for-Hina → pool → score → route across P5-1, P5-5, P5-23, P5-24, P7-6 (a location gap: does it go to Hina first or the pool first? both rows claim it). Hina connection down: P5-5 "two days after arrival at most" — find the rule when Hina never answers Synapse (AR-25 claims the hold is bounded; find what bounds it). A rejected lead Admin reassigns (J21.6): which state, do clocks restart (P5-27 "Rejected stops both"). J9.3 "server's version wins": list what server-side changes can touch a lead only the SUL or Admin may move (P1-29) — Hina hand-back, re-score, Admin reassignment, threshold change — and what "wins" means for each. P7-10 "unless an SUL has confirmed the location": find the confirm-location action in 2.2 modules or the Act-and-log list (none listed). A threshold change: P5-14 "for new scores" vs P1-19 "from then on" — which existing leads are re-segmented, when (P5-13 daily re-score for age?).
- **R6-A6 — Canvas departures with no DR.** Walk canvas v2.0 L1–L9, Z00 and Z04 and list each rule the spec drops or changes that has no DR-*n*. Candidates to test: unreachable after **two** attempts (canvas L8) vs three (P1-33); "Unreachable → nurture, returns to the pool, re-scored on the next signal" vs "Closed" (P1-33, P1-34); CNIC as secondary key (L3); farm geometry; opt-in status read from WhatsApp (L1); model monitoring — lift, drift, score distribution over time (Z00) vs P5-33 (lift only); access review surfaced in admin (Z00); per-source credentials in a vault and webhook signature verification (L2; A.3 is silent); "Hot fills the cap before High-Potential" (gone with the cap — DR-4 covers the cap, not the fill order); "SLA compliance before linking to incentives" (kept, 3.5 D7 — confirm); "agronomy team owns the severity and window tables" (L4) vs Marketing owns the timing table (5.3, 4.7 q12). File only departures with no DR; for each, propose the DR text.

**3. Sections to read.** All of Parts 1, 4, 5, 6, 7 and the Appendix (A.1–A.3, A.6). Part 2: 2.2, 2.4, J2, J7, J9. Part 3: P3-2, P3-10, P3-11, P3-16, P3-17, P3-19, J21. Canvas: all. INVARIANTS.md: all.

**4. Evidence.** Two quoted lines that cannot both be true; a quoted acceptance sentence and the test that cannot be written from it; a quoted canvas rule and the absence of a DR; a quoted agronomic claim and the source row that does not supply the datum it needs.

**5. Must ignore.** Whether a rule is *wanted* (R4). Gaming (R2). Law (R5). The field's experience (R1) — R6 files the contradiction, R1 the two-instructions-on-screen consequence. Cost, operations and document numbering (R7). Do not re-argue any DR.

**6. Rows owned.** See §6; R6 is required on 121 rows — the largest slice, because testability applies everywhere.

**7. Seams owned.** S1, S2, S3, S4, S5, S6, S7, S8, S10, S13, S20, S21, S22, S25, S26, S32.

---

## 7. Lens R7 — Open lens

**1. Persona.** Everyone R1–R6 do not speak for, and every cross-cutting concern: IT, finance, dealers and franchisees, support and operations (DBO), Syngenta global, the Hina vendor, the call-centre owner, the agronomy team as an owner; and failure modes, edge cases, scale, cost, localisation, accessibility, operability, reversibility, dependencies, ambiguity, document integrity. R7 reads §8 (the uncovered-angles list) as its brief.

**2. Attacks.**

- **R7-A1 — Operability and failure modes.** For each of these, find the row that says what happens, or name its absence: Hina down for a week; the geocoder down; a wrong boundary file loaded and rolled back (P7-16 "previous version kept" — and the leads placed in between?); WhatsApp provider outage → P4-5 held signals — and the clocks, which start at routing (after the backlog clears, so the on-time rate is flattered); P6-9 burst at 10,000 with DBO's daily hand-matching of "no contact" (J21.5a) and pool lists; support 9–6 weekdays (P6-17) against 24/7 clocks with a Sunday-only pause; backups, restore, uptime, incident handling, on-call for the third parties — none appears; find the section they belong in.
- **R7-A2 — The stakeholders not in the eight.** IT: accounts without SSO, offboarding, security review, whether field SULs *have* a Syngenta email (P1-6). Finance: D7 open — what it leaves: receipts as sales/tax evidence versus P6-11 deletion, spend and budget in the Campaign record with no approval, P3-2's reconciliation view with no sign-off owner, P6-5 whole rupees on screen vs CLAUDE.md paisa in storage (A.2 covers storage — confirm every PKR display rule). Dealers/franchisees (Naya Savera): their receipts photographed (J3.2) showing their prices; P1-32 "no stock at the franchise" captured but surfaced to no trade view; franchise coordinates held as structure data (P7-3) with no owner consent; D6 open — what it leaves: the SUL who sells around the franchise. Syngenta global: Cropwise tenant (D2), group privacy standard, brand rules for an AI voice calling growers in Syngenta's name. Hina's vendor: no name, SLA, capacity, data-handling or exit clause (5.2). The call-centre platform owner (P4-14). The agronomy team: canvas L4 gives it the severity and window tables; the spec gives the timing table to Marketing (5.3) — find who in Syngenta Pakistan owns agronomic truth.
- **R7-A3 — Cost.** Find any budget or unit-cost row. Then estimate: Hina calls (P5-2 attempts × the share of leads with a gap × P6-9 volume); geocoding per lead (P7-5); WhatsApp BSP messages (P3-17 weekly to every manager); push; hosting in Pakistan under an AWS default stack with no Pakistan region (P6-12, D5) — name the choice this forces and the row that must record it. R7 files the cost; R5 files the residency rule gap.
- **R7-A4 — Reversibility.** For every Admin setting in A.2 Settings (threshold, six promises, weights, age floor, adjustment sizes, cap km, fold, Hina attempts and days, season start, retention seasons): find what happens to existing leads, scores, clocks and growers on change and on revert. Press hardest on: retention shortened (mass anonymisation at once, irreversible — P6-11); season start moved (every "last season" tag — P6-13, P1-26); a promise shortened (every open lead overdue at once? P3-10 "take effect at once"); Hina attempts reduced while calls are in flight.
- **R7-A5 — Localisation and accessibility.** Urdu script on Android (RTL layout, font fallback for grower words in Sindhi or Punjabi shown "as sent", P2-9); the Hyderabad zone's growers and SULs (Sindhi) with a Urdu/English app and regional languages deferred (6.3.2); numerals and dates in Urdu locale vs "Mon 25th" (P2-5); English-only manager screens (P6-7) for RSMs who are "phone first"; sunlight, one-handed use, older SULs, literacy, no voice input; Pakistani working week (Friday, Eid) — R1-A1 files the clock consequence, R7 the localisation rule gap.
- **R7-A6 — Document integrity, naming and ambiguity.** P2-22 before P2-21; P4-27a outside the brief's count; A.6 index stops at DR-31 while 7.6 has DR-32 and DR-33; DR-21 repeats DR-13; 2.6 question 10 before 6; "Zonal Manager" vs "Zonal Sales Manager"; "Hina" used in P1-21 before Part 5 defines her; **"phase 1" / "phase 2"** (5.2, 5.8, 6.3.2, 4.2, P4-24) against the 2026-09-11 naming decision ("Phase" means a delivery phase 0–11 and nothing else; rollout is Pilot / Wave 2 / Wave 3) — find every use and say what a builder reading "phase 2" would look up; rows still without a Mark (the header says every row needs R / W / A before it is treated as decided — count the empty Mark cells and say whether v0.9 "approved" covers them); any "ASSUMPTION" label still standing; A.1's claim that its "Came from" column is verbatim (R6-A2 checks content; R7 checks the claim).

**3. Sections to read.** Header block, 1.1, 1.2 table; 2.1, P2-9, P2-10, P2-17; 3.2 (Admin portal, weekly summary), J21, J22, P3-15, P3-20; 4.1, 4.5, P4-1, P4-5, P4-13, P4-14, P4-15, P4-18, P4-28; 5.2, 5.8, P5-2, P5-5, P5-8, P5-14, P5-25, P5-29; all of 6.1–6.5; all of Part 7; A.2 Settings, A.3, A.6–A.9; DECISIONS.md naming entry (2026-09-11) and D5 entry.

**4. Evidence.** A named stakeholder and the quoted line that affects them with no row giving them a voice or a view; a named failure with no row for it; a computed cost from quoted numbers; a quoted setting and the absent rule for its change; a quoted naming use against the quoted DECISIONS rule.

**5. Must ignore.** Everything with a named owner in R1–R6. In particular: consent law (R5), gaming (R2), attribution (R3), contradictions between rows (R6-A2), scope (R4). R7 may *hand* a lens a finding it stumbles on by naming the lens in its ledger; it does not file it.

**6. Rows owned.** See §6; R7 is required on 58 rows, mostly Parts 6 and 7 and every row with a setting, a third party or an owner.

**7. Seams owned.** S9 (A.6 vs 7.6), S27 (P6-7 vs J14.3 / P5-11), S30 (DECISIONS naming vs spec "phase 1/2").

---

## 8. Section (b) — angles not covered by R1–R6, and who takes them

| # | Angle | Why R1–R6 miss it | Assigned to |
|---|---|---|---|
| B1 | Country IT and Syngenta global IT: accounts, no SSO, offboarding, security review, Syngenta email for field SULs | No lens is IT | R7-A2; login/device rules R5-A3 |
| B2 | Finance: D7's unspecified consequences, receipts as evidence vs deletion, budgets/spend, reconciliation sign-off, PKR display | No lens is finance | R7-A2 (finance side); R5-A4 (data side) |
| B3 | Dealers / Naya Savera franchisees: receipts photographed, "no stock" reason surfaced nowhere, franchise coordinates, D6's unspecified consequences | Not a persona; not a user | R7-A2 |
| B4 | Support / operations (DBO): daily lists at scale, support hours vs 24/7 clocks, runbooks, backups, incidents, DBO's login | R5 takes the access question only | R7-A1 (ops), R5-A5 (access) |
| B5 | Syngenta global: Cropwise tenant, group privacy standard, brand and AI-voice policy | No lens speaks for HQ | R7-A2; residency R5-A2 |
| B6 | Hina's vendor: SLA, capacity, data handling, exit, script control | Third party, no persona | R7-A2 (contract/capacity), R5-A1 (script/consent), R6-A3 (throughput) |
| B7 | Call-centre platform owner | R1 takes the agent, not the owner | R7-A2 |
| B8 | Agronomy team as an owner (canvas L4) vs Marketing owning the timing table | R6 checks correctness, not ownership | R7-A2; R6-A6 files the canvas departure |
| B9 | Failure modes: Hina down, geocoder down, bad boundary file, provider outage, queue backlog flattering clocks | R6-A5 takes Hina-down sequencing only | R7-A1 |
| B10 | Edge cases: coordinate outside Pakistan, Chak-number ambiguity, grower scanning away from the farm, two growers one phone, SUL with no Syngenta email | Scattered | R6-A3/A5 (geo), R5-A6 (identity), R1-A4 (family phone), R7-A2 (email) |
| B11 | Scale: 10,000-lead burst on DBO's manual lists, RSM pool size, notification volume | R2-A4 takes notifications | R7-A1; R2-A4 |
| B12 | Cost: Hina, geocoding, BSP, hosting in Pakistan on an AWS default | No lens prices anything | R7-A3 |
| B13 | Localisation: Urdu RTL, Sindhi in the Hyderabad zone, numerals, English-only manager screens | R1 takes the SUL's strings only | R7-A5; R1-A6 |
| B14 | Accessibility: literacy, sunlight, one-handed, older users, no voice input | Nobody | R7-A5 |
| B15 | Operability: uptime, backup, restore, monitoring, on-call | Nobody | R7-A1 |
| B16 | Reversibility of every Admin setting; anonymisation and season-start as one-way doors | R2-A6 takes the threshold only | R7-A4 |
| B17 | Dependencies and the critical path (D2, D3, boundary files, geocoder, Hina, call-centre platform, SUL app "Post-Capture") | R6 checks feasibility, not sequencing | R4-A6; R7-A2 for the third parties |
| B18 | Ambiguity of terms: "clear", "sure", "reaches the SUL", "serviceable range", "short", "plain" | R6-A1 takes testability of Parts 4–7 and 6.2 | R6-A1 (Parts 4–7, 6.2); R1-A1 ("reaches the SUL"); R7-A6 (naming and "phase") |
| B19 | Document integrity: numbering, index drift, Mark column, ASSUMPTION labels, A.1's verbatim claim | Nobody | R7-A6 (R6-A2 for content drift) |
| B20 | Grower as data subject: rights of access, correction, deletion on request | R5-A1 covers withdrawal; access/correction rights not otherwise covered | R5-A1 (add: find the row for a grower asking what is held about them) |
| B21 | Regulatory exposure of product recommendation (registration/label) | R6 finds the agronomic gap | R6-A4 finds it; R5 files the legal consequence if found |
| B22 | Competitive/commercial confidentiality: dealer prices on receipts, campaign spend visible to whom | Nobody | R7-A2 (dealers), R3-A6 (spend visibility) |

---

## 9. Findings format (every lens, every finding)

```
### F-R<lens>-<n> — <one-line title>
Severity: blocker | major | minor
Rows: <P?-? / J?.? / section>            (every row the finding touches; these feed the "zero findings" list)
Attack: R<lens>-A<k>
Quoted line: "<verbatim, the row ID and the sentence; two sentences at most>"
Second line (if a contradiction): "<verbatim>"
Consequence: <who is hurt, what number is wrong, or what a builder following the line would build>
Evidence: contradiction | named scenario | absent rule (name the section it belongs in) | external clause (name it)
Proposed fix: <the replacement sentence or new row, written in the spec's voice, with a suggested row ID>
Decision check: none | touches D<n> — what it leaves unspecified is: <…>
DR check: none | DR-<n> records the departure, and this finding is about <the unspecified consequence / the internal inconsistency>, not the departure
```

**Severity.** *Blocker*: a builder following the line would break an invariant, break Pakistani law or a platform policy, or build the wrong product for the Pilot. *Major*: a wrong or ungameable-versus-gameable number visible to a stakeholder, an untestable acceptance sentence on a Pilot row, a missing user path a decided rule needs, or a contradiction that yields two behaviours. *Minor*: wording, numbering, index drift, or a gap with no behaviour consequence in the Pilot.

**Ledger.** After the findings, the attack ledger (§0 rule 4): `R<lens>-A<k> · rows read: … · result: F-… | attempted — nothing found because …`.

**Step 2 will add** the skeptic verdict per finding, deduplicate across lenses (the "must ignore" lists decide the owner), and end with: rows with zero findings, D1–D9 touched, top five by severity.

---

## 10. Seams — pairs of sections checked against each other

| Seam | Section A | Section B | What to check | Owner |
|---|---|---|---|---|
| S1 | 1.2 P1-2 | 5.2 P5-9 | Automated WhatsApp to growers: allowed "under the rules in Part 5" vs none in phase 1 | R6 |
| S2 | 1.6 P1-42 | 3.4 P3-17, J22 | No WhatsApp to staff vs weekly WhatsApp summary to managers | R6 (R5 checks the content that leaves) |
| S3 | 1.7, 2.5 | 4.6, 6.4 | D1/D4 state; "a split action exists for shared numbers" vs no split | R6 |
| S4 | 1.2 P1-3 | 7.1 P7-2, J14.5 | "Exactly one SUL" vs territories shown as gaps | R6 (R2-A3 takes the consequence) |
| S5 | 4.3 P4-3 | 5.2 P5-1, 5.5 P5-24 | "Within minutes" vs routed after Hina | R6 |
| S6 | 1.3 P1-7, 4.3 P4-1 | 4.2 table, A.2 Signal | Nine streams vs ten | R6 |
| S7 | 6.3.1 | A.1 milestones | Franchise/serviceability "after Capture" vs "Capture: M3"; SUL app "Post-Capture" vs Pilot | R6 (R4-A6 takes the Pilot consequence) |
| S8 | A.1 "Came from (as written)" | Body rows | Verbatim claim vs drift (P6-16 and any other) | R6 |
| S9 | A.6 index | 7.6 | DR-32, DR-33 missing from the index | R7 |
| S10 | 1.5 diagram | P1-27, J21.6 | Rejected state and re-entry after Admin review | R6 |
| S11 | J2.2 | J2.4, P1-28 | Contacted on dial vs no-answer stays; what stops the contact clock | R2 |
| S12 | 1.6 P1-43 | 5.6 P5-31 | "÷ leads due" vs "÷ leads that reached the SUL"; Closed counted as completed? | R2 |
| S13 | 5.2 P5-1, P5-5 | 7.2 P7-6, 5.5 P5-23 | Location gap: Hina first or pool first | R6 |
| S14 | P1-41, P1-29 | P7-11, P7-2, P1-35, J21.6 | No reassignment vs leads of a departed SUL vs Admin reassigning rejected leads | R2 |
| S15 | P3-16, A.2 Campaign | P1-15, J6.2, J6.3 | One product per campaign vs grouped by product; talk track field | R3 |
| S16 | P4-23, P1-12 | 4.2 call-centre "called back", P5-9 | "Grower's own contact" vs outbound-initiated signals | R5 |
| S17 | P6-11 | P6-15, A.2 histories | Removal vs append-only audit | R5 |
| S18 | P6-12 | P7-14, P5-3, P3-17, P3-18 | Stored in Pakistan vs outside geocoder, Hina, Meta, email | R5 |
| S19 | P1-5 | P6-17, P7-15, A.2 User | Admin = digital team vs DBO editing in the Admin portal, no DBO role | R5 |
| S20 | P2-10 | J13.5, P7-4, J9.2 | 150 MB vs base map + boundaries + photo outbox | R6 |
| S21 | 5.3 serviceability | P7-3, DECISIONS 2026-09-21 | "Serviceable range" after the range-bearing list was replaced | R6 |
| S22 | P1-19, P1-22 | J7.2, A.2 acreage list | Threshold on total or per-crop acreage | R6 |
| S23 | P1-17 | P5-19 | "Last season" tab: proactive list or signal-driven | R1 |
| S24 | P5-14 | P1-19, P5-13 | Threshold change: existing leads, and who is told on a move down | R2 |
| S25 | P7-10 | 2.2 modules, Act-and-log | SUL-confirmed location with no action to confirm it | R6 |
| S26 | P1-25, P4-12 | P1-21, P5-1, DECISIONS D9 | Healthy scan + unknown acreage: no lead, or Hina asks first? | R6 |
| S27 | P6-7 | J14.3, P5-11 | English-only manager screens vs a lead card with ur/en reasons | R7 |
| S28 | 1.1 Pilot | 6.4 D2, P4-1 | Pilot without Crop Doctor if D2 stays open | R4 |
| S29 | P2-11 | J22.1 | No leaderboards vs "the one SUL most behind" to the RSM | R2 |
| S30 | DECISIONS 2026-09-11 naming | 5.2, 5.8, 6.3.2, P4-24 | "phase 1 / phase 2" vs "Phase = delivery phase only" | R7 |
| S31 | P1-35, J21.6 | P4-16, P4-17 | Admin "merges" two numbered growers under one-number-one-grower | R5 |
| S32 | P5-27 | J21.6 | Clocks after Admin reassigns a rejected lead | R6 |

---

## 11. Coverage matrix — every numbered requirement × reviewers who must check it

189 rows (brief's 188 + P4-27a). Journeys J1–J22 are covered through the rows that cite them and the seams above; they are not separate matrix rows. "Attacks" names where the row is pressed; a reviewer listed without an attack reference checks the row under their A1 (R6-A1 testability, R5-A1 consent, etc.).

| Row | Reviewers | Attacks |
|---|---|---|
| P1-1 | R2, R5, R6 | R5-A5, R6-A1 |
| P1-2 | R1, R5, R6 | R1-A4, R6-A2 (S1) |
| P1-3 | R2, R6, R7 | R2-A3, R6-A2 (S4), R7-A1 |
| P1-4 | R3, R5 | R3-A3, R3-A5, R5-A5 |
| P1-5 | R5, R7 | R5-A5 (S19), R7-A2 |
| P1-6 | R5, R7 | R5-A3, R7-A2 |
| P1-7 | R3, R6 | R3-A2, R6-A2 (S6) |
| P1-8 | R3, R5, R6 | R3-A1, R5-A6, R6-A5 |
| P1-9 | R5, R6 | R6-A1 |
| P1-10 | R1, R6 | R1-A3, R6-A1 |
| P1-11 | R1, R6 | R1-A6, R6-A4 |
| P1-12 | R1, R5 | R1-A4, R5-A1 (S16) |
| P1-13 | R1, R4 | R1-A3, R4-A2 |
| P1-14 | R1, R2, R6 | R1-A5, R2-A1, R6-A1 |
| P1-15 | R1, R3 | R1-A3, R3-A2 (S15) |
| P1-16 | R1, R4 | R1-A4, R4-A2 |
| P1-17 | R1, R2, R6 | R1 (S23), R2-A5, R6-A5 |
| P1-18 | R2, R3 | R2-A4, R3-A1 |
| P1-19 | R2, R6, R7 | R2-A6 (S24), R6-A4 (S22), R7-A4 |
| P1-20 | R2, R3, R5 | R2-A1, R3-A3, R3-A6, R5-A4 |
| P1-21 | R1, R5, R6 | R1-A4, R5-A1, R6-A5 (S26) |
| P1-22 | R1, R2, R5 | R1-A4, R2-A1, R5-A6 |
| P1-23 | R1, R4 | R1-A3, R4-A2 |
| P1-24 | R1, R3, R6 | R1-A4, R3-A1, R6-A5 |
| P1-25 | R4, R6 | R4-A2, R6-A4 (S26) |
| P1-26 | R1, R6, R7 | R1-A6, R6-A4, R7-A4 |
| P1-27 | R2, R6 | R2-A1, R6-A2 (S10) |
| P1-28 | R1, R2, R6 | R1-A3, R2-A1 (S11), R6-A5 |
| P1-29 | R2, R6 | R2-A3 (S14), R6-A5 |
| P1-30 | R1, R2, R7 | R1-A2, R2-A1, R7-A2 |
| P1-31 | R2, R7 | R2-A1, R7-A2 |
| P1-32 | R1, R6, R7 | R1-A3, R2-A2, R6-A4, R7-A2 |
| P1-33 | R1, R2, R6 | R1-A4, R2-A1, R6-A6 |
| P1-34 | R1, R6 | R1-A4, R6-A5 |
| P1-35 | R2, R5, R6 | R2-A1, R5-A6 (S31), R6-A2 (S10) |
| P1-36 | R5 | R5-A4, R5-A5 |
| P1-37 | R2, R6 | R2-A1, R6-A1 |
| P1-38 | R1, R2, R3 | R1-A2, R2-A2, R2-A6, R3-A2 |
| P1-39 | R1, R2, R6 | R1-A1, R2-A1, R6-A1 |
| P1-40 | R1, R2 | R1-A1, R2-A4 |
| P1-41 | R1, R2, R7 | R1-A1, R2-A3 (S14), R2-A4, R7-A1 |
| P1-42 | R1, R6 | R1-A6, R6-A2 (S2) |
| P1-43 | R2, R4, R6 | R2-A1 (S12), R4-A1, R6-A1 |
| P2-1 | R1, R4 | R1-A3, R4-A3 |
| P2-2 | R1, R6 | R1-A3, R6-A2 |
| P2-3 | R1, R6 | R1-A3, R6-A1 |
| P2-4 | R1, R6, R7 | R1-A6, R6-A1, R7-A5 |
| P2-5 | R1, R7 | R1-A1, R7-A5 |
| P2-6 | R1, R6 | R1-A6, R6-A4 |
| P2-7 | R1, R5, R6 | R1-A4, R5-A1, R6-A4 |
| P2-8 | R1, R5, R6 | R1-A6, R5-A3, R6-A3 (S20) |
| P2-9 | R1, R7 | R1-A6, R7-A5 |
| P2-10 | R1, R6, R7 | R1-A6, R6-A3 (S20), R7-A5 |
| P2-11 | R1, R2 | R1-A3, R2-A4 (S29), R4-A4 |
| P2-12 | R1, R5 | R1-A3, R5-A3 |
| P2-13 | R1, R5 | R1-A3, R5-A5 |
| P2-14 | R2, R6 | R2-A1, R6-A1 |
| P2-15 | R1, R2 | R1-A1, R2-A4 |
| P2-16 | R1, R6 | R1-A3, R6-A1 |
| P2-17 | R5, R6, R7 | R5-A3, R6-A5, R7-A1 |
| P2-18 | R1 | R1-A3, R1-A4 |
| P2-19 | R1, R5 | R1-A4, R5-A1 |
| P2-20 | R1, R4, R6 | R1-A6, R4-A3, R6-A3 |
| P2-21 | R1, R2, R6 | R1-A2, R2-A2, R6-A5 |
| P2-22 | R6, R7 | R6-A1, R7-A6 |
| P3-1 | R2, R4 | R2-A4, R4-A5 |
| P3-2 | R3, R6, R7 | R3-A6, R6-A1, R7-A2 |
| P3-3 | R2, R5 | R2-A4, R5-A5 |
| P3-4 | R2, R6 | R2-A3, R2-A4, R6-A1 |
| P3-5 | R2 | R2-A1 (S12) |
| P3-6 | R2, R4 | R2-A4, R4-A5 |
| P3-7 | R2, R6 | R2-A4, R6-A1 |
| P3-8 | R2, R3, R6 | R2-A4, R3-A3, R6-A1 |
| P3-9 | R3, R5 | R3-A5, R5-A3 |
| P3-10 | R2, R5, R7 | R2-A6, R5-A5, R7-A4 |
| P3-11 | R2, R6, R7 | R2-A3, R6-A5 (S13), R7-A1 |
| P3-12 | R3, R5 | R3-A3, R5-A4 |
| P3-13 | R5 | R5-A4, R5-A5 |
| P3-14 | R2, R7 | R2-A4, R7-A1 |
| P3-15 | R6, R7 | R6-A1, R7-A1 |
| P3-16 | R2, R3, R6 | R2-A6, R3-A2 (S15), R6-A1 |
| P3-17 | R2, R5, R6 | R2-A4, R5-A2 (S18), R6-A2 (S2) |
| P3-18 | R4, R5 | R4-A5, R5-A2 (S18) |
| P3-19 | R2, R6, R7 | R2-A3, R6-A5, R7-A4 |
| P3-20 | R2, R7 | R2-A4, R7-A5 |
| P4-1 | R4, R6, R7 | R4-A6 (S28), R6-A2 (S6), R7-A1 |
| P4-2 | R1, R4 | R1-A5, R4-A3 |
| P4-3 | R1, R4, R6 | R1-A1, R4-A2, R6-A2 (S5) |
| P4-4 | R3, R6 | R3-A1, R6-A1 |
| P4-5 | R6, R7 | R6-A1, R7-A1 |
| P4-6 | R6, R7 | R6-A1, R7-A1 |
| P4-7 | R6 | R6-A1, R6-A5 |
| P4-8 | R5, R6 | R5-A4, R6-A1 |
| P4-9 | R1, R6, R7 | R1-A6, R6-A3, R7-A5 |
| P4-10 | R6 | R6-A2 (S5), R6-A5 |
| P4-11 | R3, R6 | R3-A2, R6-A5 |
| P4-12 | R4, R6 | R4-A2, R6-A4 (S26) |
| P4-13 | R6, R7 | R6-A3, R7-A2 |
| P4-14 | R1, R7 | R1-A5, R7-A2 |
| P4-15 | R6, R7 | R6-A1, R7-A1 |
| P4-16 | R1, R5 | R1-A4, R5-A6 (S31) |
| P4-17 | R1, R5 | R1-A4, R5-A5, R5-A6 |
| P4-18 | R5, R6, R7 | R5-A4, R6-A1, R7-A1 |
| P4-19 | R5, R6, R7 | R5-A6, R6-A1, R7-A1 |
| P4-20 | R5, R6 | R5-A6, R6-A4, R6-A5 |
| P4-21 | R1, R5 | R1-A6, R5-A4 |
| P4-22 | R1, R5 | R1-A3, R5-A4 |
| P4-23 | R1, R3, R5 | R1-A4, R3-A4, R5-A1 (S16) |
| P4-24 | R1, R3, R5 | R1-A4, R3-A4, R5-A1 |
| P4-25 | R1, R3, R5 | R1-A4, R3-A4, R5-A1 |
| P4-26 | R5 | R5-A4 |
| P4-27 | R3, R5 | R3-A5, R5-A4 |
| P4-27a | R4, R5, R6, R7 | R4-A3, R5-A2, R6-A1, R7-A2 |
| P4-28 | R6, R7 | R6-A1, R7-A2 |
| P4-29 | R2, R6 | R2-A3, R6-A5 (S13) |
| P4-30 | R5, R6 | R5-A5, R6-A5 |
| P5-1 | R1, R4, R6 | R1-A4, R1-A5, R4-A2, R6-A5 (S5, S13, S26) |
| P5-2 | R5, R6, R7 | R5-A1, R6-A3, R7-A3, R7-A4 |
| P5-3 | R1, R5, R6 | R1-A4, R1-A6, R5-A1, R5-A2 (S18), R6-A1 |
| P5-4 | R1, R6 | R1-A4, R6-A4 |
| P5-5 | R4, R6, R7 | R4-A2, R6-A5, R7-A1 |
| P5-6 | R1, R5, R6 | R1-A4, R5-A1, R6-A5 |
| P5-7 | R5, R6 | R5-A1, R6-A5 (S26) |
| P5-8 | R5, R7 | R5-A2, R5-A4, R7-A1 |
| P5-9 | R3, R5, R6 | R3-A4, R5-A1 (S16), R6-A2 (S1) |
| P5-10 | R2, R6 | R2-A1, R6-A1 |
| P5-11 | R1, R6, R7 | R1-A6, R6-A1, R7-A5 (S27) |
| P5-12 | R1, R2 | R1-A3, R2-A4 |
| P5-13 | R1, R2, R6 | R1-A1, R2-A6 (S24), R6-A5 |
| P5-14 | R2, R6, R7 | R2-A6 (S24), R6-A5, R7-A4 |
| P5-15 | R4, R6 | R4-A1, R6-A6 |
| P5-16 | R3, R6 | R3-A3, R6-A5 |
| P5-17 | R3, R6 | R3-A1, R3-A2, R6-A1 |
| P5-18 | R2, R6 | R2-A1, R6-A1, R6-A4 |
| P5-19 | R1, R6 | R1 (S23), R6-A5 |
| P5-20 | R1, R4, R6 | R1-A3, R4-A1, R6-A2 |
| P5-21 | R1, R6 | R1-A4, R6-A1 |
| P5-22 | R2, R6 | R2-A3, R6-A5 |
| P5-23 | R2, R6 | R2-A3, R6-A5 (S13) |
| P5-24 | R4, R6 | R4-A2, R6-A2 (S5) |
| P5-25 | R6, R7 | R6-A1 (S21), R6-A2 (S7), R7-A2 |
| P5-26 | R2, R6 | R2-A3, R6-A5 |
| P5-27 | R1, R2, R6 | R1-A1, R2-A1 (S11), R6-A5 (S32) |
| P5-28 | R2, R3, R6 | R2-A6, R3-A2, R6-A1 |
| P5-29 | R2, R7 | R2-A4, R7-A1 |
| P5-30 | R1, R2, R6 | R1-A1, R2-A1, R6-A1 |
| P5-31 | R2, R4, R6 | R2-A1, R2-A2 (S12), R4-A1, R6-A1 |
| P5-32 | R5, R6 | R5-A4, R6-A1 |
| P5-33 | R3, R4, R6 | R3-A5, R4-A1, R6-A6 |
| P5-34 | R2, R4, R6 | R2-A6, R4-A1, R6-A6 |
| P5-35 | R5, R6 | R5-A4, R6-A1 |
| P6-1 | R6 | R6-A1 |
| P6-2 | R6 | R6-A4 |
| P6-3 | R5, R6 | R5-A4, R6-A1 |
| P6-4 | R6, R7 | R6-A1, R7-A1 |
| P6-5 | R6, R7 | R6-A1, R7-A2 |
| P6-6 | R1, R6 | R1-A6, R6-A5 |
| P6-7 | R1, R7 | R1-A6, R7-A5 (S27) |
| P6-8 | R1, R6, R7 | R1-A6, R6-A3, R7-A5 |
| P6-9 | R4, R6, R7 | R4-A2, R6-A3, R7-A1, R7-A3 |
| P6-10 | R5 | R5-A3, R5-A5 |
| P6-11 | R5, R6, R7 | R5-A4 (S17), R6-A5, R7-A4 |
| P6-12 | R5, R7 | R5-A2 (S18), R7-A3 |
| P6-13 | R2, R6, R7 | R2-A2, R6-A4, R7-A4 |
| P6-14 | R2, R5, R7 | R2-A1, R5-A5, R7-A2 |
| P6-15 | R5, R6 | R5-A4 (S17), R6-A1 |
| P6-16 | R5, R7 | R5-A3, R7-A2, R6-A2 (S8) |
| P6-17 | R5, R7 | R5-A5 (S19), R7-A1 |
| P6-18 | R1, R4 | R1-A3, R4-A2 |
| P6-19 | R2, R3 | R2-A4, R3-A3 |
| P6-20 | R6 | R6-A1, R6-A4 |
| P6-21 | R4, R6 | R4-A5, R6-A1 |
| P7-1 | R6, R7 | R6-A3, R7-A6 |
| P7-2 | R2, R6, R7 | R2-A3 (S14), R6-A2 (S4), R7-A1 |
| P7-3 | R6, R7 | R6-A1 (S21), R6-A2 (S7), R7-A2 |
| P7-4 | R1, R6, R7 | R1-A6 (S20), R6-A3, R7-A3 |
| P7-5 | R1, R6 | R1-A1, R6-A1, R6-A3 |
| P7-6 | R1, R6 | R1-A4, R6-A5 (S13) |
| P7-7 | R6 | R6-A3 |
| P7-8 | R2, R6 | R2-A3, R6-A1, R6-A3 |
| P7-9 | R2, R6, R7 | R2-A3, R6-A5, R7-A1 |
| P7-10 | R1, R5, R6 | R1-A4, R5-A4, R6-A5 (S25) |
| P7-11 | R2, R6 | R2-A3 (S14), R6-A5 |
| P7-12 | R5, R6 | R5-A4, R6-A1 |
| P7-13 | R1, R5 | R1-A6, R5-A2 |
| P7-14 | R5, R6, R7 | R5-A2 (S18), R6-A3, R7-A3 |
| P7-15 | R5, R7 | R5-A5 (S19), R7-A2 |
| P7-16 | R6, R7 | R6-A3, R7-A1, R7-A4 |
| P7-17 | R2, R7 | R2-A4, R7-A1 |

**Check.** 189 rows; every row has at least one reviewer; every attack R1-A1 … R7-A6 appears in the matrix at least once; every seam S1–S32 has an owner who is also a reviewer on its rows.

---

## 12. What Ahsan decides now

Approve this plan, or change the lens list / attack list, before Step 2 runs. Nothing in Step 2 edits SPEC.md.
