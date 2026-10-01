# Synapse specification

Version: **v1.0 — 2026-10-01.** All seven parts and the Appendix approved by Ahsan (Parts 1–6 on 2026-09-21, Part 7 on 2026-09-28); the session 2.2 adversarial review applied as Ahsan triaged it (`docs/reviews/spec-r1.md`; decisions in `docs/reviews/spec-r1-raw/triage.md` and `docs/DECISIONS.md` 2026-10-01). Open items are in 6.7. ·
Owner: Ahsan · Tasks: SYN-9 (v0.9), SYN-11 (v1.0)

> **How this document is built.** Seven parts, each written in plain language
> and marked by Ahsan before the next is drafted. A technical appendix follows
> Part 7 and can be skipped. After v1.0, a change to this file is a change
> request (`docs/PROCESS.md` §3), never an edit.
>
> **Inputs, in order of precedence.** `docs/INVARIANTS.md` (nine rules that
> change only through a DECISIONS entry) · Ahsan's product input
> (`docs/notes/spec-input-2026-09-15.md`, `-16.md`, `-17.md`, `-18.md`, `-25.md`) ·
> `docs/reference/01-product-canvas.md` · `docs/notes/base44-audit.md`.
> Where Ahsan's input and the canvas differ, the spec follows Ahsan and
> records the canvas's position in the part's disagreement register.
>
> **Marks.** Every row was approved with its part on the date in the version
> line. An **R** records a row Ahsan marked individually, including every row
> revised from the session 2.2 review (`docs/reviews/spec-r1.md`, decisions in
> `docs/reviews/spec-r1-raw/triage.md`). After v1.0 a change is a change
> request. A value written "set by Ahsan" is open and listed in 6.7.
>
> **Words.** SUL = Sales Unit Lead, the person who works leads in one
> territory. "Routed" = sent to an SUL's phone. "Threshold" = the acreage
> threshold, 20 acres, changeable in Admin. Money is shown in PKR; time in
> Pakistan time. "Phase" always means a delivery phase (0–11); the product
> rolls out as Pilot, Wave 2, Wave 3.

---

## Part 1 — Foundations: who, what a lead is, how it is grouped, how it ends

### 1.1 Purpose

Synapse brings every place a grower shows demand for a Syngenta product into
one place, automatically. A Crop Doctor scan, a conversation with Savera, a
post in the Cropwise community, a WhatsApp message asking a price, a lead form
from a Facebook or TikTok campaign, a call-centre note, a marketing campaign
response: each becomes a lead, attached to one grower record even when the
same grower has spoken through three channels. Every lead is scored, placed in
one of three segments, and sent to the SUL who owns that territory, with a
clock on it. What the SUL logs — contacted, visited, converted with a PKR
value, not converted with a reason — closes the loop: managers see progress by
territory, region and zone; marketing and portfolio managers see which
campaigns and brands produced leads that converted; and the scoring engine
learns which growers actually buy.

**Design principle: no clutter.** Smart Agro Lite gave SULs many sources and
many flags and they did not know which lead to tap. Synapse shows an SUL three
segments and nothing else on the home screen, ranks leads inside each, puts
today's due leads first, and never hides a lead behind a cap. Every manager
sees one level below them, by name, and their own total.

**Pilot and Capture.** The Pilot is the go-live subset (Crop Doctor, WhatsApp
and campaigns — one or more, NPI or brand, NPI being a tag — two zones, the
first scorecard); 6.8 lists what it needs. Capture is the first build scope:
all nine lead streams, the e-commerce purchase stream, and the one-grower
record. This document specifies the whole product; the appendix says what
Capture builds. *Revised 1 Oct (review r1, S107, S113).*

### 1.2 Who uses Synapse — eight stakeholders

| Stakeholder | Goal in one sentence | Where and how | Sees | Can change |
|---|---|---|---|---|
| **Sales Unit Lead (SUL)** | Convert the leads in my territory, in order, without missing one | Phone, in the field, patchy signal, Urdu or English | Own territory's leads in three segments; own summary | Every lead's state and outcome; the grower's acreage and new/existing mark |
| **Regional Sales Manager (RSM)** | Know which SUL is letting leads go cold, and follow up | Phone first | Region's SULs and territories, by name; overdue first | Flags a lead for an SUL to act on |
| **Zonal Manager (ZM; Zonal Sales Manager in the field)** | Know whether a region is short of leads or short of follow-up | Phone first | Zone → regions → territories, by name | Flags a region or territory for an RSM (P3-4) |
| **Head of Sales** | Compare zones on the same numbers and the national on-time rate | Phone and desktop | All zones side by side; drill zone → region → territory; breach notifications for every zone | Flags a zone for a ZM; recommends targets (P3-21) |
| **Country Leadership Team** | See whether the funnel is growing and whether the engine beats a plain list | Desktop; a monthly one-page summary | National funnel by source and campaign; conversions and PKR by zone and portfolio; on-time rate; engine versus plain list | Nothing; read-only |
| **Portfolio Manager** | Know whether my portfolio's brands and campaigns produced leads that converted, and chase the field where they did not | Phone first | Own portfolio (insecticides, fungicides, herbicides, or biologicals and seed care); its brands, campaigns and leads; drill zone → region → territory | Nothing on a lead; flags a territory one level down; owns and approves the product and timing lists for the portfolio (4.5) |
| **Marketing** | Decide where next season's campaign spend goes | Desktop | Campaigns, portfolios, brands, channels, with totals; never a grower's name or number | Defines campaign names; asks Admin to create them |
| **Admin** | Keep Synapse correct: users, territories, settings, campaigns, connections, audit | Desktop portal; own login | Everything in the portal; the below-threshold list; rejected leads; connection health; audit trail | Users and roles, territories, the acreage threshold, clock promises, scoring weights, campaigns |

DBO (Digital Business Operations) and the call-centre agents it looks after
run Synapse day to day. They are part of the operating team, not a ninth
stakeholder, and have their own portal role (P1-5a). *Added 1 Oct (review r1,
S51, S13, S14).*

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-1 | Serves the eight stakeholders above; each sees their own level and everything beneath it, named, and nothing beside or above it. | An RSM opens Synapse and sees their region's SULs by name; there is no way to open another region. | Your input (15, 16 Sept); Canvas; Invariant 7 | |
| P1-2 | Growers are never users. They are reached by their SUL, or by Hina's automated call under the rules in Part 5; Synapse sends them no automated WhatsApp message. *Revised 1 Oct (review r1, S69).* | No grower login exists anywhere. | Audit §1.5; Canvas; Your answer (1 Oct, review r1) | R |
| P1-3 | Every SUL owns exactly one territory, and a territory has at most one SUL; leads for a territory go to its SUL. A territory with no SUL is a gap (P7-2) and its leads go to the regional pool (P7-9). *Revised 1 Oct (review r1, S72).* | Admin assigns territory T to SUL X; a new lead in T appears on X's phone, nobody else's. | Your input (15 Sept); Your answer (30 Sept, review r1) | R |
| P1-4 | Marketing and Portfolio Managers see campaigns, brands and totals, never a grower's name or number, and no figure finer than a territory: no count or export by village. Both drill zone → region → territory. *Revised 1 Oct (review r1, S104).* | A Marketing user opens a campaign and sees 1,240 leads by product and crop, split by zone, region and territory; no row names a grower or a village. | Canvas; Invariant 7; Your answer (30 Sept, review r1) | R |
| P1-5 | Admin is the digital team on its own login, never combined with a sales or marketing role; every Admin action is recorded with who and when. | A Portfolio Manager who also administers Synapse has two logins; the audit trail shows which one changed a weight. | Your answer (17 Sept) | |
| P1-5a | **DBO** has its own role: edit the sales structure and village-to-BSA assignment; work the below-threshold, rejected, no-valid-number and pool lists; enter targets on Head of Sales' recommendation (P3-21); approve Hina's script for non-campaign leads (P5-2); maintain the product and timing lists when the PMs ask (4.5); and give call-centre agents the capture form (P4-14). DBO cannot change settings, export, undo number changes, remove leads or read the audit trail. Call-centre agents log in under DBO with access to the capture form and the leads they captured only. *Added 1 Oct (review r1, S51, S13, S14).* | A DBO user opens the Territories page and the daily lists, but sees no Settings page and no Export button. | Your answers (30 Sept, 1 Oct, review r1); DECISIONS 2026-10-01 | R |
| P1-6 | Country IT confirms who may have an account; users register and log in with their Syngenta email; Admin manages everything else. Every SUL and RSM has a Syngenta email (confirmed by Ahsan, 1 Oct). *Revised 21 Sept and 1 Oct (review r1, S88).* | A new SUL registers with their Syngenta email; Admin then assigns their territory. | Your answers (17, 21 Sept; 1 Oct) | R |

### 1.3 What a lead is

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-7 | A lead is one grower showing demand through one of nine lead streams: Crop Doctor scans, Savera conversations, Cropwise community posts, WhatsApp inbound, Facebook, TikTok, call-centre capture, NPI campaigns, brand campaigns. E-commerce purchases are a tenth stream that never creates a lead; a purchase goes on the grower's timeline (P4-27a). In this document "channel" and "stream" mean the same thing. No lead ever arrives by manual upload. *Revised 1 Oct (review r1, S113, S67, N23).* | Every lead shows which stream it came from; there is no "import" button anywhere. | Your input (15 Sept); Canvas; Audit lesson; Your answer (30 Sept, review r1) | R |
| P1-8 | Every lead belongs to exactly one grower record. When the same grower speaks through three streams, Synapse recognises one grower and merges the signals into one lead rather than three. | A grower who scanned in Crop Doctor on Monday and messaged on WhatsApp on Wednesday appears once on the SUL's list, with both signals shown, and the score has risen. | Invariant 2; Invariant 3; Canvas | |
| P1-8a | **Campaign credit.** When signals from more than one campaign merge into one lead, the lead is credited to the most recent campaign signal before the SUL's first reached contact; every other campaign that touched it is listed on the lead as "also touched". Marketing counts the lead once, against the credited campaign. A campaign lead's channel is the stream that carried the credited campaign. *Added 1 Oct (review r1, S32).* | A grower scans in Crop Doctor on Monday and fills a campaign A form on Wednesday: the lead is credited to campaign A, channel Facebook. | Your answer (30 Sept, review r1: last campaign wins) | R |
| P1-9 | The same signal arriving twice never creates a second lead. | A WhatsApp provider resends yesterday's message; nothing new appears. | Invariant 3 | |
| P1-10 | A lead carries: the grower (name, number, village), crop, problem or need, acreage (estimated, confirmed, or unknown), source stream, campaign if any, its top three reasons (SULs never see the score number, P5-12), segment, both clocks, territory and SUL, last season's status if any, the new/existing mark, and the grower's history. *Revised 1 Oct (review r1, S98, N15).* | An SUL opens a lead and sees all of these on one screen, without opening another. | Your input (15 Sept); Canvas; Your answer (30 Sept, review r1) | R |
| P1-11 | Acreage is marked **estimated** when it came from a source or a conversation, **confirmed** when an SUL logged it after asking the grower, and **unknown** otherwise. | The lead card shows "Acreage: 25 (estimated)" or "25 (confirmed)" or "unknown". | Canvas; Your input (16 Sept) | |
| P1-12 | Every lead records the consent basis for contacting the grower: the stream and date of the grower's own contact with Syngenta. The incoming contact is the consent: Synapse stamps it on the lead automatically, and nobody manages consent by hand. No SUL is asked to contact a grower without one. *Revised 21 Sept: D1 decided — any contact with Syngenta is the basis (Part 4, P4-23); Cropwise-sourced leads are routed from day one. Revised 1 Oct (review r1, S108).* | "Consent: Crop Doctor scan, 3 Oct" on every card. | Invariant 1; Your decision D1 (18 Sept); Your answer (1 Oct, review r1) | R |

