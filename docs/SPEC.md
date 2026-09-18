# Synapse specification

Version: **v0.3 — Parts 1 to 3 approved; Part 4 next** ·
Owner: Ahsan · Task: SYN-9

> **How this document is built.** Six parts, each written in plain language
> and marked by Ahsan before the next is drafted. A technical appendix follows
> Part 6 and can be skipped. After v1.0, a change to this file is a change
> request (`docs/PROCESS.md` §3), never an edit.
>
> **Inputs, in order of precedence.** `docs/INVARIANTS.md` (nine rules that
> change only through a DECISIONS entry) · Ahsan's product input
> (`docs/notes/spec-input-2026-09-15.md`, `-16.md`, `-17.md`) ·
> `docs/reference/01-product-canvas.md` · `docs/notes/base44-audit.md`.
> Where Ahsan's input and the canvas differ, the spec follows Ahsan and
> records the canvas's position in the part's disagreement register.
>
> **How to mark.** Every row has a Mark column. Write **R** (right), **W**
> (wrong, say why in one line) or **A** (ask the field). Or reply in chat by
> row ID. Rows labelled "Canvas — not in your input" are things the canvas
> specifies that you have not mentioned; strike them freely. Rows labelled
> **ASSUMPTION** are gaps found while drafting that no input answers; each
> carries a recommendation and needs your mark before it is treated as decided.
>
> **Words.** SUL = Sales Unit Lead, the person who works leads in one
> territory. "Routed" = sent to an SUL's phone. "Threshold" = the acreage
> threshold, 20 acres, changeable in Admin. Money is shown in PKR; time in
> Pakistan time.

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
sees one level below them, by name, and their own total. Every screen answers
one question.

**Pilot and Capture.** The Pilot is the go-live subset (Crop Doctor, WhatsApp
and one campaign, two zones, the first scorecard). Capture is the first build
scope: all nine streams plus the one-grower record. This document specifies
the whole product; the appendix says what Capture builds.

### 1.2 Who uses Synapse — eight stakeholders

| Stakeholder | Goal in one sentence | Where and how | Sees | Can change |
|---|---|---|---|---|
| **Sales Unit Lead (SUL)** | Convert the leads in my territory, in order, without missing one | Phone, in the field, patchy signal, Urdu or English | Own territory's leads in three segments; own summary | Every lead's state and outcome; the grower's acreage and new/existing mark |
| **Regional Sales Manager (RSM)** | Know which SUL is letting leads go cold, and follow up | Phone first | Region's SULs and territories, by name; overdue first | Flags a lead for an SUL to act on |
| **Zonal Manager (ZM)** | Know whether a region is short of leads or short of follow-up | Phone first | Zone → regions → territories, by name | Flags a lead for an RSM |
| **Head of Sales** | Compare zones on the same numbers and the national on-time rate | Phone and desktop | All zones side by side; drill zone → region → territory; breach notifications for every zone | Flags, as above |
| **Country Leadership Team** | See whether the funnel is growing and whether the engine beats a plain list | Desktop; a monthly one-page summary | National funnel by source and campaign; conversions and PKR by zone and portfolio; on-time rate; engine versus plain list | Nothing; read-only |
| **Portfolio Manager** | Know whether my portfolio's brands and campaigns produced leads that converted, and chase the field where they did not | Phone first | Own portfolio (insecticides, fungicides, herbicides, or biologicals and seed care); its brands, campaigns and leads; drill zone → region → territory | Nothing on a lead; can follow up with the team |
| **Marketing** | Decide where next season's campaign spend goes | Desktop | Campaigns, portfolios, brands, channels, with totals; never a grower's name or number | Defines campaign names; asks Admin to create them |
| **Admin** | Keep Synapse correct: users, territories, settings, campaigns, connections, audit | Desktop portal; own login | Everything in the portal; the below-threshold list; rejected leads; connection health; audit trail | Users and roles, territories, the acreage threshold, clock promises, scoring weights, campaigns |

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-1 | Serves the eight stakeholders above; each sees their own level and everything beneath it, named, and nothing beside or above it. | An RSM opens Synapse and sees their region's SULs by name; there is no way to open another region. | Your input (15, 16 Sept); Canvas; Invariant 7 | |
| P1-2 | Growers are never users. They are reached by an SUL, or by an automated WhatsApp message under the rules in Part 5. | No grower login exists anywhere. | Audit §1.5; Canvas | |
| P1-3 | Every SUL owns exactly one territory and every territory has exactly one SUL; leads for a territory go to its SUL. | Admin assigns territory T to SUL X; a new lead in T appears on X's phone, nobody else's. | Your input (15 Sept) | |
| P1-4 | Marketing and Portfolio Managers see campaigns, brands and totals, never a grower's name, number or village. | A Marketing user opens a campaign and sees 1,240 leads by product and crop; no row names a grower. | Canvas; Invariant 7 | |
| P1-5 | Admin is the digital team on its own login, never combined with a sales or marketing role; every Admin action is recorded with who and when. | A Portfolio Manager who also administers Synapse has two logins; the audit trail shows which one changed a weight. | Your answer (17 Sept) | |
| P1-6 | Country IT manages who may log in; Admin manages everything else. | A new SUL is given access by IT; Admin then assigns their territory. | Your answer (17 Sept) | |

### 1.3 What a lead is

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-7 | A lead is one grower showing demand through one of nine streams: Crop Doctor scans, Savera conversations, Cropwise community posts, WhatsApp inbound, Facebook, TikTok, call-centre capture, NPI campaigns, brand campaigns. No lead ever arrives by manual upload. | Every lead shows which stream it came from; there is no "import" button anywhere. | Your input (15 Sept); Canvas; Audit lesson | |
| P1-8 | Every lead belongs to exactly one grower record. When the same grower speaks through three streams, Synapse recognises one grower and merges the signals into one lead rather than three. | A grower who scanned in Crop Doctor on Monday and messaged on WhatsApp on Wednesday appears once on the SUL's list, with both signals shown, and the score has risen. | Invariant 2; Invariant 3; Canvas | |
| P1-9 | The same signal arriving twice never creates a second lead. | A WhatsApp provider resends yesterday's message; nothing new appears. | Invariant 3 | |
| P1-10 | A lead carries: the grower (name, number, village), crop, problem or need, acreage (estimated, confirmed, or unknown), source stream, campaign if any, score with its top three reasons, segment, clock, territory and SUL, last season's status if any, the new/existing mark, and the grower's history. | An SUL opens a lead and sees all of these on one card without scrolling to another screen. | Your input (15 Sept); Canvas | |
| P1-11 | Acreage is marked **estimated** when it came from a source or a conversation, **confirmed** when an SUL logged it after asking the grower, and **unknown** otherwise. | The lead card shows "Acreage: 25 (estimated)" or "25 (confirmed)" or "unknown". | Canvas; Your input (16 Sept) | |
| P1-12 | No SUL is asked to contact a grower whose consent to be contacted is not recorded. Leads from such growers are kept and counted, but not routed, until the consent basis is known. Decision D1 governs data captured for crop advice. | Until D1 is decided, Crop Doctor, Savera and community signals are stored on the grower's history but no SUL is asked to call. | Invariant 1; Canvas — not in your input; D1 | |