### 1.4 The three segments and the acreage rule

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-13 | An SUL's home screen shows three segments and nothing else: **Hot**, **Campaign**, **Potential**. | Three tiles with counts and today's due leads; no fourth bucket, no source filters on the home screen. | Your input (15 Sept); Your decision (segments) | |
| P1-14 | **Hot** = the grower showed clear purchase intent (asked a product price, asked for the nearest franchise, or said they need the product) **and** the crop is known **and** acreage is at or above the threshold. All three; the score only orders leads inside Hot. | A grower with 30 acres of cotton who asked the price of a product is Hot however the score lands; a grower who asked the same with unknown acreage is not. | Your input (15 Sept); Your answer (17 Sept); see DR-2 | |
| P1-15 | **Campaign** = the lead carries a marketing campaign (brand-level or a full crop programme). Opening a campaign shows its leads grouped by product (the lead's recommended product) and by crop, with crop and acreage on each. *Revised 1 Oct (review r1, N22).* | An SUL opens "Dhaan ki Shaan", sees its leads grouped by product, then by crop, each with acreage. | Your input (15 Sept); Your answer (17 Sept, campaigns); Your answer (1 Oct, review r1) | R |
| P1-16 | **Potential** = every other routed lead, ranked, with crop and acreage shown when known and the lead shown even when acreage is unknown. | A Crop Doctor scan of a diseased crop with no acreage yet appears in Potential marked "acreage unknown". | Your input (15 Sept) | |
| P1-17 | Inside Potential, a separate tab, **Last season**, holds this season's leads from growers who converted or were never reached last season. It lists no grower without a lead this season (SULs cannot create leads, J12.2). The tab appears from the first season start after go-live; before that there is no last season in Synapse. *Revised 1 Oct (review r1, S16, S105), matching P5-19.* | Potential has two tabs: "This season" and "Last season". | Your answer (17 Sept, lifecycle); Your answer (30 Sept, review r1) | R |
| P1-18 | A lead that carries a campaign sits in the **Campaign** segment even when it meets the Hot conditions. Inside the campaign it is tagged "meets Hot conditions" and ranks first; it is never shown in Hot. | A campaign lead whose grower asked the price appears under its campaign with a "Hot" tag at the top of the campaign's list, and not in the Hot segment. | Your mark (18 Sept) | R |
| P1-19 | The **acreage threshold** is 20 acres, held as an Admin setting; every change is recorded; the same number applies everywhere the threshold is used (Hot, hiding, healthy scans). It is compared with the grower's **total** acreage across crops; where only per-crop figures exist, their sum. A change applies to leads that reach an SUL after it: open leads keep their segment and promises, and below-threshold leads are not routed after the fact. *Revised 1 Oct (review r1, S79, S28).* | Admin changes 20 to 25; leads routed from then on need 25 for Hot, open leads are untouched, and the audit trail shows who changed it and when. A grower with 15 acres of cotton and 10 of wheat has 25. | Your input (16 Sept); Your answer (17 Sept, one threshold); Your answer (30 Sept, review r1); DECISIONS 2026-10-01 | R |
| P1-20 | Known acreage **below** the threshold: the lead is never shown to any sales user. It is kept in the portal on Admin's "below threshold" list, counted in Marketing and Portfolio Manager totals labelled "below threshold", and still builds the grower's record. | A 5-acre grower who asked a price never appears on an SUL's phone; Marketing sees the campaign produced 300 below-threshold leads. | Your input (16 Sept); Your answer (17 Sept) | |
| P1-21 | Acreage **unknown**: the lead is first held for Hina, the AI calling agent, who phones the grower to ask (Part 5); if she gets it the lead is scored and routed with it; if she cannot reach the grower the lead is routed to Potential (or Campaign) marked "acreage unknown — ask and log". *Revised 21 Sept: Hina replaces the WhatsApp question.* | The lead card shows "Acreage 30 (confirmed by Hina)" or "Acreage unknown — ask and log" with a one-tap entry. | Your input (15, 16 Sept); Your answer (21 Sept, Hina) | R |
| P1-22 | When an SUL logs an acreage it stays on the grower and shows on every later lead. If it is below the threshold, the lead the SUL is working is **closed at once** (state "Closed: below threshold"), and that grower's later leads are not routed to the SUL. When the SUL's entry lowers an acreage someone else confirmed, the RSM sees the closure with the previous value and who confirmed it, and Admin can undo it as for a number change (J8.2). A closure after a promise had passed counts as missed (P5-31). *Revised 1 Oct (review r1, S19).* | The SUL logs 12 acres; the lead closes with "below threshold" in its history and leaves the list; the RSM's SUL view counts it; next season the same grower's scan goes to the below-threshold list. | Your input (16 Sept); Your mark (18 Sept); Your answer (30 Sept, review r1) | R |
| P1-23 | There is **no cap** on how many leads an SUL receives. Inside each segment leads follow the order in P5-20; the first 20 show and the rest sit one tap away under "more leads". Flagged, overdue and due-today leads are never folded, even past 20. *Revised 1 Oct (review r1, N35).* | An SUL with 80 Potential leads sees the urgent and top-ranked ones first and taps "more" to see the rest; nothing is withheld. | Your input (15 Sept); Your decision (segments); see DR-4; Your answer (1 Oct, review r1) | R |
| P1-24 | Any new signal on an existing lead re-scores it and can move it up a segment. A move up restarts both clocks under the new segment's promises; a move down keeps the earlier due times (P5-27). *Revised 1 Oct (review r1, S29).* | A Potential lead whose grower then asks the price on WhatsApp and gives 30 acres moves to Hot and the SUL is notified; its clocks restart under Hot's promises. | Canvas; Your answer (30 Sept, review r1) | R |
| P1-25 | A **healthy** Crop Doctor scan becomes a lead only when the grower's known acreage is at or above the threshold; otherwise it is recorded on the grower's history and no lead is made. | A healthy scan from a 40-acre grower appears in Potential; the same scan from a 6-acre grower or an unknown-acreage grower creates no lead. | Your decision D9 | |
| P1-26 | **Seasons.** When a grower returns next season through any stream, the lead goes through the full cycle again, including scoring, and carries a tag showing last season's status. Last season's status is "converted" if any of the grower's leads converted in the previous crop year (with the PKR of those conversions), otherwise the latest outcome of that year. *Revised 1 Oct (review r1, S76).* | A lead card shows "Last season: converted, PKR 85,000" or "Last season: not reached". | Your answer (17 Sept, lifecycle); Your answer (30 Sept, review r1) | R |

### 1.5 How a lead moves and ends

A lead is in exactly one state. It moves only by the moves in the table
below, and every move is recorded with who and when. There are no hidden
flags. *Revised 1 Oct (review r1, S4): the arrow diagram is replaced by this
table, which lists every move the journeys make.*

**Open states:** Held (waiting for Hina) · Pool (waiting for the RSM) · New ·
Contacted · Visit planned · Follow-up. **Final states:** Completed: converted
· Completed: not converted · Closed: unreachable · Closed: below threshold ·
Closed: no valid number · Closed: merged · Rejected (until Admin acts).

| From | Move | To | Who |
|---|---|---|---|
| (arrival) | A lead with a number and a gap (P5-1) | Held | Synapse |
| (arrival) | A lead with no gap that places (Part 7) | New | Synapse |
| (arrival) | A lead with no gap that cannot place (structure gap, beyond the cap) | Pool | Synapse |
| (arrival) | Known acreage below the threshold | Closed: below threshold | Synapse |
| (arrival) | No valid number and no clear match to a grower with one (P4-18) | Closed: no valid number | Synapse |
| Held | Hina hands over, her window ends, or Hina is switched off (P5-5) | New, Pool, Closed: below threshold, or Closed: no valid number (Hina's "wrong number") | Synapse |
| Pool | The RSM assigns an SUL | New | RSM |
| New | The SUL marks a contact "Reached" | Contacted | SUL |
| New, Contacted | The SUL plans a visit | Visit planned | SUL |
| New, Contacted, Visit planned | The SUL sets a follow-up date | Follow-up | SUL |
| Contacted, Visit planned, Follow-up | The SUL logs an outcome | Completed: converted, or Completed: not converted | SUL |
| New, Contacted, Visit planned, Follow-up | After the attempts in P1-33 | Closed: unreachable | SUL |
| New, Contacted, Visit planned, Follow-up | The SUL logs acreage under the threshold | Closed: below threshold | SUL |
| New, Contacted, Visit planned, Follow-up | The SUL rejects with a reason | Rejected | SUL |
| Rejected | Admin reassigns (to the same or another SUL) | New, with fresh clocks | Admin |
| Rejected | Admin merges with another lead | Closed: merged | Admin |
| Rejected | Admin removes (P1-36) | — (removed) | Admin |
| Any open state | Admin moves the lead to another SUL on the RSM's request (P3-24) | New, for the new SUL | Admin |

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-27 | Thirteen states, listed above: six open (**Held**, **Pool**, **New** — routed, not yet reached — **Contacted**, **Visit planned**, **Follow-up**) and seven final (**Completed: converted**, **Completed: not converted**, **Closed: unreachable**, **Closed: below threshold**, **Closed: no valid number**, **Closed: merged**, **Rejected** until Admin acts). A lead changes state only by a move in the table, through one function; every move logged. *Revised 1 Oct (review r1, S4, N38).* | A lead's history reads like a diary: "New 3 Oct 09:10 · Contacted 3 Oct 11:40 by SUL X · Visit planned 5 Oct …". | Your input (15 Sept); Your answer (17 Sept); Invariant 5; Your answers (30 Sept, 1 Oct, review r1) | R |
| P1-28 | A call or WhatsApp from inside the lead logs an **attempt** with its time. The lead moves to **Contacted**, and the contact clock stops, only when the SUL marks the attempt "Reached"; "No answer" leaves the state and both clocks unchanged. When the SUL reached the grower another way, one tap records it. Every attempt, reached or not, is a line in the history. *Revised 1 Oct (review r1, S1).* | The SUL taps Call; the call is in the history; the SUL taps "Reached" and the lead moves to Contacted. | Your input (15 Sept); Audit keeper (call and WhatsApp leave a trace); Canvas; Your answer (30 Sept, review r1); DECISIONS 2026-10-01 | R |
| P1-29 | Only the SUL who owns the lead, or Admin, can move it; the one exception is the RSM assigning a pool lead to an SUL (P3-11). Managers flag; they do not move. *Revised 1 Oct (review r1, S4): consistency with the state table.* | An RSM cannot mark a lead Contacted; they can flag it. | Invariant 7; Your answer (17 Sept, escalation); Your answer (30 Sept, review r1) | R |
| P1-30 | **Completed: converted** requires the PKR value (the receipt total), a **receipt photo** (required until point-of-sale integration exists), one or more **product lines** — each a product, a quantity and its unit as on the pack — and the new/existing mark. The closing SUL and date are recorded automatically. Synapse refuses a receipt image already attached to another conversion. Each week a random sample of conversions (an Admin setting, starting 5%) lands on the RSM's list to check the receipt against the value and products; the share checked and the share that failed show beside PKR on manager views. *Revised 18 Sept: product and quantity became required (Part 2, question 7). Revised 1 Oct (review r1, S97, S20).* | The SUL cannot save "converted" without value, receipt and at least one product line; the same receipt photo cannot be used twice; the record shows who closed it and when. | Your input (15 Sept); Your answer (18 Sept); Invariant 6; Your answer (30 Sept, review r1) | R |
| P1-31 | No **fulfilling franchise** is recorded on a conversion until point-of-sale integration exists; the receipt shows it. *Revised 18 Sept.* | No franchise field on the conversion screen. | Your answer (18 Sept); see DR-6 | R |
| P1-32 | **Completed: not converted** requires one reason from a fixed list — no need · no budget · no stock at the franchise · bought a competitor · wrong contact — and an optional comment. "Wrong contact" means the grower was reached but gave false details; a wrong number is handled by P1-35. Reasons are counted by area for every stakeholder (P3-23). *Revised 1 Oct (review r1, S11, S91).* | The SUL cannot close a lead as not converted without picking a reason. | Canvas; Your input (15 Sept, "completed once the loop is closed"); see DR-1; Your answer (30 Sept, review r1) | R |
| P1-33 | **Closed: unreachable** — after three failed contact attempts, each logged, on at least two different days with the first and last at least 24 hours apart (Admin settings), the SUL closes the lead with a reason: no answer · number switched off · number not in service. Unreachable closures are counted per SUL on the RSM's SUL view. *Revised 1 Oct (review r1, S17).* | After the third failed call on the second day the lead offers "Close as unreachable" with the reason list. | Your answer (17 Sept); Your answer (30 Sept, review r1) | R |
| P1-34 | A lead closed this season stays closed this season. A new signal from that grower in the same season creates a new lead under the normal rules, with the closed lead visible in the grower's history. A closed lead never silently re-opens on an SUL's list. | The grower who was unreachable in October messages in November; a new lead appears with "Closed: unreachable, 12 Oct" in its history. | Your mark (18 Sept) | R |
| P1-35 | **Reject a lead.** An SUL can mark a lead "not a valid lead" with one fixed reason — not my territory · duplicate of another lead · internal or test entry · wrong contact details. A wrong number is handled one way: Change number (J8) when the SUL has the right one; Reject: wrong contact details when they do not. The lead leaves the SUL's list once the reason is picked and goes to Admin's review list, where Admin reassigns (fresh clocks), merges or removes it. Rejections are counted per source and per SUL on the RSM's SUL view; a lead rejected after one of its promises had passed counts as missed (P5-31). *Revised 1 Oct (review r1, S9, S11, S18).* | A lead from the wrong district vanishes from the SUL's list once the reason is picked; Admin sees it under "Rejected" with the reason and the SUL. | Your answer (17 Sept); Audit keeper (report with reason, admin-only removal); Your answer (30 Sept, review r1) | R |
| P1-36 | Nothing is deleted by an SUL. Removal is Admin's alone and leaves an audit line. A removal deletes the lead's personal data and keeps only the technical identifier that stops the same signal making a lead again (INV-3). *Revised 1 Oct (review r1, N4).* | The audit trail shows "Lead 4821 removed by Admin Y, reason: test entry". | Audit keeper; Canvas; Your answer (1 Oct, review r1) | R |
| P1-37 | Every lead shows the **new/existing** mark the SUL sets for the grower; the mark stays on the grower for every later lead. | Card header: "Existing grower" or "New grower". | Your input (15 Sept); see DR-5 | |

### 1.6 The clock

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-38 | Every routed lead carries **two promises**, both Admin settings. **Contact:** Hot within 24 hours, Campaign within the promise set when Admin creates the campaign, Potential within 72 hours. **Completion:** Hot within 7 days, Campaign per campaign, Potential within 14 days. | Each lead shows two countdowns, "contact by" and "complete by"; Admin's settings page lists the four Hot and Potential promises, and each campaign's two promises are on its campaign record. *Revised 1 Oct (review r1, S116).* | Canvas (contact numbers); Your mark (18 Sept, two clocks); completion numbers are a starting proposal | R |
| P1-39 | Both clocks start when the SUL's phone receives the lead. The contact clock stops at the first contact marked "Reached"; the completion clock stops when the lead is completed (converted or not converted) or closed. A clock stops at the time the action was logged on the phone, even if the phone was offline. *Revised 1 Oct (review r1, S1, S5, S6).* | A Hot lead that reaches the phone Monday 09:00 shows "contact by Tuesday 09:00" and "complete by next Monday"; the first stops at the first reached call, the second at close. | Your mark (18 Sept); Your answer (30 Sept, review r1); DECISIONS 2026-10-01 | R |
| P1-40 | A lead overdue on either clock is marked on the SUL's list and card and counted on the SUL's summary. | "Overdue: contact" or "Overdue: completion" badge on the lead; "3 overdue now" on the summary. | Your answer (17 Sept, summary); Canvas | |
| P1-41 | When either promise is missed, the SUL, the RSM and the Zonal Manager are told (as in P3-14). Nothing is reassigned automatically. The RSM follows up with the SUL by flagging the lead; the ZM follows up with the RSM by flagging the region or territory (P3-4); a lead flag shows on the SUL's lead and summary. *Revised 1 Oct (review r1, S25, S27).* | The RSM sees the overdue lead at the top of their view, taps "Flag to SUL", and the SUL sees "Flagged by your RSM". | Your answer (17 Sept, escalation); see DR-3; Your answer (30 Sept, review r1) | R |
| P1-42 | Notifications are in-app (with phone push where the device allows). No per-lead notification goes by SMS or WhatsApp to staff. The one WhatsApp staff receive is the weekly summary (P3-17). *Revised 1 Oct (review r1, N6).* | A push on the phone and a bell inside the app. | Your mark (18 Sept); Your answer (1 Oct, review r1) | R |
| P1-43 | The **on-time rate** is the Pilot's headline number and appears on every manager's view, reported for both clocks with contact first. Its single definition is P5-31. *Revised 1 Oct (review r1, S21).* | The RSM's first screen shows "Contacted on time this week: 78% · Completed on time: 61%". | Canvas; Your decision (clock kept); Your mark (18 Sept, two clocks); Your answer (1 Oct, review r1) | R |
| P1-44 | **Judging the Pilot.** Beside the two on-time rates, the Pilot is judged on the conversion rate of routed leads and converted PKR per SUL per month, each against a baseline recorded before go-live (the season before, in the Pilot zones) and a target written beside it. Baselines and targets are set by Ahsan before go-live and recorded in DECISIONS. *Added 1 Oct (review r1, S39).* | The leadership view shows each of the four numbers next to its baseline and target. | Your answer (30 Sept, review r1) | R |

### 1.7 Decisions this part rests on

| ID | Decision | State | What it means for this part |
|---|---|---|---|
| D1 | Consent basis for advisory-captured data (Crop Doctor, Savera, community) used for sales contact | **Decided 2026-09-18** — any contact with Syngenta is the basis (leadership's position) | P1-12: every lead records the stream and date; Cropwise-sourced leads routed from day one. |
| D4 | Verified mobile number as the grower's key; the shared-number rule | **Decided 2026-09-18** — one number, one grower; no split action; the SUL corrects a wrong number (P4-17). Its no-number rule was changed on 1 Oct: a lead with no valid number is closed (P4-18). | P1-8; P1-35. |
| D7 | Conversion value: self-declared or reconciled | Open — Ahsan with finance | Self-declared with a receipt in the Pilot (P1-30); point-of-sale integration is the intended reconciliation path (your input, 15 Sept). No conversion value is linked to incentives until then. |
| D9 | Healthy Crop Doctor scan is a lead only at or above the threshold | **Decided 2026-09-15** | P1-25. |
| — | Three segments, no cap; clock kept, notify-only; one threshold at 20 as a setting; eight personas | **Decided 2026-09-15/16/17** | P1-13 to P1-23, P1-38 to P1-43. Recorded in `docs/DECISIONS.md`. |
| D8 | — | Not used | Withdrawn 2026-09-16; the number is never re-assigned. |

### 1.8 Question log (Part 1)

| # | Question | Answer (date) | Rows |
|---|---|---|---|
| 1 | Which states does a lead move through? | Seven states, plus "Closed: below threshold" added 18 Sept; unreachable closes after three failed attempts with a reason; next season the full cycle repeats with last season's tag; last season's growers in a separate Potential tab (17 Sept) | P1-17, P1-22, P1-26, P1-27, P1-33 |
| 2 | Keep a "this lead is wrong" action? | Yes, four fixed reasons, Admin review, counted per source (17 Sept) | P1-35 |
| 3 | What happens when the clock runs out? | Notify SUL, RSM and ZM; managers follow up in the product; no reassignment (17 Sept) | P1-41 |
| 4 | Who sees leads below the threshold? | Admin list; Marketing and Portfolio totals labelled; never sales views; still build the grower (17 Sept) | P1-20 |
| 5 | Does the score gate Hot? | No; three conditions only; score orders inside Hot (17 Sept) | P1-14 |
| 6 | Two acreage numbers, 15 and 20? | One threshold at 20, as a setting, may change after Phase 4 (16 Sept) | P1-19 |
| 7 | Five gaps found while drafting, marked ASSUMPTION | Answered 18 Sept: a Hot-qualifying campaign lead sits in Campaign, tagged (P1-18) · logging a low acreage closes the current lead (P1-22, new state "Closed: below threshold") · a closed lead stays closed, a new signal makes a new lead (P1-34) · the clock runs until close or completion, not first contact (P1-39) · notifications in-app and push (P1-42) | P1-18, P1-22, P1-27, P1-34, P1-39, P1-42 |
| 8 | With the clock running to completion, what are the promises? | Two clocks, contact and completion, both Admin settings; completion numbers (7 and 14 days) are a starting proposal for your mark (18 Sept) | P1-38, P1-39, P1-40, P1-43 |

### 1.9 Where the canvas differs (Part 1)

Recorded, not resolved. The spec follows the left column; the reviewers in
session 2.2 will see both.

| DR | Spec (your input) | Canvas | Why the canvas said so |
|---|---|---|---|
| DR-1 | Not-converted reasons: five (canvas list); Smart Agro Lite had four different ones (already purchased · checking the app · unaware of the lead · other) | Five codes | Losses train the engine; "no stock" repeated across a district is a supply finding. The audit's four were about the scan, not the sale. |
| DR-2 | Hot = intent + crop + acreage ≥ threshold; score orders inside | Hot = score ≥ 70 **and** intent **and** acreage known | A high score without stated intent is a selling conversation, not an order. Your rule keeps that; it drops the score gate and raises acreage from "known" to "≥ threshold". |
| DR-3 | Breach notifies SUL, RSM, ZM; managers flag; no reassignment | Breach visible to RSM, lead reassigned within 24 hours | Canvas wanted a mechanism that guarantees a contacted grower. Your choice keeps the human in the decision. |
| DR-4 | Three segments, no cap; the first 20 shown, the rest one tap away, urgent leads never folded | Four tiers including Nurture (no field task) and a daily cap per officer | Canvas's anti-clutter devices; the failure it feared was 400 leads dumped on one officer in week one. |
| DR-5 | SUL marks the grower new or existing | Derived from purchase history | Canvas trusted the record over memory; your mark is faster and the field knows its growers. |
| DR-6 | Conversion = PKR value + receipt + product + quantity, all required; no franchise | Conversion = product, quantity, PKR, franchise, date, always | Only the franchise differs now (18 Sept); the receipt shows it until point-of-sale integration. |
| DR-7 | Eight stakeholders | Six dashboards | Head of Sales and Country Leadership exist and read the numbers. |
| DR-8 | Your 15 Sept note showed campaign leads under the threshold with their acreage; your 16 Sept note hides every under-threshold lead from SULs. The later note is followed (P1-15, P1-20). | — | Input versus input; mark P1-15 if campaign leads should be the exception. |
| DR-34 | Unreachable after three SUL attempts over at least two days; the lead closes, and a new signal makes a new lead (P1-33, P1-34) | Canvas L8: unreachable after two attempts, returns to the pool, re-scored on the next signal, flags contact-data quality to the source | Your answer, 17 Sept. Contact quality is partly kept through the rejection and not-converted reasons (P1-35, P1-32). Recorded 1 Oct (review r1, S118). |
| DR-38 | The Pilot runs one or more campaigns, NPI or brand; NPI is a tag (1.1) | DECISIONS 2026-09-11 and the canvas: one NPI campaign | Your answer, 30 Sept (review r1, S107); DECISIONS 2026-10-01. |

---

## Part 2 — The SUL's experience

### 2.1 What the SUL app is

One app on the SUL's own Android phone. It opens on three segments and
nothing else. Every lead it shows is in the SUL's territory, ranked, with a
clock. Everything the SUL needs for a day in the field is on the phone before
they leave signal; everything they log is kept on the phone and sent when
signal returns. The app speaks Urdu or English, the SUL's choice. It shows the
SUL their own progress and never a league table.

### 2.2 Modules

| Module | What it is for | Came from | Mark |
|---|---|---|---|
| **Home — three segments** | Hot, Campaign, Potential, each with a count and today's due leads; the only things on the home screen | Your input (15 Sept) | |
| **Segment list** | The leads in one segment in the order of P5-20; the first 20 show and the rest sit under "more", but flagged, overdue and due-today leads are never folded; Potential has two tabs, "This season" and "Last season" | Your input; Part 1; Your answer (1 Oct, review r1) | R |
| **Campaign browser** | Inside Campaign: one entry per campaign with open leads, ended ones marked "ended", then leads grouped by product and by crop | Your input (15 Sept); Your answer (30 Sept, review r1) | R |
| **Lead card** | Everything about one lead on one screen, with the actions | Your input; Canvas | |
| **Act and log** | Call, WhatsApp, Navigate; mark an attempt "Reached" or "No answer"; log visit planned, follow-up, converted, not converted, unreachable, reject; ask and log acreage; correct a grower's number; confirm the grower's location; reply to a manager's flag | Your input; Audit keepers; Your answers (30 Sept, review r1) | R |
| **Grower profile and timeline** | Who the grower is, their crops and acreage, and every scan, message, call, visit and outcome across seasons | Canvas | |
| **My summary** | The SUL's own numbers for today / this week / month to date / quarter / year / season / custom (defined in P3-7), one trend line, overdue now, leads flagged by line managers | Your input; Your answer (17 Sept); Your answer (30 Sept, review r1) | R |
| **Notifications** | New lead in Hot, overdue on either clock, flag from a manager, a lead moved up a segment, an applied change to the scoring weights | Part 1; Your answer (30 Sept, review r1) | R |
| **Profile** | Language choice, territory shown, sign out | Your answer (17 Sept, languages) | |

### 2.3 Journeys

Each journey is a numbered list of what the SUL does and what Synapse shows.
Screen states (empty, loading, error) and layout are Phase 4's work, not this
document's.

#### J1 — Morning start

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J1.1 | Opens the app at 7 am, no signal | Home with three segments and counts from last night's sync; "last updated 22:40" | Your input; Canvas (offline) | |
| J1.2 | Looks at Hot | The Hot list, ranked; leads due today first, each with grower, crop, acreage, both clocks, and the first of its top three reasons | Part 1 | |
| J1.3 | Sees one lead badged "Flagged by your RSM" | The flag sits above the ranking so it is seen first; tapping shows the RSM's one-line note | Your answer (17 Sept, summary) | |
| J1.4 | Plans the day from the three lists, or from the map when heading to one area | Nothing else competes for attention on the home screen: no map, no source filters, no points. The map is one tap away from any segment list (P2-20, J13). | Your input (no clutter); Your answer (18 Sept, map, revised) | |

#### J2 — Work a Hot lead

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J2.1 | Taps a Hot lead | The lead card: grower name and village, crop, problem or need, acreage with estimated/confirmed, why it is Hot (the three conditions), the top three reasons in the SUL's language (no score number, P5-12), recommended product where it matches (P2-7; no PKR estimate), nearest franchise, consent basis, campaign if any, last season's status if any, new/existing mark, two clocks | Your input; Canvas; Your answer (18 Sept, card extras); Your answer (30 Sept, review r1) | R |
| J2.2 | Taps Call | The phone dials; the attempt is in the history with time; after the call the card asks "Reached?" — "Reached" moves the lead to Contacted and stops the contact clock; "No answer" changes nothing (J2.4) | Audit keeper (call leaves a trace); Part 1 (P1-28); Your answer (30 Sept, review r1) | R |
| J2.3 | Or taps WhatsApp | WhatsApp opens on the grower's number; the attempt is in the history; the SUL marks "Reached" when the grower replies or picks up, and only then does the lead move to Contacted | Audit keeper; Canvas; Your answer (30 Sept, review r1) | R |
| J2.4 | Grower does not answer | Taps "No answer": one failed attempt logged; the lead stays where it was; after the third failed attempt, on a second day at least 24 hours after the first, the card offers "Close as unreachable" with its reason list (P1-33) | Your answer (17 Sept); Your answer (30 Sept, review r1) | R |
| J2.5 | Agrees a visit | Taps "Visit planned", picks a day: two taps; the lead moves to Visit planned | Your input; Canvas (two taps) | |
| J2.6 | Needs to get there | Taps Navigate; directions open to the grower's location where Synapse has one | Audit keeper (navigate) | |

#### J3 — Visit and convert

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J3.1 | At the farm, taps "Log outcome" | Three choices: Converted · Not converted · Follow-up needed | Your input | |
| J3.2 | Taps Converted | Asks for, all required: PKR value (the receipt total), receipt photo (camera or gallery), one or more product lines (product from the pick-list, quantity, unit as on the pack), new or existing grower (pre-filled if already marked). No franchise field until point-of-sale integration. A receipt photo already used on another conversion is refused. | Your input (15 Sept); Your answer (18 Sept, converted); Invariant 6; Your answer (30 Sept, review r1) | R |
| J3.3 | Enters PKR 85,000, adds two product lines (product, quantity, unit), takes the receipt photo, confirms | The lead moves to Completed: converted with the SUL's name and time; the summary's converted count and value rise; the grower's timeline records the sale | Your input; Invariant 6; Your answer (30 Sept, review r1) | R |
| J3.4 | Is offline at the farm | Everything above works; the photo and outcome wait on the phone and send on reconnect; the SUL sees "will send when online" | Canvas (offline); Audit keeper (outbox) | |

#### J4 — Not converted

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J4.1 | Taps "Not converted" | A reason list: no need · no budget · no stock at the franchise · bought a competitor · wrong contact; an optional comment | Canvas; Part 1 (DR-1) | |
| J4.2 | Picks "No stock at the franchise", confirms | The lead moves to Completed: not converted with the reason; three taps from the lead card (P2-3) | Your input; Canvas; Your answer (30 Sept, review r1) | R |
| J4.3 | Later, the same grower messages again this season | A new lead appears with the earlier outcome in its history | Part 1 (P1-34) | |

#### J5 — A lead goes overdue

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J5.1 | Has not contacted a Hot lead for 24 hours | The lead is badged "Overdue: contact"; a notification reaches the SUL, the RSM and the ZM; the summary's "overdue now" rises | Part 1 (P1-40, P1-41) | |
| J5.2 | Sees the RSM's flag arrive | "Flagged by your RSM" on the lead and on the summary; the lead sorts to the top until the SUL's next action on it or a one-line reply answers the flag (P2-23) | Your answer (17 Sept); Your answer (30 Sept, review r1) | R |
| J5.3 | Reaches the grower | The contact clock stops at the time logged on the phone; the badge clears; if the managers were already told of a breach that the logged time shows never happened, the notice is withdrawn; the completion clock keeps running | Part 1 (P1-39); Your answer (30 Sept, review r1) | R |
| J5.4 | Has not completed a Hot lead in 7 days | "Overdue: completion" badge and the same notifications | Part 1 (P1-38) | |
| J5.5 | Completes the lead on day 9 | The lead moves to Completed as normal; it counts as completed, but late, in the completion on-time rate (P5-31) | Your answer (1 Oct, review r1, N14) | R |

#### J6 — A campaign lead

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J6.1 | Opens Campaign | One entry per campaign with open leads in the territory, live or ended, ended ones marked "ended", with lead counts | Your input (15 Sept); Your answer (30 Sept, review r1) | R |
| J6.2 | Opens "Dhaan ki Shaan" | Leads grouped by product (the lead's recommended product), then by crop; each with acreage; leads that meet the Hot conditions tagged and first | Your input; Part 1 (P1-18); Your answer (1 Oct, review r1) | R |
| J6.3 | Opens a lead | The lead card, with the campaign, its product and its talk track where Marketing supplied one (an optional field on the campaign, P3-16) | Canvas; Your answer (30 Sept, review r1) | R |
| J6.4 | Works it as in J2 to J4 | Same states, same clocks (the campaign's own promises) | Part 1 | |

#### J7 — Unknown acreage: ask and log

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J7.1 | Opens a Potential lead marked "acreage unknown" | The card shows "Acreage unknown — ask and log" and Hina's note ("no answer after 3 attempts", or "Grower refused Hina's call, <date>"); a lead Hina reached arrives with acreage already confirmed and is not marked unknown | Your input (16 Sept); Your answer (21 Sept, Hina); Your answer (30 Sept, review r1) | R |
| J7.2 | Asks the grower on the call; taps the acreage field | Enters a number, optionally per crop; saved as **confirmed** on the grower | Your input (16 Sept); Part 1 (P1-11) | |
| J7.3 | Logs 30 acres | The lead re-scores; if the grower also showed clear intent and the crop is known it moves to Hot and the SUL is told | Part 1 (P1-24) | |
| J7.4 | Logs 12 acres | The lead closes as "Closed: below threshold" and leaves the list; the grower's later leads are not routed to the SUL | Your mark (18 Sept) | |

#### J8 — Correcting a grower's number

One mobile number belongs to one grower. There is no split action (see
DR-13). A wrong number the SUL cannot correct is a rejection: "wrong contact
details" (P1-35).

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J8.1 | Calls and learns the number on the lead is wrong, or the grower has a new number | Taps "Change number" on the grower's profile, enters the new one | Your answer (18 Sept, shared number) | R |
| J8.2 | Confirms | The grower's number is updated; the old number and the change are kept in the history with who and when; Admin can see and undo it. If the new number already belongs to another grower, Synapse says so and does not save; the SUL rejects the lead as "duplicate of another lead" and Admin merges the two (P1-35, J21.6). | Your answer (18 Sept); Invariant 2; Your answer (1 Oct, review r1) | R |

#### J9 — An offline day

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J9.1 | Leaves signal for the day | All three segments, every lead card, every grower profile in the territory, and the product list are already on the phone | Canvas (offline-first); Audit lesson (reads were not cached) | |
| J9.2 | Logs eight outcomes and two acreages, takes three receipt photos | Each is saved on the phone at once with "will send when online"; nothing is lost if the phone restarts | Canvas; Audit keeper (outbox) | |
| J9.3 | Regains signal | Everything sends in the order it was logged, each action carrying the time it was logged on the phone, and the clocks stop at those times; the app confirms. A server-side re-score or segment move never overrides an outcome the SUL logged; only an Admin removal or a change of territory does, and then the SUL's entry goes to Admin's review list. Nothing the SUL logged is discarded. | Canvas; Your answer (30 Sept, review r1); DECISIONS 2026-10-01 | R |

#### J10 — Reviewing my progress

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J10.1 | Opens My summary | For the chosen period: leads received, completed, converted, converted value in PKR; one line of conversions per week; overdue now; leads flagged by line managers; breached timelines | Your input (15 Sept); Your answer (17 Sept) | |
| J10.2 | Switches the period | Today · this week · month to date · quarter · year · season · custom (P3-7) | Your input; Audit keeper (presets); Your answer (30 Sept, review r1) | R |
| J10.3 | Looks for a ranking | There is none; the SUL sees their own numbers only | Your answer (17 Sept); Audit lesson (gamification) | |

#### J11 — Rejecting a lead

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J11.1 | Opens a lead from a village outside the territory | Taps "Not a valid lead"; picks: not my territory · duplicate of another lead · internal or test entry · wrong contact details | Your answer (17 Sept) | |
| J11.2 | Confirms | The lead leaves the list at once and goes to Admin's review list; the SUL's summary does not count it as pending | Part 1 (P1-35) | |

#### J12 — Finding a grower

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J12.1 | A grower calls the SUL out of the blue | The SUL searches by name, number or village, typed in Urdu or Latin script, and opens the grower's profile and timeline | Audit (list search); Canvas (interaction history); Your answer (30 Sept, review r1) | R |
| J12.2 | The grower wants to buy | Not in this specification: an SUL cannot create a lead by hand. The project's first focus is converting leads from the digital streams. The SUL sells as today and the sale is not a Synapse lead. Out of scope until Ahsan asks (6.3.2). | Your answer (18 Sept, walk-in lead); Your answer (1 Oct, review r1) | R |

#### J13 — Planning a village visit from the map

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J13.1 | Is going to a village or BSA tomorrow; opens the map from a segment list | A Google map with the territory's open leads as pins, coloured by segment (Hot, Campaign, Potential), marked when overdue or campaign; the SUL's own position. No village or BSA outlines are drawn (P7-4). | Your note (18 Sept, map); Your answer (1 Oct, review r1) | R |
| J13.2 | Picks the village or BSA from a list | Only the pins of leads placed in that village or BSA remain, with a count by segment | Your note (18 Sept); Your answer (1 Oct, review r1) | R |
| J13.3 | Taps a pin | The lead card (J2.1); "Visit planned" for tomorrow is two taps; the map returns to the remaining pins | Your note (18 Sept); Part 1 | |
| J13.4 | Selects several leads for the same trip | Each is marked Visit planned for that day; the next morning they sit at the top of their lists as due | Your note (18 Sept); P2-21 | |
| J13.5 | Is offline in the village | The pins, cards and every action work from the phone; the Google base map shows what is already cached on the phone; nothing is lost | Canvas (offline); Your answer (1 Oct, review r1) | R |

### 2.4 Rules that hold on every SUL screen

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P2-1 | The home screen shows three segments and nothing else. | No map, no filters, no points on the first screen. | Your input (15 Sept) | |
| P2-2 | Every list follows the order in P5-20; the first 20 show and the rest sit under a "more" fold, except that flagged, overdue and due-today leads are never folded. No cap. *Revised 1 Oct (review r1, N35).* | The SUL never scrolls past a lead that matters to reach one that does not. | Your input; Part 1 (P1-23); Your answer (1 Oct, review r1) | R |
| P2-3 | A normal outcome is logged in three taps or fewer from the lead card, reason included. Contacted: one tap ("Reached"). Visit planned: two (Visit planned, day). Follow-up: three (Follow-up, date, confirm). Not converted: three (Not converted, reason, confirm). Converted takes more because value, receipt and product lines are required. *Revised 1 Oct (review r1, S9).* | A tester counts the taps from the lead card and gets these numbers. | Canvas (two-tap rule); see DR-9; Your answer (30 Sept, review r1) | R |
| P2-4 | Every lead shows its top three reasons in plain words, in the SUL's language. | "Asked the price on WhatsApp · 30 acres of cotton · Spray window open now". | Canvas; Invariant 8 | |
| P2-5 | Both clocks are visible on every lead in every list and on the card. Dates, times and numbers use Western digits in the English style in both languages. *Revised 1 Oct (review r1, N42).* | "Contact by Tue 09:00 · Complete by Mon 25th", the same in Urdu. | Part 1 (P1-38); Your answer (1 Oct, review r1) | R |
| P2-6 | Acreage is always labelled estimated, confirmed or unknown. | Never a bare number. | Part 1 (P1-11) | |
| P2-7 | The consent basis is shown on every lead card. A recommended product is shown where the lead's crop and problem match a Product row, including preventive rows for healthy scans (problem "preventive"). No indicative PKR value is shown. *Revised 1 Oct (review r1, S77).* | "Consent: messaged us on WhatsApp, 3 Oct" · "Suggested: <product> for <problem>". | Canvas; Invariant 1; Your answer (18 Sept, card extras); Your answer (30 Sept, review r1) | R |
| P2-8 | The app works fully offline: reads and writes. Everything in the territory is on the phone; every action waits on the phone and sends in order. | J9. | Canvas; Audit lesson | |
| P2-9 | The app is in Urdu or English, chosen once in Profile and changeable any time; grower messages are shown as sent. Hina's summary is held in Urdu and English and shown in the SUL's language. Flag notes, talk tracks and product and campaign names are shown as written and marked "as written". Village and grower names are searchable in Urdu and Latin script. *Revised 1 Oct (review r1, S15, N13).* | Every label, reason list and notification in the chosen language. | Your answer (17 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| P2-10 | The app runs on Android 9 or newer with 2 GB of memory, takes under 150 MB with a full territory cached (unsent receipt photos count inside the 150 MB and are compressed to fit), and is usable on 2G/3G. No iPhone in the Pilot. The 2G/3G numbers and a survey of the field's phones are set in Phase 4 (parked, SYN-12). *Revised 1 Oct (review r1, N19, S61).* | Installs and works on the field's current phones. | Your answer (17 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| P2-11 | No points, badges or leaderboards. The SUL sees their own progress only. | J10.3. | Your answer (17 Sept); Audit lesson | |
| P2-12 | Call, WhatsApp and Navigate are on the lead card, and each leaves a line in the history. | J2.2, J2.3, J2.6. | Audit keeper | |
| P2-13 | The grower's full timeline across seasons is one tap from any lead. | Scans, messages, calls, visits, outcomes, in date order, with the season marked. | Canvas | |
| P2-14 | The new/existing mark is set once per grower and shown on every lead. | Card header. | Your input (15 Sept) | |
| P2-15 | Notifications: a new Hot lead, a lead moved up a segment, overdue on either clock, a manager's flag, an applied change to the scoring weights (with its reason in the SUL's language, P5-34). In-app and push only. *Revised 1 Oct (review r1, S99).* | A bell count and phone push. | Part 1 (P1-42); Your answer (30 Sept, review r1) | R |
| P2-16 | Period views on My summary: today, this week, month to date, quarter, year, season, custom, as defined in P3-7 (managers: P3-7). *Revised 1 Oct (review r1, N16, S102).* | J10.2. | Your input (15 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| P2-17 | The SUL sees only their own territory's leads and growers. A change of territory by Admin changes what the SUL sees at the next sync, and the old leads are no longer on their phone. When an SUL moves territory, Admin moves their open leads in the old territory to a named SUL on the RSM's request (P3-24); nothing moves automatically. *Revised 1 Oct (review r1, S24).* | An SUL moved from T1 to T2 opens the app and sees T2. | Invariant 7; Your answer (30 Sept, review r1) | R |
| P2-18 | A lead with unknown acreage always carries a one-tap "ask and log" entry. | J7. | Your input (16 Sept) | |
| P2-19 | The SUL never sees a lead whose grower's known acreage is below the threshold, and never sees leads from growers without a recorded consent basis. | Such leads are simply absent. | Part 1 (P1-12, P1-20) | |
| P2-20 | The home screen has no map. A **map view** is one tap from any segment list: a Google map with the territory's open leads as pins, coloured by segment and marked by category (campaign, crop, overdue), filterable to a village or a BSA picked from a list. No village or BSA outlines are drawn. Tapping a pin opens the lead card; the SUL can pick the leads near where they are going and work them from there. Navigate on the lead card opens directions. The Google Maps integration is built and run by the team. *Revised 18 Sept from "view-only" after your note. Revised 1 Oct (review r1, N7).* | Going to a village, the SUL opens the map, filters to it, sees three Hot and five Potential leads nearby, taps one and starts J2. | Your answer (18 Sept, map, revised); Audit lesson (map never the home screen); Your answer (1 Oct, review r1) | R |
| P2-21 | Follow-up is a date the SUL sets. On that day the lead comes to the top of its list and counts as due; the completion clock keeps running. A missed follow-up date is shown on the lead and the summary but does not notify managers. | "Follow-up: Thu 12th" on the card; on Thursday it is at the top; on Friday it shows "follow-up missed". | Your answer (18 Sept, follow-up) | R |
| P2-22 | A **BSA** (Basic Sales Unit Area) is a named area inside a territory made of villages, generally with one Naya Savera franchisee; held in the sales structure DBO maintains (Part 7). "Nearby" on the map means something the field already uses. | The map's filter lists the territory's BSAs and villages. | Your notes (18, 25 Sept); approved with Part 2 | R |
| P2-23 | **Answering a flag.** A flag on a lead is answered by the SUL's next action on that lead or by a one-line reply. An answered flag stops sorting the lead to the top and shows the sender when and how it was answered. *Added 1 Oct (review r1, S8).* | The SUL logs "Visit planned"; the flag shows "answered 11:40 by Visit planned" to the RSM. | Your answer (30 Sept, review r1) | R |
| P2-24 | **Accessibility.** The SUL app stays usable at the phone's largest text size, readable in direct sunlight (a high-contrast theme), usable one-handed (primary actions in the lower half of the screen), and accepts the phone's voice keyboard in text fields. *Added 1 Oct (review r1, S123).* | A tester at the largest text size, outdoors, one-handed, logs an outcome. | Your answer (1 Oct, review r1) | R |

### 2.5 Decisions this part rests on

| ID | Decision | State | What it means for this part |
|---|---|---|---|
| D1 | Consent for advisory-captured data | **Decided 2026-09-18** | P2-19: every lead carries its consent basis; Cropwise-sourced leads are shown from day one. |
| D4 | Mobile number as the grower's key | **Decided 2026-09-18**; no-number rule changed 1 Oct | J8 number correction; J12 search by number; one number per grower; a lead with no valid number never reaches an SUL. |
| D7 | Conversion value: declared or reconciled | Open | J3: receipt required until point-of-sale integration. |
| — | Three segments; two clocks notify-only; threshold as a setting | Decided | All of 2.3 and 2.4. |

### 2.6 Question log (Part 2)

| # | Question | Answer (date) | Rows |
|---|---|---|---|
| 1 | Which languages? | Urdu and English, SUL chooses; regional after the Pilot (17 Sept) | P2-9 |
| 2 | Which phones? | Android 9+, 2 GB, under 150 MB, 2G/3G, no iPhone (17 Sept) | P2-10 |
| 3 | What is on My summary? | Received, completed, converted, PKR value, one trend line, overdue now, flagged by line managers, breached timelines; no comparison (17 Sept) | J10 |
| 4 | Can an SUL create a lead by hand? | No; focus is digital streams (18 Sept). Out of scope until Ahsan asks (1 Oct, review r1, S31) | J12.2 |
| 5 | Is there a map? | First answer: view-only. Revised the same day: a working map one tap from any segment list, pins by segment and category, filterable to a village or BSA, tapping a pin opens the lead, so the SUL can plan a visit to one area. Never the home screen (18 Sept). A Google map with lead pins; no village boundaries shown to SULs (1 Oct, review r1, N7) | J1.4, J13, P2-20 |
| 6 | How does follow-up work? | A date the SUL sets; the lead resurfaces that day; a missed date is shown, managers not notified (18 Sept) | P2-21 |
| 7 | What does Converted require? | PKR value, receipt, product and quantity, all required; no franchise until point-of-sale integration (18 Sept) | J3.2; revises P1-30, P1-31 |
| 8 | Which canvas extras stay on the card? | Consent basis and recommended product; no PKR estimate (18 Sept) | J2.1, P2-7 |
| 9 | Who splits a shared number? | Nobody: one number per grower; the SUL can change a grower's number, Admin can see and undo (18 Sept) | J8; see DR-13 |
| 10 | What is a BSA? | P2-22 as written, approved with Part 2 (18 Sept): a named area inside a territory, in the sales master; villages map to one BSA | P2-22 |

### 2.7 Where the canvas or the audit differs (Part 2)

| DR | Spec | Canvas or audit | Note |
|---|---|---|---|
| DR-9 | Two taps for a normal outcome; converted takes more | Canvas: two taps for a normal outcome; Smart Agro Lite: about three | Converted needs value and receipt by your rule, so it is the exception. |
| DR-10 | Full offline: reads and writes on the phone | Smart Agro Lite: writes held back, reads not cached, map empty offline | Canvas and your input agree; the audit's version is the mistake not carried. |
| DR-11 | No points or leaderboards | Smart Agro Lite: points, badges, top-5 leaderboard | Audit lesson; canvas warns visible performance data changes behaviour. |
| DR-12 | A working map one tap from a segment list, for planning an area visit; never the home screen | Smart Agro Lite: map of scan markers was the home screen | Your note, 18 Sept. The list stays the primary surface; the map is a planning tool. |
| DR-13 | One number per grower; the SUL corrects a wrong number; no split | Canvas: shared and family numbers are common and need an explicit split action or counts corrupt | Your answer, 18 Sept. Two growers on one family phone will be one grower record; recorded for the session 2.2 reviewers. |
| DR-14 | No PKR estimate on the card; product and quantity required on conversion; no franchise | Canvas: indicative value on the card; conversion carries franchise | Your answers, 18 Sept. |

## Part 3 — Managers, leadership, marketing and admin

### 3.1 What they get

Everyone above the SUL reads the same numbers the SUL's logging produced,
one level down, by name. An RSM sees SULs; a ZM sees regions and can open a
territory; Head of Sales sees zones side by side; Leadership sees the country.
Nobody sees a number they cannot trace to a person or a territory, and nobody
sees two definitions of the same number. Managers act through one mechanism,
the flag, which travels one level at a time and lands at the top of the
report's list. Marketing and Portfolio Managers read campaigns, brands and
portfolios, never a grower. Admin keeps the machine honest from a desktop
portal and every Admin action is on the record.

### 3.2 Modules

| Module | Who | What it is for | Came from | Mark |
|---|---|---|---|---|
| **RSM dashboard** | RSM | Region's SULs and territories by name; overdue first; SUL-wise and territory-wise numbers; full lead cards for overdue, flagged and pool leads (P3-3); flags to SULs; the regional pool; the weekly receipt sample (P1-30) | Your input (15 Sept); Your answers (18 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| **ZM dashboard** | ZM | Zone → regions → territories; progress, gaps and analytics; no grower details; flags to RSMs | Your input; Your answer (18 Sept, manager view) | |
| **Head of Sales dashboard** | Head of Sales | All zones side by side on the same numbers; national on-time rates; drill to territory; breach notifications for every zone; flags to ZMs | Your answer (17 Sept) | |
| **Leadership dashboard and monthly summary** | Country Leadership Team | Read-only national view; a monthly one-page summary | Your answer (17 Sept) | |
| **Portfolio dashboard** | Portfolio Manager | Own portfolio's brands, campaigns and leads by product and crop; drill zone → region → territory; flags to ZMs; the product and timing lists the PM owns | Your input (15 Sept); Your answer (18 Sept); Your answer (30 Sept, review r1) | R |
| **Marketing analytics** | Marketing | Campaigns, portfolios, brands, channels; leads, conversions, PKR, spend; drill zone → region → territory; aggregate exports. No cost per lead (6.3.2) | Your input (15 Sept); Canvas; Your answer (18 Sept, cost); Your answers (30 Sept, 1 Oct, review r1) | R |
| **Admin portal** | Admin; DBO for its own pages (P1-5a) | Users and roles; territories and BSAs; settings (threshold, clock promises, weights, holiday list, targets); campaigns; connections and their health (the streams, Hina and the address service), with the vendor register (P6-22); franchise points (per BSA, Part 7); product and timing lists; below-threshold list; "no valid number" list (Part 4); held campaign signals; rejected leads; regional pool sizes; audit trail | Canvas; Your answers (17, 18 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| **Weekly WhatsApp summary** | RSM, ZM, Head of Sales, PMs | Monday 9 am, last week at the reader's own level, in English | Audit keeper (changed daily → weekly); Your answer (18 Sept); Your answer (1 Oct, review r1) | R |
| **Flags and notifications** | All managers | Flag with note and due-by day, one level down, on a lead or on a territory, region or zone (P3-4); notifications for breaches, flags answered, settings changes | Your answers (17, 18 Sept); Your answer (30 Sept, review r1) | R |
| **Targets** | Head of Sales recommends; Admin or DBO enter | On-time targets and targets for leads converted, sales value and leads followed up (P3-21) | Your answer (30 Sept, review r1) | R |

### 3.3 Journeys

#### J14 — RSM morning

| Step | The RSM does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J14.1 | Opens the app | The region's overdue leads first, grouped by SUL, with which clock is breached; then the week's on-time rates and this week's numbers by SUL | Your input (15 Sept); Canvas (breaches first) | |
| J14.2 | Opens an SUL | That SUL's numbers for the period (received, labelled supply; contacted on time; completed; completed on time; converted; PKR; overdue now), against their targets (P3-21), their three segment counts, and their rejections, unreachable closures and below-threshold closures | Your input (SUL-wise); Your answers (30 Sept, 1 Oct, review r1) | R |
| J14.3 | Opens an overdue, flagged or pool lead | The full lead card, grower name and number included; every view of a number is logged. Other leads open without the number (P3-3) | Your answer (18 Sept, manager view); Your answer (1 Oct, review r1) | R |
| J14.4 | Taps Flag, writes "Visit before Thursday", sets Thursday | The lead sorts to the top of the SUL's list with the note; the SUL's summary shows it; the RSM sees when and how the SUL answered it (P2-23) | Your answer (18 Sept, flag); Your answer (30 Sept, review r1) | R |
| J14.5 | Switches to territory view | The same numbers by territory, including any territory with no SUL assigned, shown as a gap | Your input (territory-wise) | |

#### J15 — The regional pool

| Step | The RSM does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J15.1 | Opens "Unassigned" | Leads in the region that could not be placed in a territory (a structure gap, beyond the distance cap, or an ambiguous address with its candidate villages), with what is known (village, district, crop, source) | Canvas (region pool); Your answer (18 Sept); Your answer (30 Sept, review r1) | R |
| J15.2 | Picks an SUL for a lead | The lead is routed to that SUL and takes that SUL's territory as its placement; both clocks start when the SUL's phone receives it; the assignment is in the history | Your answer (18 Sept, pool); Your answers (30 Sept, 1 Oct, review r1) | R |
| J15.3 | Sees the same village again next week | Admin has been shown the pool size by region and the unmatched villages, so the territory master can be fixed | Your answer (18 Sept); Canvas (master drift) | |

#### J16 — ZM: short of leads, or short of follow-up

| Step | The ZM does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J16.1 | Opens the app | The zone's regions side by side: leads received, contacted on time, completed, completed on time, converted, PKR, overdue — for the chosen period, against targets (P3-21) | Your input (15 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| J16.2 | Sees Region B behind | Two numbers set apart: leads received per territory (supply) and the on-time rates (follow-up), so the ZM can tell which is short (P3-6) | Canvas; Your answer (18 Sept, progress and gaps) | |
| J16.3 | Opens Region B, then a territory | Territory-level numbers and the SUL's name; no grower names or numbers, no lead cards | Your answer (18 Sept, manager view) | |
| J16.4 | Flags the region or a territory to its RSM | Note and due-by day; lands at the top of the RSM's view; when the RSM flags the SUL the two flags are linked, so the ZM sees each step and when it was answered | Your answers (17, 18 Sept); Your answer (30 Sept, review r1) | R |

#### J17 — Head of Sales

| Step | Head of Sales does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J17.1 | Opens the app | All zones side by side on the same numbers, plus national on-time rates for both clocks | Your answer (17 Sept) | |
| J17.2 | Drills | Zone → region → territory, same shape as the ZM's view, no grower details | Your answers (17, 18 Sept) | |
| J17.3 | Receives breach notifications for every zone | One digest per day at 8 am rather than one per lead: "14 leads breached yesterday: Zone A 9, Zone B 5"; tapping it opens the list | Your answer (17 Sept); Your mark (18 Sept, digest) | R |
| J17.4 | Flags a zone to its ZM | Same flag, on the zone; one level down | Part 1 (P1-41); Your answer (30 Sept, review r1) | R |
| J17.5 | Is told a setting changed | "Admin changed the acreage threshold from 20 to 25 at 14:02" | Your answer (18 Sept, controls) | |

#### J18 — Country Leadership Team

| Step | Leadership does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J18.1 | Opens the dashboard | National funnel by source and by campaign; conversions and PKR by zone and by portfolio; on-time rates; the Pilot's four numbers against baseline and target (P1-44); time from the grower's signal to first contact, split into Hina's hold and the SUL's clock (P5-31a); leads below threshold as a count; whether the scoring engine beats a plain list (P5-33); each figure beside the previous period's; zones not live marked "not live" (P3-22) | Your answer (17 Sept); Canvas (model lift); Your answer (30 Sept, review r1) | R |
| J18.2 | Receives the monthly summary | One page on the first working day of the month, with the contents listed in P3-18, unflattering numbers included; sent by email as a page and also shown in the dashboard | Your answer (17 Sept); Canvas ("including when unflattering"); approved with Part 3; Your answer (30 Sept, review r1) | R |
| J18.3 | Looks for a grower | There are none to find; nothing on this view names a grower | Your answer (18 Sept, manager view) | |

#### J19 — Portfolio Manager

| Step | The PM does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J19.1 | Opens the app | Own portfolio only: its brands and its campaigns that are live or had activity in the period, with leads, conversions and PKR for the period; below-threshold leads as a labelled count | Your input (15 Sept); Your answer (17 Sept, under-threshold); Your answer (30 Sept, review r1) | R |
| J19.2 | Opens a campaign | Leads by product (the lead's recommended product) and by crop; conversions and PKR by each; zone → region → territory drill | Your input (15 Sept); Your answer (1 Oct, review r1) | R |
| J19.3 | Sees a territory behind on a campaign | Flags the territory to the ZM with a note and due-by day; the ZM flags the RSM, the RSM the SUL, each flag linked to the one above; the PM sees each step and when it was answered | Your answer (18 Sept, PM follow-up); Your answer (30 Sept, review r1) | R |
| J19.4 | Looks for a grower | No grower names or numbers on any PM view | Canvas; Invariant 7 | |

#### J20 — Marketing

| Step | Marketing does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J20.1 | Opens analytics | Every campaign: leads (routed, below threshold on arrival, closed below threshold later, closed unreachable, each labelled), contacted, converted, PKR; held campaign signals not yet readable, per stream (P4-11); by portfolio, by brand, by channel (stream), by last-season status (P1-26), and zone → region → territory; not-converted reasons by area (P3-23); for the period | Your input (15 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| J20.2 | Compares campaigns | Leads, conversions and PKR side by side, with the spend entered on each. Cost per lead is out of scope for now (6.3.2) | Canvas; Your answer (18 Sept, cost); Your answer (1 Oct, review r1) | R |
| J20.3 | Defines a new campaign | Gives Admin the name (brand-level or a crop programme), whether it is NPI, portfolio, brand or programme, product, crop, dates, its contact and completion promises, budget and, if available, a talk track in Urdu and English; Admin creates it | Your answer (17 Sept, campaigns); Your answer (30 Sept, review r1) | R |
| J20.4 | Updates spend | Edits actual spend on the campaign record monthly; the change is logged | Your answer (18 Sept, cost) | |
| J20.5 | Exports | Aggregate figures to a spreadsheet, never a grower's name or number and nothing finer than a territory; every file carries a definitions sheet for its numbers and, when data is incomplete, the same warning as the screen (P3-8); every export logged with who and when | Your answer (18 Sept, controls); Audit keeper (About sheet, as-of and count); Your answers (30 Sept, 1 Oct, review r1) | R |

#### J21 — Admin

| Step | Admin does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J21.1 | A new SUL joins | The SUL registers with their Syngenta email and confirms it from a link sent to that mailbox; the account works once Country IT's list confirms it; Admin sets the role and assigns the territory; the SUL's phone shows that territory at the next sync | Your answer (17 Sept, Admin); Invariant 7; Your answers (30 Sept, 1 Oct, review r1) | R |
| J21.2 | Changes the acreage threshold, a clock promise or a scoring weight | Applies to leads that reach an SUL after the change (P3-10); recorded with who, when and the previous value; Head of Sales notified, and for a weight change every stakeholder (P5-14); the audit trail shows it | Your answer (18 Sept, controls); Canvas (weights audited); Your answer (30 Sept, review r1) | R |
| J21.3 | Creates a campaign from Marketing's definition | Name, NPI or not, portfolio, brand or crop programme, product, crop, dates, promises, budget, optional talk track; leads carrying that campaign appear under it from then on, and held signals for it are released once its reference can be read (P4-11) | Your answer (17 Sept, campaigns); Your answer (30 Sept, review r1) | R |
| J21.4 | Opens Connections | Each of the nine lead streams and the e-commerce purchase stream, plus Hina and the address service, with its state (connected, failing, not yet connected), last item received, items held back for a reason, requests refused for a bad signature, and its vendor-register entry and escalation contact (P6-22); a failing connection is shown before anyone notices missing leads | Canvas; Your answers (30 Sept, 1 Oct, review r1) | R |
| J21.5 | Opens Below threshold | Every lead held back for known acreage under the threshold, by source and campaign, and every lead an SUL closed below threshold, with the SUL who logged it; nothing to action, everything to count | Your answer (17 Sept); Your answer (30 Sept, review r1) | R |
| J21.5a | Opens "No valid number" | Leads closed because they had no valid number and matched no grower who has one, by source and campaign, with possible matches for a person to confirm; a later signal from the same grower with a valid number becomes a normal lead carrying this history; unmatched ones are deleted after the period in P6-11 (Part 4, P4-18) | Your answer (21 Sept); Your answer (1 Oct, review r1) | R |
| J21.6 | Opens Rejected | Leads SULs rejected, with reason, source and SUL; Admin reassigns to the same or another SUL (the lead becomes New with fresh clocks), merges with another lead (P4-17), or removes with a logged reason | Your answer (17 Sept, reject); Your answer (30 Sept, review r1) | R |
| J21.7 | Opens Territories | The tree from zone to village; each BSA with its franchise; each territory's SUL; the gaps (villages in no BSA, BSAs without a franchise, territories without an SUL, leads placed by nearest franchise, pools); boundary file versions; edits here never touch a grower | Your answers (17, 18, 28 Sept); Part 7 | |
| J21.8 | Opens the audit trail | Everything in the one audit list (P6-15) | Canvas; Your answers (18 Sept); Your answer (30 Sept, review r1) | R |
| J21.9 | An SUL goes on leave, leaves or moves territory | On the RSM's request, Admin moves that SUL's open leads to a named SUL; each move is logged with who, why and when; the lead becomes New for the new SUL with fresh clocks; nothing moves automatically (P3-24) | Your answer (30 Sept, review r1) | R |
| J21.10 | A user leaves or changes role | Country IT tells Admin the same day; Admin deactivates the account, which ends every session at once; the phone's local data expires if it has not synced for the hours Ahsan sets and is wiped at the next connection; the deactivation is in the audit trail (P6-16) | Your answer (30 Sept, review r1) | R |

#### J22 — Monday morning summary

| Step | Who | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J22.1 | RSM, ZM, Head of Sales, each PM | One WhatsApp message in English at 9 am Pakistan time: last week at their own level — leads received, contacted on time, completed, completed on time, converted, PKR, overdue now, and the one SUL or territory (or brand, for a PM) furthest below its target (P3-21) | Your answer (18 Sept, weekly); Audit keeper; Your answers (30 Sept, 1 Oct, review r1) | R |
| J22.2 | — | Each send is logged with who received what; the message names no grower | Audit lesson (no record of sends); Invariant 7 | |

### 3.4 Rules that hold on every manager, marketing and admin screen

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P3-1 | Every level sees the level below it **named**, plus its own total. Nothing is aggregated past the person or territory behind it. | A ZM sees regions by name, then territories by name, never "Zone total" alone. | Canvas; Your input (15 Sept) | |
| P3-2 | One definition per number, everywhere: a "conversion", "on time", "received" mean the same thing on every screen and in every summary. A definitions page states each one, including the difference between leads below threshold on arrival and leads closed below threshold later, and a reconciliation view shows that the totals agree. *Revised 1 Oct (review r1, N28).* | Marketing's converted count for a campaign equals the sum of the RSMs' converted counts for it. | Canvas (one semantic layer); Audit keeper (definitions and sign-off); Your answer (1 Oct, review r1) | R |
| P3-3 | The RSM opens a full lead card, grower number included, only for an overdue, flagged or pool lead; other leads in the region open without the number. Every opening of a number is logged. ZM, Head of Sales, Leadership, PMs and Marketing see progress, gaps and analytics and never a grower's name, number or village. *Revised 1 Oct (review r1, S54): narrows the 18 Sept answer.* | J14.3, J16.3, J18.3. | Your answer (18 Sept, manager view); Your answer (1 Oct, review r1); DECISIONS 2026-10-01 | R |
| P3-4 | The **flag** is the one way a manager acts: a note and a due-by day, one level down only. An RSM flags a lead for an SUL. Head of Sales flags a zone for its ZM; a ZM or a PM flags a region or territory for its RSM (a PM through the ZM). A lead flag is answered at the SUL's next action on the lead or by a reply (P2-23); a zone, region or territory flag is answered when its receiver replies or flags one level down. A flag passed down is a new flag linked to the one above, so the first sender sees each step and when it was answered. *Revised 1 Oct (review r1, S25, S8).* | J14.4, J16.4, J19.3. | Your answers (17, 18 Sept); Your answer (30 Sept, review r1) | R |
| P3-5 | Two on-time rates, contact and completion, contact first, at every level. | "Contacted on time 78% · Completed on time 61%". | Part 1 (P1-43) | |
| P3-6 | "Short of leads" and "short of follow-up" are shown as separate numbers on every ZM and Head of Sales view: leads received per territory, and the on-time rates. "Short of leads" means leads received per territory below the zone's median for the period; "behind" means furthest below target among units with at least 10 leads due (P3-21). *Revised 1 Oct (review r1, S26).* | J16.2. | Canvas; Your answer (18 Sept); Your answer (30 Sept, review r1) | R |
| P3-7 | Period presets everywhere: today, this week, month to date, quarter, year, season, custom; every number says its period. "Year" and "quarter" are calendar periods; "season" is the crop year (P6-13); a week runs Monday to Sunday, Pakistan time. *Revised 1 Oct (review r1, S102).* | A period control at the top of every dashboard. | Your input (15 Sept); Audit keeper; Your answer (30 Sept, review r1) | R |
| P3-8 | Honest reporting: a non-dismissible notice when data is incomplete — a connected stream is failing, or the dashboard figures are older than the hours Ahsan sets — naming the cause; downloads stay allowed but every file carries the same warning; every export and summary says "as of" and how many records; unresolved rows (unmatched village, unknown acreage, held campaign signals) counted openly, never hidden. *Revised 1 Oct (review r1, S66, S36).* | "Data as of 08:00 · 4,212 leads · 37 with unmatched village"; "Incomplete: WhatsApp failing since 09:40". | Audit keepers; Your answers (30 Sept, 1 Oct, review r1) | R |
| P3-9 | Exports exist for Marketing (aggregate only) and Admin. No manager or SUL exports a list. Every export is logged. | No export button on RSM, ZM, Head of Sales, PM or SUL screens. | Your answer (18 Sept, controls) | |
| P3-10 | Settings changes (threshold, clock promises, weights, campaign promises) are made by Admin alone, are recorded with who, when and the previous value, and notify Head of Sales (every stakeholder for weights, P5-14). Every setting has a minimum and a maximum (A.2) and a value outside them is refused. A change to the threshold or a promise applies to leads that reach an SUL after the change; open leads keep their segment and due times. *Revised 1 Oct (review r1, S28, S95, N12).* | J21.2, J17.5. | Your answer (18 Sept, controls); Canvas (weights audited); Your answers (30 Sept, 1 Oct, review r1); DECISIONS 2026-10-01 | R |
| P3-11 | The regional pool is the RSM's: leads that cannot be placed in a territory are assigned by the RSM by hand, and a pool-assigned lead takes the chosen SUL's territory as its placement; clocks start when the SUL's phone receives it; Admin sees pool sizes and unmatched villages by region. *Revised 1 Oct (review r1, N20, S5).* | J15. | Your answer (18 Sept, pool); Your answers (30 Sept, 1 Oct, review r1) | R |
| P3-12 | Below-threshold leads appear only on Admin's list and as labelled counts on Marketing, PM and Leadership views. | J19.1, J20.1, J21.5. | Your answer (17 Sept) | |
| P3-13 | Everything in the one audit list (P6-15) is in the audit trail. *Revised 1 Oct (review r1, S53).* | J21.8. | Canvas; Your answers (18 Sept); Your answer (30 Sept, review r1) | R |
| P3-14 | Notifications to managers: a breach in their scope, a flag answered, a settings change (Head of Sales; every stakeholder for weights). In-app and push. RSM and ZM receive breaches as a digest at 08:00 and 14:00 (Admin settings) with counts by SUL, plus one push for each breached Hot contact promise; no push between 21:00 and 07:00 Pakistan time. The manager above sees when each report last opened their breach list. Head of Sales receives breaches as one daily digest at 8 am. *Revised 1 Oct (review r1, S27).* | J17.3. | Part 1 (P1-42); Your mark (18 Sept, digest); Your answer (30 Sept, review r1) | R |
| P3-15 | Connection health is on the Admin portal before anyone notices missing leads: state per connection (streams, Hina, address service), last item received, items held back and why, requests refused for a bad signature. | J21.4. | Canvas; Your answers (30 Sept, 1 Oct, review r1) | R |
| P3-16 | Campaigns are created by Admin from Marketing's definition with: name, NPI or not, portfolio, brand or crop programme, product, crop, start and end dates, contact and completion promises (required; a campaign cannot be saved without them, and neither may be shorter than the campaign-promise floor in A.2 Settings), budget, actual spend, and an optional talk track in Urdu and English. A signal after the end date still carries the campaign, labelled "after end". *Revised 1 Oct (review r1, S33, S30, S34, S107).* | J20.3, J21.3. | Your answers (17, 18 Sept); Your answer (30 Sept, review r1) | R |
| P3-17 | The weekly WhatsApp summary goes to RSMs, ZMs, Head of Sales and PMs on Monday at 9 am at their own level, in English, through the messaging service and approved template listed on Connections, to the staff mobile number on each user; Leadership gets the monthly page; SULs get nothing by WhatsApp. Every send is logged; no grower is named. *Revised 1 Oct (review r1, N6, N43).* | J22. | Your answer (18 Sept, weekly); Your answer (1 Oct, review r1) | R |
| P3-18 | The monthly leadership summary is produced by Synapse on the first working day of the month (P5-30), includes the unflattering numbers, and never names a grower. For the month and the month before it holds: leads received by source and campaign; conversions and PKR by zone and portfolio; both on-time rates by zone; the Pilot's numbers against baseline and target (P1-44); time from signal to first contact (P5-31a); the engine-versus-plain-list comparison (P5-33); and the counts of below-threshold, no-valid-number, pool, rejected and Hina-waiting leads, each marked as risen or fallen. Delivered by email as a one-page document and shown in the dashboard. *Revised 1 Oct (review r1, S44).* | J18.2. | Your answer (17 Sept); Canvas; approved with Part 3; Your answer (30 Sept, review r1) | R |
| P3-19 | Admin's territory edits (zones, regions, territories, BSAs, SUL assignment) never change a grower's record; a boundary change re-routes future leads only. Open leads stay with the SUL who has them. | J21.7. | Your answer (17 Sept, territory); approved with Part 3 | R |
| P3-20 | Manager and marketing dashboards work on the phone for RSM, ZM, Head of Sales and PMs, and on desktop for Marketing, Admin and Leadership. They need signal; nothing is cached for offline use. | A ZM on the road sees the dashboard when there is signal. | Your input (15 Sept, "mobile dashboard"); Canvas | |
| P3-21 | **Targets.** Head of Sales recommends targets; Admin or DBO enter them. Targets exist for the contact and completion on-time rates, leads converted, sales value (PKR) and leads followed up. Admin can change the target rules or switch any target off. "Behind" is measured against the targets on manager views only; SULs see no ranking (P2-11). A target is not an incentive: no PKR figure is linked to incentives while D7 is open. *Added 1 Oct (review r1, S26).* | "Contacted on time 78% · target 85%" on the RSM's view. | Your answer (30 Sept, review r1); DECISIONS 2026-10-01 | R |
| P3-22 | A zone, region or territory that is not live in the Pilot shows "not live", never zeros; "national" is labelled with the live zones. *Added 1 Oct (review r1, S101).* | "National — Pilot, 2 of 4 zones". | Your answer (30 Sept, review r1) | R |
| P3-23 | Not-converted reasons are counted by zone, region, territory and BSA and shown to every stakeholder at their own level. *Added 1 Oct (review r1, S91).* | "No stock at the franchise: 14 in BSA Sahiwal-3 this week". | Your answer (30 Sept, review r1) | R |
| P3-24 | **Moving open leads.** Only a person moves a routed lead: on the RSM's request, Admin moves an SUL's open leads to a named SUL (leave, departure, territory change); each move is logged with who, why and when, the lead becomes New for the new SUL with fresh clocks, and any breach before the move stays with the first SUL. Nothing is reassigned automatically or by rule. *Added 1 Oct (review r1, S23, S24).* | J21.9. | Your answer (30 Sept, review r1); DECISIONS 2026-09-15 | R |

### 3.5 Decisions this part rests on

| ID | Decision | State | What it means for this part |
|---|---|---|---|
| D3 | Campaign ID convention | Open — Marketing via Ahsan, decided in M5 | Campaign reporting (J19, J20) depends on the campaign surviving from ad to lead; Admin's campaign record is the Synapse side of it. A campaign signal whose campaign cannot be read is held until it can be (P4-11). |
| D6 | Territory versus franchise catchment conflict | Open — sales leadership | Not needed here; no franchise appears on any manager view in the Pilot. |
| D7 | Conversion value declared or reconciled | Open | Every PKR figure on every dashboard is self-declared with a receipt; no dashboard number is linked to incentives until D7 is decided. |
| — | Eight personas; two clocks notify-only; threshold as a setting | Decided | All of Part 3. |

### 3.6 Question log (Part 3)

| # | Question | Answer (date) | Rows |
|---|---|---|---|
| 1 | How much of a lead does a manager see? | RSM: full card. ZM and above: progress, gaps and analytics, no grower details (18 Sept) | P3-3, J14.3, J16.3 |
| 2 | What is a flag? | A note and a due-by day; the lead sorts to the top; one level down (18 Sept) | P3-4 |
| 3 | Who works the regional pool? | The RSM assigns by hand; clocks start then; Admin sees pool sizes (18 Sept) | P3-11, J15 |
| 4 | Weekly summary: who and what? | RSM, ZM, Head of Sales, PMs; Monday 9 am; own level (18 Sept) | P3-17, J22 |
| 5 | How does a PM follow up? | PM flags the ZM, ZM flags the RSM (18 Sept) | P3-4, J19.3 |
| 6 | Where does campaign spend come from? | Marketing enters it on the campaign record; cost per lead shown; blank shows "no spend entered" (18 Sept). Cost per lead moved out of scope for now (1 Oct, review r1, S37) | P3-16, J20.2 |
| 7 | Second person on settings? Who exports? | Admin alone, logged, Head of Sales notified; exports for Marketing and Admin only (18 Sept) | P3-9, P3-10 |
| 8 | Head of Sales: what beyond a ZM? | All zones side by side plus national on-time rates (17 Sept) | J17 |
| 9 | Leadership: screen or report? | Both: dashboard and a monthly summary (17 Sept) | J18, P3-18 |
| 10 | Head of Sales: one notification per breached lead, or a digest? | Daily digest at 8 am; RSM and ZM still get one per lead (18 Sept) | J17.3, P3-14 |
| 11 | Two gaps marked ASSUMPTION | Approved with Part 3 (18 Sept): monthly summary by email and in the dashboard (P3-18); open leads stay with their SUL when a boundary changes (P3-19) | P3-18, P3-19 |

### 3.7 Where the canvas or the audit differs (Part 3)

| DR | Spec | Canvas or audit | Note |
|---|---|---|---|
| DR-15 | RSM assigns from the pool but never reassigns a routed lead | Canvas: RSM reassigns breached leads within 24 hours | Follows your notify-only rule (DR-3). |
| DR-16 | Weekly WhatsApp summary, Monday 9 am | Smart Agro Lite: daily at 9 am | Your answer, 17 Sept. |
| DR-17 | ZM and above see no grower details | Canvas: sales scope is own level and everything beneath, which included grower detail | Your answer, 18 Sept; fewer people can see personal data. |
| DR-18 | Single sign-on not in the Pilot; Syngenta email plus a Synapse password | Canvas: SSO where available | Your answer, 21 Sept; in Part 6's out-of-scope list. |
| DR-39 | No periodic access review; Admin changes, adds and removes roles on the communications it receives | Canvas Z00: access review surfaced in Admin | Your answer, 30 Sept (review r1, S52). Recorded 1 Oct. |

## Part 4 — Where leads come from, and one grower

### 4.1 How a lead arrives

Nine lead streams and one purchase stream, each its own connection, each
optional: Synapse runs correctly with three connected and the rest not.
Nothing arrives by upload. A signal is kept the moment it arrives and becomes
a lead at once; reading the grower's intent from their words follows, and
routing waits for it only for a short, fixed time (P4-10). A lead with a gap
waits for Hina (Part 5). The same
signal twice never makes a second lead. Nothing is lost silently: a signal
Synapse cannot accept is held, retried, and shown to Admin with the reason.
One stream failing never stops another. Every signal is attached to one
grower, identified by their mobile number, so a grower who scans, chats and
messages is one grower with one lead and one history.

### 4.2 The streams

Nine at the start, plus e-commerce purchases added on 21 September. The list
can grow or shrink; each stream has its own row and its own rule. Every
stream is marked **to confirm with the system owner**: the intended
connection is stated, and the M2 spike proves the first one.

| Stream | What the grower did | What Synapse learns | How it arrives | Owner to confirm | Blocked by | Came from | Mark |
|---|---|---|---|---|---|---|---|
| **Crop Doctor scan** | Photographed a crop in Cropwise and got a diagnosis | Crop, diagnosis, how severe, how sure, location, Cropwise grower ID, number where Cropwise has it | Pulled from the Cropwise platform on a schedule | Cropwise Pakistan tenant owner (global digital or country IT) | D2 (access) | Your input (15 Sept); Canvas | |
| **Savera conversation** | Talked to the Savera agent for advice; Savera recommended products | Crop, problem, products discussed, acreage if stated, buying questions | Transcripts pulled from the Cropwise platform | As above | D2 | Your input (15 Sept); Canvas | |
| **Cropwise community post** | Posted or commented in the in-app community | Crop, problem described, intent in the words, engagement | Pulled from the Cropwise platform | As above | D2 | Your answer (17 Sept, sources); Canvas | |
| **WhatsApp inbound** | Messaged Syngenta's WhatsApp number: asked a price, asked advice, said they want to buy | Message text, intent read from it, the number itself | Arrives as each message is received, through the messaging provider | Digital team (the provider account) | — | Your input (15 Sept); Canvas; Your answer (1 Oct, review r1, N31) | R |
| **Facebook** | Filled a lead form on an ad, or messaged the page | Form fields, message intent, campaign and ad | Arrives as each form or message is received, from the Meta platform | Marketing (the ad account) | D3 (campaign convention) | Your answer (17 Sept); Canvas | |
| **TikTok** | Filled a lead form on an ad | Form fields, campaign | Arrives as each form is received, from the TikTok platform | Marketing | D3; TikTok lead forms available for the Pakistan account, to confirm | Your answer (17 Sept); Canvas | |
| **Call centre** | Called the centre, or was called back | Agent's note: grower, number, crop, acreage, what they asked | The centre's own platform feeds Synapse; if it cannot, a short Synapse form for agents; decided in the M2 spike | Call-centre manager | Which platform the centre runs | Your answer (21 Sept); Canvas | |
| **NPI campaign** | Responded to a new-product campaign | Campaign, product, creative, what they did on landing | Arrives from the campaign platform, carrying the campaign under the agreed convention | Marketing | D3 | Your input (15 Sept, campaigns); Canvas | |
| **Brand campaign** | Responded to a brand-level or crop-programme campaign | Campaign, brand or programme, creative, what they did on landing | As above | Marketing | D3 | Your input (15 Sept); Your answer (17 Sept, campaigns); Canvas | |
| **E-commerce purchase** *(added 21 Sept)* | Bought on Syngenta's e-commerce channel | Product, quantity, value, date — only for growers with confirmed acreage at or above the threshold (P4-27a); never creates a lead | Pulled from the e-commerce platform on a schedule | E-commerce owner, to confirm | Which platform; whether it carries the grower's number | Your answer (21 Sept); Canvas (e-commerce); Your answer (30 Sept, review r1) | R |

Marketing's own WhatsApp campaigns are sent outside Synapse from the number
its owner names in this table; that owner handles requests to stop messaging
outside Synapse. A reply to such a campaign arrives on WhatsApp inbound, is
filed under the WhatsApp channel and is credited to the campaign under the D3
convention. *Added 1 Oct (review r1, N27, N26).*

### 4.3 Rules for every stream

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P4-1 | Every stream is a separate connection and every stream is optional. Synapse runs correctly with any subset connected; no stream waits on another. Hina and the address service are connections too, and Synapse runs correctly with either switched off (P5-5). *Revised 1 Oct (review r1, S113, N2).* | Admin's Connections page shows ten stream rows plus Hina and the address service; three streams "connected", the rest "not yet connected", and leads flow from the three. | Your answer (17 Sept, sources); Canvas; Your answers (30 Sept, 1 Oct, review r1) | R |
| P4-2 | No lead ever arrives by upload. There is no import screen anywhere. | No spreadsheet path exists. | Your input (15 Sept); Audit lesson | |
| P4-3 | For streams that push (WhatsApp, Facebook, TikTok, campaigns), a lead with no gap reaches the SUL's phone within the minutes Ahsan sets of the grower acting. Pulled streams (Cropwise streams, call centre, e-commerce) are checked every so many minutes, an Admin setting per stream, and a lead with no gap reaches the phone within one check plus the same minutes. A lead with a gap reaches the SUL at Hina's handover (P5-5). *Revised 1 Oct (review r1, S57).* | A grower messages at 10:02 with no gap; the SUL's phone shows the lead within the set minutes. | Canvas; Your answer (1 Oct, review r1) | R |
| P4-4 | The same signal arriving twice never makes a second lead; it merges into the existing one. | A provider resends yesterday's message; the lead's history shows one signal, not two. | Invariant 3 | |
| P4-5 | Nothing is lost silently. A signal Synapse cannot accept is held, retried, and listed for Admin with the reason; when the cause is fixed the held signals flow through. | Connections shows "WhatsApp: 12 held — provider error since 09:40"; at 10:10 the count is 0. | Canvas; Audit lesson (silent drops) | |
| P4-6 | One stream failing never stops another or slows the rest. | Facebook is down for a day; WhatsApp leads keep arriving on time. | Invariant 9 | |
| P4-7 | A bad value is rejected and reported, never guessed. No made-up location, no "today" for a missing date, no zero for a missing acreage. | A signal with an impossible location is held with "location invalid"; nothing is stored as 0. | Audit lesson (§7.11) | |
| P4-8 | The grower's original words and the original signal are kept unchanged, so a lead can be re-read and the reading improved later, until the retention rule removes them (P6-11). The original signal is personal data: retention strips its name and number and it never appears in an export. *Revised 1 Oct (review r1, N3).* | The lead card shows the grower's own message under "What they said". | Canvas; Your answer (21 Sept, unsure intent); Your answer (1 Oct, review r1) | R |
| P4-9 | Intent is read from the grower's words in Urdu, English, regional languages and transliterated Urdu, with a confidence. A reading of "buy" counts only at or above a minimum confidence (an Admin setting; its starting value comes from the test below); under it, the reading is "unclear". When the reading is unclear, the lead is held for Hina, who asks the grower (Part 5); if Hina cannot reach them, the lead goes to Potential marked "intent unclear" and cannot be Hot until the SUL confirms intent on the call with one tap ("wants to buy" / "advice only"). Before the Pilot, intent reading is tested on anonymised real messages labelled by the field, split by language, against a minimum accuracy for "buy" and a maximum share of "unclear" set by Ahsan; the gate sits in M4. Hina's and the SUL's answers improve the reading. *Revised 21 Sept for Hina. Revised 1 Oct (review r1, N5, S74).* | The card shows "Intent unclear — confirm on call"; after "wants to buy" the lead re-scores. | Your answer (21 Sept); Canvas; Your answers (30 Sept, 1 Oct, review r1) | R |
| P4-10 | The lead record exists the moment the signal arrives; the intent reading follows. Routing waits for the reading for at most the seconds Ahsan sets, then treats intent as "unclear" (P4-9). *Revised 1 Oct (review r1, S81).* | A lead arrives with "reading…"; if the reading has not come back in time it is treated as unclear. | Canvas (AI never in the delivery path); Your answer (1 Oct, review r1) | R |
| P4-11 | A campaign lead carries its campaign from the ad to the lead under the one convention agreed with Marketing (D3). A campaign signal whose campaign cannot be read is **held**, not routed, and listed for Admin. When the campaign becomes readable (D3 agreed, or a mapping fixed), Admin releases the held signals of a stream in one action, each carrying its campaign; Marketing sees how many are held per campaign stream. Until D3 is agreed in M5, campaign signals without a readable reference wait. *Revised 1 Oct (review r1, S35, S36).* | Connections shows "3 campaign signals held — campaign not readable"; after the fix, Admin releases them and they route. | Canvas; D3; Your answer (30 Sept, review r1); DECISIONS 2026-10-01 | R |
| P4-12 | A healthy Crop Doctor scan becomes a lead only when the grower's known acreage is at or above the threshold (Part 1, P1-25). Below it or unknown: history only. *Revised 1 Oct (review r1, S68): observable added.* | A healthy scan from a 6-acre grower shows on the timeline as "Scan: healthy — no lead (below threshold)". | Your decision D9; Your answer (30 Sept, review r1) | R |
| P4-13 | Every stream is marked "to confirm with the system owner" with the owner named where known; the M2 spike proves the first stream end to end before the rest are built. | The table in 4.2. | Your answer (17 Sept, live feeds) | |
| P4-14 | Call-centre capture tries the centre's own platform first; if it has no way out, agents get a short Synapse form: number, grower's name, village, tehsil and district, crop, acreage, and intent as a pick (wants to buy / advice only) with what they asked. The call centre is part of DBO, which looks after it; agents log in under DBO (P1-5a). The choice is made in the M2 spike. *Revised 1 Oct (review r1, S13, S14).* | Either no new screen for agents, or one short one. | Your answer (21 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| P4-15 | Connection health is visible to Admin before anyone notices missing leads: state per stream, last lead received, signals held and why. | J21.4. | Canvas | |

### 4.4 One grower

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P4-16 | A grower is identified by their mobile number. One number belongs to exactly one grower. A number is **verified** once a message was received from it or a Hina or SUL contact reached the grower on it. A signal carrying an unverified number (typed into a form) that matches an existing grower whose name or village differs is held as a possible match (P4-19) instead of joining that grower. *Revised 1 Oct (review r1, S56).* | Two signals with the same number are one grower; a form with a mistyped digit that hits another grower's number waits for a person to confirm. | Invariant 2; Your answer (18 Sept); Your decision D4; Your answer (30 Sept, review r1) | R |
| P4-17 | There is no split action. A wrong or changed number is corrected by the SUL on the grower's profile; the change is kept with who and when; Admin can undo it; a number already on another grower cannot be saved on a second one. When one person turns out to have two grower records (two numbers), Admin merges them by choosing the surviving record: the other's signals, leads and history move to it; its number is kept on the survivor as a known alternate so later signals from it route there; conflicting confirmed values keep the more recent, with both shown; the merge is logged and Admin can undo it. *Revised 1 Oct (review r1, S55).* | J8; Admin's merge screen shows both records side by side before saving. | Your answer (18 Sept); see DR-13; Your answer (30 Sept, review r1) | R |
| P4-18 | A lead is routed only when the grower has a valid number. A signal with no number is first matched to an existing grower who has one, by the rule in P4-19; if it matches, it joins that grower and is routed normally. Otherwise the lead is **closed as "no valid number"**, never routed, and listed on Admin's "No valid number" list, counted in source and campaign totals. If the same grower later sends a signal with a valid number, that signal becomes a normal lead carrying the earlier history. A closed lead that never matches a grower is deleted after the period in P6-11. *Revised 1 Oct (review r1, N38, N4): reverses the 21 Sept "no contact" hold.* | A community post with a name and village but no number is closed as "no valid number"; when the same grower messages on WhatsApp a week later, a new lead appears carrying the post in its history. | Your answer (21 Sept, re-asked); Canvas (nothing enters unattached); Your answer (1 Oct, review r1); DECISIONS 2026-10-01 | R |
| P4-19 | A no-number signal joins an existing grower automatically only when village and crop match exactly and the name matches after normalisation (spelling and transliteration rules kept in Admin). Any weaker match is shown to Admin as a "possible match" and is never attached without a person confirming. *Revised 1 Oct (review r1, S58).* | Admin's "No valid number" list shows "possible match: <name>, <village>" for a person to confirm. | Canvas (secondary matching); Your answer (30 Sept, review r1) | R |
| P4-20 | When two sources give different values for the same thing (name spelling, village, acreage), the most recent verified value wins and Synapse remembers where each value came from. An acreage **confirmed** by an SUL is never overwritten by an **estimated** one from a source. | The profile shows "Acreage 25 (confirmed by SUL X, 4 Oct)"; a later scan saying 18 does not change it. | Canvas; Your input (16 Sept) | |
| P4-21 | The grower's profile holds: name, number, village and location (province, district, tehsil, village, and map position with its source and whether an SUL confirmed it, P7-10), crops grown, acreage (per crop where known, with estimated/confirmed), preferred language (Urdu or English; Hina always calls in Urdu, P5-3), the new/existing mark, and last season's status. *Revised 1 Oct (review r1, S83, N13).* | One profile screen; the lead card draws from it. | Canvas; Your input (15, 16 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| P4-22 | Every scan, message, call, visit, campaign touch, purchase and outcome is one timeline on the grower, across seasons, marked by season. | J12.1; P2-13. | Canvas | |
| P4-23 | **Consent.** Any contact with Syngenta through any stream is the consent basis for a sales contact about that need. Every lead records which stream and date the consent came from, stamped automatically from the incoming signal; the card shows it. *Revised 1 Oct (review r1, S108).* | "Consent: Crop Doctor scan, 3 Oct" · "Consent: WhatsApp message, 5 Oct". | Your decision D1 (18 Sept); Invariant 1; Your answer (1 Oct, review r1) | R |
| P4-24 | There is **no opt-out** in this specification, for growers or for SULs. A grower's request to stop, in any channel, is a message on the lead like any other and is left to the SUL's judgement. Opt-out returns only as a change request (6.3.2). *Revised 1 Oct (review r1, S96): wording only.* | No opt-out control anywhere; the consent basis (P4-23) is the whole consent record. | Your answer (21 Sept, "no opt-out option for now"); see DR-19 | R |
| P4-25 | A STOP, "band karo" or similar on WhatsApp appears in the lead's history as a message; Synapse takes no opt-out action on it, and the message is scored like any other. *Revised 1 Oct (review r1, N17): wording only.* | The message under "What they said". | Your answer (21 Sept); Your answer (1 Oct, review r1) | R |
| P4-26 | Growers below the acreage threshold and growers with no lead this season keep a profile and a history; only routing changes. | The grower exists on Admin's lists and in totals. | Your answer (17 Sept, under-threshold); Part 1 | |
| P4-27 | Nothing is stored about a grower that no stream, Hina or SUL gave, apart from coordinates converted from an address the grower gave. No purchased lists, no outside enrichment. The list of streams can grow or shrink; each addition is a stream with its own row in 4.2 and its own rule. *Revised 1 Oct (review r1, S110).* | The profile holds only what the streams, Hina and the SUL put there, and coordinates converted from a given address. | Your answer (21 Sept, re-asked); Your answer (30 Sept, review r1) | R |
| P4-27a | **E-commerce purchases** are an added stream: a purchase on Syngenta's e-commerce channel becomes a signal only for a grower whose acreage is **confirmed** and at or above the threshold. A purchase never creates a lead: it goes on the grower's timeline, feeds the grower-history ingredient, and re-scores an open lead if one exists. Orders from buyers who are not such growers are discarded on arrival and never stored or logged. *Revised 1 Oct (review r1, S67, S109).* | A confirmed 30-acre grower's online order appears on their timeline and re-scores their lead; a 10-acre or unconfirmed grower's order does not enter Synapse. | Your answer (21 Sept, re-asked); Canvas (e-commerce under pulled sources); Your answer (30 Sept, review r1) | R |

### 4.5 The lists Synapse depends on

| List | Holds | Kept by | Refreshed | Came from | Mark |
|---|---|---|---|---|---|
| **Sales structure** | Zones (four), regions, territories, BSAs with their franchise name and point, which villages belong to each BSA, and which SUL owns each territory | Owner: Digital Business Operations (DBO) — *revised 21 Sept from Sales Operations: "anything operational is owned by DBO"*; Admin has full access | When changed; every change logged | Your answer (17 Sept, territory); Audit keeper (one territory master) | |
| **Grower location list and boundaries** | Provinces, districts, tehsils, villages; the digitised village boundaries for Punjab and Sindh; SUL location points | Owner: the digital team (Admin) for the boundary files, address conversion and SUL points — *revised 28 Sept*; DBO for village-to-BSA assignment | Boundary file loaded as a whole, previous version kept | Your answer (17 Sept); P2-22 | |
| **Products** | Syngenta products by portfolio and brand, with the crops and problems each treats (including preventive rows for healthy scans), for the recommended product and the conversion pick-list | Owner: the Portfolio Managers, who approve every row for their portfolio; DBO maintains the list when they ask; Admin has full access — *revised 1 Oct (review r1, S92, N36)* | When changed | Canvas; Your answers (18 Sept; 30 Sept, 1 Oct) | R |
| **Season timing table** | Crop, problem, zone (or province) and the months the treatment applies; a missing zone row falls back to the national row | Owner: the Portfolio Managers; DBO maintains it when they ask — *revised 1 Oct (review r1, S92, S75)* | When changed | Your answers (21 Sept; 30 Sept) | R |
| **Campaigns** | Every campaign as defined in Part 3 (P3-16) | Admin, from Marketing | When created or edited | Your answer (17 Sept) | |
| **Users** | Everyone who can log in, their role and scope, with a change history | IT (login), Admin (role and scope) | When changed | Your answer (17 Sept, Admin) | |
| **Settings** | The acreage threshold, the four Hot and Potential clock promises, the campaign-promise floor, the scoring weights, the yearly pause-day list and the working week, the targets, the acreage bands, the retention period, and the rest in A.2 | Admin; targets entered by Admin or DBO on Head of Sales' recommendation | When changed; every change logged and Head of Sales notified (every stakeholder for weights) | Your answers (17, 18 Sept; 30 Sept, 1 Oct) | R |

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P4-28 | Each part of a list has one named owner who is told when a row is rejected or a value is missing; a product row's notice goes to the PM of that product's portfolio; rejected rows are reported, never dropped. *Revised 1 Oct (review r1, N36).* | "Sales structure: 2 territories with no SUL — owner notified". | Canvas (named steward); Audit keeper; Your answer (1 Oct, review r1) | R |
| P4-29 | A lead is placed by the grower's coordinate: inside a digitised village boundary it takes that village's BSA and territory; elsewhere the nearest franchise point within a cap; with no coordinate a complete address is converted to one; otherwise the regional pool. *Revised 28 Sept; the full rules are Part 7.* | J15; Part 7. | Your answers (17, 28 Sept); Part 3 (P3-11) | R |
| P4-30 | Editing a list never edits a grower. | P3-19. | Your answer (17 Sept) | |

### 4.6 Decisions this part rests on

| ID | Decision | State | What it means for this part |
|---|---|---|---|
| D1 | Consent basis for advisory-captured data | **Decided 2026-09-18** — any contact with Syngenta is the consent basis | P4-23; Cropwise-sourced growers routed from day one; the M6 gate in the plan is lifted. |
| D2 | Who owns Cropwise platform access for Pakistan | Open — action: Ahsan files the request | The three Cropwise streams cannot be connected until answered; they are specified here regardless. |
| D3 | Campaign ID convention | Open — Marketing via Ahsan, decided in M5 | P4-11; campaign signals whose campaign cannot be read are held until it can be. |
| D4 | Mobile number as key; shared-number rule | **Decided 2026-09-18** — one number, one grower, no split, SUL corrects; no-number rule changed 1 Oct (P4-18) | P4-16 to P4-18. |
| D9 | Healthy scan rule | Decided | P4-12. |

### 4.7 Question log (Part 4)

| # | Question | Answer (date) | Rows |
|---|---|---|---|
| 1 | How is consent recorded per stream? | Any contact with Syngenta is consent (18 Sept) | P4-23 |
| 2 | Is that leadership's position or an interim default? | Leadership's position; D1 decided (18 Sept) | 4.6 |
| 3 | How does a grower opt out? | First "via the SUL only"; then, on the STOP-message question: no opt-out option for growers or SULs for now (21 Sept) | P4-24, P4-25 |
| 4 | Is a signal with no number routed? | First answer "routed anyway"; changed the same day on re-asking: routed only if there is a number, otherwise matched to an existing grower or held on Admin's "no contact" list and merged when a number arrives (21 Sept). Changed 1 Oct (review r1, N38): with no valid number the lead is closed | P4-18, P4-19 |
| 5 | What happens when intent is unclear? | Potential, marked, never Hot until the SUL confirms (21 Sept) | P4-9 |
| 6 | Call-centre capture? | Platform feed first, Synapse form if it cannot; decided in M2 (21 Sept) | P4-14 |
| 7 | Named campaigns? | Marketing names them; brand-level or crop programme; Admin creates (17 Sept) | 4.2, P3-16 |
| 8 | Live feeds today? | Each marked "to confirm with the system owner" (17 Sept) | P4-13 |
| 9 | Territory shape? | Sales hierarchy separate from grower location (17 Sept) | 4.5, P4-29 |
| 10 | What happens to a WhatsApp STOP? | Nothing; no opt-out (21 Sept) | P4-25 |
| 11 | Any outside data on growers? | First answer pressed by accident; re-asked: none beyond the streams and SULs, but streams may be added or removed — e-commerce purchases added, for confirmed acreage at or above the threshold only (21 Sept) | P4-27, P4-27a, 4.2 |
| 12 | Who owns the lists? | First: Sales Operations for structure and locations. Revised later the same day when the franchise list was asked: "anything operational is owned and managed by the Digital Business Operations team (DBO)" — so DBO owns structure, locations and franchises; Marketing with the PMs owns products and the timing table; Admin has access (21 Sept). Revised 1 Oct (review r1, S92): the PMs own and approve products and the timing table; DBO maintains them if required | 4.5, P5-25 |

### 4.8 Where the canvas or the audit differs (Part 4)

| DR | Spec | Canvas or audit | Note |
|---|---|---|---|
| DR-19 | Any contact with Syngenta is the consent basis; no opt-out in this specification | Canvas: consent basis, scope, timestamp, source and opt-out state per grower, explicit consent language at capture recommended; opt-out enforced across every channel | D1 decided by leadership, 18 Sept; no opt-out, 21 Sept. The record per lead is kept (stream and date), so the canvas's register still exists; the basis is broader and there is no way for a grower to withdraw it. The session 2.2 consent lens will raise this; it is recorded here so the reviewers argue against the decision, not discover it. |
| DR-20 | A signal with no number is matched to a grower who has one, or its lead is closed as "no valid number"; never routed | Canvas: every signal matches a grower or creates one, "nothing enters unattached" | Your re-answer of 21 Sept held such signals on a "no contact" list; changed 1 Oct (review r1, N38): the lead is closed, and a later signal with a valid number carries its history. Nothing is lost silently; the closed lead is counted. |
| DR-35 | Secondary match by name, village and crop only; no CNIC, no union council, no franchise affinity on the grower (P4-19, P4-21, P4-27) | Canvas L3: CNIC where available as a secondary key; union council; franchise affinity | Follows D4 and the 17 Sept location answer. Recorded 1 Oct (review r1, S119). |
| DR-21 | No split action; one number, one grower | Canvas: explicit split for shared and family numbers | DR-13 repeated here; D4 decided. |
| DR-22 | Product list only; no price or dose list in the Pilot | Canvas: product and price master synced nightly for value mapping | Follows DR-14 (no PKR estimate on the card) and the 17 Sept scoring answer (acreage instead of order value). |

## Part 5 — Scoring, routing and the clock, in detail

### 5.1 From signal to SUL

A signal has become a lead attached to one grower (Part 4). It is **scored
on arrival**, which sets its place in Hina's queue. Before it reaches an SUL,
three things happen in order. **Gaps are filled:** if the lead has a number
but no acreage, no crop, no clear purchase intent or no usable location,
Hina, the AI calling agent, phones the grower and asks; a lead with no gap
skips this step. **The lead is re-scored** with what Hina found, from five
ingredients and four adjustments, and placed in Hot, Campaign or Potential,
or closed below the threshold; only this score segments it. **The lead is
routed** to the SUL who owns the grower's territory, and its two clocks start
when the SUL's phone receives it. *Revised 1 Oct (review r1, N37, S5).* What the SUL logs comes back as an outcome the engine learns
from. Every step is recorded; nothing waits on a person except the SUL.

### 5.2 Filling the gaps — Hina, gap-filling

Hina is an AI voice agent built and run by a third party and connected to
Synapse. In this specification she asks; selling is a future change request
(see 5.8).

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-1 | A lead that has a number and is missing acreage, crop, clear purchase intent or a usable location (Part 7, P7-6) is **held for Hina** before any SUL sees it. A lead with no gap is routed at once. If the grower's earlier scan and Hina call already meet the handover criteria, Hina does not call again: the new lead goes straight to its segment with the latest activity. *Revised 1 Oct (review r1, N1, S80).* | A Crop Doctor scan with no acreage does not appear on the SUL's phone yet; a WhatsApp "what is the price, I have 30 acres of cotton" from a grower whose location is known appears at once. | Your answers (21 Sept, Hina 1 and 2); Your answers (30 Sept, 1 Oct, review r1) | R |
| P5-2 | Synapse decides which leads Hina calls, in what order (score on arrival, then age) and with what limit: **3 attempts over 2 days**, both Admin settings within their ranges (A.2); a change to the limits applies to leads sent to Hina after the change. What Hina says — her script and persona — is controlled and approved by Marketing for campaign leads and by Admin or DBO for non-campaign leads; the approved version is recorded on the Hina connection, and they can stop it. No disclosure line is required. *Revised 1 Oct (review r1, S46, N12): reverses "Hina decides only how she runs each call".* | Admin's settings show "Hina: 3 attempts, 2 days"; Hina's call list is ordered by Synapse; the connection shows "Script v4, approved by Marketing, 2 Oct". | Your answer (21 Sept, Hina 4); Your answers (30 Sept, 1 Oct, review r1); DECISIONS 2026-10-01 | R |
| P5-3 | Hina always calls in Urdu. She returns, per lead: acreage, crop, purchase intent (wants to buy / advice only / unclear), any location the grower gave, the outcome of each attempt (answered, no answer, wrong number, refused), and a plain-words summary in Urdu and English of at most the length Ahsan sets; a longer summary is rejected and logged. No recording and no transcript enter Synapse. *Revised 1 Oct (review r1, S111, S15, N13).* | The lead's history shows "Hina, 4 Oct 11:20: answered — 30 acres cotton, asked about price. Summary: grower has whitefly on 30 acres, wants to know price before deciding." | Your answer (21 Sept, Hina 3); Your answers (30 Sept, 1 Oct, review r1) | R |
| P5-4 | Acreage from Hina is marked **confirmed by Hina** and treated like an SUL's confirmation: it stays on the grower and is not overwritten by a later estimate. | "Acreage 30 (confirmed by Hina, 4 Oct)". | Your answer (21 Sept); Part 4 (P4-20) | |
| P5-5 | When Hina finishes — data obtained, attempts exhausted, or her window (Admin setting, 2 days) ends whatever the number of attempts — the lead is re-scored with what she found and goes into Hot, Campaign or Potential, or is closed below threshold. Synapse runs correctly with Hina not connected or switched off by Admin: every lead with a gap then routes at once with its gaps open, marked "Hina unavailable". The SUL's two clocks start when the SUL's phone receives the lead. *Revised 1 Oct (review r1, N2, S89, S5).* | Two days after arrival at most, the lead is on the SUL's phone or closed. | Your answers (21 Sept, Hina 2 and 3); Part 1; Your answers (30 Sept, 1 Oct, review r1) | R |
| P5-6 | A lead Hina could not reach is routed anyway, with its gaps still open, marked "Hina: no answer after <n> attempts"; the SUL asks on the call. "Refused" ends Hina's attempts and the lead routes marked "Grower refused Hina's call, <date>". "Wrong number" ends her attempts and the lead is closed as "no valid number" (P4-18). *Revised 1 Oct (review r1, S12, N38).* | Potential lead with "acreage unknown — Hina could not reach". | Your answer (21 Sept, Hina 2); Your answers (30 Sept, 1 Oct, review r1) | R |
| P5-7 | Hina never calls below-threshold growers, held signals, or leads with no gap. *Revised 1 Oct (review r1, S96): wording only.* | Hina's call list holds only routed-eligible leads with a gap. | Your answer (21 Sept, Hina 1) | R |
| P5-8 | Every Hina call is logged as an automated contact with the grower and is visible on the lead, on Admin's audit trail and in Connections (Hina as a connection with health). The Hina connection records the vendor's name, guaranteed calls per day, time to first attempt, what the vendor stores and for how long, deletion when Synapse anonymises a grower, the approved script version, and an off switch for Admin; the vendor is on the vendor register (P6-22). *Revised 1 Oct (review r1, S89, S47).* | Connections shows "Hina: connected, 41 leads waiting, 12 returned today". | Canvas (automated reads logged); Part 3 (P3-13); Your answer (30 Sept, review r1) | R |
| P5-9 | Synapse sends **no automated WhatsApp message** to growers. Hina is the only automated contact. Marketing may run its own WhatsApp campaigns outside Synapse to qualify leads; their responses arrive as campaign signals like any other (4.2). *Revised 1 Oct (review r1, S96): wording only.* | No template, no nurture content, no acreage question by WhatsApp. | Your answer (21 Sept, WhatsApp auto) | R |
| P5-10 | Hina's contact does not count as the SUL's contact; the SUL's contact clock starts when the SUL's phone receives the lead and stops at the SUL's first reached contact. | On-time rates measure the SUL, not Hina. | Part 1 (P1-39); Your answer (21 Sept); Your answer (30 Sept, review r1) | R |

### 5.3 The score

0 to 100 from five ingredients, then four adjustments. Weights are Admin
settings; every change is logged and reversible. The first engine is a
rule-based scorecard; it is never switched off.

**Points per level.** How many of an ingredient's points each level earns
(intent's four levels, acreage's "threshold" and "large", crop need's three
levels, timing's three), the acre figure for "large", the age floor, and what
a lead scores when crop-need severity is missing are set in one table that the
builder proposes during the build and Ahsan approves before any score ships.
Until then the scorecard is not live. Age counts from the lead's latest
signal. *Added 1 Oct (review r1, S63).*

| Weight | Ingredient | What it measures | Read from | Low → high | Came from | Mark |
|---:|---|---|---|---|---|---|
| **30** | Purchase intent | How explicitly the grower asked to buy | The grower's words (message, transcript, form, call-centre note, Hina's answer), read with a confidence; the SUL's one-tap confirmation | Passive scan → problem question → product question → price or purchase question | Canvas; Your answer (21 Sept, weights) | |
| **25** | Acreage | Sale potential | Confirmed (SUL or Hina) or estimated acreage; unknown scores zero here | Under threshold → threshold → large | Your answer (17 and 21 Sept) | |
| **20** | Crop need | How badly the crop needs treatment now | Crop Doctor diagnosis, severity and confidence; agronomic words in the message | Healthy or preventive → confirmed early → active and spreading | Canvas | |
| **15** | Season timing | Whether the treatment window is open | A crop-and-window table (crop, problem, zone, months) owned and approved by the Portfolio Managers in Admin; a missing zone row falls back to the national row; scores the middle value until a row exists | Window closed → opens soon → open now | Canvas; Your answer (21 Sept, timing); Your answer (30 Sept, review r1, S75, S92) | R |
| **10** | Grower history | Past relationship | Last season's status, prior outcomes, the new/existing mark, e-commerce purchases | New → known → previous buyer | Canvas; Your input (15 Sept) | |

| Adjustment | Effect | When | Came from | Mark |
|---|---|---|---|---|
| **Age** | −2 per day after the first 48 hours, down to a floor so age alone never reaches zero; any new signal from the grower resets the age | Every lead, daily | Canvas; Your answer (21 Sept, decay) | |
| **Reachability** | −15 while the grower's number has never been confirmed: no message received from it, no Hina or SUL contact that reached the grower | Numbers typed into forms until confirmed | Canvas; Your answer (21 Sept, adjustments) | |
| **Serviceability** | −10 where the grower's BSA has no franchise point (P7-3) | Needs the franchise points per BSA (P5-25, P7-3) | Canvas; Your answer (21 Sept, adjustments); Your answer (28 Sept, franchise per BSA); revised 1 Oct (review r1, S60) | R |
| **Repeat signals** | A new signal from the same grower merges into the open lead and raises its score; never a second lead | Every repeat | Canvas; Invariant 3 | |

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-11 | Every score carries its version and its breakdown, and shows its **top three reasons** in plain words in the SUL's language. The reasons are the three largest positive contributions, plus the largest penalty when it is over 10 points; each is a fixed Urdu and English sentence per ingredient level or adjustment with the grower's values filled in, and Marketing or Admin owns the wording. *Revised 1 Oct (review r1, S65).* | "Asked the price on WhatsApp · 30 acres, confirmed by Hina · Spray window open for cotton whitefly". | Invariant 8; Canvas; Your answer (30 Sept, review r1) | R |
| P5-12 | SULs see the order and the reasons, not the number. Managers and Admin see the 0–100 number. | No score number on any SUL screen; "Score 72" on the RSM's lead card. | Your answer (21 Sept, engine + score) | |
| P5-13 | A lead is re-scored on every new signal, on every answer from Hina or the SUL (acreage, intent), and daily for age. Re-scoring can move a lead up a segment; the SUL is told when it does. | P1-24; J7.3. | Canvas; Part 1 | |
| P5-14 | Weights, the age floor, the two adjustment sizes and Hina's limits are Admin settings within their ranges (A.2); every change is recorded with who, when and the previous value and takes effect for new scores. The five weights must total 100 before a set can be saved, and the final score is kept between 0 and 100. Any change to the weights, typed by Admin or applied from an engine proposal, notifies every stakeholder; other changes notify Head of Sales. *Revised 1 Oct (review r1, S64, S100, N12).* | J21.2. | Canvas; Your answer (18 Sept, controls); Your answers (30 Sept, 1 Oct, review r1); DECISIONS 2026-10-01 | R |
| P5-15 | The first engine is a rule-based scorecard with these weights; a learning engine may follow after a season of outcomes; the scorecard stays as the fallback and the explanation and is never switched off. | Every lead always has its reasons. | Canvas | |

### 5.4 Segments, precisely

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-16 | **Below threshold**: known acreage under the threshold → not routed; Admin's list; counted for Marketing, PMs and Leadership; the grower keeps a profile. Applies before segmenting. | P1-20. | Your input (16 Sept) | |
| P5-17 | **Campaign**: the lead carries a campaign → Campaign segment, whatever else is true; tagged "meets Hot conditions" and first in its campaign when it does. | P1-15, P1-18. | Your input; Your mark (18 Sept) | |
| P5-18 | **Hot**: no campaign, and clear purchase intent (price, nearest franchise, or "I need it"), and crop known, and acreage confirmed or estimated at or above the threshold. The number does not gate it. | P1-14. | Your input (15 Sept); Your answer (17 Sept) | |
| P5-19 | **Potential**: everything else routed. Inside it, "Last season" holds this season's leads from growers converted or never touched last season. | P1-16, P1-17. | Your input; Your answer (17 Sept) | |
| P5-20 | Inside every segment and every campaign: flagged leads first, then overdue leads (oldest breach first), then today's due leads (contact promise, completion promise or follow-up date today), then, in a campaign, leads tagged "meets Hot conditions", then by score, then by age. The first **20** leads are on the list; the rest sit under "more leads", one tap away, except that flagged, overdue and due-today leads are never folded. *Revised 1 Oct (review r1, S10, S73, N35).* | P2-2. | Your input (no cap); Your answer (21 Sept, fold); Your answers (30 Sept, 1 Oct, review r1) | R |
| P5-21 | Unclear intent after Hina and before the SUL's confirmation is shown as "intent unclear" and cannot make a lead Hot. | P4-9. | Your answer (21 Sept) | |

### 5.5 Routing

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-22 | A lead is routed by the grower's coordinate → village boundary (or nearest franchise point) → BSA → territory → the SUL who owns it (Part 7). One SUL per territory; no lead has two owners. | P1-3, P7-7, P7-8. | Your input; Your answers (17, 28 Sept) | |
| P5-23 | A lead that cannot be placed in a territory → the regional pool; the RSM assigns by hand; clocks start when the assigned SUL's phone receives it. Pool items show their age and alert their owner when overdue (P6-17a). *Revised 1 Oct (review r1, S5, S86).* | J15. | Your answer (18 Sept); Your answer (30 Sept, review r1) | R |
| P5-24 | Routing happens after Hina (if the lead had a gap) and after scoring, so the SUL receives a complete, scored lead. | P5-5. | Your answers (21 Sept) | |
| P5-25 | The franchise is a property of the BSA in the sales structure (name and coordinate; zero, one or more per BSA); it feeds "nearest franchise" on the lead card, the serviceability adjustment, and routing outside the digitised areas. Owner: DBO, edited in Admin. *Revised 28 Sept: the separate franchise list became a BSA property (Part 7, P7-3).* | The BSA row on the Territories page carries its franchise. | Your answers (21, 28 Sept) | R |
| P5-26 | A territory boundary change re-routes future leads only; open leads stay with their SUL. | P3-19. | Approved with Part 3 | |

### 5.6 The two clocks, precisely

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-27 | Both clocks start when the SUL's phone receives the lead (after routing, pool assignment, handover from Hina, or a move by Admin). Contact stops at the SUL's first reached contact; completion stops at Completed or Closed; each stops at the time the action was logged on the phone. Rejected stops both; when Admin reassigns a rejected lead, both clocks start afresh for the SUL who gets it, and the rejected episode stays out of the rate. When a lead moves up a segment, both clocks restart under the new segment's promises; a move down keeps the earlier due times. A lead that stays with its SUL keeps its due times when settings change (P3-10). *Revised 1 Oct (review r1, S1, S4, S5, S6, S29, S95).* | P1-39. | Your mark (18 Sept); Your answers (30 Sept, 1 Oct, review r1); DECISIONS 2026-10-01 | R |
| P5-28 | Promises, all Admin settings: contact — Hot 24 h, Campaign per campaign, Potential 72 h; completion — Hot 7 days, Campaign per campaign, Potential 14 days. A campaign cannot be created without both of its promises, and neither may be shorter than the campaign-promise floor (an Admin setting, starting 24 hours for contact and 7 days for completion). Every on-time rate can be split by segment, and campaigns with their own promises are named beside it. *Revised 1 Oct (review r1, S30).* | P1-38; P3-16. | Canvas; Your mark (18 Sept); Your answer (21 Sept, campaign clock); Your answer (30 Sept, review r1) | R |
| P5-29 | Overdue on either clock: badge on the lead and summary; the SUL is notified per lead; RSM and ZM get the breach digest and Hot-contact pushes of P3-14; a daily 8 am digest for Head of Sales. When an action synced later shows the promise was met (logged on time while offline), the overdue mark and the managers' notice for that lead are withdrawn. No reassignment. *Revised 1 Oct (review r1, S27, S6).* | P1-41, P3-14. | Your answers (17, 18 Sept); Your answer (30 Sept, review r1) | R |
| P5-30 | Clocks count calendar hours and days but **pause on Sundays and on the days in Admin's yearly pause-day list** (Eid and similar). Other public holidays count unless listed. The working week used for support hours and for the monthly summary's "first working day" is one Admin setting; every change to either is logged. *Revised 1 Oct (review r1, S7, S124): amends the 21 Sept "Sundays only" answer.* | A Hot lead routed Saturday 18:00 is due for contact Monday 18:00; over a listed three-day Eid the due time moves three days. | Your answer (21 Sept, calendar); Your answer (30 Sept, review r1); DECISIONS 2026-10-01 | R |
| P5-31 | **The on-time rate, one definition.** For a period: the denominator is every lead whose promise ended in the period or whose clock stopped in it; the numerator is those whose clock stopped before the promise. Converted, not converted and Closed: unreachable count as completed; follow-up dates never enter the rate. Both clocks at every level, contact first. Leads waiting for Hina, held, in the pool, or closed before reaching an SUL are not in the denominator. A lead rejected or closed below threshold by the SUL after one of its promises had passed counts as missed for that promise. *Revised 1 Oct (review r1, S21, S103, S18, S19).* | P1-43, P3-5. | Canvas; Your mark (18 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| P5-31a | **Time to the SUL.** Every lead records the time from the grower's signal to the SUL's first reached contact, split into Hina's hold, any wait in the pool, and the SUL's clock. Managers and Leadership see its median and the share over 72 hours beside the on-time rates, so a wait before the SUL is never counted as on time. *Added 1 Oct (review r1, S41).* | "Signal to first contact: median 31 h (Hina 18 h, SUL 13 h) · 12% over 72 h". | Your answer (30 Sept, review r1) | R |

### 5.7 Learning from outcomes

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-32 | Every completed or closed lead — converted with value, product and quantity; not converted with reason; unreachable; below threshold — is kept as a labelled example with the score, reasons and segment it had. *Revised 1 Oct (review r1, S68): observable added.* | Admin's Connections page shows "Labelled examples: 4,120 (converted 610 · not converted 1,900 · unreachable 1,410 · below threshold 200)", equal to the count of leads closed in those four ways. | Canvas; Your answer (30 Sept, review r1) | R |
| P5-33 | Conversion by segment, by source, by campaign, by crop, by acreage band (A.2 Settings) and by district is watched continuously. Leadership's "does the engine beat a plain list" compares conversion by score tenth among leads the SUL contacted within the contact promise, against the plain list — arrival order — so attention does not create the gap; the share of each tenth that was contacted is shown beside it, and a tenth with fewer than 30 contacted leads shows "too few to compare". *Revised 1 Oct (review r1, S40, S112).* | J18.1. | Canvas (model lift); Your answer (30 Sept, review r1) | R |
| P5-34 | After a season, the engine may **propose** weight changes with the evidence. Admin applies or rejects; every stakeholder is notified of an applied change, as for any weight change (P5-14); every change is logged and reversible. Nothing retunes itself. *Revised 1 Oct (review r1, S100).* | "Scoring weights changed on 1 Mar: acreage 25 → 30. Reason: …" on every user's notifications. | Your answer (21 Sept, engine + score); Canvas (no silent self-retuning); Your answer (30 Sept, review r1) | R |
| P5-35 | The SUL's one-tap intent confirmation and Hina's answers are kept as examples that improve intent reading. *Revised 1 Oct (review r1, S68): observable added.* | Admin's Connections page shows the number of new intent examples each week. | Your answer (21 Sept, unsure intent); Your answer (30 Sept, review r1) | R |

### 5.8 Hina as an AI SUL — a future change request, recorded, not specified

When Hina can close a sale, she becomes the first layer of calling for every
grower before an SUL, an "AI SUL", with her own scoring and priority layer:
she calls every routed lead, converts what she can in one call or several,
and hands the rest to SULs with what she learned. This is **out of scope for
this specification** and lives here so it is not forgotten; it returns as a
change request with its own section when the third party proves a closed
sale on real calls. Until then, everything in 5.2 holds.

### 5.9 Decisions this part rests on

| ID | Decision | State | What it means for this part |
|---|---|---|---|
| D1 | Consent | Decided 18 Sept | Hina may call any grower who contacted Syngenta. |
| D3 | Campaign convention | Open | Campaign segment and promises depend on it. |
| D6 | Territory vs franchise conflict | Open — sales leadership | Routing outside the digitised areas uses franchise points (P7-8); D6 decides who owns the relationship, not where a lead routes. |
| D7 | Conversion value | Open | Learning uses self-declared values with receipts. |
| — | Hina gap-filling rules; weights and adjustments; timing table (owner changed to the PMs on 1 Oct); engine proposals applied by Admin with notifications; no automated WhatsApp | Decided 21 Sept; amended 1 Oct | 5.2, 5.3, 5.7. Recorded in `docs/DECISIONS.md`. |

### 5.10 Question log (Part 5)

| # | Question | Answer (date) | Rows |
|---|---|---|---|
| 1 | Starting weights? | Intent 30 · Acreage 25 · Crop need 20 · Timing 15 · History 10 (21 Sept) | 5.3 |
| 2 | Keep age decay? | Yes, −2 per day after 48 h (21 Sept) | 5.3 |
| 3 | Reachability and serviceability? | Keep both; add a franchise list (21 Sept) | 5.3, P5-25 |
| 4 | Acreage by WhatsApp? | No; Hina, the AI calling agent, asks by phone (21 Sept) | 5.2 |
| 5 | What is Hina? | AI voice agent by a third party; today she fills gaps (acreage, crop, intent) before routing; as a future change request, the first layer of calling for all growers (21 Sept) | 5.2, 5.8 |
| 6 | Which leads does Hina call? | Only those with missing data (21 Sept) | P5-1, P5-7 |
| 7 | Where is the lead while Hina calls? | Held; SUL sees nothing until handover; leads with no gap route at once (21 Sept) | P5-1, P5-5 |
| 8 | What does Hina hand back? | Structured answers and a short summary; no recording; leads land in the same three segments (21 Sept) | P5-3 |
| 9 | Who orders Hina's calls? | Synapse sends the order and the attempt limit (21 Sept) | P5-2 |
| 10 | Any automated WhatsApp from Synapse? | None from Synapse; Marketing may run its own WhatsApp campaigns to qualify leads (21 Sept) | P5-9 |
| 11 | Timing table owner? | Marketing; neutral until filled (21 Sept). Changed 1 Oct (review r1, S92): the Portfolio Managers own and approve it | 5.3 |
| 12 | Engine proposals and score visibility? | Admin applies; Head of Sales, ZMs, RSMs and SULs notified; SUL sees rank and reasons, not the number (21 Sept) | P5-12, P5-34 |
| 13 | Four gaps marked ASSUMPTION | Answered 21 Sept: fold = top 20 per segment (P5-20) · franchise list owned by DBO (P5-25) · promises required to create a campaign (P5-28) · clocks pause on Sundays only (P5-30). Amended 1 Oct (review r1, S7): clocks also skip Admin's listed pause days | P5-20, P5-25, P5-28, P5-30 |

### 5.11 Where the canvas or the audit differs (Part 5)

| DR | Spec | Canvas or audit | Note |
|---|---|---|---|
| DR-23 | Leads with a gap wait for Hina, up to 2 days, before an SUL sees them | Canvas: lead delivery must never depend on a model call; "a dropped lead is a lost sale nobody sees" | Your decision, 21 Sept. Bounded by the attempt limit and by "no gap → route at once"; a lead is never dropped, only delayed. The session 2.2 delivery lens will weigh the delay against the value of confirmed acreage. |
| DR-24 | Acreage asked by Hina on the phone; no WhatsApp question | Canvas: acreage cascade step 3 is an automated WhatsApp callback, max 2 attempts | Your answer, 21 Sept. Same intent, different channel, three attempts. |
| DR-25 | No automated nurture or WhatsApp content from Synapse | Canvas: nurture automation matched to crop and season | Your answers, 17 and 21 Sept; Marketing's own WhatsApp campaigns feed signals in. |
| DR-26 | Acreage is an ingredient; no order-value calculation | Canvas: opportunity value = acreage × dose × price | Your answer, 17 Sept; recorded in DECISIONS. Acreage also takes 25 and crop need 20, the reverse of the canvas's severity 25 and value 20 (your answer, 21 Sept; recorded 1 Oct, review r1, S122). |
| DR-27 | Franchise points per BSA, used for serviceability, "nearest franchise" and routing outside the digitised areas | Canvas "consequences accepted": franchise data removed | Names and locations only, not sales or invoices; since 28 Sept a property of the BSA (P7-3), with no separate range. D6 stays open. |
| DR-28 | Hina's future role as an AI SUL | Not in the canvas | Recorded in 5.8 and DECISIONS; not specified. |
| DR-36 | Model monitoring is lift and conversion breakdowns only; no drift or score-distribution watch; PMs see conversions, not the score distribution per campaign (P5-33, J19) | Canvas Z00: lift, drift, score distribution over time; Z04: PM score distribution and converted value per campaign | Recorded 1 Oct (review r1, S120). |
| DR-37 | The Portfolio Managers own and approve the timing table and the product list; Admin sets weights; timing reads crop, problem, zone and months only — no sowing date, weather, crop stage or pest pressure | Canvas L4, L5: the agronomy team owns the severity and window tables; agronomy and sales leadership set the weights; inputs include sowing date and weather | Your answers, 18 Sept (Admin-alone settings), 21 Sept (timing table) and 30 Sept (PMs own, S92). Recorded 1 Oct (review r1, S121). |

## Part 6 — What is recorded, how well it must work, what it must never do, and the decisions

### 6.1 What Synapse records

Plain lists of what each record holds. Items marked **(personal)** are
personal data: they are hidden from anyone outside the rules in Parts 2 and
3, never appear in an export or a summary, never appear in a log line, and
are removed under the retention rule (6.2). Field-level detail with types is
in the Appendix.

| Record | What it holds | Came from | Mark |
|---|---|---|---|
| **Grower** | Name (personal) · mobile number (personal; one per grower; history of changes with who and when) and any known alternate numbers from a merge (personal) · village and location: province, district, tehsil, village, map position with its source and whether an SUL confirmed it, and its history (personal) · crops grown · acreage, per crop where known, each marked estimated / confirmed by SUL / confirmed by Hina, with source and date · preferred language · new/existing mark · last season's status · the date of last activity | Parts 1, 4, 7; revised 1 Oct (review r1) | R |
| **Consent basis** (one per lead) | The stream and the date of the grower's own contact with Syngenta that the lead came from, stamped automatically from the incoming signal | Part 4 (P4-23); D1; revised 1 Oct (review r1, S108) | R |
| **Signal** | Which stream · when the grower acted · what they did (scan, message, post, form, call, purchase) · the grower's own words where there are any (personal) · crop, problem, severity and confidence where the stream gives them · campaign where carried · the original as received, unchanged (personal) · whether it was held (campaign not readable, invalid) and why | Part 4; revised 1 Oct (review r1, N3, S35) | R |
| **Lead** | The grower · the signals it merges · crop and need · recommended product (derived) · acreage and its status · purchase intent and how sure (from words, Hina, or the SUL's tap) · source stream · campaign and any "also touched" campaigns · segment · state and every state change with who and when · territory and SUL · how it was placed · both clocks: start, promise, stop (phone-logged time), overdue · time to first reached contact · follow-up date · flags received · Hina's attempts and summary · last season's tag · rejection reason if any | Parts 1, 2, 5, 7; revised 1 Oct (review r1) | R |
| **Score** | The number · which weights version produced it · each ingredient's contribution · each adjustment applied · the top three reasons, in Urdu and English · when it was calculated | Part 5; Invariant 8 | |
| **Outcome** | Converted: PKR value (receipt total), product lines (product, quantity, unit), receipt photo (personal), closing SUL, date · Not converted: reason, comment, SUL, date · Closed: unreachable (attempts, reason), below threshold, no valid number, or merged · Rejected: reason, SUL, Admin's action | Part 1; revised 1 Oct (review r1, S97) | R |
| **Hina call** | Lead · attempt number · when · outcome (answered, no answer, wrong number, refused) · acreage, crop, intent and location returned · the summary in Urdu and English (personal) · no recording, no transcript | Part 5; revised 1 Oct (review r1) | R |
| **Flag** | From whom to whom · what it is on (a lead, or a territory, region or zone) · the flag above it, if passed down · note · due-by day · when sent · when and how answered | Part 3; revised 1 Oct (review r1, S25) | R |
| **Campaign** | Name · kind (brand-level or crop programme) · NPI or not · portfolio · brand or programme · product · crop · start and end · contact and completion promises · budget · actual spend, with change history · talk track (Urdu and English, optional) | Parts 3, 4; revised 1 Oct (review r1, S33, S107) | R |
| **Product** | Name · portfolio · brand · crops and problems it treats (including preventive) | Part 4 | |
| **Sales structure** | Zones · regions · territories · BSAs, each with its villages and its franchise (name, coordinate; business data, owned by DBO) · which SUL owns each territory (at most one) · SUL location points · change history | Parts 4, 7; revised 1 Oct (review r1, N11, S72) | R |
| **Grower location list** | Provinces · districts · tehsils · villages · which BSA each village belongs to · the digitised village boundaries (Punjab and Sindh), versioned, used for routing only | Parts 4, 7 | |
| **Timing table** | Crop · problem · zone (or province) · months when treatment applies | Part 5; revised 1 Oct (review r1, S75) | R |
| **Targets** | What is targeted (each on-time rate, leads converted, sales value, leads followed up) · level and unit · value · period · on or off · who entered it and on whose recommendation | Part 3 (P3-21) | R |
| **Vendor register** | Each third party that receives grower data: what it receives, where it keeps it, for how long, the signed processing agreement, the escalation contact and response time | Part 6 (P6-22) | R |
| **User** | Name · Syngenta email (the login) · staff mobile number (for the weekly summary) · role (including DBO) · scope (territory, region, zone, portfolio, or all) · language · active or not · change history (who, when, before, after) | Parts 1, 3; revised 1 Oct (review r1, S51, S53, N6) | R |
| **Settings** | Acreage threshold · four Hot and Potential clock promises and the campaign-promise floor · scoring weights, age floor, adjustment sizes · fold size · Hina attempts and days · intent confidence minimum · stream check intervals · season start date · pause-day list and working week · acreage bands · retention period · breach digest times · receipt sample rate · every change with who, when and the previous value; each within a minimum and maximum (A.2) | Parts 1, 3, 4, 5, 6; revised 1 Oct (review r1, S116, N12) | R |
| **Audit entry** | Who · when · what (the one list in P6-15) · on which record · before and after for settings only; never a grower's name, number, words or location | Part 3; revised 1 Oct (review r1, S53) | R |

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P6-1 | Every record above is kept in one place, and every screen, summary and export reads from that one place. No screen keeps its own copy of a number. | Two screens never disagree about a count. | Canvas (one data platform); Audit lesson (§7.12, §7.22) | |
| P6-2 | A diagnosis is recorded as "healthy" only when the source said so. A blank diagnosis is "unknown", never healthy and never diseased. | A Crop Doctor scan with no diagnosis shows "diagnosis unknown". | Audit keeper (healthy is affirmative) | |
| P6-3 | Every item marked (personal) is marked in the record itself, so exports, summaries and logs leave it out by rule, not by memory. | An export never contains a name or number, whoever runs it. | Canvas (PII tagged); Audit lesson (§7.4) | |
| P6-4 | One user list, one sales structure. A role or territory is stored once and read from there by every screen. | Changing a territory in Admin changes it everywhere at once. | Audit lesson (§7.13) | |
| P6-5 | Money is stored as integer paisa (A.2) and shown in PKR, whole rupees, with lakh grouping, never as a rounded estimate or abbreviated. Calculated amounts are rounded half up to whole rupees. Time is shown in Pakistan time everywhere. *Revised 1 Oct (review r1, N40).* | "PKR 12,50,000", never "PKR 12.5 lakh", "PKR 1.25m" or "≈ 12,50,000". | Rule book (`CLAUDE.md`); Your answer (1 Oct, review r1) | R |

### 6.2 How well it must work

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P6-6 | **Offline.** The SUL app works fully without signal: every lead, grower and list in the territory is on the phone; every action waits on the phone and sends in order when signal returns, carrying the time it was logged; the SUL's entry is never lost, even if the phone restarts or the same lead changed on the server meanwhile (J9.3). *Revised 1 Oct (review r1, S82).* | J9. | Canvas; Your input (15 Sept); Your answer (30 Sept, review r1) | R |
| P6-6a | **The phone.** The app's offline store is encrypted. The app opens only after the phone's PIN or biometric check. Screens that show a grower's name, number or receipt block screenshots and screen recording. Admin can revoke a device, which wipes Synapse's data on it at the next connection. An SUL reports a lost phone to Admin, who revokes it the same day; the revocation is in the audit trail. *Added 1 Oct (review r1, S2).* | A revoked phone opens to "This device is no longer signed in"; its Synapse data is gone. | Your answer (30 Sept, review r1) | R |
| P6-7 | **Languages.** The SUL app in Urdu or English, chosen by the SUL; every reason list, notification and SUL-facing summary in both (P2-9). Manager, marketing and Admin screens, and the weekly WhatsApp summary, in English; a user's language setting applies to the SUL app only. Grower words shown as sent. Digits and dates in the English style everywhere. Regional languages later. *Revised 1 Oct (review r1, N43, N42).* | P2-9. | Your answer (17 Sept); Your answer (1 Oct, review r1) | R |
| P6-8 | **Phones.** Android 9 or newer, 2 GB memory, under 150 MB with a full territory on the phone (unsent receipt photos included), usable on 2G/3G. No iPhone in the Pilot. The 2G/3G numbers and a device survey are set in Phase 4 (SYN-12). *Revised 1 Oct (review r1, N19, S61).* | P2-10. | Your answer (17 Sept); Your answers (30 Sept, 1 Oct, review r1) | R |
| P6-9 | **Volume.** Up to 1,000 leads a day on a normal day. A campaign launch of 10,000 leads in twenty minutes loses nothing; during it every lead with no gap reaches its SUL within the minutes Ahsan sets, and the SUL app stays as fast as normal. Each SUL's leads appear in the order the growers acted. *Revised 1 Oct (review r1, S62).* | Connections shows the burst arriving and clearing; no SUL notices. | Your answer (21 Sept, volumes); Plan M8 (the burst); Your answer (1 Oct, review r1) | R |
| P6-10 | **Personal data.** Only what the streams, Hina and SULs gave, and coordinates converted from a given address; marked in the record; visible only inside each user's scope; every opening of a name, number or receipt by a manager is logged. *Revised 1 Oct (review r1, S110).* | P3-13, P6-3. | Canvas; Your answers (18, 21 Sept); Your answer (30 Sept, review r1) | R |
| P6-11 | **Retention.** After two seasons (two crop years) with no signal, contact or purchase, the grower's name, number, location and receipts are removed from every place they occur — the grower record and its change history, each signal's original copy and words, Hina summaries, receipts and positions; crops, acreage band (A.2), district and outcomes stay without identity. A lead closed as "no valid number" that never matched a grower is deleted after the months Ahsan sets. The period is an Admin setting between 1 and 3 seasons: before saving a shorter period Admin sees how many growers it would anonymise, and the shorter period applies from the next season start and can be reverted until then. Admin alone decides; every removal is logged. *Revised 1 Oct (review r1, S50, N3, N4, S112).* | Admin's audit trail shows "anonymised: 312 growers inactive since Kharif 2024". | Your answer (17 Sept, retention); Canvas; Your answers (30 Sept, 1 Oct, review r1) | R |
| P6-12 | **Residency.** Grower data is stored in Pakistan. The hosting that meets this is decided in tech.md from Syngenta's recommended stack (Phase 3; D5). *Revised 1 Oct (review r1, N33).* | Confirmed in Phase 3 with the hosting choice; IT can be shown where. | Your answer (21 Sept); Your answer (1 Oct, review r1) | R |
| P6-13 | **Season.** One season a year: a crop year of twelve months from a start date Admin sets. "Last season" is the previous crop year; "two seasons of inactivity" is two crop years. A change to the start date applies from the next season: tags already on leads are kept, and tabs and the retention count use the season each lead was created in. *Revised 1 Oct (review r1, S94).* | Admin's settings show "Season starts 1 April". | Your answer (21 Sept, season); Your answer (30 Sept, review r1) | R |
| P6-14 | **Receipts.** A receipt photo can be opened by the SUL who logged it and by everyone above them in the sales line up to Head of Sales; each opening is logged. Marketing, PMs and Leadership see that a receipt exists, never the image. A receipt is evidence of the sale only: the franchisee's prices on it are never extracted, reported or used; franchisees are told that receipts are photographed; Syngenta Legal confirms this before the Pilot. *Revised 1 Oct (review r1, S90).* | An RSM opens a receipt; the audit trail records it. | Your answer (21 Sept, receipts); Your answer (1 Oct, review r1) | R |
| P6-15 | **Audit.** One audit list, used everywhere: every settings change; flag; number change and undo; removal; merge; reassignment or move of a lead; possible match confirmed or declined; user role, scope or active change; manager view of personal data; export; login; Hina call; automated read. It is recorded and readable by Admin; nothing in the audit trail can be edited or deleted, and it holds no grower name, number, words or location. *Revised 1 Oct (review r1, S53).* | J21.8. | Canvas; Your answers (18 Sept); Your answer (30 Sept, review r1) | R |
| P6-16 | **Login.** Staff register and log in with their Syngenta email address and a Synapse password. Registration sends a one-time link to the Syngenta mailbox, and the account works only after Country IT's list confirms it; Admin sets role and scope. Passwords have a minimum length and are reset by a mailbox link; an account locks after 5 failed tries; sessions end after a set time on the app (offline included) and on the portal; Admin logins need a second factor (the numbers are set by Ahsan). A leaver is deactivated the day IT tells Admin, which ends every session (J21.10). Single sign-on with the corporate identity is out of scope for now (6.3.2). *Revised 1 Oct (review r1, S48, S3).* | The login screen asks for a Syngenta email; a non-Syngenta address cannot register; a deactivated user cannot log in or sync. | Your answer (21 Sept, login); Canvas (SSO where available, deferred); Your answer (30 Sept, review r1) | R |
| P6-17 | **Running it.** DBO watches the portal daily and handles the below-threshold, no-valid-number, rejected and pool lists and SUL support; the digital team (Admin) owns settings and is the escalation point to the third parties (Hina, the messaging provider, the address service, hosting). Support runs 9 to 6 on the working week Admin sets (P5-30); the app and the clocks run every day. A stream, Hina or the address service failing for more than an hour alerts the digital team's on-call contact at any hour; each third party's escalation contact and response time are on Connections. *Revised 1 Oct (review r1, S87, S124).* | A failing stream at 18:10 on a Friday reaches the on-call contact by 19:10. | Your answer (21 Sept, operations); Your answer (30 Sept, review r1) | R |
| P6-17a | **Manual queues.** Each manual list (no valid number, possible matches, rejected, held campaign signals, every regional pool) shows its count and the age of its oldest item; an item a person can act on that is older than two working days is shown to its owner and to Admin as overdue, and the weekly summary counts it. *Added 1 Oct (review r1, S86).* | "Pool, Region B: 7 · oldest 3 days — overdue". | Your answer (30 Sept, review r1) | R |
| P6-18 | **No clutter.** Three segments and nothing else on home; the first 20 per segment, urgent leads never folded; every manager sees one level down, named. *Revised 1 Oct (review r1, S68).* | Parts 2, 3. | Your input (15 Sept); Your answer (30 Sept, review r1) | R |
| P6-19 | **Honest numbers.** A screen with incomplete data says so, names the cause and cannot be dismissed (P3-8); downloads carry the same warning; every summary says "as of" and how many; unresolved rows are counted openly. *Revised 1 Oct (review r1, S66).* | P3-8. | Audit keepers; Your answer (1 Oct, review r1) | R |
| P6-20 | **Nothing invented.** No default replaces a missing value: no zero acreage, no "today" for a missing date, no guessed location, no PKR estimate. Unknown is shown as unknown. | "Acreage unknown", never "0". | Audit lesson (§7.11); Your answer (18 Sept, no PKR estimate) | |
| P6-21 | **Evidence.** Every rule in this document is proven by something Ahsan can watch: a screen, a count, a test that names the rule. "It should work" is not evidence. | Every part's rows have a "What you would see". | Rule book (`CLAUDE.md`); Audit lesson (§7.21) | |
| P6-22 | **Vendor register.** Every third party that receives grower data — Hina's vendor, the messaging provider, any intent-reading or address service — is listed in Admin with what it receives, where it keeps it, for how long, and a data processing agreement signed by Syngenta Pakistan Legal that names deletion of call recordings within the days Ahsan sets. No connection goes live without its entry. The Google Maps integration is built and run by the team and is not on the register. *Added 1 Oct (review r1, S47).* | Connections shows each third party's register entry; an entry-less connection cannot be switched on. | Your answers (30 Sept, 1 Oct, review r1) | R |
| P6-23 | **Inbound data is genuine.** Every inbound feed, Hina's included, must carry the provider's valid signature before it is accepted; a request without one is refused and counted on Connections. How keys are stored, how backups and restores keep anonymisations, the audit trail and synced phone actions intact, and the uptime target are set in docs/INFRA.md in Phase 3 (parked, SYN-13). *Added 1 Oct (review r1, S84, N9).* | Connections shows "Hina: 0 refused (bad signature) today". | Your answer (1 Oct, review r1) | R |

### 6.3 Out of scope, and what Synapse must never do

**6.3.1 Specified here, built after Capture.** Capture, the first build scope,
is the streams, the one-grower record, the first scorecard, a one-page list,
Hina's gap-filling connection, the acreage rules, and the franchise points per
BSA that routing needs (M3). Built after Capture, as specified in Parts 2, 3
and 5: the full SUL app, the manager, leadership, marketing and Admin
dashboards, flags, the weekly and monthly summaries, the serviceability
adjustment and "nearest franchise" on the card, the learning engine's
proposals. The Appendix marks each row with its build milestone, and 6.8 says
which rows the Pilot needs. *Revised 1 Oct (review r1, S60, S42).*

**6.3.2 Out of scope for this specification**, by your decision, each with
the date and a note on when it returns. Each returns only as a change
request.

| Item | Decided | Returns when |
|---|---|---|
| SUL creates a lead by hand (walk-in growers) | 18 Sept; confirmed 1 Oct (review r1, S31) | When Ahsan asks; the focus is leads from the digital streams |
| Cost per lead and cost per converted lead on Marketing's screens | 1 Oct (review r1, S37) | When Ahsan asks; spend is still entered on each campaign |
| Grower opt-out, by grower or by SUL | 21 Sept | A change request; recorded for the consent reviewer |
| Splitting a shared number into two growers | 18 Sept | If the field reports shared-number growers merged in error |
| A PKR estimate on the lead card | 18 Sept | With a product-and-price list, if wanted |
| Fulfilling franchise on a conversion | 18 Sept | With point-of-sale integration |
| Point-of-sale integration (conversion from sales data, no receipt) | 15 Sept | When POS exists; the intended answer to D7 |
| Automated WhatsApp messages from Synapse to growers | 21 Sept | A change request, alongside Hina's wider role |
| Hina as an AI SUL: first layer of calling for every grower, closing sales | 21 Sept | A change request when the third party proves a closed sale on real calls; its own spec section |
| Regional-language UI (Punjabi, Sindhi, Saraiki, Pashto) | 17 Sept | After the Pilot, as a change request |
| The canvas's Nurture tier and daily cap | 15 Sept | Not planned; an Admin setting away if the field asks |
| Single sign-on with the Syngenta corporate identity | 21 Sept | When Syngenta IT connects its identity system; until then, Syngenta email plus a Synapse password |

**6.3.3 Removed from the product** by the canvas, not to be re-opened: IVR as
a source (growers without the app or WhatsApp reach Synapse through the call
centre); franchise invoice data and reconciliation (until POS); farm mapping
(acreage comes from profile, conversation, Hina or the SUL, and nothing else).

**6.3.4 What Synapse must never do.** One row per pattern in Smart Agro Lite
that must not cross (audit §7, 22 patterns, and §9, three more), plus four
from this specification. Each names the rule that forbids it.

| AR | Synapse must never… | Forbidden by | Audit |
|---|---|---|---|
| AR-1 | …let a screen decide who sees what. Scope is decided once, centrally, and every screen, summary and export obeys it. | P1-1, P3-3; Invariant 7 | §7.1 |
| AR-2 | …have a page or export reachable by address that shows more than the user's scope. | P3-9, P1-1 | §7.2 |
| AR-3 | …ask anyone to contact a grower without a recorded consent basis. | P1-12, P4-23; Invariant 1 | §7.3 |
| AR-4 | …copy a grower's name or number into a second record, log line or export, or leave personal data unmarked. | P6-3, P6-10 | §7.4 |
| AR-5 | …treat a phone number as free text, keep two growers on one number, or let the newest spelling silently win. | P4-16, P4-17, P4-20; Invariant 2 | §7.5 |
| AR-6 | …count the same signal twice or make a second lead from a resent one. | P4-4; Invariant 3 | §7.6 |
| AR-7 | …call a lead Hot from a typed flag, or show a score without its reasons and version. | P5-18, P5-11; Invariants 4, 8 | §7.7 |
| AR-8 | …change a lead's state from more than one place, or in two ways that disagree. | P1-27; Invariant 5 | §7.8 |
| AR-9 | …record a conversion as a bare number: without product, quantity and the SUL who closed it. | P1-30; Invariant 6 | §7.9 |
| AR-10 | …use a tick-box (reported, converted) as a hidden state beside the real one. | P1-27 | §7.10 |
| AR-11 | …take leads from a spreadsheet, let a failed check through, or fill a bad value with a default. | P4-2, P4-7, P6-20 | §7.11 |
| AR-12 | …count a dashboard from whatever a screen managed to download. | P6-1, P3-2 | §7.12 |
| AR-13 | …keep a user's role or territory in two places. | P6-4 | §7.13 |
| AR-14 | …swallow a failure. On the SUL app a write that fails is shown and retried, never dropped; on the online-only dashboards (P3-20) a failed action is shown as failed. *Revised 1 Oct (review r1, N21).* | P4-5, P2-8, P3-20 | §7.14 |
| AR-15 | …keep weights or thresholds in code, or score the same action two ways. | P5-14, P3-10 | §7.15 |
| AR-16 | …work offline for writes only, or leave a failed action stuck forever. | P2-8, P6-6 | §7.16 |
| AR-17 | …find a territory by matching text. Routing goes through the sales structure and location lists. | P4-29, P5-22 | §7.17 |
| AR-18 | …let an automated process read grower data without a log line. | P5-8, P6-15 | §7.18 |
| AR-19 | …run with a setting nobody has written down. | P6-1, Appendix | §7.19 |
| AR-20 | …leave dead screens, dead guards or unused parts in place; a guard that is not wired looks like a guard. | Appendix (quality) | §7.20 |
| AR-21 | …claim a test or a check that does not exist. | P6-21 | §7.21, §9 |
| AR-22 | …compute a number from whichever record happened to be loaded. | P6-1, P3-2 | §7.22 |
| AR-23 | …use a manual spreadsheet as the way leads enter. | P4-2 | §9 |
| AR-24 | …show points, badges or leaderboards, or hard-code the weights behind them. | P2-11 | §9 |
| AR-25 | …let reading a message with AI delay or block a lead's arrival beyond the fixed wait in P4-10. Hina's hold is bounded by her attempt limit and her window, both kept by Synapse, ends when Admin switches Hina off, and never applies to a lead with no gap. *Revised 1 Oct (review r1, S81, N2).* | P4-10, P5-1, P5-5 | Canvas |
| AR-26 | …route a lead whose grower's known acreage is below the threshold to any sales user. | P1-20, P5-16 | — |
| AR-27 | …hide a lead behind a cap or a Nurture tier. | P1-23, P5-20 | Canvas (declined) |
| AR-28 | …show a PKR estimate nobody can stand behind. | P2-7, P6-20 | — |

### 6.4 Decisions

| ID | Decision | State | Owner | What it blocks or governs |
|---|---|---|---|---|
| D1 | Consent basis for advisory-captured data used for sales contact | **Decided 2026-09-18**: any contact with Syngenta is the basis; no opt-out | Leadership, via Ahsan | Cropwise-sourced growers routed from day one |
| D2 | Who owns Cropwise platform access for the Pakistan tenant | **Filed, awaiting reply** (21 Sept); recipient and date to be added | Ahsan | Connecting the three Cropwise streams; the M2 spike may use WhatsApp instead |
| D3 | Campaign ID convention | Open; decided in M5 | Marketing, via Ahsan | Campaign segment and every marketing number; campaign signals whose campaign cannot be read are held until then (P4-11) |
| D4 | Mobile number as the grower's key; shared-number rule | **Decided 2026-09-18**: one number, one grower; no split; SUL corrects. No-number rule changed 1 Oct: a lead with no valid number is closed (P4-18) | Ahsan | One-grower rules, Part 4 |
| D5 | Syngenta's recommended stack | Decided 2026-09-11: default stack, revisit Phase 3 | Ahsan | P6-12: the hosting that keeps grower data in Pakistan is decided in tech.md from Syngenta's recommended stack |
| D6 | Territory vs franchise catchment conflict | Open; confirm before rollout | Sales leadership, via Ahsan | Routing outside the digitised areas uses franchise points (P7-8); D6 decides who owns the relationship, not where a lead routes |
| D7 | Conversion value: declared or reconciled | Open; point-of-sale integration is the intended path | Ahsan with finance | No PKR figure is linked to incentives until decided |
| D8 | — | Not used; withdrawn 16 Sept | — | — |
| D9 | Healthy Crop Doctor scan is a lead only at or above the threshold | **Decided 2026-09-15** | Ahsan | Crop Doctor connector rule |

Session decisions, all recorded in `docs/DECISIONS.md` with the date: three
segments and no cap · two clocks, notify-only · acreage threshold 20 as a
setting · eight personas · acreage replaces order value · Hina gap-filling ·
scoring details · D1 · D4 · geo hierarchy and routing (28 Sept) · the review
r1 triage and its reversals (1 Oct).

### 6.5 Question log (Part 6)

| # | Question | Answer (date) | Rows |
|---|---|---|---|
| 1 | What is a season? | One per year, a crop year from an Admin-set date (21 Sept) | P6-13 |
| 2 | Who can open a receipt photo? | Everyone in the sales line up to Head of Sales (21 Sept) | P6-14 |
| 3 | Where is data stored? | In Pakistan (21 Sept) | P6-12 |
| 4 | Normal-day volume? | 1,000 leads a day (21 Sept) | P6-9 |
| 5 | Who runs it day to day? | DBO; the digital team owns settings and escalation (21 Sept) | P6-17 |
| 6 | D2 status? | Filed, awaiting a reply (21 Sept) | 6.4 |
| 7 | Is the out-of-scope list right? | Aligned. Single sign-on was first kept in, then put back out the same day: staff use their Syngenta email to register and log in, without corporate SSO (21 Sept) | 6.3.2, P6-16 |
| 8 | Retention? | Two seasons of inactivity, then anonymise (17 Sept) | P6-11 |
| 9 | Who is Admin? | The digital team, own login (17 Sept), with a Syngenta email like everyone else | P1-5, P6-16 |
| 10 | Support hours? | Working days 9 am to 6 pm; the app and clocks run every day (21 Sept). The working week is now one Admin setting, with an out-of-hours alert (1 Oct, review r1, S124, S87) | P6-17 |
| 11 | Manager, PM, Marketing and Admin screen language? | English only; grower words and lead reasons as written (21 Sept) | P6-7 |

### 6.6 Where the canvas or the audit differs (Part 6)

| DR | Spec | Canvas or audit | Note |
|---|---|---|---|
| DR-29 | Receipts visible up to Head of Sales | Canvas: sales scope own level and below (consistent); ZM and above otherwise see no personal data (DR-17) | The receipt is the one personal item ZM and Head of Sales can open, by your answer, 21 Sept. |
| DR-30 | One season a year | Canvas: seasons unspecified; the field runs Kharif and Rabi | Your answer, 21 Sept. "Last season" means last crop year. |
| DR-31 | Data in Pakistan | Canvas: residency governed by consent, no rule | Your answer, 21 Sept; a Phase 3 hosting rule. |

### 6.7 Open at v1.0

Values and actions this specification needs that are not yet settled. Each
has an owner and the point it is due by; `docs/PLAN.md` has no calendar
dates yet, so the due point is a milestone or phase. Nothing here is built on
an assumed value: a row that depends on one waits for it. *Added 1 Oct
(review r1).*

| # | What is open | Rows | Owner | Due by |
|---|---|---|---|---|
| O-1 | Mark which rows the Pilot needs (the Pilot column, 6.8) | 6.8, A.1 | Ahsan | Before M8 |
| O-2 | Name the two Pilot zones; state the Pilot's SUL count and expected routed leads per SUL per day, and check the completion promises against them | 6.8, P1-38 | Ahsan | Before M8 |
| O-3 | Baselines and targets for the four Pilot numbers | P1-44 | Ahsan, with Head of Sales | Before go-live |
| O-4 | Target values for each target type | P3-21 | Head of Sales recommends; Admin or DBO enter | Before go-live |
| O-5 | Points-per-level table: points per level, the acre figure for "large", the age floor, missing crop-need severity | 5.3 | Builder proposes; Ahsan approves | Before scoring ships (M8 weights) |
| O-6 | Minimum and maximum for every setting | P3-10, A.2 Settings | Builder proposes; Ahsan approves | M8 |
| O-7 | Delivery numbers: minutes for a pushed lead, check interval per pulled stream, minutes during a burst | P4-3, P6-9 | Ahsan | M4 (connector template); M8 (burst) |
| O-8 | Intent: seconds routing waits for the reading; the intent test's sample size, minimum "buy" accuracy and maximum "unclear" share; the starting confidence minimum | P4-9, P4-10 | Ahsan | M4 |
| O-9 | Maximum length of Hina's summary | P5-3 | Ahsan | M8 (Hina connection) |
| O-10 | Login numbers: minimum password length, session limits on app and portal; hours after which an unsynced phone's data expires | P6-16, J21.10 | Ahsan | M0/M1 (login); M8 (offline) |
| O-11 | Hours after which dashboard figures count as stale | P3-8 | Ahsan | Before the dashboards are built |
| O-12 | Months after which an unmatched "no valid number" lead is deleted | P4-18, P6-11 | Ahsan | M3 |
| O-13 | Days within which a vendor deletes call recordings | P6-22 | Ahsan, with Syngenta Legal | Before Hina connects (M8) |
| O-14 | The working week and the first yearly pause-day list | P5-30 | Admin / DBO | Before go-live |
| O-15 | Hina vendor details on the connection (name, calls per day, time to first attempt, storage, exit) | P5-8 | Admin | Before Hina connects (M8) |
| O-16 | Vendor register entries and signed processing agreements | P6-22 | Admin; Syngenta Legal signs | Before each connection goes live |
| O-17 | Legal check that the Facebook and TikTok form privacy notices cover follow-up by staff and by Hina (review r1, S38; no SPEC row) | 4.2 | Marketing, with Syngenta Legal | Before those streams connect |
| O-18 | Legal confirmation that receipts are evidence only; franchisees told receipts are photographed | P6-14 | Syngenta Legal; DBO tells franchisees | Before the Pilot |
| O-19 | The Urdu and English reason sentences | P5-11 | Marketing or Admin | M8 |
| O-20 | Timing-table rows by zone; preventive product rows | 4.5, P2-7 | The Portfolio Managers | Before go-live |
| O-21 | Training for SULs, RSMs and ZMs in the Pilot zones | 6.8 | DBO | Before go-live |
| O-22 | Open decisions D2, D3, D6, D7 | 6.4 | As in 6.4 | D2 at M6 (fallback in 6.8); D3 in M5; D6 before rollout; D7 with finance |
| O-23 | 2G/3G numbers and the field phone survey (parked, Linear SYN-12) | P2-10, P6-8 | Ahsan; DBO surveys | Phase 4 |
| O-24 | Restore rules, uptime target and key storage (parked, Linear SYN-13); hosting that meets P6-12, in tech.md | P6-12, P6-23 | Ahsan | Phase 3 |

### 6.8 The Pilot

The Pilot is Crop Doctor, WhatsApp and campaigns (NPI or brand), in two
zones, with the first scorecard. *Added 1 Oct (review r1, S42, S43, S45,
S22, S101).*

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P6-24 | **Pilot rows.** A.1 carries a Pilot column (yes / after the Pilot) that Ahsan marks (O-1). Proposed for the Pilot: the SUL app's home, segment lists, lead card, act and log, both clocks, offline and My summary; the RSM dashboard with flags; the Head of Sales on-time view; Admin settings, connections, rejected, below-threshold, no-valid-number and pool lists; Hina gap-filling. | A.1 shows which rows go live in the Pilot. | Your answer (30 Sept, review r1) | R |
| P6-25 | **Zones and people.** The two Pilot zones are named here before M8, with the Pilot's SUL count and expected routed leads per SUL per day; the completion promises are checked against them before go-live (O-2). Zones not live show "not live" (P3-22). | This row names the zones. | Your answer (30 Sept, review r1) | R |
| P6-26 | **Readiness and training.** Before go-live, DBO trains every SUL, RSM and ZM in the Pilot zones in person; the RSM and ZM session covers the flag as their way to act (P3-4). Each SUL's last sync time is on the RSM's view, and an SUL not synced for 2 working days is flagged to the RSM. This does not repeat the Phase 9 go/no-go checklist. | The RSM's SUL view shows "last synced 2 days ago". | Your answer (30 Sept, review r1) | R |
| P6-27 | **Exit and Wave 2.** The Pilot runs for one crop season or 16 weeks, whichever ends first. Wave 2 goes ahead only if the Pilot's numbers (P1-44) meet their targets; Ahsan and Head of Sales decide, recorded in DECISIONS. | A DECISIONS entry records the Wave 2 decision. | Your answer (30 Sept, review r1) | R |
| P6-28 | **If D2 stays open.** If Cropwise access (D2) is unanswered at M6, the Pilot goes live on WhatsApp and campaigns in the same two zones, Crop Doctor joins as the first Wave 2 addition, and the Pilot is judged on those streams; Ahsan confirms at M6. | 6.4 D2 shows the answer or the fallback. | Your answer (30 Sept, review r1) | R |

## Part 7 — Geo hierarchy and routing

### 7.1 The hierarchy

Pakistan is divided into four zones: **Lahore, Multan, Bahawalpur,
Hyderabad**. A zone has regions; a region has territories; a territory has
BSAs (Basic Sales Unit Areas); a BSA has villages. One Zonal Sales Manager
per zone, one RSM per region, one SUL per territory, and generally one Naya
Savera franchisee per BSA. The village is the smallest unit and the one a
coordinate lands in.

| Level | Made of | Looked after by | Came from | Mark |
|---|---|---|---|---|
| Zone (4) | Regions | Zonal Sales Manager | Your note (25 Sept) | |
| Region | Territories | Regional Sales Manager | Your note (25 Sept) | |
| Territory | BSAs | Sales Unit Lead — at most one; none is a gap | Your note (25 Sept); Your input (15 Sept); Your answer (30 Sept, review r1) | R |
| BSA | Villages; generally one Naya Savera franchisee, with its location | — | Your note (25 Sept); Your answer (28 Sept, franchise per BSA) | |
| Village | The digitised boundary a coordinate falls in (Punjab and Sindh) | — | Your note (25 Sept) | |

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P7-1 | Holds the five-level hierarchy as one structure: every village belongs to one BSA, every BSA to one territory, every territory to one region, every region to one zone. The four zones are named above; a fifth would be a structure change by DBO. | Admin's Territories page shows the tree from zone to village. | Your note (25 Sept) | |
| P7-2 | Every territory has at most one SUL, every region one RSM, every zone one Zonal Sales Manager; every SUL owns exactly one territory. A level with nobody assigned is shown as a gap. *Revised 1 Oct (review r1, S72).* | "Territory T-14: no SUL" on the Territories page and on the RSM's view. | Your note (25 Sept); Part 1 (P1-3); Your answer (30 Sept, review r1) | R |
| P7-3 | The franchise is a property of the BSA: its name and coordinate, zero, one or occasionally more per BSA. This replaces the separate franchise list of Part 5; "nearest franchise" on the lead card is the grower's BSA's franchise, and a BSA with no franchise takes the serviceability adjustment and shows the nearest franchise in the territory. | The BSA row on the Territories page carries its franchise. | Your answer (28 Sept, franchise per BSA); revises P5-25 | |
| P7-4 | The digitised village boundaries for Punjab and Sindh, about 95% of Syngenta's sales area, are held in Synapse and used for routing (P7-7). They are not shown to SULs: the SUL's map is a Google map with lead pins (P2-20); boundaries may be shown later if required. Elsewhere only points exist: each franchise's coordinate and each SUL's coordinate. *Revised 1 Oct (review r1, N7): reverses "drawn on the SUL's map".* | The SUL's map shows lead pins on a Google map; Admin's Territories page shows the boundary files and their versions. | Your note (25 Sept); Your answer (28 Sept, outside areas); Your answer (1 Oct, review r1); DECISIONS 2026-10-01 | R |

### 7.2 Placing a lead

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P7-5 | A lead is placed only by a **coordinate**. Streams that give one (Crop Doctor, a shared WhatsApp location) use it. A stream that gives none must give a complete address — village, tehsil, district — which Synapse converts to a coordinate and records how sure the conversion is. A conversion that resolves only to a tehsil or district, or matches more than one village, does not place the lead: it goes to the regional pool with the candidate villages listed for the RSM. An unplaced address is labelled "no match" or "service unavailable, retrying"; while the service is down the lead is held and retried, not sent to the pool or to Hina. *Revised 1 Oct (review r1, S59, N8).* | The lead shows "Placed by: coordinate" or "Placed by: address (converted)"; the pool shows "Chak 12 — 2 candidate villages". | Your answer (28 Sept, placement); Your answers (30 Sept, 1 Oct, review r1) | R |
| P7-6 | A lead with neither a coordinate nor a complete address is held for Hina first: the missing location is one of the gaps she asks the grower for (Part 5, P5-1). If Hina cannot get a location, the lead goes to Admin's "no location" list for DBO to place. *Revised 1 Oct (review r1, S80).* | Hina's summary: "village: Chak 12, tehsil Sahiwal, district Sahiwal"; the lead then places. | Your answer (28 Sept, placement); Part 5; Your answer (30 Sept, review r1) | R |
| P7-7 | Inside Punjab and Sindh: the coordinate is matched to the digitised village boundary it falls in; the village's BSA and territory give the SUL. | "Village Chak 12 → BSA Sahiwal-3 → Territory T-14 → SUL X". | Your note (25 Sept) | |
| P7-8 | Outside the digitised areas: the lead goes to the territory of the BSA whose **franchise point is nearest** to the coordinate, within a distance cap (starting setting 50 km, an Admin setting); the lead is marked "placed by nearest franchise". Beyond the cap it goes to the regional pool of the region whose franchise was nearest, however far, with its distance shown, so the nearest RSM decides. | "Placed by nearest franchise, 31 km" · pool entry "74 km from the nearest franchise". | Your answers (25, 28 Sept) | R |
| P7-9 | A **structure gap** — a village in no BSA, a BSA in no territory, a territory with no SUL — sends the lead to the regional pool for the RSM and the gap to DBO on the Territories page. A coordinate outside Pakistan or in no zone goes to Admin's held-signals list marked "location outside the structure" and is not routed. *Revised 1 Oct (review r1, S117).* | "Unassigned: village Chak 9 is in no BSA" on the Territories page. | Your answer (28 Sept, structure gaps); Your answer (30 Sept, review r1) | R |
| P7-10 | The grower's location is the **most recent** coordinate from any signal, unless an SUL has **confirmed** the location on the profile; a confirmed location is not overwritten. The SUL confirms it with one action on the profile, using the phone's position at the farm. Every change is kept in the history with its source. *Revised 1 Oct (review r1, S83).* | Profile: "Location confirmed by SUL X, 4 Oct" or "Location from Crop Doctor scan, 12 Nov". | Your answer (28 Sept, which point); Your answer (30 Sept, review r1) | R |
| P7-11 | A lead is placed when it is routed, by the grower's location at that moment; a later change of location or of the structure moves future leads only. Open leads stay with their SUL. | P3-19. | Your answer (28 Sept); approved with Part 3 | |
| P7-12 | Every lead records how it was placed (village boundary, converted address, nearest franchise, pool assignment by the RSM), the village, BSA and territory, and the distance where a nearest-point rule was used. | The lead's history shows its placement. | Your note (25 Sept) | |
| P7-13 | A grower's coordinate and address are personal data: on the profile and the lead card inside the SUL's and RSM's scope, on the map as a pin, never in an export, summary or log line. | P6-3. | Part 6 | |
| P7-14 | Address-to-coordinate conversion is built in Capture (M3), not left to Phase 3. It sends only the address text — village, tehsil, district — never the grower's name, number or anything else. It may be an internal service built by Syngenta and shared with Synapse, or an outside mapping service; an outside service is used only once its vendor-register entry exists (P6-22). Synapse keeps the provision for both and Ahsan names the choice later. Its health is on Connections. Every conversion is logged. *Revised 1 Oct (review r1, S96, S47, N8).* | Recorded in the audit trail as an automated read; Connections shows "Address service: connected". | Your answer (28 Sept, address service); Your answers (30 Sept, 1 Oct, review r1) | R |

### 7.3 Who keeps it, and how it changes

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P7-15 | **DBO owns the structure**: zones, regions, territories, BSAs, village-to-BSA assignment, SUL assignment, and the franchise name and point per BSA. Edited in the Admin portal; every change logged; a change re-routes future leads only. | J21.7. | Your answer (28 Sept, ownership) | |
| P7-16 | **Admin (the digital team) owns** the digitised boundary files, the address conversion, and the SUL location points. A new boundary file is loaded as a whole; the load is logged and the previous version kept. Admin can restore the previous version in one step. Every placement records the boundary file version it used, so a restore lists the open leads placed under the withdrawn version for Admin to re-place in bulk, each move logged and made as in P3-24. *Revised 1 Oct (review r1, S85).* | Admin's Territories page: "Boundaries: Punjab v3, Sindh v2, loaded 2 Oct"; "Restore Punjab v2 — 48 open leads to re-place". | Your answer (28 Sept, ownership); Your answer (30 Sept, review r1) | R |
| P7-17 | Gaps are always visible: villages in no BSA, BSAs with no franchise, territories with no SUL, unmatched addresses, leads placed by nearest franchise, leads in pools — each as a count and a list for DBO. | The Territories page opens on its gaps. | Your answer (28 Sept, structure gaps); Audit keeper (unresolved rows counted) | |

### 7.4 Decisions this part rests on

| ID | Decision | State | What it means for this part |
|---|---|---|---|
| D6 | Territory vs franchise catchment conflict | Open — sales leadership | The franchise now sits inside the BSA inside the territory, so the SUL and the franchise share a geography by construction; the rule for who owns the relationship is still open and nothing here depends on it. |
| — | Geo hierarchy and routing rules | Decided 25 and 28 Sept | All of Part 7. Recorded in `docs/DECISIONS.md`. |

### 7.5 Question log (Part 7)

| # | Question | Answer (date) | Rows |
|---|---|---|---|
| 1 | Outside Punjab and Sindh, which point routes? | Nearest franchise point with a distance cap; first answered 25 Sept, re-asked and confirmed 28 Sept | P7-8 |
| 2 | What must a lead have to be placed? | A coordinate; a full address is converted to one; else the pool and Hina asks (28 Sept) | P7-5, P7-6 |
| 3 | Which coordinate places the grower? | The most recent, unless an SUL confirmed one (28 Sept) | P7-10 |
| 4 | Franchise list or franchise per BSA? | One list: a property of the BSA (28 Sept) | P7-3 |
| 5 | Who owns the geo data? | DBO the structure; Admin the boundary files, conversion and SUL points (28 Sept) | P7-15, P7-16 |
| 6 | Structure gaps? | Regional pool, gap shown to DBO (28 Sept) | P7-9, P7-17 |
| 7 | Beyond the cap, which pool? | The region of the nearest franchise, however far (28 Sept) | P7-8 |
| 8 | Address conversion service? | Built in Capture (M3); internal service or an outside one, provision for both, choice to be named later (28 Sept) | P7-14 |

### 7.6 Where the canvas or the audit differs (Part 7)

| DR | Spec | Canvas or audit | Note |
|---|---|---|---|
| DR-32 | Coordinate → digitised village boundary → BSA → territory; nearest franchise point elsewhere | Canvas: geo → beat → SO, nearest serviceable franchise and its stock position; Smart Agro Lite: territory by fuzzy text matching across six fields | Consistent with the canvas ("beat" = territory, BSA below it); the audit's text matching is AR-17. Franchise stock position is not in scope. |
| DR-33 | Franchise is a property of the BSA; no separate list | Part 5 (this spec, 21 Sept): a separate franchise list | Your answer, 28 Sept; P5-25 revised. |

---

## Appendix — technical detail

*You can stop reading before this point.* This appendix exists for the
session 2.2 reviewers, for Phase 3 (architecture) and for the builders. It
adds nothing a product reader needs.

### A.1 Traceability — every row, its canvas layer, invariants and build milestone

Canvas layers are those of `docs/reference/01-product-canvas.md` (L1–L8,
Z00, Z04). Milestones are those of `docs/PLAN.md` (M0–M8 = Capture);
"Post-Capture" means specified now, built in the Act scope after M8. The
"Pilot" column is marked by Ahsan (6.8, O-1); blank means not yet marked.
The "Came from" column repeats the row's own attribution verbatim and is
checked against it on every change (A.9). Rows follow the body's order.
*Regenerated 1 Oct (review r1, S114, S126).*

| ID | Canvas layer | Invariants cited | Build milestone | Pilot | Came from (as written) |
|---|---|---|---|---|---|
| P1-1 | Z00 identity & access; Z04 grain | INV-7 | Post-Capture; M1 list scope | | Your input (15, 16 Sept); Canvas; Invariant 7 |
| P1-2 | Z00 identity & access; Z04 grain | - | Post-Capture; M1 list scope | | Audit §1.5; Canvas; Your answer (1 Oct, review r1) |
| P1-3 | Z00 identity & access; Z04 grain | - | Post-Capture; M1 list scope | | Your input (15 Sept); Your answer (30 Sept, review r1) |
| P1-4 | Z00 identity & access; Z04 grain | INV-7 | Post-Capture; M1 list scope | | Canvas; Invariant 7; Your answer (30 Sept, review r1) |
| P1-5 | Z00 identity & access; Z04 grain | - | Post-Capture; M1 list scope | | Your answer (17 Sept) |
| P1-5a | Z00 identity & access; Z04 grain | INV-7 | Post-Capture; M1 list scope | | Your answers (30 Sept, 1 Oct, review r1); DECISIONS 2026-10-01 |
| P1-6 | Z00 identity & access; Z04 grain | - | Post-Capture; M1 list scope | | Your answers (17, 21 Sept; 1 Oct) |
| P1-7 | L2 ingestion; L3 Grower 360 | - | Capture: M1, M3 | | Your input (15 Sept); Canvas; Audit lesson; Your answer (30 Sept, review r1) |
| P1-8 | L2 ingestion; L3 Grower 360 | INV-2, INV-3 | Capture: M1, M3 | | Invariant 2; Invariant 3; Canvas |
| P1-8a | L2 ingestion; L3 Grower 360 | - | Capture: M3, M5 | | Your answer (30 Sept, review r1: last campaign wins) |
| P1-9 | L2 ingestion; L3 Grower 360 | INV-3 | Capture: M1, M3 | | Invariant 3 |
| P1-10 | L2 ingestion; L3 Grower 360 | - | Capture: M1, M3 | | Your input (15 Sept); Canvas; Your answer (30 Sept, review r1) |
| P1-11 | L2 ingestion; L3 Grower 360 | - | Capture: M1, M3 | | Canvas; Your input (16 Sept) |
| P1-12 | L2 ingestion; L3 Grower 360 | INV-1 | Capture: M1, M3 | | Invariant 1; Your decision D1 (18 Sept); Your answer (1 Oct, review r1) |
| P1-13 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your input (15 Sept); Your decision (segments) |
| P1-14 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your input (15 Sept); Your answer (17 Sept); see DR-2 |
| P1-15 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your input (15 Sept); Your answer (17 Sept, campaigns); Your answer (1 Oct, review r1) |
| P1-16 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your input (15 Sept) |
| P1-17 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your answer (17 Sept, lifecycle); Your answer (30 Sept, review r1) |
| P1-18 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your mark (18 Sept) |
| P1-19 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your input (16 Sept); Your answer (17 Sept, one threshold); Your answer (30 Sept, review r1); DECISIONS 2026-10-01 |
| P1-20 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your input (16 Sept); Your answer (17 Sept) |
| P1-21 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your input (15, 16 Sept); Your answer (21 Sept, Hina) |
| P1-22 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your input (16 Sept); Your mark (18 Sept); Your answer (30 Sept, review r1) |
| P1-23 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your input (15 Sept); Your decision (segments); see DR-4; Your answer (1 Oct, review r1) |
| P1-24 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Canvas; Your answer (30 Sept, review r1) |
| P1-25 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your decision D9 |
| P1-26 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | | Your answer (17 Sept, lifecycle); Your answer (30 Sept, review r1) |
| P1-27 | L8 outcome | INV-5 | Post-Capture | | Your input (15 Sept); Your answer (17 Sept); Invariant 5; Your answers (30 Sept, 1 Oct, review r1) |
| P1-28 | L8 outcome | - | Post-Capture | | Your input (15 Sept); Audit keeper (call and WhatsApp leave a trace); Canvas; Your answer (30 Sept, review r1); DECISIONS 2026-10-01 |
| P1-29 | L8 outcome | INV-7 | Post-Capture | | Invariant 7; Your answer (17 Sept, escalation); Your answer (30 Sept, review r1) |
| P1-30 | L8 outcome | INV-6 | Post-Capture | | Your input (15 Sept); Your answer (18 Sept); Invariant 6; Your answer (30 Sept, review r1) |
| P1-31 | L8 outcome | - | Post-Capture | | Your answer (18 Sept); see DR-6 |
| P1-32 | L8 outcome | - | Post-Capture | | Canvas; Your input (15 Sept, "completed once the loop is closed"); see DR-1; Your answer (30 Sept, review r1) |
| P1-33 | L8 outcome | - | Post-Capture | | Your answer (17 Sept); Your answer (30 Sept, review r1) |
| P1-34 | L8 outcome | - | Post-Capture | | Your mark (18 Sept) |
| P1-35 | L8 outcome | - | Post-Capture | | Your answer (17 Sept); Audit keeper (report with reason, admin-only removal); Your answer (30 Sept, review r1) |
| P1-36 | L8 outcome | - | Post-Capture | | Audit keeper; Canvas; Your answer (1 Oct, review r1) |
| P1-37 | L8 outcome | - | Post-Capture | | Your input (15 Sept); see DR-5 |
| P1-38 | L7 routing & SLA | - | Post-Capture | | Canvas (contact numbers); Your mark (18 Sept, two clocks); completion numbers are a starting proposal |
| P1-39 | L7 routing & SLA | - | Post-Capture | | Your mark (18 Sept); Your answer (30 Sept, review r1); DECISIONS 2026-10-01 |
| P1-40 | L7 routing & SLA | - | Post-Capture | | Your answer (17 Sept, summary); Canvas |
| P1-41 | L7 routing & SLA | - | Post-Capture | | Your answer (17 Sept, escalation); see DR-3; Your answer (30 Sept, review r1) |
| P1-42 | L7 routing & SLA | - | Post-Capture | | Your mark (18 Sept); Your answer (1 Oct, review r1) |
| P1-43 | L7 routing & SLA | - | Post-Capture | | Canvas; Your decision (clock kept); Your mark (18 Sept, two clocks); Your answer (1 Oct, review r1) |
| P1-44 | L7 routing & SLA | - | Post-Capture | | Your answer (30 Sept, review r1) |
| J1.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input; Canvas (offline) |
| J1.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 |
| J1.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept, summary) |
| J1.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input (no clutter); Your answer (18 Sept, map, revised) |
| J2.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input; Canvas; Your answer (18 Sept, card extras); Your answer (30 Sept, review r1) |
| J2.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Audit keeper (call leaves a trace); Part 1 (P1-28); Your answer (30 Sept, review r1) |
| J2.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Audit keeper; Canvas; Your answer (30 Sept, review r1) |
| J2.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept); Your answer (30 Sept, review r1) |
| J2.5 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input; Canvas (two taps) |
| J2.6 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Audit keeper (navigate) |
| J3.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input |
| J3.2 | L8 SUL app | INV-6 | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept); Your answer (18 Sept, converted); Invariant 6; Your answer (30 Sept, review r1) |
| J3.3 | L8 SUL app | INV-6 | Post-Capture (M1 has the one-page list only) | | Your input; Invariant 6; Your answer (30 Sept, review r1) |
| J3.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Canvas (offline); Audit keeper (outbox) |
| J4.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Canvas; Part 1 (DR-1) |
| J4.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input; Canvas; Your answer (30 Sept, review r1) |
| J4.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-34) |
| J5.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-40, P1-41) |
| J5.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept); Your answer (30 Sept, review r1) |
| J5.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-39); Your answer (30 Sept, review r1) |
| J5.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-38) |
| J5.5 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (1 Oct, review r1, N14) |
| J6.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept); Your answer (30 Sept, review r1) |
| J6.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input; Part 1 (P1-18); Your answer (1 Oct, review r1) |
| J6.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Canvas; Your answer (30 Sept, review r1) |
| J6.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 |
| J7.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input (16 Sept); Your answer (21 Sept, Hina); Your answer (30 Sept, review r1) |
| J7.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input (16 Sept); Part 1 (P1-11) |
| J7.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-24) |
| J7.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your mark (18 Sept) |
| J8.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, shared number) |
| J8.2 | L8 SUL app | INV-2 | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept); Invariant 2; Your answer (1 Oct, review r1) |
| J9.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Canvas (offline-first); Audit lesson (reads were not cached) |
| J9.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Canvas; Audit keeper (outbox) |
| J9.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Canvas; Your answer (30 Sept, review r1); DECISIONS 2026-10-01 |
| J10.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept); Your answer (17 Sept) |
| J10.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input; Audit keeper (presets); Your answer (30 Sept, review r1) |
| J10.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept); Audit lesson (gamification) |
| J11.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept) |
| J11.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-35) |
| J12.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Audit (list search); Canvas (interaction history); Your answer (30 Sept, review r1) |
| J12.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, walk-in lead); Your answer (1 Oct, review r1) |
| J13.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your note (18 Sept, map); Your answer (1 Oct, review r1) |
| J13.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your note (18 Sept); Your answer (1 Oct, review r1) |
| J13.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your note (18 Sept); Part 1 |
| J13.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your note (18 Sept); P2-21 |
| J13.5 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Canvas (offline); Your answer (1 Oct, review r1) |
| P2-1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept) |
| P2-2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input; Part 1 (P1-23); Your answer (1 Oct, review r1) |
| P2-3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Canvas (two-tap rule); see DR-9; Your answer (30 Sept, review r1) |
| P2-4 | L8 SUL app | INV-8 | Post-Capture (M1 has the one-page list only) | | Canvas; Invariant 8 |
| P2-5 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-38); Your answer (1 Oct, review r1) |
| P2-6 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-11) |
| P2-7 | L8 SUL app | INV-1 | Post-Capture (M1 has the one-page list only) | | Canvas; Invariant 1; Your answer (18 Sept, card extras); Your answer (30 Sept, review r1) |
| P2-8 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Canvas; Audit lesson |
| P2-9 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept); Your answers (30 Sept, 1 Oct, review r1) |
| P2-10 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept); Your answers (30 Sept, 1 Oct, review r1) |
| P2-11 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept); Audit lesson |
| P2-12 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Audit keeper |
| P2-13 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Canvas |
| P2-14 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept) |
| P2-15 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-42); Your answer (30 Sept, review r1) |
| P2-16 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept); Your answers (30 Sept, 1 Oct, review r1) |
| P2-17 | L8 SUL app | INV-7 | Post-Capture (M1 has the one-page list only) | | Invariant 7; Your answer (30 Sept, review r1) |
| P2-18 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your input (16 Sept) |
| P2-19 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-12, P1-20) |
| P2-20 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, map, revised); Audit lesson (map never the home screen); Your answer (1 Oct, review r1) |
| P2-21 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, follow-up) |
| P2-22 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your notes (18, 25 Sept); approved with Part 2 |
| P2-23 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (30 Sept, review r1) |
| P2-24 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | | Your answer (1 Oct, review r1) |
| J14.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept); Canvas (breaches first) |
| J14.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your input (SUL-wise); Your answers (30 Sept, 1 Oct, review r1) |
| J14.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, manager view); Your answer (1 Oct, review r1) |
| J14.4 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, flag); Your answer (30 Sept, review r1) |
| J14.5 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your input (territory-wise) |
| J15.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Canvas (region pool); Your answer (18 Sept); Your answer (30 Sept, review r1) |
| J15.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, pool); Your answers (30 Sept, 1 Oct, review r1) |
| J15.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept); Canvas (master drift) |
| J16.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept); Your answers (30 Sept, 1 Oct, review r1) |
| J16.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Canvas; Your answer (18 Sept, progress and gaps) |
| J16.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, manager view) |
| J16.4 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answers (17, 18 Sept); Your answer (30 Sept, review r1) |
| J17.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept) |
| J17.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answers (17, 18 Sept) |
| J17.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept); Your mark (18 Sept, digest) |
| J17.4 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Part 1 (P1-41); Your answer (30 Sept, review r1) |
| J17.5 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, controls) |
| J18.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept); Canvas (model lift); Your answer (30 Sept, review r1) |
| J18.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept); Canvas ("including when unflattering"); approved with Part 3; Your answer (30 Sept, review r1) |
| J18.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, manager view) |
| J19.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept); Your answer (17 Sept, under-threshold); Your answer (30 Sept, review r1) |
| J19.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept); Your answer (1 Oct, review r1) |
| J19.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, PM follow-up); Your answer (30 Sept, review r1) |
| J19.4 | Z04 dashboards / Z00 admin | INV-7 | Post-Capture (M1 has the one-page list only) | | Canvas; Invariant 7 |
| J20.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your input (15 Sept); Your answers (30 Sept, 1 Oct, review r1) |
| J20.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Canvas; Your answer (18 Sept, cost); Your answer (1 Oct, review r1) |
| J20.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept, campaigns); Your answer (30 Sept, review r1) |
| J20.4 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, cost) |
| J20.5 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, controls); Audit keeper (About sheet, as-of and count); Your answers (30 Sept, 1 Oct, review r1) |
| J21.1 | Z04 dashboards / Z00 admin | INV-7 | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept, Admin); Invariant 7; Your answers (30 Sept, 1 Oct, review r1) |
| J21.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, controls); Canvas (weights audited); Your answer (30 Sept, review r1) |
| J21.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept, campaigns); Your answer (30 Sept, review r1) |
| J21.4 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Canvas; Your answers (30 Sept, 1 Oct, review r1) |
| J21.5 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept); Your answer (30 Sept, review r1) |
| J21.5a | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (21 Sept); Your answer (1 Oct, review r1) |
| J21.6 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (17 Sept, reject); Your answer (30 Sept, review r1) |
| J21.7 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answers (17, 18, 28 Sept); Part 7 |
| J21.8 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Canvas; Your answers (18 Sept); Your answer (30 Sept, review r1) |
| J21.9 | Z04 dashboards / Z00 admin | INV-5 | Post-Capture (M1 has the one-page list only) | | Your answer (30 Sept, review r1) |
| J21.10 | Z04 dashboards / Z00 admin | INV-7 | Post-Capture (M1 has the one-page list only) | | Your answer (30 Sept, review r1) |
| J22.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | | Your answer (18 Sept, weekly); Audit keeper; Your answers (30 Sept, 1 Oct, review r1) |
| J22.2 | Z04 dashboards / Z00 admin | INV-7 | Post-Capture (M1 has the one-page list only) | | Audit lesson (no record of sends); Invariant 7 |
| P3-1 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Canvas; Your input (15 Sept) |
| P3-2 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Canvas (one semantic layer); Audit keeper (definitions and sign-off); Your answer (1 Oct, review r1) |
| P3-3 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (18 Sept, manager view); Your answer (1 Oct, review r1); DECISIONS 2026-10-01 |
| P3-4 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answers (17, 18 Sept); Your answer (30 Sept, review r1) |
| P3-5 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Part 1 (P1-43) |
| P3-6 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Canvas; Your answer (18 Sept); Your answer (30 Sept, review r1) |
| P3-7 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your input (15 Sept); Audit keeper; Your answer (30 Sept, review r1) |
| P3-8 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Audit keepers; Your answers (30 Sept, 1 Oct, review r1) |
| P3-9 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (18 Sept, controls) |
| P3-10 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (18 Sept, controls); Canvas (weights audited); Your answers (30 Sept, 1 Oct, review r1); DECISIONS 2026-10-01 |
| P3-11 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (18 Sept, pool); Your answers (30 Sept, 1 Oct, review r1) |
| P3-12 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (17 Sept) |
| P3-13 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Canvas; Your answers (18 Sept); Your answer (30 Sept, review r1) |
| P3-14 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Part 1 (P1-42); Your mark (18 Sept, digest); Your answer (30 Sept, review r1) |
| P3-15 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Canvas; Your answers (30 Sept, 1 Oct, review r1) |
| P3-16 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answers (17, 18 Sept); Your answer (30 Sept, review r1) |
| P3-17 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (18 Sept, weekly); Your answer (1 Oct, review r1) |
| P3-18 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (17 Sept); Canvas; approved with Part 3; Your answer (30 Sept, review r1) |
| P3-19 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (17 Sept, territory); approved with Part 3 |
| P3-20 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your input (15 Sept, "mobile dashboard"); Canvas |
| P3-21 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (30 Sept, review r1); DECISIONS 2026-10-01 |
| P3-22 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (30 Sept, review r1) |
| P3-23 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | | Your answer (30 Sept, review r1) |
| P3-24 | Z04 dashboards; Z00 admin console | INV-5 | Post-Capture; connection health from M4 | | Your answer (30 Sept, review r1); DECISIONS 2026-09-15 |
| P4-1 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Your answer (17 Sept, sources); Canvas; Your answers (30 Sept, 1 Oct, review r1) |
| P4-2 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Your input (15 Sept); Audit lesson |
| P4-3 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Canvas; Your answer (1 Oct, review r1) |
| P4-4 | L1 sources; L2 ingestion | INV-3 | Capture: M2, M4-M7, M8 | | Invariant 3 |
| P4-5 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Canvas; Audit lesson (silent drops) |
| P4-6 | L1 sources; L2 ingestion | INV-9 | Capture: M2, M4-M7, M8 | | Invariant 9 |
| P4-7 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Audit lesson (§7.11) |
| P4-8 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Canvas; Your answer (21 Sept, unsure intent); Your answer (1 Oct, review r1) |
| P4-9 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Your answer (21 Sept); Canvas; Your answers (30 Sept, 1 Oct, review r1) |
| P4-10 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Canvas (AI never in the delivery path); Your answer (1 Oct, review r1) |
| P4-11 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Canvas; D3; Your answer (30 Sept, review r1); DECISIONS 2026-10-01 |
| P4-12 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Your decision D9; Your answer (30 Sept, review r1) |
| P4-13 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Your answer (17 Sept, live feeds) |
| P4-14 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Your answer (21 Sept); Your answers (30 Sept, 1 Oct, review r1) |
| P4-15 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | | Canvas |
| P4-16 | L3 Grower 360 | INV-2 | Capture: M3, M6 | | Invariant 2; Your answer (18 Sept); Your decision D4; Your answer (30 Sept, review r1) |
| P4-17 | L3 Grower 360 | - | Capture: M3, M6 | | Your answer (18 Sept); see DR-13; Your answer (30 Sept, review r1) |
| P4-18 | L3 Grower 360 | - | Capture: M3, M6 | | Your answer (21 Sept, re-asked); Canvas (nothing enters unattached); Your answer (1 Oct, review r1); DECISIONS 2026-10-01 |
| P4-19 | L3 Grower 360 | - | Capture: M3, M6 | | Canvas (secondary matching); Your answer (30 Sept, review r1) |
| P4-20 | L3 Grower 360 | - | Capture: M3, M6 | | Canvas; Your input (16 Sept) |
| P4-21 | L3 Grower 360 | - | Capture: M3, M6 | | Canvas; Your input (15, 16 Sept); Your answers (30 Sept, 1 Oct, review r1) |
| P4-22 | L3 Grower 360 | - | Capture: M3, M6 | | Canvas |
| P4-23 | L3 Grower 360 | INV-1 | Capture: M3, M6 | | Your decision D1 (18 Sept); Invariant 1; Your answer (1 Oct, review r1) |
| P4-24 | L3 Grower 360 | - | Capture: M3, M6 | | Your answer (21 Sept, "no opt-out option for now"); see DR-19 |
| P4-25 | L3 Grower 360 | - | Capture: M3, M6 | | Your answer (21 Sept); Your answer (1 Oct, review r1) |
| P4-26 | L3 Grower 360 | - | Capture: M3, M6 | | Your answer (17 Sept, under-threshold); Part 1 |
| P4-27 | L3 Grower 360 | - | Capture: M3, M6 | | Your answer (21 Sept, re-asked); Your answer (30 Sept, review r1) |
| P4-27a | L3 Grower 360 | - | Capture: M3, M6 | | Your answer (21 Sept, re-asked); Canvas (e-commerce under pulled sources); Your answer (30 Sept, review r1) |
| P4-28 | L2 batch sync; L4 territory | - | Capture: M3, M7 | | Canvas (named steward); Audit keeper; Your answer (1 Oct, review r1) |
| P4-29 | L2 batch sync; L4 territory | - | Capture: M3, M7 | | Your answers (17, 28 Sept); Part 3 (P3-11) |
| P4-30 | L2 batch sync; L4 territory | - | Capture: M3, M7 | | Your answer (17 Sept) |
| P5-1 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | | Your answers (21 Sept, Hina 1 and 2); Your answers (30 Sept, 1 Oct, review r1) |
| P5-2 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | | Your answer (21 Sept, Hina 4); Your answers (30 Sept, 1 Oct, review r1); DECISIONS 2026-10-01 |
| P5-3 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | | Your answer (21 Sept, Hina 3); Your answers (30 Sept, 1 Oct, review r1) |
| P5-4 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | | Your answer (21 Sept); Part 4 (P4-20) |
| P5-5 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | | Your answers (21 Sept, Hina 2 and 3); Part 1; Your answers (30 Sept, 1 Oct, review r1) |
| P5-6 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | | Your answer (21 Sept, Hina 2); Your answers (30 Sept, 1 Oct, review r1) |
| P5-7 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | | Your answer (21 Sept, Hina 1) |
| P5-8 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | | Canvas (automated reads logged); Part 3 (P3-13); Your answer (30 Sept, review r1) |
| P5-9 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | | Your answer (21 Sept, WhatsApp auto) |
| P5-10 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | | Part 1 (P1-39); Your answer (21 Sept); Your answer (30 Sept, review r1) |
| P5-11 | L5 scoring engine | INV-8 | Capture: M1 (v0 stub), weights M8; learning post-Capture | | Invariant 8; Canvas; Your answer (30 Sept, review r1) |
| P5-12 | L5 scoring engine | - | Capture: M1 (v0 stub), weights M8; learning post-Capture | | Your answer (21 Sept, engine + score) |
| P5-13 | L5 scoring engine | - | Capture: M1 (v0 stub), weights M8; learning post-Capture | | Canvas; Part 1 |
| P5-14 | L5 scoring engine | - | Capture: M1 (v0 stub), weights M8; learning post-Capture | | Canvas; Your answer (18 Sept, controls); Your answers (30 Sept, 1 Oct, review r1); DECISIONS 2026-10-01 |
| P5-15 | L5 scoring engine | - | Capture: M1 (v0 stub), weights M8; learning post-Capture | | Canvas |
| P5-16 | L6 tiers | - | Post-Capture; M1 shows segment | | Your input (16 Sept) |
| P5-17 | L6 tiers | - | Post-Capture; M1 shows segment | | Your input; Your mark (18 Sept) |
| P5-18 | L6 tiers | - | Post-Capture; M1 shows segment | | Your input (15 Sept); Your answer (17 Sept) |
| P5-19 | L6 tiers | - | Post-Capture; M1 shows segment | | Your input; Your answer (17 Sept) |
| P5-20 | L6 tiers | - | Post-Capture; M1 shows segment | | Your input (no cap); Your answer (21 Sept, fold); Your answers (30 Sept, 1 Oct, review r1) |
| P5-21 | L6 tiers | - | Post-Capture; M1 shows segment | | Your answer (21 Sept) |
| P5-22 | L4 territory; L7 routing | - | Capture: M3 routing; pool post-Capture | | Your input; Your answers (17, 28 Sept) |
| P5-23 | L4 territory; L7 routing | - | Capture: M3 routing; pool post-Capture | | Your answer (18 Sept); Your answer (30 Sept, review r1) |
| P5-24 | L4 territory; L7 routing | - | Capture: M3 routing; pool post-Capture | | Your answers (21 Sept) |
| P5-25 | L4 territory; L7 routing | - | Capture: M3 routing; pool post-Capture | | Your answers (21, 28 Sept) |
| P5-26 | L4 territory; L7 routing | - | Capture: M3 routing; pool post-Capture | | Approved with Part 3 |
| P5-27 | L7 SLA clock | - | Post-Capture | | Your mark (18 Sept); Your answers (30 Sept, 1 Oct, review r1); DECISIONS 2026-10-01 |
| P5-28 | L7 SLA clock | - | Post-Capture | | Canvas; Your mark (18 Sept); Your answer (21 Sept, campaign clock); Your answer (30 Sept, review r1) |
| P5-29 | L7 SLA clock | - | Post-Capture | | Your answers (17, 18 Sept); Your answer (30 Sept, review r1) |
| P5-30 | L7 SLA clock | - | Post-Capture | | Your answer (21 Sept, calendar); Your answer (30 Sept, review r1); DECISIONS 2026-10-01 |
| P5-31 | L7 SLA clock | - | Post-Capture | | Canvas; Your mark (18 Sept); Your answers (30 Sept, 1 Oct, review r1) |
| P5-31a | L7 SLA clock | - | Post-Capture | | Your answer (30 Sept, review r1) |
| P5-32 | L5 continuous learning | - | Post-Capture | | Canvas; Your answer (30 Sept, review r1) |
| P5-33 | L5 continuous learning | - | Post-Capture | | Canvas (model lift); Your answer (30 Sept, review r1) |
| P5-34 | L5 continuous learning | - | Post-Capture | | Your answer (21 Sept, engine + score); Canvas (no silent self-retuning); Your answer (30 Sept, review r1) |
| P5-35 | L5 continuous learning | - | Post-Capture | | Your answer (21 Sept, unsure intent); Your answer (30 Sept, review r1) |
| P6-1 | Z00 data platform | - | Capture: M1, M3 | | Canvas (one data platform); Audit lesson (§7.12, §7.22) |
| P6-2 | Z00 data platform | - | Capture: M1, M3 | | Audit keeper (healthy is affirmative) |
| P6-3 | Z00 data platform | - | Capture: M1, M3 | | Canvas (PII tagged); Audit lesson (§7.4) |
| P6-4 | Z00 data platform | - | Capture: M1, M3 | | Audit lesson (§7.13) |
| P6-5 | Z00 data platform | - | Capture: M1, M3 | | Rule book (`CLAUDE.md`); Your answer (1 Oct, review r1) |
| P6-6 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Canvas; Your input (15 Sept); Your answer (30 Sept, review r1) |
| P6-6a | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (30 Sept, review r1) |
| P6-7 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (17 Sept); Your answer (1 Oct, review r1) |
| P6-8 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (17 Sept); Your answers (30 Sept, 1 Oct, review r1) |
| P6-9 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (21 Sept, volumes); Plan M8 (the burst); Your answer (1 Oct, review r1) |
| P6-10 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Canvas; Your answers (18, 21 Sept); Your answer (30 Sept, review r1) |
| P6-11 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (17 Sept, retention); Canvas; Your answers (30 Sept, 1 Oct, review r1) |
| P6-12 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (21 Sept); Your answer (1 Oct, review r1) |
| P6-13 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (21 Sept, season); Your answer (30 Sept, review r1) |
| P6-14 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (21 Sept, receipts); Your answer (1 Oct, review r1) |
| P6-15 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Canvas; Your answers (18 Sept); Your answer (30 Sept, review r1) |
| P6-16 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (21 Sept, login); Canvas (SSO where available, deferred); Your answer (30 Sept, review r1) |
| P6-17 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (21 Sept, operations); Your answer (30 Sept, review r1) |
| P6-17a | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answer (30 Sept, review r1) |
| P6-18 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your input (15 Sept); Your answer (30 Sept, review r1) |
| P6-19 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Audit keepers; Your answer (1 Oct, review r1) |
| P6-20 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Audit lesson (§7.11); Your answer (18 Sept, no PKR estimate) |
| P6-21 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Rule book (`CLAUDE.md`); Audit lesson (§7.21) |
| P6-22 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | | Your answers (30 Sept, 1 Oct, review r1) |
| P6-23 | Z00 platform & control; L2 ingestion | INV-9 | Capture: M4 (connector template) | | Your answer (1 Oct, review r1) |
| P6-24 | — (rollout) | - | Before M8 | | Your answer (30 Sept, review r1) |
| P6-25 | — (rollout) | - | Before M8 | | Your answer (30 Sept, review r1) |
| P6-26 | — (rollout) | - | Before go-live | | Your answer (30 Sept, review r1) |
| P6-27 | — (rollout) | - | Pilot | | Your answer (30 Sept, review r1) |
| P6-28 | — (rollout) | - | M6 | | Your answer (30 Sept, review r1) |
| P7-1 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your note (25 Sept) |
| P7-2 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your note (25 Sept); Part 1 (P1-3); Your answer (30 Sept, review r1) |
| P7-3 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answer (28 Sept, franchise per BSA); revises P5-25 |
| P7-4 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your note (25 Sept); Your answer (28 Sept, outside areas); Your answer (1 Oct, review r1); DECISIONS 2026-10-01 |
| P7-5 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answer (28 Sept, placement); Your answers (30 Sept, 1 Oct, review r1) |
| P7-6 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answer (28 Sept, placement); Part 5; Your answer (30 Sept, review r1) |
| P7-7 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your note (25 Sept) |
| P7-8 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answers (25, 28 Sept) |
| P7-9 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answer (28 Sept, structure gaps); Your answer (30 Sept, review r1) |
| P7-10 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answer (28 Sept, which point); Your answer (30 Sept, review r1) |
| P7-11 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answer (28 Sept); approved with Part 3 |
| P7-12 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your note (25 Sept) |
| P7-13 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Part 6 |
| P7-14 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answer (28 Sept, address service); Your answers (30 Sept, 1 Oct, review r1) |
| P7-15 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answer (28 Sept, ownership) |
| P7-16 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answer (28 Sept, ownership); Your answer (30 Sept, review r1) |
| P7-17 | L4 territory mapping; L7 routing | - | Capture: M3 (routing), M7 (masters); boundaries and conversion M3 | | Your answer (28 Sept, structure gaps); Audit keeper (unresolved rows counted) |
### A.2 Records at field level