### 1.4 The three segments and the acreage rule

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-13 | An SUL's home screen shows three segments and nothing else: **Hot**, **Campaign**, **Potential**. | Three tiles with counts and today's due leads; no fourth bucket, no source filters on the home screen. | Your input (15 Sept); Your decision (segments) | |
| P1-14 | **Hot** = the grower showed clear purchase intent (asked a product price, asked for the nearest franchise, or said they need the product) **and** the crop is known **and** acreage is at or above the threshold. All three; the score only orders leads inside Hot. | A grower with 30 acres of cotton who asked the price of a product is Hot however the score lands; a grower who asked the same with unknown acreage is not. | Your input (15 Sept); Your answer (17 Sept); see DR-2 | |
| P1-15 | **Campaign** = the lead carries a marketing campaign (brand-level or a full crop programme). Opening a campaign shows its leads grouped by product and by crop, with crop and acreage on each. | An SUL opens "Dhaan ki Shaan", sees its leads grouped by product, then by crop, each with acreage. | Your input (15 Sept); Your answer (17 Sept, campaigns) | |
| P1-16 | **Potential** = every other routed lead, ranked, with crop and acreage shown when known and the lead shown even when acreage is unknown. | A Crop Doctor scan of a diseased crop with no acreage yet appears in Potential marked "acreage unknown". | Your input (15 Sept) | |
| P1-17 | Inside Potential, a separate tab shows **last season's growers**: those converted last season and those never touched last season, so the SUL can start the season from known ground. | Potential has two tabs: "This season" and "Last season". | Your answer (17 Sept, lifecycle) | |
| P1-18 | A lead that carries a campaign sits in the **Campaign** segment even when it meets the Hot conditions. Inside the campaign it is tagged "meets Hot conditions" and ranks first; it is never shown in Hot. | A campaign lead whose grower asked the price appears under its campaign with a "Hot" tag at the top of the campaign's list, and not in the Hot segment. | Your mark (18 Sept) | R |
| P1-19 | The **acreage threshold** is 20 acres, held as an Admin setting; every change is recorded; the same number applies everywhere the threshold is used (Hot, hiding, healthy scans). | Admin changes 20 to 25; from then on Hot needs 25, and the audit trail shows who changed it and when. | Your input (16 Sept); Your answer (17 Sept, one threshold) | |
| P1-20 | Known acreage **below** the threshold: the lead is never shown to any sales user. It is kept in the portal on Admin's "below threshold" list, counted in Marketing and Portfolio Manager totals labelled "below threshold", and still builds the grower's record. | A 5-acre grower who asked a price never appears on an SUL's phone; Marketing sees the campaign produced 300 below-threshold leads. | Your input (16 Sept); Your answer (17 Sept) | |
| P1-21 | Acreage **unknown**: the lead is routed to Potential (or Campaign) marked "acreage unknown". Synapse asks the grower once by WhatsApp (Part 5); the SUL is prompted to ask and log it. | The lead card shows "Acreage unknown — ask and log" with a one-tap entry. | Your input (15, 16 Sept); Canvas | |
| P1-22 | When an SUL logs an acreage it stays on the grower and shows on every later lead. If it is below the threshold, the lead the SUL is working is **closed at once** (state "Closed: below threshold"), and that grower's later leads are not routed to the SUL. | The SUL logs 12 acres; the lead closes with "below threshold" in its history and leaves the list; next season the same grower's scan goes to the below-threshold list. | Your input (16 Sept); Your mark (18 Sept) | R |
| P1-23 | There is **no cap** on how many leads an SUL receives. Inside each segment leads are ranked by score, today's due leads first; leads with low scores sit below a "more leads" fold. | An SUL with 80 Potential leads sees the top ones first and taps "more" to see the rest; nothing is withheld. | Your input (15 Sept); Your decision (segments); see DR-4 | |
| P1-24 | Any new signal on an existing lead re-scores it and can move it up a segment. | A Potential lead whose grower then asks the price on WhatsApp and gives 30 acres moves to Hot and the SUL is notified. | Canvas | |
| P1-25 | A **healthy** Crop Doctor scan becomes a lead only when the grower's known acreage is at or above the threshold; otherwise it is recorded on the grower's history and no lead is made. | A healthy scan from a 40-acre grower appears in Potential; the same scan from a 6-acre grower or an unknown-acreage grower creates no lead. | Your decision D9 | |
| P1-26 | **Seasons.** When a grower returns next season through any stream, the lead goes through the full cycle again, including scoring, and carries a tag showing last season's status. | A lead card shows "Last season: converted, PKR 85,000" or "Last season: not reached". | Your answer (17 Sept, lifecycle) | |

### 1.5 How a lead moves and ends

A lead is in exactly one state. It moves only along the arrows below, and every
move is recorded with who and when. There is one path and no hidden flags.