Types: text · number · whole number · money (PKR, stored as whole paisa, shown as
whole rupees) · date-time (stored UTC, shown Asia/Karachi) · date · yes/no ·
choice (fixed list) · reference (points at another record) · photo · position
(latitude, longitude). **PII** marks personal data (P6-3). **Req** = required.

**Grower** — id · name (text, PII, req) · mobile (text, PII, req, unique across growers; change history: old value, new value, who, when, undone-by) · alternate_mobiles (list of text, PII; from a merge, P4-17) · province, district, tehsil, village (choice from the location list, PII) · position (PII, optional) · position_status (choice: from_signal, confirmed_sul) · position_history (value, source, who, when; PII) · language (choice: ur, en; the SUL app only — Hina calls in Urdu) · new_or_existing (choice, set by SUL) · crops (list of choice) · acreage (list of: crop, acres number, status choice estimated/confirmed_sul/confirmed_hina, source reference, when; the threshold compares the total) · last_season_status (choice: converted / not converted / unreachable / untouched / none; rule in P1-26) · last_activity (date-time) · anonymised_at (date-time, optional).

**Signal** — id · stream (choice: the nine lead streams and the e-commerce purchase stream in 4.2) · source_event_id (text, req; unique together with stream — INV-3, A4) · grower (reference, optional until matched) · occurred_at (date-time, req) · kind (choice: scan, message, post, form, call, purchase, campaign_response) · words (text, PII, optional) · crop, problem (choice/text) · severity, confidence (number, optional) · campaign (reference, optional) · raw (the original as received, unchanged; PII) · held_reason (choice: none, campaign_unreadable, invalid, location_outside_structure; text detail) · consent_basis: stream + occurred_at (derived; never null on a lead — INV-1, A6).