```
New → Contacted → Visit planned → Follow-up → Completed: converted
                                            → Completed: not converted (reason)
                                            → Closed: unreachable (after 3 failed attempts, reason)
Any open state → Closed: below threshold (SUL logs acreage under the threshold)
Any open state → Rejected (SUL, reason) → Admin review
```

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-27 | Eight states: **New** (routed, untouched), **Contacted**, **Visit planned**, **Follow-up**, **Completed: converted**, **Completed: not converted**, **Closed: unreachable**, **Closed: below threshold**. One way in to each; every move logged. | A lead's history reads like a diary: "New 3 Oct 09:10 · Contacted 3 Oct 11:40 by SUL X · Visit planned 5 Oct …". | Your input (15 Sept); Your answer (17 Sept); Invariant 5 | |
| P1-28 | **Contacted** is logged automatically when the SUL calls or messages from inside the lead, or with one tap when they contacted the grower another way. Each contact attempt, successful or not, is a line in the history. | The SUL taps Call; the lead moves to Contacted and the call is in the history. | Your input (15 Sept); Audit keeper (call and WhatsApp leave a trace); Canvas | |
| P1-29 | Only the SUL who owns the lead, or Admin, can move it. Managers flag; they do not move. | An RSM cannot mark a lead Contacted; they can flag it. | Invariant 7; Your answer (17 Sept, escalation) | |
| P1-30 | **Completed: converted** requires the PKR value, a **receipt photo** (required until point-of-sale integration exists), the **product** and **quantity**, and the new/existing mark. The closing SUL and date are recorded automatically. *Revised 18 Sept: product and quantity became required (Part 2, question 7).* | The SUL cannot save "converted" without value, receipt, product and quantity; the record shows who closed it and when. | Your input (15 Sept); Your answer (18 Sept); Invariant 6 | R |
| P1-31 | No **fulfilling franchise** is recorded on a conversion until point-of-sale integration exists; the receipt shows it. *Revised 18 Sept.* | No franchise field on the conversion screen. | Your answer (18 Sept); see DR-6 | R |
| P1-32 | **Completed: not converted** requires one reason from a fixed list — no need · no budget · no stock at the franchise · bought a competitor · wrong contact — and an optional comment. | The SUL cannot close a lead as not converted without picking a reason. | Canvas; Your input (15 Sept, "completed once the loop is closed"); see DR-1 | |
| P1-33 | **Closed: unreachable** — after three failed contact attempts, each logged, the SUL closes the lead with a reason from the dropdown. | After the third failed call the lead offers "Close as unreachable" with a reason list. | Your answer (17 Sept) | |
| P1-34 | A lead closed this season stays closed this season. A new signal from that grower in the same season creates a new lead under the normal rules, with the closed lead visible in the grower's history. A closed lead never silently re-opens on an SUL's list. | The grower who was unreachable in October messages in November; a new lead appears with "Closed: unreachable, 12 Oct" in its history. | Your mark (18 Sept) | R |
| P1-35 | **Reject a lead.** An SUL can mark a lead "not a valid lead" with one fixed reason — not my territory · duplicate of another lead · internal or test entry · wrong contact details. It leaves the SUL's list at once and goes to Admin's review list, where Admin reassigns, merges or removes it. Rejections are counted per source. | A lead from the wrong district vanishes from the SUL's list after one tap; Admin sees it under "Rejected" with the reason. | Your answer (17 Sept); Audit keeper (report with reason, admin-only removal) | |
| P1-36 | Nothing is deleted by an SUL. Removal is Admin's alone and leaves an audit line. | The audit trail shows "Lead 4821 removed by Admin Y, reason: test entry". | Audit keeper; Canvas | |
| P1-37 | Every lead shows the **new/existing** mark the SUL sets for the grower; the mark stays on the grower for every later lead. | Card header: "Existing grower" or "New grower". | Your input (15 Sept); see DR-5 | |

### 1.6 The clock

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-38 | Every routed lead carries **two promises**, both Admin settings. **Contact:** Hot within 24 hours, Campaign within the promise set when Admin creates the campaign, Potential within 72 hours. **Completion:** Hot within 7 days, Campaign per campaign, Potential within 14 days. | Each lead shows two countdowns, "contact by" and "complete by"; Admin's settings page lists all six promises. | Canvas (contact numbers); Your mark (18 Sept, two clocks); completion numbers are a starting proposal | |
| P1-39 | Both clocks start when the lead reaches the SUL. The contact clock stops at the first Contacted; the completion clock stops when the lead is completed (converted or not converted) or closed. | A Hot lead routed Monday 09:00 shows "contact by Tuesday 09:00" and "complete by next Monday"; the first stops at the first call, the second at close. | Your mark (18 Sept) | R |
| P1-40 | A lead overdue on either clock is marked on the SUL's list and card and counted on the SUL's summary. | "Overdue: contact" or "Overdue: completion" badge on the lead; "3 overdue now" on the summary. | Your answer (17 Sept, summary); Canvas | |
| P1-41 | When either promise is missed, the SUL, the RSM and the Zonal Manager are all notified. Nothing is reassigned. The RSM and ZM follow up with their direct report inside Synapse by flagging the lead; the flag shows on the SUL's lead and summary. | The RSM sees the overdue lead at the top of their view, taps "Flag to SUL", and the SUL sees "Flagged by your RSM". | Your answer (17 Sept, escalation); see DR-3 | |
| P1-42 | Notifications are in-app (with phone push where the device allows). No notification goes by SMS or WhatsApp to staff in the Pilot. | A push on the phone and a bell inside the app. | Your mark (18 Sept) | R |
| P1-43 | The **on-time rate** is the Pilot's headline number and appears on every manager's view, reported for both clocks with contact first: leads contacted within their contact promise ÷ leads due, and leads completed within their completion promise ÷ leads due. | The RSM's first screen shows "Contacted on time this week: 78% · Completed on time: 61%". | Canvas; Your decision (clock kept); Your mark (18 Sept, two clocks) | |

### 1.7 Decisions this part rests on

| ID | Decision | State | What it means for this part |
|---|---|---|---|
| D1 | Consent basis for advisory-captured data (Crop Doctor, Savera, community) used for sales contact | Open — Syngenta leadership via Ahsan | Until decided: those signals are stored on the grower's history and no SUL is asked to call (P1-12). |
| D4 | Verified mobile number as the grower's key; the shared-number rule | Open — recommended yes; confirmed in M3 | P1-8 assumes it; a split action exists for shared numbers (Part 4). |
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
| DR-4 | Three segments, no cap, fold for low scores | Four tiers including Nurture (no field task) and a daily cap per officer | Canvas's anti-clutter devices; the failure it feared was 400 leads dumped on one officer in week one. |
| DR-5 | SUL marks the grower new or existing | Derived from purchase history | Canvas trusted the record over memory; your mark is faster and the field knows its growers. |
| DR-6 | Conversion = PKR value + receipt + product + quantity, all required; no franchise | Conversion = product, quantity, PKR, franchise, date, always | Only the franchise differs now (18 Sept); the receipt shows it until point-of-sale integration. |
| DR-7 | Eight stakeholders | Six dashboards | Head of Sales and Country Leadership exist and read the numbers. |
| DR-8 | Your 15 Sept note showed campaign leads under the threshold with their acreage; your 16 Sept note hides every under-threshold lead from SULs. The later note is followed (P1-15, P1-20). | — | Input versus input; mark P1-15 if campaign leads should be the exception. |

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
| **Segment list** | The leads in one segment, ranked, today's due first, low scores below a "more" fold; Potential has two tabs, "This season" and "Last season" | Your input; Part 1 | |
| **Campaign browser** | Inside Campaign: one entry per campaign, then leads grouped by product and by crop | Your input (15 Sept) | |
| **Lead card** | Everything about one lead on one screen, with the actions | Your input; Canvas | |
| **Act and log** | Call, WhatsApp, Navigate; log contact, visit planned, follow-up, converted, not converted, unreachable, reject; ask and log acreage; correct a grower's number | Your input; Audit keepers | |
| **Grower profile and timeline** | Who the grower is, their crops and acreage, and every scan, message, call, visit and outcome across seasons | Canvas | |
| **My summary** | The SUL's own numbers for today / this week / month to date / quarter / year / custom, one trend line, overdue now, leads flagged by line managers | Your input; Your answer (17 Sept) | |
| **Notifications** | New lead in Hot, overdue on either clock, flag from a manager, a lead moved up a segment | Part 1 | |
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
| J2.1 | Taps a Hot lead | The lead card: grower name and village, crop, problem or need, acreage with estimated/confirmed, why it is Hot (the three conditions), score with top three reasons in the SUL's language, recommended product where known (no PKR estimate), nearest franchise, consent basis, campaign if any, last season's status if any, new/existing mark, two clocks | Your input; Canvas; Your answer (18 Sept, card extras) | R |
| J2.2 | Taps Call | The phone dials; the lead moves to Contacted; the call is in the history with time; the contact clock stops | Audit keeper (call leaves a trace); Part 1 | |
| J2.3 | Or taps WhatsApp | WhatsApp opens on the grower's number; the lead moves to Contacted; the message attempt is in the history | Audit keeper; Canvas | |
| J2.4 | Grower does not answer | Taps "No answer": one failed attempt logged; the lead stays where it was; after the third failed attempt the card offers "Close as unreachable" with a reason list | Your answer (17 Sept) | |
| J2.5 | Agrees a visit | Taps "Visit planned", picks a day: two taps; the lead moves to Visit planned | Your input; Canvas (two taps) | |
| J2.6 | Needs to get there | Taps Navigate; directions open to the grower's location where Synapse has one | Audit keeper (navigate) | |

#### J3 — Visit and convert

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J3.1 | At the farm, taps "Log outcome" | Three choices: Converted · Not converted · Follow-up needed | Your input | |
| J3.2 | Taps Converted | Asks for, all required: PKR value, receipt photo (camera or gallery), product (pick-list), quantity, new or existing grower (pre-filled if already marked). No franchise field until point-of-sale integration. | Your input (15 Sept); Your answer (18 Sept, converted); Invariant 6 | R |
| J3.3 | Enters PKR 85,000, picks the product and quantity, takes the receipt photo, confirms | The lead moves to Completed: converted with the SUL's name and time; the summary's converted count and value rise; the grower's timeline records the sale | Your input; Invariant 6 | |
| J3.4 | Is offline at the farm | Everything above works; the photo and outcome wait on the phone and send on reconnect; the SUL sees "will send when online" | Canvas (offline); Audit keeper (outbox) | |

#### J4 — Not converted

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J4.1 | Taps "Not converted" | A reason list: no need · no budget · no stock at the franchise · bought a competitor · wrong contact; an optional comment | Canvas; Part 1 (DR-1) | |
| J4.2 | Picks "No stock at the franchise", confirms | The lead moves to Completed: not converted with the reason; two taps in total | Your input; Canvas | |
| J4.3 | Later, the same grower messages again this season | A new lead appears with the earlier outcome in its history | Part 1 (P1-34) | |

#### J5 — A lead goes overdue

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J5.1 | Has not contacted a Hot lead for 24 hours | The lead is badged "Overdue: contact"; a notification reaches the SUL, the RSM and the ZM; the summary's "overdue now" rises | Part 1 (P1-40, P1-41) | |
| J5.2 | Sees the RSM's flag arrive | "Flagged by your RSM" on the lead and on the summary; the lead sorts to the top | Your answer (17 Sept) | |
| J5.3 | Contacts the grower | The contact clock stops; the badge clears; the completion clock keeps running | Part 1 (P1-39) | |
| J5.4 | Has not completed a Hot lead in 7 days | "Overdue: completion" badge and the same notifications | Part 1 (P1-38) | |