**Lead** — id · grower (reference, req) · signals (list of references) · crop · need · recommended_product (reference, derived from Product.treats) · acreage_status (derived) · intent (choice: buy, advice, unclear; confidence number; source choice words/hina/sul) · stream (first signal's) · campaign (reference, optional; the credited campaign, P1-8a) · also_touched (list of campaign references) · segment (choice: hot, campaign, potential) · below_threshold (yes/no) · state (choice, the thirteen of P1-27; transitions only through one function — INV-5, A5) · state_history (who, when, from, to) · territory, sul (reference) · contact_clock, completion_clock (start = when the SUL's phone received the lead, promise_at, stopped_at = the time logged on the phone, overdue yes/no) · time_to_first_contact (Hina hold, pool wait, SUL clock) · follow_up_date (date) · flags (list) · hina_attempts (list) · last_season_tag · rejection (reason choice, who, when, admin_action).

**Score** — lead (reference) · value (whole number 0–100) · weights_version (reference) · engine_version_hash (text, req — INV-8, A1) · contributions (list of ingredient, points) · adjustments (list of adjustment, points) · reasons (three, text, ur and en) · scored_at.

**Outcome** — lead · kind (choice: converted, not_converted, unreachable, below_threshold, no_valid_number, merged, rejected) · value (money, the receipt total, req for converted — INV-6) · product_lines (list of: product reference, quantity number, unit choice; at least one, req for converted) · receipt (photo, PII, req for converted until POS; refused if already on another conversion) · reason (choice, req for not_converted; the five of P1-32; for unreachable, the three of P1-33) · comment (text) · closed_by (reference, req) · closed_at (date-time, req).

**Hina call** — lead · attempt (whole number, 1 to the active hina_attempts) · at · outcome (choice: answered, no_answer, wrong_number, refused) · acreage, crop, intent, location returned · summary (text, ur and en, PII, at most hina_summary_max_chars) · no audio, no transcript.

**Flag** — from_user, to_user · on (choice: lead, territory, region, zone) and its reference · parent_flag (reference, optional; the flag it was passed down from) · note (text) · due (date) · sent_at · answered_at, answered_by (action or reply).

**Campaign** — id · name · kind (choice: brand, crop_programme) · npi (yes/no) · portfolio (choice: insecticides, fungicides, herbicides, biologicals_seed_care) · brand or programme (text) · product (reference) · crop · starts, ends (date) · contact_promise, completion_promise (hours/days, req; not below the campaign-promise floor) · budget, spend (money; change history) · talk_track (text, ur and en, optional) · campaign_id_convention (text, per D3).

**Product** — id · name · portfolio · brand · treats (list of crop, problem; problem may be "preventive") · approved_by (PM, when).

**Sales structure** — zone (choice of four) · region · territory · bsa · sul (reference, optional; at most one per territory, and each SUL on exactly one territory) · sul_position (position) · change history. **BSA** — id · territory · franchises (list of: name, position; business data) · villages (list). **Location** — province · district · tehsil · village · bsa. **Boundary** — village · polygon · file_version · loaded_at · active (yes/no; the previous version can be restored). **Timing** — crop · problem · zone (optional; blank = national) · months (list) · approved_by. **Lead placement** — lead · method (choice: boundary, converted_address, nearest_franchise, pool_assigned) · village, bsa (optional for a pool assignment) · territory · boundary_file_version (optional) · distance_km (number, optional) · conversion_confidence (number, optional) · candidates (list of villages, when ambiguous).