#### J6 — A campaign lead

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J6.1 | Opens Campaign | One entry per live campaign in the territory, with lead counts | Your input (15 Sept) | |
| J6.2 | Opens "Dhaan ki Shaan" | Leads grouped by product, then by crop; each with acreage; leads that meet the Hot conditions tagged and first | Your input; Part 1 (P1-18) | |
| J6.3 | Opens a lead | The lead card, with the campaign, its product and its talk track where Marketing supplied one | Canvas | |
| J6.4 | Works it as in J2 to J4 | Same states, same clocks (the campaign's own promises) | Part 1 | |

#### J7 — Unknown acreage: ask and log

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J7.1 | Opens a Potential lead marked "acreage unknown" | The card shows "Acreage unknown — ask and log", and whether Synapse's own WhatsApp question has already been sent and answered | Your input (16 Sept); Canvas | |
| J7.2 | Asks the grower on the call; taps the acreage field | Enters a number, optionally per crop; saved as **confirmed** on the grower | Your input (16 Sept); Part 1 (P1-11) | |
| J7.3 | Logs 30 acres | The lead re-scores; if the grower also showed clear intent and the crop is known it moves to Hot and the SUL is told | Part 1 (P1-24) | |
| J7.4 | Logs 12 acres | The lead closes as "Closed: below threshold" and leaves the list; the grower's later leads are not routed to the SUL | Your mark (18 Sept) | |

#### J8 — Correcting a grower's number

One mobile number belongs to one grower. There is no split action in this
phase (see DR-13).

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J8.1 | Calls and learns the number on the lead is wrong, or the grower has a new number | Taps "Change number" on the grower's profile, enters the new one | Your answer (18 Sept, shared number) | R |
| J8.2 | Confirms | The grower's number is updated; the old number and the change are kept in the history with who and when; Admin can see and undo it. If the new number already belongs to another grower, Synapse says so and does not save. | Your answer (18 Sept); Invariant 2 | R |

#### J9 — An offline day

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J9.1 | Leaves signal for the day | All three segments, every lead card, every grower profile in the territory, and the product list are already on the phone | Canvas (offline-first); Audit lesson (reads were not cached) | |
| J9.2 | Logs eight outcomes and two acreages, takes three receipt photos | Each is saved on the phone at once with "will send when online"; nothing is lost if the phone restarts | Canvas; Audit keeper (outbox) | |
| J9.3 | Regains signal | Everything sends in the order it was logged; the app confirms; if the same lead changed on the server meanwhile, the server's version wins on the record but the SUL's entry is kept in the history, never discarded | Canvas | |

#### J10 — Reviewing my progress

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J10.1 | Opens My summary | For the chosen period: leads received, completed, converted, converted value in PKR; one line of conversions per week; overdue now; leads flagged by line managers; breached timelines | Your input (15 Sept); Your answer (17 Sept) | |
| J10.2 | Switches the period | Today · this week · month to date · quarter · year · custom | Your input; Audit keeper (presets) | |
| J10.3 | Looks for a ranking | There is none; the SUL sees their own numbers only | Your answer (17 Sept); Audit lesson (gamification) | |

#### J11 — Rejecting a lead

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J11.1 | Opens a lead from a village outside the territory | Taps "Not a valid lead"; picks: not my territory · duplicate of another lead · internal or test entry · wrong contact details | Your answer (17 Sept) | |
| J11.2 | Confirms | The lead leaves the list at once and goes to Admin's review list; the SUL's summary does not count it as pending | Part 1 (P1-35) | |

#### J12 — Finding a grower

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J12.1 | A grower calls the SUL out of the blue | The SUL searches by name, number or village and opens the grower's profile and timeline | Audit (list search); Canvas (interaction history) | |
| J12.2 | The grower wants to buy | Not in this phase: an SUL cannot create a lead by hand. The project's first focus is converting leads from the digital streams. The SUL sells as today and the sale is not a Synapse lead. To be reconsidered next year or in the second phase (Part 6, out of scope). | Your answer (18 Sept, walk-in lead) | R |

#### J13 — Planning a village visit from the map

| Step | The SUL does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J13.1 | Is going to a village or BSA tomorrow; opens the map from a segment list | The territory's open leads as pins, coloured by segment (Hot, Campaign, Potential), marked when overdue or campaign; the SUL's own position | Your note (18 Sept, map) | |
| J13.2 | Filters to the village or BSA | Only that area's pins remain, with a count by segment | Your note (18 Sept) | |
| J13.3 | Taps a pin | The lead card (J2.1); "Visit planned" for tomorrow is two taps; the map returns to the remaining pins | Your note (18 Sept); Part 1 | |
| J13.4 | Selects several leads for the same trip | Each is marked Visit planned for that day; the next morning they sit at the top of their lists as due | Your note (18 Sept); P2-21 | |
| J13.5 | Is offline in the village | The map, pins and cards work from the phone; the base map for the territory is cached; nothing is lost | Canvas (offline) | |

### 2.4 Rules that hold on every SUL screen

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P2-1 | The home screen shows three segments and nothing else. | No map, no filters, no points on the first screen. | Your input (15 Sept) | |
| P2-2 | Every list is ranked by score inside its segment, today's due leads first, flagged leads above that, low scores below a "more" fold. No cap. | The SUL never scrolls past a lead that matters to reach one that does not. | Your input; Part 1 (P1-23) | |
| P2-3 | A normal outcome is logged in two taps. | Contacted, visit planned, follow-up, not converted: two taps each. Converted takes more because value and receipt are required. | Canvas (two-tap rule); see DR-9 | |
| P2-4 | Every lead shows its top three reasons in plain words, in the SUL's language. | "Asked the price on WhatsApp · 30 acres of cotton · Spray window open now". | Canvas; Invariant 8 | |
| P2-5 | Both clocks are visible on every lead in every list and on the card. | "Contact by Tue 09:00 · Complete by Mon 25th". | Part 1 (P1-38) | |
| P2-6 | Acreage is always labelled estimated, confirmed or unknown. | Never a bare number. | Part 1 (P1-11) | |
| P2-7 | The consent basis and the recommended product are shown on every lead card. No indicative PKR value is shown. | "Consent: messaged us on WhatsApp, 3 Oct" · "Suggested: <product> for <problem>". | Canvas; Invariant 1; Your answer (18 Sept, card extras) | R |
| P2-8 | The app works fully offline: reads and writes. Everything in the territory is on the phone; every action waits on the phone and sends in order. | J9. | Canvas; Audit lesson | |
| P2-9 | The app is in Urdu or English, chosen once in Profile and changeable any time; grower messages are shown as sent. | Every label, reason list and notification in the chosen language. | Your answer (17 Sept) | |
| P2-10 | The app runs on Android 9 or newer with 2 GB of memory, takes under 150 MB with a full territory cached, and is usable on 2G/3G. No iPhone in the Pilot. | Installs and works on the field's current phones. | Your answer (17 Sept) | |
| P2-11 | No points, badges or leaderboards. The SUL sees their own progress only. | J10.3. | Your answer (17 Sept); Audit lesson | |
| P2-12 | Call, WhatsApp and Navigate are on the lead card, and each leaves a line in the history. | J2.2, J2.3, J2.6. | Audit keeper | |
| P2-13 | The grower's full timeline across seasons is one tap from any lead. | Scans, messages, calls, visits, outcomes, in date order, with the season marked. | Canvas | |
| P2-14 | The new/existing mark is set once per grower and shown on every lead. | Card header. | Your input (15 Sept) | |
| P2-15 | Notifications: a new Hot lead, a lead moved up a segment, overdue on either clock, a manager's flag. In-app and push only. | A bell count and phone push. | Part 1 (P1-42) | |
| P2-16 | Period views everywhere a number is shown: today, this week, month to date, quarter, year, custom. | J10.2. | Your input (15 Sept) | |
| P2-17 | The SUL sees only their own territory's leads and growers. A change of territory by Admin changes what the SUL sees at the next sync, and the old leads are no longer on their phone. | An SUL moved from T1 to T2 opens the app and sees T2. | Invariant 7 | |
| P2-18 | A lead with unknown acreage always carries a one-tap "ask and log" entry. | J7. | Your input (16 Sept) | |
| P2-19 | The SUL never sees a lead whose grower's known acreage is below the threshold, and never sees leads from growers without a recorded consent basis. | Such leads are simply absent. | Part 1 (P1-12, P1-20) | |
| P2-20 | The home screen has no map. A **map view** is one tap from any segment list: the territory's open leads as pins, coloured by segment and marked by category (campaign, crop, overdue), filterable to a village or a BSA. Tapping a pin opens the lead card; the SUL can pick the leads near where they are going and work them from there. The map also serves understanding and analytics. Navigate on the lead card opens directions. *Revised 18 Sept from "view-only" after your note.* | Going to a village, the SUL opens the map, filters to it, sees three Hot and five Potential leads nearby, taps one and starts J2. | Your answer (18 Sept, map, revised); Audit lesson (map never the home screen) | |
| P2-22 | A **BSA** (Basic Sales Unit Area) is a named area inside a territory, held in the sales master that Admin maintains; each grower's village maps to one BSA. "Nearby" on the map means something the field already uses. | The map's filter lists the territory's BSAs and villages. | Your note (18 Sept); approved with Part 2 | R |
| P2-21 | Follow-up is a date the SUL sets. On that day the lead comes to the top of its list and counts as due; the completion clock keeps running. A missed follow-up date is shown on the lead and the summary but does not notify managers. | "Follow-up: Thu 12th" on the card; on Thursday it is at the top; on Friday it shows "follow-up missed". | Your answer (18 Sept, follow-up) | R |

### 2.5 Decisions this part rests on

| ID | Decision | State | What it means for this part |
|---|---|---|---|
| D1 | Consent for advisory-captured data | Open | P2-19: Cropwise-sourced leads absent until decided. |
| D4 | Mobile number as the grower's key | Open, recommended yes | J8 number correction; J12 search by number; one number per grower. |
| D7 | Conversion value: declared or reconciled | Open | J3: receipt required until point-of-sale integration. |
| — | Three segments; two clocks notify-only; threshold as a setting | Decided | All of 2.3 and 2.4. |

### 2.6 Question log (Part 2)

| # | Question | Answer (date) | Rows |
|---|---|---|---|
| 1 | Which languages? | Urdu and English, SUL chooses; regional after the Pilot (17 Sept) | P2-9 |
| 2 | Which phones? | Android 9+, 2 GB, under 150 MB, 2G/3G, no iPhone (17 Sept) | P2-10 |
| 3 | What is on My summary? | Received, completed, converted, PKR value, one trend line, overdue now, flagged by line managers, breached timelines; no comparison (17 Sept) | J10 |
| 4 | Can an SUL create a lead by hand? | No, not in this phase; reconsider next year or in the second phase; focus is digital streams (18 Sept) | J12.2 |
| 5 | Is there a map? | First answer: view-only. Revised the same day: a working map one tap from any segment list, pins by segment and category, filterable to a village or BSA, tapping a pin opens the lead, so the SUL can plan a visit to one area. Never the home screen (18 Sept) | J1.4, J13, P2-20 |
| 10 | What is a BSA? | P2-22 as written, approved with Part 2 (18 Sept): a named area inside a territory, in the sales master; villages map to one BSA | P2-22 |
| 6 | How does follow-up work? | A date the SUL sets; the lead resurfaces that day; a missed date is shown, managers not notified (18 Sept) | P2-21 |
| 7 | What does Converted require? | PKR value, receipt, product and quantity, all required; no franchise until point-of-sale integration (18 Sept) | J3.2; revises P1-30, P1-31 |
| 8 | Which canvas extras stay on the card? | Consent basis and recommended product; no PKR estimate (18 Sept) | J2.1, P2-7 |
| 9 | Who splits a shared number? | Nobody: one number per grower; the SUL can change a grower's number, Admin can see and undo (18 Sept) | J8; see DR-13 |

### 2.7 Where the canvas or the audit differs (Part 2)

| DR | Spec | Canvas or audit | Note |
|---|---|---|---|
| DR-9 | Two taps for a normal outcome; converted takes more | Canvas: two taps for a normal outcome; Smart Agro Lite: about three | Converted needs value and receipt by your rule, so it is the exception. |
| DR-10 | Full offline: reads and writes on the phone | Smart Agro Lite: writes held back, reads not cached, map empty offline | Canvas and your input agree; the audit's version is the mistake not carried. |
| DR-11 | No points or leaderboards | Smart Agro Lite: points, badges, top-5 leaderboard | Audit lesson; canvas warns visible performance data changes behaviour. |
| DR-12 | A working map one tap from a segment list, for planning an area visit; never the home screen | Smart Agro Lite: map of scan markers was the home screen | Your note, 18 Sept. The list stays the primary surface; the map is a planning tool. |
| DR-13 | One number per grower; the SUL corrects a wrong number; no split | Canvas: shared and family numbers are common and need an explicit split action or counts corrupt | Your answer, 18 Sept. Two growers on one family phone will be one grower record in this phase; recorded for the session 2.2 reviewers. |
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
| **RSM dashboard** | RSM | Region's SULs and territories by name; overdue first; SUL-wise and territory-wise numbers; full lead cards; flags to SULs; the regional pool | Your input (15 Sept); Your answers (18 Sept) | |
| **ZM dashboard** | ZM | Zone → regions → territories; progress, gaps and analytics; no grower details; flags to RSMs | Your input; Your answer (18 Sept, manager view) | |
| **Head of Sales dashboard** | Head of Sales | All zones side by side on the same numbers; national on-time rates; drill to territory; breach notifications for every zone; flags to ZMs | Your answer (17 Sept) | |
| **Leadership dashboard and monthly summary** | Country Leadership Team | Read-only national view; a monthly one-page summary | Your answer (17 Sept) | |
| **Portfolio dashboard** | Portfolio Manager | Own portfolio's brands, campaigns and leads by product and crop; drill zone → region → territory; flags to ZMs | Your input (15 Sept); Your answer (18 Sept) | |
| **Marketing analytics** | Marketing | Campaigns, portfolios, brands, channels; leads, conversions, PKR, cost per lead; aggregate exports | Your input (15 Sept); Canvas; Your answer (18 Sept, cost) | |
| **Admin portal** | Admin | Users and roles; territories and BSAs; settings (threshold, clock promises, weights); campaigns; connections and their health; below-threshold list; rejected leads; regional pool sizes; audit trail | Canvas; Your answers (17, 18 Sept) | |
| **Weekly WhatsApp summary** | RSM, ZM, Head of Sales, PMs | Monday 9 am, last week at the reader's own level | Audit keeper (changed daily → weekly); Your answer (18 Sept) | |
| **Flags and notifications** | All managers | Flag with note and due-by day, one level down; notifications for breaches, flags actioned, settings changes | Your answers (17, 18 Sept) | |

### 3.3 Journeys

#### J14 — RSM morning

| Step | The RSM does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J14.1 | Opens the app | The region's overdue leads first, grouped by SUL, with which clock is breached; then the week's on-time rates and this week's numbers by SUL | Your input (15 Sept); Canvas (breaches first) | |
| J14.2 | Opens an SUL | That SUL's numbers for the period (received, contacted on time, completed, converted, PKR, overdue now) and their three segment counts | Your input (SUL-wise) | |
| J14.3 | Opens an overdue lead | The full lead card, grower name and number included; every view of a number is logged | Your answer (18 Sept, manager view) | |
| J14.4 | Taps Flag, writes "Visit before Thursday", sets Thursday | The lead sorts to the top of the SUL's list with the note; the SUL's summary shows it; the flag and the SUL's response are in the lead's history | Your answer (18 Sept, flag) | |
| J14.5 | Switches to territory view | The same numbers by territory, including any territory with no SUL assigned, shown as a gap | Your input (territory-wise) | |

#### J15 — The regional pool

| Step | The RSM does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J15.1 | Opens "Unassigned" | Leads in the region whose grower location matched no territory, with what is known (village, district, crop, source) | Canvas (region pool); Your answer (18 Sept) | |
| J15.2 | Picks an SUL for a lead | The lead is routed to that SUL; both clocks start now; the assignment is in the history | Your answer (18 Sept, pool) | |
| J15.3 | Sees the same village again next week | Admin has been shown the pool size by region and the unmatched villages, so the territory master can be fixed | Your answer (18 Sept); Canvas (master drift) | |

#### J16 — ZM: short of leads, or short of follow-up

| Step | The ZM does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J16.1 | Opens the app | The zone's regions side by side: leads received, contacted on time, completed, converted, PKR, overdue — for the chosen period | Your input (15 Sept) | |
| J16.2 | Sees Region B behind | Two numbers set apart: leads received per territory (supply) and the on-time rates (follow-up), so the ZM can tell which is short | Canvas; Your answer (18 Sept, progress and gaps) | |
| J16.3 | Opens Region B, then a territory | Territory-level numbers and the SUL's name; no grower names or numbers, no lead cards | Your answer (18 Sept, manager view) | |
| J16.4 | Flags the RSM | Note and due-by day; lands at the top of the RSM's view; the RSM flags the SUL; the ZM sees when each was actioned | Your answers (17, 18 Sept) | |

#### J17 — Head of Sales

| Step | Head of Sales does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J17.1 | Opens the app | All zones side by side on the same numbers, plus national on-time rates for both clocks | Your answer (17 Sept) | |
| J17.2 | Drills | Zone → region → territory, same shape as the ZM's view, no grower details | Your answers (17, 18 Sept) | |
| J17.3 | Receives breach notifications for every zone | One digest per day at 8 am rather than one per lead: "14 leads breached yesterday: Zone A 9, Zone B 5"; tapping it opens the list | Your answer (17 Sept); Your mark (18 Sept, digest) | R |
| J17.4 | Flags a ZM | Same flag; one level down | Part 1 (P1-41) | |
| J17.5 | Is told a setting changed | "Admin changed the acreage threshold from 20 to 25 at 14:02" | Your answer (18 Sept, controls) | |

#### J18 — Country Leadership Team

| Step | Leadership does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J18.1 | Opens the dashboard | National funnel by source and by campaign; conversions and PKR by zone and by portfolio; on-time rates; leads below threshold as a count; whether the scoring engine beats a plain list | Your answer (17 Sept); Canvas (model lift) | |
| J18.2 | Receives the monthly summary | One page on the first working day of the month, unflattering numbers included; sent by email as a page and also shown in the dashboard | Your answer (17 Sept); Canvas ("including when unflattering"); approved with Part 3 | R |
| J18.3 | Looks for a grower | There are none to find; nothing on this view names a grower | Your answer (18 Sept, manager view) | |

#### J19 — Portfolio Manager

| Step | The PM does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J19.1 | Opens the app | Own portfolio only: its brands and live campaigns with leads, conversions and PKR for the period; below-threshold leads as a labelled count | Your input (15 Sept); Your answer (17 Sept, under-threshold) | |
| J19.2 | Opens a campaign | Leads by product and by crop; conversions and PKR by each; zone → region → territory drill | Your input (15 Sept) | |
| J19.3 | Sees a territory behind on a campaign | Flags the ZM with a note and due-by day; the ZM flags the RSM, the RSM the SUL; the PM sees when each was actioned | Your answer (18 Sept, PM follow-up) | |
| J19.4 | Looks for a grower | No grower names or numbers on any PM view | Canvas; Invariant 7 | |

#### J20 — Marketing

| Step | Marketing does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J20.1 | Opens analytics | Every campaign: leads (routed and below threshold, labelled), contacted, converted, PKR; by portfolio, by brand, by channel; for the period | Your input (15 Sept) | |
| J20.2 | Compares campaigns | Cost per lead and cost per converted lead where spend was entered; "no spend entered" otherwise | Canvas; Your answer (18 Sept, cost) | |
| J20.3 | Defines a new campaign | Gives Admin the name (brand-level or a crop programme), portfolio, brand or programme, product, crop, dates, its contact and completion promises, and budget; Admin creates it | Your answer (17 Sept, campaigns) | |
| J20.4 | Updates spend | Edits actual spend on the campaign record monthly; the change is logged | Your answer (18 Sept, cost) | |
| J20.5 | Exports | Aggregate figures to a spreadsheet, never a grower's name, number or village; every export logged with who and when | Your answer (18 Sept, controls); Audit keeper (About sheet, as-of and count) | |

#### J21 — Admin

| Step | Admin does | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J21.1 | A new SUL joins | IT gives the login; Admin sets the role and assigns the territory; the SUL's phone shows that territory at the next sync | Your answer (17 Sept, Admin); Invariant 7 | |
| J21.2 | Changes the acreage threshold, a clock promise or a scoring weight | Takes effect at once; recorded with who, when and the previous value; Head of Sales notified; the audit trail shows it | Your answer (18 Sept, controls); Canvas (weights audited) | |
| J21.3 | Creates a campaign from Marketing's definition | Name, portfolio, brand or crop programme, product, crop, dates, promises, budget; leads carrying that campaign appear under it from then on | Your answer (17 Sept, campaigns) | |
| J21.4 | Opens Connections | Each of the nine streams with its state (connected, failing, not yet connected), last lead received, leads held back for a reason; a failing stream is shown before anyone notices missing leads | Canvas | |
| J21.5 | Opens Below threshold | Every lead held back for known acreage under the threshold, by source and campaign; nothing to action, everything to count | Your answer (17 Sept) | |
| J21.6 | Opens Rejected | Leads SULs rejected, with reason and source; Admin reassigns to a territory, merges with another lead, or removes with a logged reason | Your answer (17 Sept, reject) | |
| J21.7 | Opens Territories | Zones, regions, territories, BSAs and their SULs; unmatched villages from the regional pools; edits here never touch a grower | Your answers (17, 18 Sept) | |
| J21.8 | Opens the audit trail | Every settings change, every flag, every number change by an SUL (with undo), every removal, every view of a grower's number by a manager, every export, every automated read of grower data | Canvas; Your answers (18 Sept) | |

#### J22 — Monday morning summary

| Step | Who | Synapse shows or does | Came from | Mark |
|---|---|---|---|---|
| J22.1 | RSM, ZM, Head of Sales, each PM | One WhatsApp message at 9 am Pakistan time: last week at their own level — leads received, contacted on time, completed, converted, PKR, overdue now, and the one SUL or territory (or brand, for a PM) most behind | Your answer (18 Sept, weekly); Audit keeper | |
| J22.2 | — | Each send is logged with who received what; the message names no grower | Audit lesson (no record of sends); Invariant 7 | |

### 3.4 Rules that hold on every manager, marketing and admin screen

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P3-1 | Every level sees the level below it **named**, plus its own total. Nothing is aggregated past the person or territory behind it. | A ZM sees regions by name, then territories by name, never "Zone total" alone. | Canvas; Your input (15 Sept) | |
| P3-2 | One definition per number, everywhere: a "conversion", "on time", "received" mean the same thing on every screen and in every summary. A definitions page states each one, and a reconciliation view shows that the totals agree. | Marketing's converted count for a campaign equals the sum of the RSMs' converted counts for it. | Canvas (one semantic layer); Audit keeper (definitions and sign-off) | |
| P3-3 | The RSM can open a full lead card, grower number included. ZM, Head of Sales, Leadership, PMs and Marketing see progress, gaps and analytics and never a grower's name, number or village. | J14.3, J16.3, J18.3. | Your answer (18 Sept, manager view) | |
| P3-4 | The **flag** is the one way a manager acts on a lead: a note and a due-by day, one level down only (Head of Sales → ZM → RSM → SUL; PM → ZM → RSM → SUL). The flagged lead sorts to the top for the report; the flag and the response are in the history; the sender sees when it was actioned. | J14.4, J16.4, J19.3. | Your answers (17, 18 Sept) | |
| P3-5 | Two on-time rates, contact and completion, contact first, at every level. | "Contacted on time 78% · Completed on time 61%". | Part 1 (P1-43) | |
| P3-6 | "Short of leads" and "short of follow-up" are shown as separate numbers on every ZM and Head of Sales view: leads received per territory, and the on-time rates. | J16.2. | Canvas; Your answer (18 Sept) | |
| P3-7 | Period presets everywhere: today, this week, month to date, quarter, year, custom; every number says its period. | A period control at the top of every dashboard. | Your input (15 Sept); Audit keeper | |
| P3-8 | Honest reporting: a non-dismissible notice when data is incomplete; export off while it is; every export and summary says "as of" and how many records; unresolved rows (unmatched village, unknown acreage) counted openly, never hidden. | "Data as of 08:00 · 4,212 leads · 37 with unmatched village". | Audit keepers | |
| P3-9 | Exports exist for Marketing (aggregate only) and Admin. No manager or SUL exports a list. Every export is logged. | No export button on RSM, ZM, Head of Sales, PM or SUL screens. | Your answer (18 Sept, controls) | |
| P3-10 | Settings changes (threshold, clock promises, weights, campaign promises) are made by Admin alone, take effect at once, are recorded with who, when and the previous value, and notify Head of Sales. | J21.2, J17.5. | Your answer (18 Sept, controls); Canvas (weights audited) | |
| P3-11 | The regional pool is the RSM's: leads with no territory match are assigned by the RSM by hand; clocks start at assignment; Admin sees pool sizes and unmatched villages by region. | J15. | Your answer (18 Sept, pool) | |
| P3-12 | Below-threshold leads appear only on Admin's list and as labelled counts on Marketing, PM and Leadership views. | J19.1, J20.1, J21.5. | Your answer (17 Sept) | |
| P3-13 | Every manager's view of a grower's number, every export, every settings change, every flag and every automated read of grower data is in the audit trail. | J21.8. | Canvas; Your answers (18 Sept) | |
| P3-14 | Notifications to managers: a breach in their scope, a flag actioned, a settings change (Head of Sales). In-app and push. RSM and ZM get one per breached lead; Head of Sales receives breaches as one daily digest at 8 am. | J17.3. | Part 1 (P1-42); Your mark (18 Sept, digest) | R |
| P3-15 | Connection health is on the Admin portal before anyone notices missing leads: state per stream, last lead received, leads held back and why. | J21.4. | Canvas | |
| P3-16 | Campaigns are created by Admin from Marketing's definition with: name, portfolio, brand or crop programme, product, crop, start and end dates, contact and completion promises, budget and actual spend. | J20.3, J21.3. | Your answers (17, 18 Sept) | |
| P3-17 | The weekly WhatsApp summary goes to RSMs, ZMs, Head of Sales and PMs on Monday at 9 am at their own level; Leadership gets the monthly page; SULs get nothing by WhatsApp. Every send is logged; no grower is named. | J22. | Your answer (18 Sept, weekly) | |
| P3-18 | The monthly leadership summary is produced by Synapse on the first working day of the month, includes the unflattering numbers, and never names a grower. Delivered by email as a one-page document and shown in the dashboard. | J18.2. | Your answer (17 Sept); Canvas; approved with Part 3 | R |
| P3-19 | Admin's territory edits (zones, regions, territories, BSAs, SUL assignment) never change a grower's record; a boundary change re-routes future leads only. Open leads stay with the SUL who has them. | J21.7. | Your answer (17 Sept, territory); approved with Part 3 | R |
| P3-20 | Manager and marketing dashboards work on the phone for RSM, ZM, Head of Sales and PMs, and on desktop for Marketing, Admin and Leadership. They need signal; nothing is cached for offline use. | A ZM on the road sees the dashboard when there is signal. | Your input (15 Sept, "mobile dashboard"); Canvas | |

### 3.5 Decisions this part rests on

| ID | Decision | State | What it means for this part |
|---|---|---|---|
| D3 | Campaign ID convention | Open — Marketing via Ahsan, decided in M5 | Campaign reporting (J19, J20) depends on the campaign surviving from ad to lead; Admin's campaign record is the Synapse side of it. |
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
| 6 | Where does campaign spend come from? | Marketing enters it on the campaign record; cost per lead shown; blank shows "no spend entered" (18 Sept) | P3-16, J20.2 |
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
| DR-18 | Single sign-on not in the Pilot | Canvas: SSO where available | Left to Part 6's out-of-scope list; IT gives logins. |

## Part 4 — Where leads come from, and one grower

*To be drafted after Part 3 is marked.*

## Part 5 — Scoring, routing and the clock, in detail

*To be drafted after Part 4 is marked.*

## Part 6 — What is recorded, how well it must work, what it must never do, and the decisions

*To be drafted after Part 5 is marked.*

## Appendix — technical detail

*Written with Part 6. You can stop reading before this point.* Traceability
to the exact canvas layer, audit rule, invariant and milestone; field-level
records; technical non-functionals; keeper map; mistake map; full
disagreement register; question log.