**User** — id · name · syngenta_email (text, unique, must be a Syngenta address; the login) · staff_mobile (text, for the weekly summary) · role (choice: sul, rsm, zm, head_of_sales, leadership, pm, marketing, admin, dbo; call-centre agents are dbo-scoped to the capture form) · scope (territory / region / zone / portfolio / all) · language · active · change history (who, when, before, after).

**Targets** — kind (choice: contact_on_time, completion_on_time, leads_converted, sales_value, leads_followed_up) · level and unit (reference) · value · period · on (yes/no) · entered_by · recommended_by (Head of Sales) · versioned.

**Vendor register** — third party · what it receives · where it keeps it · how long · processing agreement (document, signed by, when) · recording deletion days · escalation contact · response time · connection (reference).

**Settings** (each versioned: value, previous, who, when; each within a minimum and maximum, O-6) — acreage_threshold (20) · contact_promise_hot (24 h), _potential (72 h) · completion_promise_hot (7 d), _potential (14 d) · campaign_promise_floor (24 h contact, 7 d completion) · weights (30/25/20/15/10; must total 100) · age_decay_per_day (2), age_grace_hours (48), age_floor (O-5) · reachability_penalty (15) · serviceability_penalty (10) · nearest_franchise_cap_km (50) · fold_size (20) · unreachable_spacing (two days, 24 h apart) · hina_attempts (3), hina_days (2) · hina_summary_max_chars (O-9) · intent_confidence_min (O-8) · intent_wait_seconds (O-8) · push_delivery_minutes, burst_delivery_minutes, poll_interval_minutes per stream (O-7) · breach_digest_times (08:00, 14:00) · quiet_hours (21:00–07:00) · receipt_sample_percent (5) · stale_figures_hours (O-11) · season_start (date) · pause_days (list of dates) · working_week (O-14) · acreage_bands (under threshold · threshold–49 · 50–99 · 100+) · retention_seasons (2; between 1 and 3) · no_valid_number_delete_months (O-12) · phone_data_expiry_hours (O-10).

**Audit entry** — who · when · action (choice: the one list in P6-15) · record (reference) · before, after (for settings) — append-only, never edited; no grower name, number, words or location.

### A.3 Technical non-functionals

- Webhook streams acknowledge within 100 ms and hand the work to a queue; extraction, Hina hand-off, scoring and routing run in workers with retries and a dead-letter queue that is replayable and alerted (A3). P6-9's burst is a queue-depth number, not an outage.
- Idempotency is a unique constraint on (stream, source_event_id) at the write, not a check in code (A4, INV-3).
- Consent basis is a NOT NULL column on every lead, derived from the signal that created it (A6, INV-1), from the first migration.
- Scope is enforced in the query layer: one function reads leads for a user and applies the hierarchy filter; no screen queries leads any other way (A8, INV-7).
- Lifecycle transitions live in one function; states are an enum (A5, INV-5, INV-6).
- Scoring is a pure function `score(lead, weights, now) → {value, segment, reasons, engineVersion}` with no database, network or clock inside (A1, INV-8); a season can be replayed against a new weights version before it ships.
- Weights and every setting live in the database, versioned; the engine reads the active version (A10).
- PII columns are tagged in the schema; logs, exports and the warehouse redact by rule; a phone number never appears in a log line (A7, PROCESS §12).
- The SUL app is offline-first from its first screen: an encrypted local store, an outbox of actions each carrying the time it was logged on the phone, sync on reconnect. An SUL's state changes apply in logged order and stop clocks at the logged time; a server re-score or segment move never overrides them; only an Admin removal or a territory change does, and then the entry goes to Admin's review list. Nothing logged is discarded (A9; J9.3, P6-6a).
- Money is integer paisa in storage, whole rupees on screen; time is UTC in storage, Asia/Karachi on screen (`CLAUDE.md`).
- Config from environment only, every variable documented in `.env.example` (`CLAUDE.md`; AR-19). No dead code, no swallowed errors (AR-14, AR-20).
- Residency: all grower data at rest in Pakistan (P6-12) — a Phase 3 hosting constraint, decided in tech.md from Syngenta's recommended stack.
- Every inbound webhook, Hina's included, verifies the provider's signature before it is acknowledged; an unsigned or invalid request is refused and counted on Connections (P6-23). Key storage, backup and restore, and the uptime target are in docs/INFRA.md (Phase 3, SYN-13).
- Login: Syngenta email address plus a Synapse password, registration restricted to the Syngenta email domain (P6-16); SSO deferred (6.3.2).
- Routing: point-in-polygon against the digitised village boundaries (Punjab, Sindh); nearest-point search over BSA franchise coordinates elsewhere with a distance cap; forward geocoding of a complete address through a service that receives the address text only — behind one interface so an internal Syngenta geocoder or an outside provider can sit behind it (P7-14, choice pending). Placement is recorded per lead (method, distance, confidence) — Part 7.
- Routing also refuses to place a converted address that resolves only to a tehsil or district or matches more than one village (P7-5); while the address service is down the lead is held and retried.
- Hina: an outbound integration (Synapse → third party: ordered lead batch with attempt limit) and an inbound one (third party → Synapse: structured answers per attempt, summary text, signed); every inbound is idempotent on (lead, attempt); every call is an audit entry (P5-8). Synapse keeps the hold's clock: a lead is released when hina_days have passed whatever Hina has reported, and Admin's off switch releases every held lead at once (P5-5).

### A.4 Keeper map — audit §9 behaviours, where each landed

| Keeper | Row(s) | Note |
|---|---|---|
| K1 Call and Navigate inline, each leaving a trace | P2-12, J2.2, J2.3, J2.6 | WhatsApp added |
| K2 Structured reason on non-conversion; proof photo on conversion | P1-30, P1-32, J3.2, J4.1 | Reasons are the canvas five (DR-1); receipt required until POS |
| K3 "Report this scan" with reason; admin-only removal | P1-35, P1-36, J11 | Four fixed reasons; Admin review list |
| K4 Honest reporting: incomplete-data banner, export off on partial read, About sheet, "as of" + count, unresolved rows counted | P3-8, P6-19, J20.5 | — |
| K5 Revenue stated as a floor with the unvalued count beside it | P3-8, P6-19 | Re-read: under INV-6 every conversion has a value; the "floor" idea survives as unresolved rows (unknown acreage, unmatched village) counted openly beside every total |
| K6 KPI definitions in one place; a sign-off page that reconciles them | P3-2 | Called the "reconciliation view" in this specification (review r1, N39) |
| K7 One territory master as the single source of truth | 4.5 sales structure, P4-29, P6-4 | Owner DBO |
| K8 Healthy is affirmative; blank is unknown | P6-2, P4-12 | — |
| K9 A daily summary to management on WhatsApp | P3-17, J22 | Changed to weekly, Monday 9 am (17 Sept) |
| K10 The idea of an offline outbox | P2-8, P6-6, J9 | Full offline-first, reads included |
| K11 Date presets that match the field: this week, month to date | P2-16, P3-7, J10.2 | Plus quarter, year, custom |

### A.5 Mistake map — audit §7 and §9, each to the row that forbids it

| Audit | Pattern | Forbidden by |
|---|---|---|
| §7.1 | Authorisation in the browser | AR-1 |
| §7.2 | Hidden unscoped routes | AR-2 |
| §7.3 | No consent basis anywhere | AR-3 |
| §7.4 | PII duplicated and unmarked | AR-4 |
| §7.5 | Phone as free text; newest spelling wins | AR-5 |
| §7.6 | No source event id; duplicates by design | AR-6 |
| §7.7 | hot_lead as a typed flag; no score, factors or version | AR-7 |
| §7.8 | Lifecycle by direct updates from five places | AR-8 |
| §7.9 | Conversion as a float PKR only | AR-9 |
| §7.10 | Flags as pseudo-states | AR-10 |
| §7.11 | One manual import; errors do not block; silent defaults | AR-11 |
| §7.12 | Full-table fetch and in-browser metrics | AR-12 |
| §7.13 | Two sources of truth for role and territory | AR-13 |
| §7.14 | Swallowed errors | AR-14 |
| §7.15 | Hard-coded gamification weights; two formulas | AR-15 |
| §7.16 | Offline queue with fake ids, reads not cached | AR-16 |
| §7.17 | Territory by fuzzy text matching | AR-17 |
| §7.18 | Scheduled service-role read of grower data, unlogged | AR-18 |
| §7.19 | No `.env.example`; undocumented variables | AR-19 |
| §7.20 | Dead code, dead guards, dead dependencies | AR-20 |
| §7.21 | Documentation asserting tests that do not exist | AR-21 |
| §7.22 | Numbers from whichever entity happened to load | AR-22 |
| §9 a | Manual spreadsheet as the ingestion layer | AR-23 (and AR-11) |
| §9 b | Gamification with hard-coded weights | AR-24 (and AR-15) |
| §9 c | Documentation claiming verification it does not have | AR-21 |

25 of 25 mapped.

### A.6 Disagreement register — index

DR-1 to DR-8, DR-34 and DR-38 in 1.9 · DR-9 to DR-14 in 2.7 · DR-15 to
DR-18 and DR-39 in 3.7 · DR-19 to DR-22 and DR-35 in 4.8 · DR-23 to DR-28,
DR-36 and DR-37 in 5.11 · DR-29 to DR-31 in 6.6 · DR-32 and DR-33 in 7.6. Each
records the spec's position against the canvas's, the audit's, an earlier
decision's or an earlier part of this specification, and why; none is
resolved in a row. DR-34 to DR-39 were added from the session 2.2 review
(1 Oct). *Revised 1 Oct (review r1, S125).*

### A.7 Question log — index

Every question asked in session 2.1, its answer and date, is in the part it
belongs to (1.8, 2.6, 3.6, 4.7, 5.10, 6.5, 7.5). Ahsan's words are verbatim in
`docs/notes/spec-input-2026-09-15.md`, `-16.md`, `-17.md`, `-18.md`,
`-25.md`. The session 2.2 review's questions and answers are in
`docs/reviews/spec-r1-raw/triage.md`. *Revised 1 Oct (review r1, S125).*

### A.8 Audit §8 unknowns carried into this specification

| Audit §8 | Carried as |
|---|---|
| 8.6 Where the spreadsheets came from | Every stream "to confirm with the system owner" (P4-13); the M2 spike proves the first |
| 8.7 The intent behind Isabion Gold Campaign | Campaigns are records Marketing defines and Admin creates (P3-16); no campaign is named in the spec |
| 8.1–8.5, 8.8–8.11 | Base44-specific (sandbox isolation, run history, platform defaults, live data, build, `functionsVersion`, MCP consent page, deny rules, master currency); not specification questions |

### A.9 Quality and evidence rules the build inherits

`pnpm check` green on every PR; test run count non-zero; schema package 100% type coverage; scoring package 100% test coverage; every invariant-guarding test names the invariant; no real grower name or number anywhere; PR descriptions carry evidence (PROCESS.md §1, §11, §12). A.1's "Came from" column equals the body row's cell and is checked on every change to this file (review r1, S114).
