# Synapse specification

Version: **v0.9 — all six parts and the Appendix approved by Ahsan, 2026-09-21; next: session 2.2 adversarial review** ·
Owner: Ahsan · Task: SYN-9

> **How this document is built.** Six parts, each written in plain language
> and marked by Ahsan before the next is drafted. A technical appendix follows
> Part 6 and can be skipped. After v1.0, a change to this file is a change
> request (`docs/PROCESS.md` §3), never an edit.
>
> **Inputs, in order of precedence.** `docs/INVARIANTS.md` (nine rules that
> change only through a DECISIONS entry) · Ahsan's product input
> (`docs/notes/spec-input-2026-09-15.md`, `-16.md`, `-17.md`, `-18.md`) ·
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
| P1-6 | Country IT confirms who may have an account; users register and log in with their Syngenta email; Admin manages everything else. *Revised 21 Sept.* | A new SUL registers with their Syngenta email; Admin then assigns their territory. | Your answers (17, 21 Sept) | R |

### 1.3 What a lead is

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P1-7 | A lead is one grower showing demand through one of nine streams: Crop Doctor scans, Savera conversations, Cropwise community posts, WhatsApp inbound, Facebook, TikTok, call-centre capture, NPI campaigns, brand campaigns. No lead ever arrives by manual upload. | Every lead shows which stream it came from; there is no "import" button anywhere. | Your input (15 Sept); Canvas; Audit lesson | |
| P1-8 | Every lead belongs to exactly one grower record. When the same grower speaks through three streams, Synapse recognises one grower and merges the signals into one lead rather than three. | A grower who scanned in Crop Doctor on Monday and messaged on WhatsApp on Wednesday appears once on the SUL's list, with both signals shown, and the score has risen. | Invariant 2; Invariant 3; Canvas | |
| P1-9 | The same signal arriving twice never creates a second lead. | A WhatsApp provider resends yesterday's message; nothing new appears. | Invariant 3 | |
| P1-10 | A lead carries: the grower (name, number, village), crop, problem or need, acreage (estimated, confirmed, or unknown), source stream, campaign if any, score with its top three reasons, segment, clock, territory and SUL, last season's status if any, the new/existing mark, and the grower's history. | An SUL opens a lead and sees all of these on one card without scrolling to another screen. | Your input (15 Sept); Canvas | |
| P1-11 | Acreage is marked **estimated** when it came from a source or a conversation, **confirmed** when an SUL logged it after asking the grower, and **unknown** otherwise. | The lead card shows "Acreage: 25 (estimated)" or "25 (confirmed)" or "unknown". | Canvas; Your input (16 Sept) | |
| P1-12 | Every lead records the consent basis for contacting the grower: the stream and date of the grower's own contact with Syngenta. No SUL is asked to contact a grower without one. *Revised 21 Sept: D1 decided — any contact with Syngenta is the basis (Part 4, P4-23); Cropwise-sourced leads are routed from day one.* | "Consent: Crop Doctor scan, 3 Oct" on every card. | Invariant 1; Your decision D1 (18 Sept) | R |

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
| P1-21 | Acreage **unknown**: the lead is first held for Hina, the AI calling agent, who phones the grower to ask (Part 5); if she gets it the lead is scored and routed with it; if she cannot reach the grower the lead is routed to Potential (or Campaign) marked "acreage unknown — ask and log". *Revised 21 Sept: Hina replaces the WhatsApp question.* | The lead card shows "Acreage 30 (confirmed by Hina)" or "Acreage unknown — ask and log" with a one-tap entry. | Your input (15, 16 Sept); Your answer (21 Sept, Hina) | R |
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
| D1 | Consent basis for advisory-captured data (Crop Doctor, Savera, community) used for sales contact | **Decided 2026-09-18** — any contact with Syngenta is the basis (leadership's position) | P1-12: every lead records the stream and date; Cropwise-sourced leads routed from day one. |
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
| J7.1 | Opens a Potential lead marked "acreage unknown" | The card shows "Acreage unknown — ask and log" and Hina's note ("no answer after 3 attempts"); a lead Hina reached arrives with acreage already confirmed and is not marked unknown | Your input (16 Sept); Your answer (21 Sept, Hina) | R |
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
| **Admin portal** | Admin | Users and roles; territories and BSAs; settings (threshold, clock promises, weights); campaigns; connections and their health (the streams and Hina); franchise list; timing table; below-threshold list; "no contact" list (signals with no number, Part 4); rejected leads; regional pool sizes; audit trail | Canvas; Your answers (17, 18 Sept) | |
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
| J21.5a | Opens "No contact" | Signals that arrived with no number and matched no grower, by source and campaign, with possible matches for a person to confirm; they merge into a lead when a number arrives (Part 4, P4-18) | Your answer (21 Sept) | |
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
| P3-16 | Campaigns are created by Admin from Marketing's definition with: name, portfolio, brand or crop programme, product, crop, start and end dates, contact and completion promises (required; a campaign cannot be saved without them), budget and actual spend. | J20.3, J21.3. | Your answers (17, 18 Sept) | |
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
| DR-18 | Single sign-on not in the Pilot; Syngenta email plus a Synapse password | Canvas: SSO where available | Your answer, 21 Sept; in Part 6's out-of-scope list. |

## Part 4 — Where leads come from, and one grower

### 4.1 How a lead arrives

Nine streams, each its own connection, each optional: Synapse runs correctly
with three connected and six not. Nothing arrives by upload. A signal is kept
the moment it arrives and becomes a lead within minutes; reading the grower's
intent from their words happens after and never delays the arrival. The same
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
| **WhatsApp inbound** | Messaged Syngenta's WhatsApp number: asked a price, asked advice, said they want to buy | Message text, intent read from it, the number itself, whether they messaged first | Arrives as each message is received, through the messaging provider | Digital team (the provider account) | — | Your input (15 Sept); Canvas | |
| **Facebook** | Filled a lead form on an ad, or messaged the page | Form fields, message intent, campaign and ad | Arrives as each form or message is received, from the Meta platform | Marketing (the ad account) | D3 (campaign convention) | Your answer (17 Sept); Canvas | |
| **TikTok** | Filled a lead form on an ad | Form fields, campaign | Arrives as each form is received, from the TikTok platform | Marketing | D3; TikTok lead forms available for the Pakistan account, to confirm | Your answer (17 Sept); Canvas | |
| **Call centre** | Called the centre, or was called back | Agent's note: grower, number, crop, acreage, what they asked | The centre's own platform feeds Synapse; if it cannot, a short Synapse form for agents; decided in the M2 spike | Call-centre manager | Which platform the centre runs | Your answer (21 Sept); Canvas | |
| **NPI campaign** | Responded to a new-product campaign | Campaign, product, creative, what they did on landing | Arrives from the campaign platform, carrying the campaign under the agreed convention | Marketing | D3 | Your input (15 Sept, campaigns); Canvas | |
| **Brand campaign** | Responded to a brand-level or crop-programme campaign | Campaign, brand or programme, creative, what they did on landing | As above | Marketing | D3 | Your input (15 Sept); Your answer (17 Sept, campaigns); Canvas | |
| **E-commerce purchase** *(added 21 Sept)* | Bought on Syngenta's e-commerce channel | Product, quantity, value, date — only for growers with confirmed acreage at or above the threshold (P4-27a) | Pulled from the e-commerce platform on a schedule | E-commerce owner, to confirm | Which platform; whether it carries the grower's number | Your answer (21 Sept); Canvas (e-commerce) | |

### 4.3 Rules for every stream

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P4-1 | Every stream is a separate connection and every stream is optional. Synapse runs correctly with any subset connected; no stream waits on another. | Admin's Connections page shows nine rows; three "connected", six "not yet connected", and leads flow from the three. | Your answer (17 Sept, sources); Canvas | |
| P4-2 | No lead ever arrives by upload. There is no import screen anywhere. | No spreadsheet path exists. | Your input (15 Sept); Audit lesson | |
| P4-3 | A signal becomes a lead on the SUL's phone within minutes of the grower acting, for streams that push (WhatsApp, Facebook, TikTok, campaigns), and within the schedule for streams that are pulled (Cropwise streams, call centre). | A grower messages at 10:02; the SUL's phone shows the lead by 10:05. | Canvas | |
| P4-4 | The same signal arriving twice never makes a second lead; it merges into the existing one. | A provider resends yesterday's message; the lead's history shows one signal, not two. | Invariant 3 | |
| P4-5 | Nothing is lost silently. A signal Synapse cannot accept is held, retried, and listed for Admin with the reason; when the cause is fixed the held signals flow through. | Connections shows "WhatsApp: 12 held — provider error since 09:40"; at 10:10 the count is 0. | Canvas; Audit lesson (silent drops) | |
| P4-6 | One stream failing never stops another or slows the rest. | Facebook is down for a day; WhatsApp leads keep arriving on time. | Invariant 9 | |
| P4-7 | A bad value is rejected and reported, never guessed. No made-up location, no "today" for a missing date, no zero for a missing acreage. | A signal with an impossible location is held with "location invalid"; nothing is stored as 0. | Audit lesson (§7.11) | |
| P4-8 | The grower's original words and the original signal are kept unchanged, so a lead can be re-read and the reading improved later. | The lead card shows the grower's own message under "What they said". | Canvas; Your answer (21 Sept, unsure intent) | |
| P4-9 | Intent is read from the grower's words in Urdu, English, regional languages and transliterated Urdu. When Synapse is unsure, the lead is held for Hina, who asks the grower (Part 5); if Hina cannot reach them, the lead goes to Potential marked "intent unclear" and cannot be Hot until the SUL confirms intent on the call with one tap ("wants to buy" / "advice only"). Hina's and the SUL's answers improve the reading. *Revised 21 Sept for Hina.* | The card shows "Intent unclear — confirm on call"; after "wants to buy" the lead re-scores. | Your answer (21 Sept); Canvas | |
| P4-10 | Reading intent never delays a lead. The lead exists first; the reading follows. | A lead arrives with "reading…" and updates within a minute. | Canvas (AI never in the delivery path) | |
| P4-11 | A campaign lead carries its campaign from the ad to the lead under the one convention agreed with Marketing (D3). If the campaign cannot be read, the lead still arrives, marked "campaign unknown", and is listed for Admin. | Connections shows "3 leads with unknown campaign this week". | Canvas; D3 | |
| P4-12 | A healthy Crop Doctor scan becomes a lead only when the grower's known acreage is at or above the threshold (Part 1, P1-25). Below it or unknown: history only. | — | Your decision D9 | |
| P4-13 | Every stream is marked "to confirm with the system owner" with the owner named where known; the M2 spike proves the first stream end to end before the rest are built. | The table in 4.2. | Your answer (17 Sept, live feeds) | |
| P4-14 | Call-centre capture tries the centre's own platform first; if it has no way out, agents get a short Synapse form (number, crop, acreage, what they asked). The choice is made in the M2 spike. | Either no new screen for agents, or one short one. | Your answer (21 Sept) | |
| P4-15 | Connection health is visible to Admin before anyone notices missing leads: state per stream, last lead received, signals held and why. | J21.4. | Canvas | |

### 4.4 One grower

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P4-16 | A grower is identified by their mobile number. One number belongs to exactly one grower. | Two signals with the same number are one grower. | Invariant 2; Your answer (18 Sept); Your decision D4 | |
| P4-17 | There is no split action. A wrong or changed number is corrected by the SUL on the grower's profile; the change is kept with who and when; Admin can undo it; a number already on another grower cannot be saved on a second one. | J8. | Your answer (18 Sept); see DR-13 | |
| P4-18 | A lead is routed only when the grower has a number. A signal with no number is first matched to an existing grower by name, village and crop; if it matches one who has a number, it joins that grower and is routed normally. If it matches nobody, it is held on Admin's **"no contact"** list, counted in source and campaign totals as "no contact", and merges into a lead the moment a later signal brings a number. Never routed, never lost. | A community post with a name and village but no number sits on Admin's "no contact" list; when the same grower messages on WhatsApp a week later, one lead appears with both signals. | Your answer (21 Sept, re-asked); Canvas (nothing enters unattached) | |
| P4-19 | A match by name, village and crop is made only when it is clear; a doubtful match is not made, and the signal is held rather than attached to the wrong grower. | Admin's "no contact" list shows "possible match: <name>, <village>" for a person to confirm. | Canvas (secondary matching) | |
| P4-20 | When two sources give different values for the same thing (name spelling, village, acreage), the most recent verified value wins and Synapse remembers where each value came from. An acreage **confirmed** by an SUL is never overwritten by an **estimated** one from a source. | The profile shows "Acreage 25 (confirmed by SUL X, 4 Oct)"; a later scan saying 18 does not change it. | Canvas; Your input (16 Sept) | |
| P4-21 | The grower's profile holds: name, number, village and location (province, district, tehsil, village, and map position where a source gave one), crops grown, acreage (per crop where known, with estimated/confirmed), preferred language, the new/existing mark, and last season's status. | One profile screen; the lead card draws from it. | Canvas; Your input (15, 16 Sept) | |
| P4-22 | Every scan, message, call, visit, campaign touch, purchase and outcome is one timeline on the grower, across seasons, marked by season. | J12.1; P2-13. | Canvas | |
| P4-23 | **Consent.** Any contact with Syngenta through any stream is the consent basis for a sales contact about that need. Every lead records which stream and date the consent came from; the card shows it. | "Consent: Crop Doctor scan, 3 Oct" · "Consent: WhatsApp message, 5 Oct". | Your decision D1 (18 Sept); Invariant 1 | |
| P4-24 | There is **no opt-out** in this phase, for growers or for SULs. A grower's request to stop, in any channel, is a message on the lead like any other and is left to the SUL's judgement. Opt-out is reconsidered in a later phase (Part 6, out of scope). | No opt-out control anywhere; the consent basis (P4-23) is the whole consent record. | Your answer (21 Sept, "no opt-out option for now"); see DR-19 | R |
| P4-25 | A STOP, "band karo" or similar on WhatsApp appears in the lead's history as a message; Synapse takes no action on it. | The message under "What they said". | Your answer (21 Sept) | R |
| P4-26 | Growers below the acreage threshold and growers with no lead this season keep a profile and a history; only routing changes. | The grower exists on Admin's lists and in totals. | Your answer (17 Sept, under-threshold); Part 1 | |
| P4-27 | Nothing is stored about a grower that no stream or SUL gave. No purchased lists, no outside enrichment. The list of streams can grow or shrink; each addition is a stream with its own row in 4.2 and its own rule. | The profile holds only what the streams and the SUL put there. | Your answer (21 Sept, re-asked) | R |
| P4-27a | **E-commerce purchases** are an added stream: a purchase on Syngenta's e-commerce channel becomes a signal only for a grower whose acreage is **confirmed** and at or above the threshold. Purchases by other growers are not brought in. | A confirmed 30-acre grower's online order appears on their timeline and re-scores their lead; a 10-acre or unconfirmed grower's order does not enter Synapse. | Your answer (21 Sept, re-asked); Canvas (e-commerce under pulled sources) | |

### 4.5 The lists Synapse depends on

| List | Holds | Kept by | Refreshed | Came from | Mark |
|---|---|---|---|---|---|
| **Sales structure** | Zones, regions, territories, BSAs, and which SUL owns each territory | Owner: Digital Business Operations (DBO) — *revised 21 Sept from Sales Operations: "anything operational is owned by DBO"*; Admin has full access | When changed; every change logged | Your answer (17 Sept, territory); Audit keeper (one territory master) | |
| **Grower location list** | Provinces, districts, tehsils, villages, and which BSA each village belongs to | Owner: DBO — *revised 21 Sept*; Admin has full access | When changed | Your answer (17 Sept); P2-22 | |
| **Products** | Syngenta products by portfolio and brand, with the crops and problems each treats, for the recommended product and the conversion pick-list | Owner: Marketing with the Portfolio Managers; Admin enters changes and has full access | When changed | Canvas; Your answers (18 Sept) | |
| **Campaigns** | Every campaign as defined in Part 3 (P3-16) | Admin, from Marketing | When created or edited | Your answer (17 Sept) | |
| **Users** | Everyone who can log in, their role and scope | IT (login), Admin (role and scope) | When changed | Your answer (17 Sept, Admin) | |
| **Settings** | The acreage threshold, the six clock promises, the scoring weights, the retention period | Admin | When changed; every change logged and Head of Sales notified | Your answers (17, 18 Sept) | |

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P4-28 | Each list has one named owner who is told when a row is rejected or a value is missing; rejected rows are reported, never dropped. | "Sales structure: 2 territories with no SUL — owner notified". | Canvas (named steward); Audit keeper | |
| P4-29 | A lead is routed by matching the grower's village to a BSA and territory through these lists. A village not in the list sends the lead to the regional pool and the village to Admin's unmatched list. | J15. | Your answer (17 Sept); Part 3 (P3-11) | |
| P4-30 | Editing a list never edits a grower. | P3-19. | Your answer (17 Sept) | |

### 4.6 Decisions this part rests on

| ID | Decision | State | What it means for this part |
|---|---|---|---|
| D1 | Consent basis for advisory-captured data | **Decided 2026-09-18** — any contact with Syngenta is the consent basis | P4-23; Cropwise-sourced growers routed from day one; the M6 gate in the plan is lifted. |
| D2 | Who owns Cropwise platform access for Pakistan | Open — action: Ahsan files the request | The three Cropwise streams cannot be connected until answered; they are specified here regardless. |
| D3 | Campaign ID convention | Open — Marketing via Ahsan, decided in M5 | P4-11; campaign leads arrive marked "campaign unknown" until agreed. |
| D4 | Mobile number as key; shared-number rule | **Decided 2026-09-18** — one number, one grower, no split, SUL corrects | P4-16 to P4-18. |
| D9 | Healthy scan rule | Decided | P4-12. |

### 4.7 Question log (Part 4)

| # | Question | Answer (date) | Rows |
|---|---|---|---|
| 1 | How is consent recorded per stream? | Any contact with Syngenta is consent (18 Sept) | P4-23 |
| 2 | Is that leadership's position or an interim default? | Leadership's position; D1 decided (18 Sept) | 4.6 |
| 3 | How does a grower opt out? | First "via the SUL only"; then, on the STOP-message question: no opt-out option for growers or SULs for now (21 Sept) | P4-24, P4-25 |
| 4 | Is a signal with no number routed? | First answer "routed anyway"; changed the same day on re-asking: routed only if there is a number, otherwise matched to an existing grower or held on Admin's "no contact" list and merged when a number arrives (21 Sept) | P4-18, P4-19 |
| 5 | What happens when intent is unclear? | Potential, marked, never Hot until the SUL confirms (21 Sept) | P4-9 |
| 6 | Call-centre capture? | Platform feed first, Synapse form if it cannot; decided in M2 (21 Sept) | P4-14 |
| 7 | Named campaigns? | Marketing names them; brand-level or crop programme; Admin creates (17 Sept) | 4.2, P3-16 |
| 8 | Live feeds today? | Each marked "to confirm with the system owner" (17 Sept) | P4-13 |
| 9 | Territory shape? | Sales hierarchy separate from grower location (17 Sept) | 4.5, P4-29 |
| 10 | What happens to a WhatsApp STOP? | Nothing; no opt-out in this phase (21 Sept) | P4-25 |
| 11 | Any outside data on growers? | First answer pressed by accident; re-asked: none beyond the streams and SULs, but streams may be added or removed — e-commerce purchases added, for confirmed acreage at or above the threshold only (21 Sept) | P4-27, P4-27a, 4.2 |
| 12 | Who owns the lists? | First: Sales Operations for structure and locations. Revised later the same day when the franchise list was asked: "anything operational is owned and managed by the Digital Business Operations team (DBO)" — so DBO owns structure, locations and franchises; Marketing with the PMs owns products and the timing table; Admin has access (21 Sept) | 4.5, P5-25 |

### 4.8 Where the canvas or the audit differs (Part 4)

| DR | Spec | Canvas or audit | Note |
|---|---|---|---|
| DR-19 | Any contact with Syngenta is the consent basis; no opt-out in this phase | Canvas: consent basis, scope, timestamp, source and opt-out state per grower, explicit consent language at capture recommended; opt-out enforced across every channel | D1 decided by leadership, 18 Sept; no opt-out, 21 Sept. The record per lead is kept (stream and date), so the canvas's register still exists; the basis is broader and there is no way for a grower to withdraw it. The session 2.2 consent lens will raise this; it is recorded here so the reviewers argue against the decision, not discover it. |
| DR-20 | A signal with no number is matched or held, never routed | Canvas: every signal matches a grower or creates one, "nothing enters unattached" | Consistent after your re-answer of 21 Sept; a held signal is still attached, to the "no contact" list, so nothing enters unattached. Kept here because the first answer differed. |
| DR-21 | No split action; one number, one grower | Canvas: explicit split for shared and family numbers | DR-13 repeated here; D4 decided. |
| DR-22 | Product list only; no price or dose list in the Pilot | Canvas: product and price master synced nightly for value mapping | Follows DR-14 (no PKR estimate on the card) and the 17 Sept scoring answer (acreage instead of order value). |

## Part 5 — Scoring, routing and the clock, in detail

### 5.1 From signal to SUL

A signal has become a lead attached to one grower (Part 4). Before it reaches
an SUL, three things happen in order. **Gaps are filled:** if the lead has a
number but no acreage, no crop or no clear purchase intent, Hina, the AI
calling agent, phones the grower and asks; a lead with no gap skips this
step. **The lead is scored** from five ingredients and four adjustments, and
placed in Hot, Campaign or Potential, or closed below the threshold. **The
lead is routed** to the SUL who owns the grower's territory, and its two
clocks start. What the SUL logs comes back as an outcome the engine learns
from. Every step is recorded; nothing waits on a person except the SUL.

### 5.2 Filling the gaps — Hina (phase 1)

Hina is an AI voice agent built and run by a third party and connected to
Synapse. In this phase she asks; in the next she sells (see 5.8).

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-1 | A lead that has a number and is missing acreage, crop or clear purchase intent is **held for Hina** before any SUL sees it. A lead with no gap is routed at once. | A Crop Doctor scan with no acreage does not appear on the SUL's phone yet; a WhatsApp "what is the price, I have 30 acres of cotton" appears at once. | Your answers (21 Sept, Hina 1 and 2) | |
| P5-2 | Synapse decides which leads Hina calls, in what order (score, then age) and with what limit: **3 attempts over 2 days**, both Admin settings. Hina decides only how she runs each call. | Admin's settings show "Hina: 3 attempts, 2 days"; Hina's call list is ordered by Synapse. | Your answer (21 Sept, Hina 4) | |
| P5-3 | Hina returns, per lead: acreage, crop, purchase intent (wants to buy / advice only / unclear), the outcome of each attempt (answered, no answer, wrong number, refused), and a short plain-words summary. No recording and no transcript enter Synapse. | The lead's history shows "Hina, 4 Oct 11:20: answered — 30 acres cotton, asked about price. Summary: grower has whitefly on 30 acres, wants to know price before deciding." | Your answer (21 Sept, Hina 3) | |
| P5-4 | Acreage from Hina is marked **confirmed by Hina** and treated like an SUL's confirmation: it stays on the grower and is not overwritten by a later estimate. | "Acreage 30 (confirmed by Hina, 4 Oct)". | Your answer (21 Sept); Part 4 (P4-20) | |
| P5-5 | When Hina finishes — data obtained, or attempts exhausted — the lead is scored with what she found and goes into Hot, Campaign or Potential, or is closed below threshold. The SUL's two clocks start at handover. | Two days after arrival at most, the lead is on the SUL's phone or closed. | Your answers (21 Sept, Hina 2 and 3); Part 1 | |
| P5-6 | A lead Hina could not reach is routed anyway, with its gaps still open, marked "Hina: no answer after 3 attempts"; the SUL asks on the call. | Potential lead with "acreage unknown — Hina could not reach". | Your answer (21 Sept, Hina 2) | |
| P5-7 | Hina never calls below-threshold growers, held signals, or leads with no gap, in this phase. | Hina's call list holds only routed-eligible leads with a gap. | Your answer (21 Sept, Hina 1) | |
| P5-8 | Every Hina call is logged as an automated contact with the grower and is visible on the lead, on Admin's audit trail and in Connections (Hina as a connection with health). | Connections shows "Hina: connected, 41 leads waiting, 12 returned today". | Canvas (automated reads logged); Part 3 (P3-13) | |
| P5-9 | Synapse sends **no automated WhatsApp message** to growers in phase 1. Hina is the only automated contact. Marketing may run its own WhatsApp campaigns outside Synapse to qualify leads; their responses arrive as campaign signals like any other. | No template, no nurture content, no acreage question by WhatsApp. | Your answer (21 Sept, WhatsApp auto) | |
| P5-10 | Hina's contact does not count as the SUL's contact; the SUL's contact clock starts at handover and stops at the SUL's first contact. | On-time rates measure the SUL, not Hina. | Part 1 (P1-39); Your answer (21 Sept) | |

### 5.3 The score

0 to 100 from five ingredients, then four adjustments. Weights are Admin
settings; every change is logged and reversible. The first engine is a
rule-based scorecard; it is never switched off.

| Weight | Ingredient | What it measures | Read from | Low → high | Came from | Mark |
|---:|---|---|---|---|---|---|
| **30** | Purchase intent | How explicitly the grower asked to buy | The grower's words (message, transcript, form, call-centre note, Hina's answer), read with a confidence; the SUL's one-tap confirmation | Passive scan → problem question → product question → price or purchase question | Canvas; Your answer (21 Sept, weights) | |
| **25** | Acreage | Sale potential | Confirmed (SUL or Hina) or estimated acreage; unknown scores zero here | Under threshold → threshold → large | Your answer (17 and 21 Sept) | |
| **20** | Crop need | How badly the crop needs treatment now | Crop Doctor diagnosis, severity and confidence; agronomic words in the message | Healthy or preventive → confirmed early → active and spreading | Canvas | |
| **15** | Season timing | Whether the treatment window is open | A crop-and-window table (crop, problem, months) owned by Marketing in Admin; scores the middle value until a row exists | Window closed → opens soon → open now | Canvas; Your answer (21 Sept, timing) | |
| **10** | Grower history | Past relationship | Last season's status, prior outcomes, the new/existing mark, e-commerce purchases | New → known → previous buyer | Canvas; Your input (15 Sept) | |

| Adjustment | Effect | When | Came from | Mark |
|---|---|---|---|---|
| **Age** | −2 per day after the first 48 hours, down to a floor so age alone never reaches zero; any new signal from the grower resets the age | Every lead, daily | Canvas; Your answer (21 Sept, decay) | |
| **Reachability** | −15 while the grower's number has never been confirmed: no message received from it, no Hina or SUL contact that reached the grower | Numbers typed into forms until confirmed | Canvas; Your answer (21 Sept, adjustments) | |
| **Serviceability** | −10 where no franchise is within serviceable range of the grower's location | Needs the franchise list (5.5) | Canvas; Your answer (21 Sept, adjustments) | |
| **Repeat signals** | A new signal from the same grower merges into the open lead and raises its score; never a second lead | Every repeat | Canvas; Invariant 3 | |

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-11 | Every score carries its version and its breakdown, and shows its **top three reasons** in plain words in the SUL's language. | "Asked the price on WhatsApp · 30 acres, confirmed by Hina · Spray window open for cotton whitefly". | Invariant 8; Canvas | |
| P5-12 | SULs see the order and the reasons, not the number. Managers and Admin see the 0–100 number. | No score number on any SUL screen; "Score 72" on the RSM's lead card. | Your answer (21 Sept, engine + score) | |
| P5-13 | A lead is re-scored on every new signal, on every answer from Hina or the SUL (acreage, intent), and daily for age. Re-scoring can move a lead up a segment; the SUL is told when it does. | P1-24; J7.3. | Canvas; Part 1 | |
| P5-14 | Weights, the age floor, the two adjustment sizes and Hina's limits are Admin settings; every change is recorded with who, when and the previous value, takes effect at once for new scores, and notifies Head of Sales. | J21.2. | Canvas; Your answer (18 Sept, controls) | |
| P5-15 | The first engine is a rule-based scorecard with these weights; a learning engine may follow after a season of outcomes; the scorecard stays as the fallback and the explanation and is never switched off. | Every lead always has its reasons. | Canvas | |

### 5.4 Segments, precisely

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-16 | **Below threshold**: known acreage under the threshold → not routed; Admin's list; counted for Marketing, PMs and Leadership; the grower keeps a profile. Applies before segmenting. | P1-20. | Your input (16 Sept) | |
| P5-17 | **Campaign**: the lead carries a campaign → Campaign segment, whatever else is true; tagged "meets Hot conditions" and first in its campaign when it does. | P1-15, P1-18. | Your input; Your mark (18 Sept) | |
| P5-18 | **Hot**: no campaign, and clear purchase intent (price, nearest franchise, or "I need it"), and crop known, and acreage confirmed or estimated at or above the threshold. The number does not gate it. | P1-14. | Your input (15 Sept); Your answer (17 Sept) | |
| P5-19 | **Potential**: everything else routed. Inside it, "Last season" holds this season's leads from growers converted or never touched last season. | P1-16, P1-17. | Your input; Your answer (17 Sept) | |
| P5-20 | Inside every segment: flagged leads first, then today's due leads (contact promise, completion promise or follow-up date today), then by score, then by age. The first **20** leads are on the list; the rest sit under "more leads", one tap away. | P2-2. | Your input (no cap); Your answer (21 Sept, fold) | R |
| P5-21 | Unclear intent after Hina and before the SUL's confirmation is shown as "intent unclear" and cannot make a lead Hot. | P4-9. | Your answer (21 Sept) | |

### 5.5 Routing

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-22 | A lead is routed by the grower's village → BSA → territory → the SUL who owns it, through the sales structure list. One SUL per territory; no lead has two owners. | P1-3, P4-29. | Your input; Your answer (17 Sept) | |
| P5-23 | No village match → the regional pool; the RSM assigns by hand; clocks start at assignment. | J15. | Your answer (18 Sept) | |
| P5-24 | Routing happens after Hina (if the lead had a gap) and after scoring, so the SUL receives a complete, scored lead. | P5-5. | Your answers (21 Sept) | |
| P5-25 | The **franchise list** (name, location, serviceable range, and which territory it serves) is kept in Admin; it feeds "nearest franchise" on the lead card and the serviceability adjustment. Owner: the Digital Business Operations team (DBO), which owns everything operational; Admin has access. | J21.7 gains a Franchises tab. | Your answer (21 Sept, adjustments and franchise list) | R |
| P5-26 | A territory boundary change re-routes future leads only; open leads stay with their SUL. | P3-19. | Approved with Part 3 | |

### 5.6 The two clocks, precisely

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-27 | Both clocks start when the lead reaches the SUL (routing, pool assignment, or handover from Hina). Contact stops at the SUL's first contact; completion stops at Completed or Closed. Rejected stops both. | P1-39. | Your mark (18 Sept) | |
| P5-28 | Promises, all Admin settings: contact — Hot 24 h, Campaign per campaign, Potential 72 h; completion — Hot 7 days, Campaign per campaign, Potential 14 days. A campaign cannot be created without both of its promises. | P1-38; P3-16. | Canvas; Your mark (18 Sept); Your answer (21 Sept, campaign clock) | R |
| P5-29 | Overdue on either clock: badge on the lead and summary; one notification each to the SUL, RSM and ZM per lead; a daily 8 am digest for Head of Sales. No reassignment. | P1-41, P3-14. | Your answers (17, 18 Sept) | |
| P5-30 | Clocks count calendar hours and days but **pause on Sundays**; public holidays count. | A Hot lead routed Saturday 18:00 is due for contact Monday 18:00. | Your answer (21 Sept, calendar) | R |
| P5-31 | On-time rates: contacted within the contact promise ÷ leads that reached the SUL; completed within the completion promise ÷ leads that reached the SUL; both at every level, contact first. Leads waiting for Hina, held, below threshold or rejected are not in the denominator. | P1-43, P3-5. | Canvas; Your mark (18 Sept) | |

### 5.7 Learning from outcomes

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P5-32 | Every completed or closed lead — converted with value, product and quantity; not converted with reason; unreachable; below threshold — is kept as a labelled example with the score, reasons and segment it had. | Nothing visible; the engine's memory. | Canvas | |
| P5-33 | Conversion by segment, by source, by campaign, by crop, by acreage band and by district is watched continuously; Leadership's "does the engine beat a plain list" is the conversion rate of the top-scored tenth of leads against the bottom tenth. | J18.1. | Canvas (model lift) | |
| P5-34 | After a season, the engine may **propose** weight changes with the evidence. Admin applies or rejects; Head of Sales, ZMs, RSMs and SULs are all notified of an applied change; every change is logged and reversible. Nothing retunes itself. | "Scoring weights changed on 1 Mar: acreage 25 → 30. Reason: …" on every user's notifications. | Your answer (21 Sept, engine + score); Canvas (no silent self-retuning) | |
| P5-35 | The SUL's one-tap intent confirmation and Hina's answers are kept as examples that improve intent reading. | P4-9. | Your answer (21 Sept, unsure intent) | |

### 5.8 Hina in phase 2 — recorded, not specified

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
| D6 | Territory vs franchise conflict | Open — sales leadership | The franchise list (P5-25) names which territory a franchise serves; the conflict rule is still open and no routing depends on a franchise. |
| D7 | Conversion value | Open | Learning uses self-declared values with receipts. |
| — | Hina phase 1 rules; weights and adjustments; timing table by Marketing; engine proposals applied by Admin with notifications; no automated WhatsApp | Decided 21 Sept | 5.2, 5.3, 5.7. Recorded in `docs/DECISIONS.md`. |

### 5.10 Question log (Part 5)

| # | Question | Answer (date) | Rows |
|---|---|---|---|
| 1 | Starting weights? | Intent 30 · Acreage 25 · Crop need 20 · Timing 15 · History 10 (21 Sept) | 5.3 |
| 2 | Keep age decay? | Yes, −2 per day after 48 h (21 Sept) | 5.3 |
| 3 | Reachability and serviceability? | Keep both; add a franchise list (21 Sept) | 5.3, P5-25 |
| 4 | Acreage by WhatsApp? | No; Hina, the AI calling agent, asks by phone (21 Sept) | 5.2 |
| 5 | What is Hina? | AI voice agent by a third party; phase 1 fills gaps (acreage, crop, intent) before routing; phase 2 first layer of calling for all growers (21 Sept) | 5.2, 5.8 |
| 6 | Which leads does Hina call? | Phase 1: only those with missing data (21 Sept) | P5-1, P5-7 |
| 7 | Where is the lead while Hina calls? | Held; SUL sees nothing until handover; leads with no gap route at once (21 Sept) | P5-1, P5-5 |
| 8 | What does Hina hand back? | Structured answers and a short summary; no recording; leads land in the same three segments (21 Sept) | P5-3 |
| 9 | Who orders Hina's calls? | Synapse sends the order and the attempt limit (21 Sept) | P5-2 |
| 10 | Any automated WhatsApp in phase 1? | None from Synapse; Marketing may run its own WhatsApp campaigns to qualify leads (21 Sept) | P5-9 |
| 11 | Timing table owner? | Marketing; neutral until filled (21 Sept) | 5.3 |
| 12 | Engine proposals and score visibility? | Admin applies; Head of Sales, ZMs, RSMs and SULs notified; SUL sees rank and reasons, not the number (21 Sept) | P5-12, P5-34 |
| 13 | Four gaps marked ASSUMPTION | Answered 21 Sept: fold = top 20 per segment (P5-20) · franchise list owned by DBO (P5-25) · promises required to create a campaign (P5-28) · clocks pause on Sundays only (P5-30) | P5-20, P5-25, P5-28, P5-30 |

### 5.11 Where the canvas or the audit differs (Part 5)

| DR | Spec | Canvas or audit | Note |
|---|---|---|---|
| DR-23 | Leads with a gap wait for Hina, up to 2 days, before an SUL sees them | Canvas: lead delivery must never depend on a model call; "a dropped lead is a lost sale nobody sees" | Your decision, 21 Sept. Bounded by the attempt limit and by "no gap → route at once"; a lead is never dropped, only delayed. The session 2.2 delivery lens will weigh the delay against the value of confirmed acreage. |
| DR-24 | Acreage asked by Hina on the phone; no WhatsApp question | Canvas: acreage cascade step 3 is an automated WhatsApp callback, max 2 attempts | Your answer, 21 Sept. Same intent, different channel, three attempts. |
| DR-25 | No automated nurture or WhatsApp content from Synapse in phase 1 | Canvas: nurture automation matched to crop and season | Your answers, 17 and 21 Sept; Marketing's own WhatsApp campaigns feed signals in. |
| DR-26 | Acreage is an ingredient; no order-value calculation | Canvas: opportunity value = acreage × dose × price | Your answer, 17 Sept; recorded in DECISIONS. |
| DR-27 | Franchise list added for serviceability and "nearest franchise" | Canvas "consequences accepted": franchise data removed | The list is locations and range only, not sales or invoices; D6 stays open. |
| DR-28 | Hina's future role as an AI SUL | Not in the canvas | Recorded in 5.8 and DECISIONS; not specified. |

## Part 6 — What is recorded, how well it must work, what it must never do, and the decisions

### 6.1 What Synapse records

Plain lists of what each record holds. Items marked **(personal)** are
personal data: they are hidden from anyone outside the rules in Parts 2 and
3, never appear in an export or a summary, never appear in a log line, and
are removed under the retention rule (6.2). Field-level detail with types is
in the Appendix.

| Record | What it holds | Came from | Mark |
|---|---|---|---|
| **Grower** | Name (personal) · mobile number (personal; one per grower; history of changes with who and when) · village and location: province, district, tehsil, village, map position where a source gave it (personal) · crops grown · acreage, per crop where known, each marked estimated / confirmed by SUL / confirmed by Hina, with source and date · preferred language · new/existing mark · last season's status · the date of last activity | Parts 1, 4 | |
| **Consent basis** (one per lead) | The stream and the date of the grower's own contact with Syngenta that the lead came from | Part 4 (P4-23); D1 | |
| **Signal** | Which stream · when the grower acted · what they did (scan, message, post, form, call, purchase) · the grower's own words where there are any (personal) · crop, problem, severity and confidence where the stream gives them · campaign where carried · the original as received, unchanged · whether it was held (no number, campaign unknown, invalid) and why | Part 4 | |
| **Lead** | The grower · the signals it merges · crop and need · acreage and its status · purchase intent and how sure (from words, Hina, or the SUL's tap) · source stream · campaign · segment · state and every state change with who and when · territory and SUL · both clocks: start, promise, stop, overdue · follow-up date · flags received · Hina's attempts and summary · last season's tag · rejection reason if any | Parts 1, 2, 5 | |
| **Score** | The number · which weights version produced it · each ingredient's contribution · each adjustment applied · the top three reasons, in Urdu and English · when it was calculated | Part 5; Invariant 8 | |
| **Outcome** | Converted: PKR value, product, quantity, receipt photo (personal), closing SUL, date · Not converted: reason, comment, SUL, date · Closed: unreachable (attempts, reason) or below threshold · Rejected: reason, SUL, Admin's action | Part 1 | |
| **Hina call** | Lead · attempt number · when · outcome (answered, no answer, wrong number, refused) · acreage, crop, intent returned · the short summary (personal) · no recording, no transcript | Part 5 | |
| **Flag** | From whom to whom · lead · note · due-by day · when sent · when actioned | Part 3 | |
| **Campaign** | Name · kind (brand-level or crop programme) · portfolio · brand or programme · product · crop · start and end · contact and completion promises · budget · actual spend, with change history · NPI flag (from the canvas) | Parts 3, 4 | |
| **Product** | Name · portfolio · brand · crops and problems it treats | Part 4 | |
| **Sales structure** | Zones · regions · territories · BSAs · which SUL owns each territory · change history | Part 4 | |
| **Grower location list** | Provinces · districts · tehsils · villages · which BSA each village belongs to | Part 4 | |
| **Franchise** | Name · location · serviceable range · territory served | Part 5 | |
| **Timing table** | Crop · problem · months when treatment applies | Part 5 | |
| **User** | Name · Syngenta email (the login) · role · scope (territory, region, zone, portfolio, or all) · language · active or not | Parts 1, 3 | |
| **Settings** | Acreage threshold · six clock promises · scoring weights, age floor, adjustment sizes · fold size · Hina attempts and days · season start date · retention period · every change with who, when and the previous value | Parts 1, 5, 6 | |
| **Audit entry** | Who · when · what (a settings change, a flag, a number change and its undo, a removal, a manager opening a grower's number or a receipt, an export, a Hina call, an automated read, a login) · on which record | Part 3 | |

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P6-1 | Every record above is kept in one place, and every screen, summary and export reads from that one place. No screen keeps its own copy of a number. | Two screens never disagree about a count. | Canvas (one data platform); Audit lesson (§7.12, §7.22) | |
| P6-2 | A diagnosis is recorded as "healthy" only when the source said so. A blank diagnosis is "unknown", never healthy and never diseased. | A Crop Doctor scan with no diagnosis shows "diagnosis unknown". | Audit keeper (healthy is affirmative) | |
| P6-3 | Every item marked (personal) is marked in the record itself, so exports, summaries and logs leave it out by rule, not by memory. | An export never contains a name or number, whoever runs it. | Canvas (PII tagged); Audit lesson (§7.4) | |
| P6-4 | One user list, one sales structure. A role or territory is stored once and read from there by every screen. | Changing a territory in Admin changes it everywhere at once. | Audit lesson (§7.13) | |
| P6-5 | Money is recorded and shown in PKR, whole rupees, never as a rounded estimate. Time is shown in Pakistan time everywhere. | "PKR 85,000", never "PKR 85k" or "≈ 85,000". | Rule book (`CLAUDE.md`) | |

### 6.2 How well it must work

| ID | What Synapse does | What you would see | Came from | Mark |
|---|---|---|---|---|
| P6-6 | **Offline.** The SUL app works fully without signal: every lead, grower and list in the territory is on the phone; every action waits on the phone and sends in order when signal returns; the SUL's entry is never lost, even if the phone restarts or the same lead changed on the server meanwhile. | J9. | Canvas; Your input (15 Sept) | |
| P6-7 | **Languages.** The SUL app in Urdu or English, chosen by the SUL; every reason list, notification and summary in both. Manager, marketing and Admin screens in English. Grower words shown as sent. Regional languages later. | P2-9. | Your answer (17 Sept) | |
| P6-8 | **Phones.** Android 9 or newer, 2 GB memory, under 150 MB with a full territory on the phone, usable on 2G/3G. No iPhone in the Pilot. | P2-10. | Your answer (17 Sept) | |
| P6-9 | **Volume.** Up to 1,000 leads a day on a normal day. A campaign launch of 10,000 leads in twenty minutes loses nothing and slows nothing the SUL sees. Every lead arrives, in order, whatever the volume. | Connections shows the burst arriving and clearing; no SUL notices. | Your answer (21 Sept, volumes); Plan M8 (the burst) | |
| P6-10 | **Personal data.** Only what the streams and SULs gave; marked in the record; visible only inside each user's scope; every opening of a name, number or receipt by a manager is logged. | P3-13, P6-3. | Canvas; Your answers (18, 21 Sept) | |
| P6-11 | **Retention.** After two seasons (two crop years) with no signal, contact or purchase, the grower's name, number, location and receipts are removed; crops, acreage band, district and outcomes stay without identity. The period is an Admin setting; every removal is logged. | Admin's audit trail shows "anonymised: 312 growers inactive since Kharif 2024". | Your answer (17 Sept, retention); Canvas | |
| P6-12 | **Residency.** Grower data is stored in Pakistan. | Confirmed in Phase 3 with the hosting choice; IT can be shown where. | Your answer (21 Sept) | |
| P6-13 | **Season.** One season a year: a crop year of twelve months from a start date Admin sets. "Last season" is the previous crop year; "two seasons of inactivity" is two crop years. | Admin's settings show "Season starts 1 April". | Your answer (21 Sept, season) | |
| P6-14 | **Receipts.** A receipt photo can be opened by the SUL who logged it and by everyone above them in the sales line up to Head of Sales; each opening is logged. Marketing, PMs and Leadership see that a receipt exists, never the image. | An RSM opens a receipt; the audit trail records it. | Your answer (21 Sept, receipts) | |
| P6-15 | **Audit.** Every settings change, flag, number change and undo, removal, manager view of personal data, export, login, Hina call and automated read is recorded and readable by Admin; nothing in the audit trail can be edited or deleted. | J21.8. | Canvas; Your answers (18 Sept) | |
| P6-16 | **Login.** Staff register and log in with their Syngenta email address and a Synapse password. Country IT confirms who may have an account; Admin sets role and scope. Single sign-on with the corporate identity is out of scope for now (6.3.2). | The login screen asks for a Syngenta email; a non-Syngenta address cannot register. | Your answer (21 Sept, login); Canvas (SSO where available, deferred) | R |
| P6-17 | **Running it.** DBO watches the portal daily and handles the below-threshold, no-contact, rejected and pool lists and SUL support; the digital team (Admin) owns settings and is the escalation point to the third parties (Hina, hosting). Support on working days, 9 to 6; the app and the clocks run every day. | A failing stream is noticed by DBO the same morning. | Your answer (21 Sept, operations) | |
| P6-18 | **No clutter.** Every SUL screen answers one question; three segments and nothing else on home; the first 20 per segment; every manager sees one level down, named. | Parts 2, 3. | Your input (15 Sept) | |
| P6-19 | **Honest numbers.** A screen with incomplete data says so and cannot be dismissed; exports are off while data is incomplete; every summary says "as of" and how many; unresolved rows are counted openly. | P3-8. | Audit keepers | |
| P6-20 | **Nothing invented.** No default replaces a missing value: no zero acreage, no "today" for a missing date, no guessed location, no PKR estimate. Unknown is shown as unknown. | "Acreage unknown", never "0". | Audit lesson (§7.11); Your answer (18 Sept, no PKR estimate) | |
| P6-21 | **Evidence.** Every rule in this document is proven by something Ahsan can watch: a screen, a count, a test that names the rule. "It should work" is not evidence. | Every part's rows have a "What you would see". | Rule book (`CLAUDE.md`); Audit lesson (§7.21) | |

### 6.3 Out of scope, and what Synapse must never do

**6.3.1 Specified here, built after Capture.** Capture, the first build scope,
is the streams, the one-grower record, the first scorecard, a one-page list,
Hina's phase 1 connection and the acreage rules. Built after Capture, as
specified in Parts 2, 3 and 5: the full SUL app, the manager, leadership,
marketing and Admin dashboards, flags, the weekly and monthly summaries, the
franchise list and serviceability, the learning engine's proposals. The
Appendix marks each row with its build milestone.

**6.3.2 Out of scope for this phase**, by your decision, each with the date
and a note on when it returns.

| Item | Decided | Returns when |
|---|---|---|
| SUL creates a lead by hand (walk-in growers) | 18 Sept | Next year or phase 2; the focus is leads from the digital streams |
| Grower opt-out, by grower or by SUL | 21 Sept | Reconsidered in a later phase; recorded for the consent reviewer |
| Splitting a shared number into two growers | 18 Sept | If the field reports shared-number growers merged in error |
| A PKR estimate on the lead card | 18 Sept | With a product-and-price list, if wanted |
| Fulfilling franchise on a conversion | 18 Sept | With point-of-sale integration |
| Point-of-sale integration (conversion from sales data, no receipt) | 15 Sept | When POS exists; the intended answer to D7 |
| Automated WhatsApp messages from Synapse to growers | 21 Sept | Phase 2, alongside Hina's wider role |
| Hina as an AI SUL: first layer of calling for every grower, closing sales | 21 Sept | Phase 2, when the third party proves a closed sale on real calls; its own spec section |
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
| AR-14 | …swallow a failure. A write that fails is shown and retried, never dropped. | P4-5 | §7.14 |
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
| AR-25 | …let reading a message with AI delay or block a lead's arrival. Hina's hold is bounded by the attempt limit and never applies to a lead with no gap. | P4-10, P5-1, P5-5 | Canvas |
| AR-26 | …route a lead whose grower's known acreage is below the threshold to any sales user. | P1-20, P5-16 | — |
| AR-27 | …hide a lead behind a cap or a Nurture tier. | P1-23, P5-20 | Canvas (declined) |
| AR-28 | …show a PKR estimate nobody can stand behind. | P2-7, P6-20 | — |

### 6.4 Decisions

| ID | Decision | State | Owner | What it blocks or governs |
|---|---|---|---|---|
| D1 | Consent basis for advisory-captured data used for sales contact | **Decided 2026-09-18**: any contact with Syngenta is the basis; no opt-out this phase | Leadership, via Ahsan | Cropwise-sourced growers routed from day one |
| D2 | Who owns Cropwise platform access for the Pakistan tenant | **Filed, awaiting reply** (21 Sept); recipient and date to be added | Ahsan | Connecting the three Cropwise streams; the M2 spike may use WhatsApp instead |
| D3 | Campaign ID convention | Open; decided in M5 | Marketing, via Ahsan | Campaign segment and every marketing number; leads arrive "campaign unknown" until then |
| D4 | Mobile number as the grower's key; shared-number rule | **Decided 2026-09-18**: one number, one grower; no split; SUL corrects; no-number signals held | Ahsan | One-grower rules, Part 4 |
| D5 | Syngenta's recommended stack | Decided 2026-09-11: default stack, revisit Phase 3 | Ahsan | Nothing here |
| D6 | Territory vs franchise catchment conflict | Open; confirm before rollout | Sales leadership, via Ahsan | Nothing in this phase; no routing depends on a franchise |
| D7 | Conversion value: declared or reconciled | Open; point-of-sale integration is the intended path | Ahsan with finance | No PKR figure is linked to incentives until decided |
| D8 | — | Not used; withdrawn 16 Sept | — | — |
| D9 | Healthy Crop Doctor scan is a lead only at or above the threshold | **Decided 2026-09-15** | Ahsan | Crop Doctor connector rule |

Session decisions, all recorded in `docs/DECISIONS.md` with the date: three
segments and no cap · two clocks, notify-only · acreage threshold 20 as a
setting · eight personas · acreage replaces order value · Hina phase 1 ·
scoring details · D1 · D4.

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
| 10 | Support hours? | Working days 9 am to 6 pm; the app and clocks run every day (21 Sept) | P6-17 |
| 11 | Manager, PM, Marketing and Admin screen language? | English only; grower words and lead reasons as written (21 Sept) | P6-7 |

### 6.6 Where the canvas or the audit differs (Part 6)

| DR | Spec | Canvas or audit | Note |
|---|---|---|---|
| DR-29 | Receipts visible up to Head of Sales | Canvas: sales scope own level and below (consistent); ZM and above otherwise see no personal data (DR-17) | The receipt is the one personal item ZM and Head of Sales can open, by your answer, 21 Sept. |
| DR-30 | One season a year | Canvas: seasons unspecified; the field runs Kharif and Rabi | Your answer, 21 Sept. "Last season" means last crop year. |
| DR-31 | Data in Pakistan | Canvas: residency governed by consent, no rule | Your answer, 21 Sept; a Phase 3 hosting rule. |

## Appendix — technical detail

*You can stop reading before this point.* This appendix exists for the
session 2.2 reviewers, for Phase 3 (architecture) and for the builders. It
adds nothing a product reader needs.

### A.1 Traceability — every row, its canvas layer, invariants and build milestone

Canvas layers are those of `docs/reference/01-product-canvas.md` (L1–L8,
Z00, Z04). Milestones are those of `docs/PLAN.md` (M0–M8 = Capture);
"Post-Capture" means specified now, built in the Act scope after M8. The
"Came from" column repeats the row's own attribution verbatim so the two
never drift.

| ID | Canvas layer | Invariants cited | Build milestone | Came from (as written) |
|---|---|---|---|---|
| P1-1 | Z00 identity & access; Z04 grain | INV-7 | Post-Capture; M1 list scope | Your input (15, 16 Sept); Canvas; Invariant 7 |
| P1-2 | Z00 identity & access; Z04 grain | - | Post-Capture; M1 list scope | Audit §1.5; Canvas |
| P1-3 | Z00 identity & access; Z04 grain | - | Post-Capture; M1 list scope | Your input (15 Sept) |
| P1-4 | Z00 identity & access; Z04 grain | INV-7 | Post-Capture; M1 list scope | Canvas; Invariant 7 |
| P1-5 | Z00 identity & access; Z04 grain | - | Post-Capture; M1 list scope | Your answer (17 Sept) |
| P1-6 | Z00 identity & access; Z04 grain | - | Post-Capture; M1 list scope | Your answer (17 Sept) |
| P1-7 | L2 ingestion; L3 Grower 360 | - | Capture: M1, M3 | Your input (15 Sept); Canvas; Audit lesson |
| P1-8 | L2 ingestion; L3 Grower 360 | INV-2, INV-3 | Capture: M1, M3 | Invariant 2; Invariant 3; Canvas |
| P1-9 | L2 ingestion; L3 Grower 360 | INV-3 | Capture: M1, M3 | Invariant 3 |
| P1-10 | L2 ingestion; L3 Grower 360 | - | Capture: M1, M3 | Your input (15 Sept); Canvas |
| P1-11 | L2 ingestion; L3 Grower 360 | - | Capture: M1, M3 | Canvas; Your input (16 Sept) |
| P1-12 | L2 ingestion; L3 Grower 360 | INV-1 | Capture: M1, M3 | Invariant 1; Your decision D1 (18 Sept) |
| P1-13 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your input (15 Sept); Your decision (segments) |
| P1-14 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your input (15 Sept); Your answer (17 Sept); see DR-2 |
| P1-15 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your input (15 Sept); Your answer (17 Sept, campaigns) |
| P1-16 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your input (15 Sept) |
| P1-17 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your answer (17 Sept, lifecycle) |
| P1-18 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your mark (18 Sept) |
| P1-19 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your input (16 Sept); Your answer (17 Sept, one threshold) |
| P1-20 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your input (16 Sept); Your answer (17 Sept) |
| P1-21 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your input (15, 16 Sept); Your answer (21 Sept, Hina) |
| P1-22 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your input (16 Sept); Your mark (18 Sept) |
| P1-23 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your input (15 Sept); Your decision (segments); see DR-4 |
| P1-24 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Canvas |
| P1-25 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your decision D9 |
| P1-26 | L5 engine; L6 tiers | - | Capture: M1 (v0 stub), M8 (acreage); segments post-Capture | Your answer (17 Sept, lifecycle) |
| P1-27 | L8 outcome | INV-5 | Post-Capture | Your input (15 Sept); Your answer (17 Sept); Invariant 5 |
| P1-28 | L8 outcome | - | Post-Capture | Your input (15 Sept); Audit keeper (call and WhatsApp leave a trace); Canvas |
| P1-29 | L8 outcome | INV-7 | Post-Capture | Invariant 7; Your answer (17 Sept, escalation) |
| P1-30 | L8 outcome | INV-6 | Post-Capture | Your input (15 Sept); Your answer (18 Sept); Invariant 6 |
| P1-31 | L8 outcome | - | Post-Capture | Your answer (18 Sept); see DR-6 |
| P1-32 | L8 outcome | - | Post-Capture | Canvas; Your input (15 Sept, "completed once the loop is closed"); see DR-1 |
| P1-33 | L8 outcome | - | Post-Capture | Your answer (17 Sept) |
| P1-34 | L8 outcome | - | Post-Capture | Your mark (18 Sept) |
| P1-35 | L8 outcome | - | Post-Capture | Your answer (17 Sept); Audit keeper (report with reason, admin-only removal) |
| P1-36 | L8 outcome | - | Post-Capture | Audit keeper; Canvas |
| P1-37 | L8 outcome | - | Post-Capture | Your input (15 Sept); see DR-5 |
| P1-38 | L7 routing & SLA | - | Post-Capture | Canvas (contact numbers); Your mark (18 Sept, two clocks); completion numbers are a starting proposal |
| P1-39 | L7 routing & SLA | - | Post-Capture | Your mark (18 Sept) |
| P1-40 | L7 routing & SLA | - | Post-Capture | Your answer (17 Sept, summary); Canvas |
| P1-41 | L7 routing & SLA | - | Post-Capture | Your answer (17 Sept, escalation); see DR-3 |
| P1-42 | L7 routing & SLA | - | Post-Capture | Your mark (18 Sept) |
| P1-43 | L7 routing & SLA | - | Post-Capture | Canvas; Your decision (clock kept); Your mark (18 Sept, two clocks) |
| J1.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input; Canvas (offline) |
| J1.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 |
| J1.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept, summary) |
| J1.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input (no clutter); Your answer (18 Sept, map, revised) |
| J2.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input; Canvas; Your answer (18 Sept, card extras) |
| J2.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Audit keeper (call leaves a trace); Part 1 |
| J2.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Audit keeper; Canvas |
| J2.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept) |
| J2.5 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input; Canvas (two taps) |
| J2.6 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Audit keeper (navigate) |
| J3.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input |
| J3.2 | L8 SUL app | INV-6 | Post-Capture (M1 has the one-page list only) | Your input (15 Sept); Your answer (18 Sept, converted); Invariant 6 |
| J3.3 | L8 SUL app | INV-6 | Post-Capture (M1 has the one-page list only) | Your input; Invariant 6 |
| J3.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Canvas (offline); Audit keeper (outbox) |
| J4.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Canvas; Part 1 (DR-1) |
| J4.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input; Canvas |
| J4.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-34) |
| J5.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-40, P1-41) |
| J5.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept) |
| J5.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-39) |
| J5.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-38) |
| J6.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input (15 Sept) |
| J6.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input; Part 1 (P1-18) |
| J6.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Canvas |
| J6.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 |
| J7.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input (16 Sept); Your answer (21 Sept, Hina) |
| J7.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input (16 Sept); Part 1 (P1-11) |
| J7.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-24) |
| J7.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your mark (18 Sept) |
| J8.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, shared number) |
| J8.2 | L8 SUL app | INV-2 | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept); Invariant 2 |
| J9.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Canvas (offline-first); Audit lesson (reads were not cached) |
| J9.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Canvas; Audit keeper (outbox) |
| J9.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Canvas |
| J10.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input (15 Sept); Your answer (17 Sept) |
| J10.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input; Audit keeper (presets) |
| J10.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept); Audit lesson (gamification) |
| J11.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept) |
| J11.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-35) |
| J12.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Audit (list search); Canvas (interaction history) |
| J12.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, walk-in lead) |
| J13.1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your note (18 Sept, map) |
| J13.2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your note (18 Sept) |
| J13.3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your note (18 Sept); Part 1 |
| J13.4 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your note (18 Sept); P2-21 |
| J13.5 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Canvas (offline) |
| P2-1 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input (15 Sept) |
| P2-2 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input; Part 1 (P1-23) |
| P2-3 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Canvas (two-tap rule); see DR-9 |
| P2-4 | L8 SUL app | INV-8 | Post-Capture (M1 has the one-page list only) | Canvas; Invariant 8 |
| P2-5 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-38) |
| P2-6 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-11) |
| P2-7 | L8 SUL app | INV-1 | Post-Capture (M1 has the one-page list only) | Canvas; Invariant 1; Your answer (18 Sept, card extras) |
| P2-8 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Canvas; Audit lesson |
| P2-9 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept) |
| P2-10 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept) |
| P2-11 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept); Audit lesson |
| P2-12 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Audit keeper |
| P2-13 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Canvas |
| P2-14 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input (15 Sept) |
| P2-15 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-42) |
| P2-16 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input (15 Sept) |
| P2-17 | L8 SUL app | INV-7 | Post-Capture (M1 has the one-page list only) | Invariant 7 |
| P2-18 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your input (16 Sept) |
| P2-19 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-12, P1-20) |
| P2-20 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, map, revised); Audit lesson (map never the home screen) |
| P2-22 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your note (18 Sept); approved with Part 2 |
| P2-21 | L8 SUL app | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, follow-up) |
| J14.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your input (15 Sept); Canvas (breaches first) |
| J14.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your input (SUL-wise) |
| J14.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, manager view) |
| J14.4 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, flag) |
| J14.5 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your input (territory-wise) |
| J15.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Canvas (region pool); Your answer (18 Sept) |
| J15.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, pool) |
| J15.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept); Canvas (master drift) |
| J16.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your input (15 Sept) |
| J16.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Canvas; Your answer (18 Sept, progress and gaps) |
| J16.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, manager view) |
| J16.4 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answers (17, 18 Sept) |
| J17.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept) |
| J17.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answers (17, 18 Sept) |
| J17.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept); Your mark (18 Sept, digest) |
| J17.4 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Part 1 (P1-41) |
| J17.5 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, controls) |
| J18.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept); Canvas (model lift) |
| J18.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept); Canvas ("including when unflattering"); approved with Part 3 |
| J18.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, manager view) |
| J19.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your input (15 Sept); Your answer (17 Sept, under-threshold) |
| J19.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your input (15 Sept) |
| J19.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, PM follow-up) |
| J19.4 | Z04 dashboards / Z00 admin | INV-7 | Post-Capture (M1 has the one-page list only) | Canvas; Invariant 7 |
| J20.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your input (15 Sept) |
| J20.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Canvas; Your answer (18 Sept, cost) |
| J20.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept, campaigns) |
| J20.4 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, cost) |
| J20.5 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, controls); Audit keeper (About sheet, as-of and count) |
| J21.1 | Z04 dashboards / Z00 admin | INV-7 | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept, Admin); Invariant 7 |
| J21.2 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, controls); Canvas (weights audited) |
| J21.3 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept, campaigns) |
| J21.4 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Canvas |
| J21.5 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept) |
| J21.5a | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (21 Sept) |
| J21.6 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (17 Sept, reject) |
| J21.7 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answers (17, 18 Sept) |
| J21.8 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Canvas; Your answers (18 Sept) |
| J22.1 | Z04 dashboards / Z00 admin | - | Post-Capture (M1 has the one-page list only) | Your answer (18 Sept, weekly); Audit keeper |
| J22.2 | Z04 dashboards / Z00 admin | INV-7 | Post-Capture (M1 has the one-page list only) | Audit lesson (no record of sends); Invariant 7 |
| P3-1 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Canvas; Your input (15 Sept) |
| P3-2 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Canvas (one semantic layer); Audit keeper (definitions and sign-off) |
| P3-3 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your answer (18 Sept, manager view) |
| P3-4 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your answers (17, 18 Sept) |
| P3-5 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Part 1 (P1-43) |
| P3-6 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Canvas; Your answer (18 Sept) |
| P3-7 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your input (15 Sept); Audit keeper |
| P3-8 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Audit keepers |
| P3-9 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your answer (18 Sept, controls) |
| P3-10 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your answer (18 Sept, controls); Canvas (weights audited) |
| P3-11 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your answer (18 Sept, pool) |
| P3-12 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your answer (17 Sept) |
| P3-13 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Canvas; Your answers (18 Sept) |
| P3-14 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Part 1 (P1-42); Your mark (18 Sept, digest) |
| P3-15 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Canvas |
| P3-16 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your answers (17, 18 Sept) |
| P3-17 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your answer (18 Sept, weekly) |
| P3-18 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your answer (17 Sept); Canvas; approved with Part 3 |
| P3-19 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your answer (17 Sept, territory); approved with Part 3 |
| P3-20 | Z04 dashboards; Z00 admin console | - | Post-Capture; connection health from M4 | Your input (15 Sept, "mobile dashboard"); Canvas |
| P4-1 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Your answer (17 Sept, sources); Canvas |
| P4-2 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Your input (15 Sept); Audit lesson |
| P4-3 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Canvas |
| P4-4 | L1 sources; L2 ingestion | INV-3 | Capture: M2, M4-M7, M8 | Invariant 3 |
| P4-5 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Canvas; Audit lesson (silent drops) |
| P4-6 | L1 sources; L2 ingestion | INV-9 | Capture: M2, M4-M7, M8 | Invariant 9 |
| P4-7 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Audit lesson (§7.11) |
| P4-8 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Canvas; Your answer (21 Sept, unsure intent) |
| P4-9 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Your answer (21 Sept); Canvas |
| P4-10 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Canvas (AI never in the delivery path) |
| P4-11 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Canvas; D3 |
| P4-12 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Your decision D9 |
| P4-13 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Your answer (17 Sept, live feeds) |
| P4-14 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Your answer (21 Sept) |
| P4-15 | L1 sources; L2 ingestion | - | Capture: M2, M4-M7, M8 | Canvas |
| P4-16 | L3 Grower 360 | INV-2 | Capture: M3, M6 | Invariant 2; Your answer (18 Sept); Your decision D4 |
| P4-17 | L3 Grower 360 | - | Capture: M3, M6 | Your answer (18 Sept); see DR-13 |
| P4-18 | L3 Grower 360 | - | Capture: M3, M6 | Your answer (21 Sept, re-asked); Canvas (nothing enters unattached) |
| P4-19 | L3 Grower 360 | - | Capture: M3, M6 | Canvas (secondary matching) |
| P4-20 | L3 Grower 360 | - | Capture: M3, M6 | Canvas; Your input (16 Sept) |
| P4-21 | L3 Grower 360 | - | Capture: M3, M6 | Canvas; Your input (15, 16 Sept) |
| P4-22 | L3 Grower 360 | - | Capture: M3, M6 | Canvas |
| P4-23 | L3 Grower 360 | INV-1 | Capture: M3, M6 | Your decision D1 (18 Sept); Invariant 1 |
| P4-24 | L3 Grower 360 | - | Capture: M3, M6 | Your answer (21 Sept, "no opt-out option for now"); see DR-19 |
| P4-25 | L3 Grower 360 | - | Capture: M3, M6 | Your answer (21 Sept) |
| P4-26 | L3 Grower 360 | - | Capture: M3, M6 | Your answer (17 Sept, under-threshold); Part 1 |
| P4-27 | L3 Grower 360 | - | Capture: M3, M6 | Your answer (21 Sept, re-asked) |
| P4-27a | L3 Grower 360 | - | Capture: M3, M6 | Your answer (21 Sept, re-asked); Canvas (e-commerce under pulled sources) |
| P4-28 | L2 batch sync; L4 territory | - | Capture: M3, M7 | Canvas (named steward); Audit keeper |
| P4-29 | L2 batch sync; L4 territory | - | Capture: M3, M7 | Your answer (17 Sept); Part 3 (P3-11) |
| P4-30 | L2 batch sync; L4 territory | - | Capture: M3, M7 | Your answer (17 Sept) |
| P5-1 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | Your answers (21 Sept, Hina 1 and 2) |
| P5-2 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | Your answer (21 Sept, Hina 4) |
| P5-3 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | Your answer (21 Sept, Hina 3) |
| P5-4 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | Your answer (21 Sept); Part 4 (P4-20) |
| P5-5 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | Your answers (21 Sept, Hina 2 and 3); Part 1 |
| P5-6 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | Your answer (21 Sept, Hina 2) |
| P5-7 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | Your answer (21 Sept, Hina 1) |
| P5-8 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | Canvas (automated reads logged); Part 3 (P3-13) |
| P5-9 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | Your answer (21 Sept, WhatsApp auto) |
| P5-10 | L4 acreage cascade (Hina replaces the WhatsApp step) | - | Capture: M8 (Hina connection) | Part 1 (P1-39); Your answer (21 Sept) |
| P5-11 | L5 scoring engine | INV-8 | Capture: M1 (v0 stub), weights M8; learning post-Capture | Invariant 8; Canvas |
| P5-12 | L5 scoring engine | - | Capture: M1 (v0 stub), weights M8; learning post-Capture | Your answer (21 Sept, engine + score) |
| P5-13 | L5 scoring engine | - | Capture: M1 (v0 stub), weights M8; learning post-Capture | Canvas; Part 1 |
| P5-14 | L5 scoring engine | - | Capture: M1 (v0 stub), weights M8; learning post-Capture | Canvas; Your answer (18 Sept, controls) |
| P5-15 | L5 scoring engine | - | Capture: M1 (v0 stub), weights M8; learning post-Capture | Canvas |
| P5-16 | L6 tiers | - | Post-Capture; M1 shows segment | Your input (16 Sept) |
| P5-17 | L6 tiers | - | Post-Capture; M1 shows segment | Your input; Your mark (18 Sept) |
| P5-18 | L6 tiers | - | Post-Capture; M1 shows segment | Your input (15 Sept); Your answer (17 Sept) |
| P5-19 | L6 tiers | - | Post-Capture; M1 shows segment | Your input; Your answer (17 Sept) |
| P5-20 | L6 tiers | - | Post-Capture; M1 shows segment | Your input (no cap); Your answer (21 Sept, fold) |
| P5-21 | L6 tiers | - | Post-Capture; M1 shows segment | Your answer (21 Sept) |
| P5-22 | L4 territory; L7 routing | - | Capture: M3 routing; pool post-Capture | Your input; Your answer (17 Sept) |
| P5-23 | L4 territory; L7 routing | - | Capture: M3 routing; pool post-Capture | Your answer (18 Sept) |
| P5-24 | L4 territory; L7 routing | - | Capture: M3 routing; pool post-Capture | Your answers (21 Sept) |
| P5-25 | L4 territory; L7 routing | - | Capture: M3 routing; pool post-Capture | Your answer (21 Sept, adjustments and franchise list) |
| P5-26 | L4 territory; L7 routing | - | Capture: M3 routing; pool post-Capture | Approved with Part 3 |
| P5-27 | L7 SLA clock | - | Post-Capture | Your mark (18 Sept) |
| P5-28 | L7 SLA clock | - | Post-Capture | Canvas; Your mark (18 Sept); Your answer (21 Sept, campaign clock) |
| P5-29 | L7 SLA clock | - | Post-Capture | Your answers (17, 18 Sept) |
| P5-30 | L7 SLA clock | - | Post-Capture | Your answer (21 Sept, calendar) |
| P5-31 | L7 SLA clock | - | Post-Capture | Canvas; Your mark (18 Sept) |
| P5-32 | L5 continuous learning | - | Post-Capture | Canvas |
| P5-33 | L5 continuous learning | - | Post-Capture | Canvas (model lift) |
| P5-34 | L5 continuous learning | - | Post-Capture | Your answer (21 Sept, engine + score); Canvas (no silent self-retuning) |
| P5-35 | L5 continuous learning | - | Post-Capture | Your answer (21 Sept, unsure intent) |
| P6-1 | Z00 data platform | - | Capture: M1, M3 | Canvas (one data platform); Audit lesson (§7.12, §7.22) |
| P6-2 | Z00 data platform | - | Capture: M1, M3 | Audit keeper (healthy is affirmative) |
| P6-3 | Z00 data platform | - | Capture: M1, M3 | Canvas (PII tagged); Audit lesson (§7.4) |
| P6-4 | Z00 data platform | - | Capture: M1, M3 | Audit lesson (§7.13) |
| P6-5 | Z00 data platform | - | Capture: M1, M3 | Rule book (`CLAUDE.md`) |
| P6-6 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Canvas; Your input (15 Sept) |
| P6-7 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Your answer (17 Sept) |
| P6-8 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Your answer (17 Sept) |
| P6-9 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Your answer (21 Sept, volumes); Plan M8 (the burst) |
| P6-10 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Canvas; Your answers (18, 21 Sept) |
| P6-11 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Your answer (17 Sept, retention); Canvas |
| P6-12 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Your answer (21 Sept) |
| P6-13 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Your answer (21 Sept, season) |
| P6-14 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Your answer (21 Sept, receipts) |
| P6-15 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Canvas; Your answers (18 Sept) |
| P6-16 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Canvas (SSO where available); Your answer (21 Sept, keep SSO) |
| P6-17 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Your answer (21 Sept, operations) |
| P6-18 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Your input (15 Sept) |
| P6-19 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Audit keepers |
| P6-20 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Audit lesson (§7.11); Your answer (18 Sept, no PKR estimate) |
| P6-21 | Z00 platform & control | - | Capture: M8 (burst, offline, PII); login M0/M1 | Rule book (`CLAUDE.md`); Audit lesson (§7.21) |

### A.2 Records at field level

Types: text · number · whole number · money (PKR, stored as whole paisa, shown as
whole rupees) · date-time (stored UTC, shown Asia/Karachi) · date · yes/no ·
choice (fixed list) · reference (points at another record) · photo · position
(latitude, longitude). **PII** marks personal data (P6-3). **Req** = required.

**Grower** — id · name (text, PII, req) · mobile (text, PII, req, unique across growers; change history: old value, new value, who, when, undone-by) · province, district, tehsil, village (choice from the location list, PII) · position (PII, optional) · language (choice: ur, en) · new_or_existing (choice, set by SUL) · crops (list of choice) · acreage (list of: crop, acres number, status choice estimated/confirmed_sul/confirmed_hina, source reference, when) · last_season_status (choice: converted / not converted / unreachable / untouched / none) · last_activity (date-time) · anonymised_at (date-time, optional).

**Signal** — id · stream (choice: the ten in 4.2) · source_event_id (text, req; unique together with stream — INV-3, A4) · grower (reference, optional until matched) · occurred_at (date-time, req) · kind (choice: scan, message, post, form, call, purchase, campaign_response) · words (text, PII, optional) · crop, problem (choice/text) · severity, confidence (number, optional) · campaign (reference, optional) · raw (the original as received, unchanged) · held_reason (choice: none, no_number, campaign_unknown, invalid; text detail) · consent_basis: stream + occurred_at (derived; never null on a lead — INV-1, A6).

**Lead** — id · grower (reference, req) · signals (list of references) · crop · need · acreage_status (derived) · intent (choice: buy, advice, unclear; confidence number; source choice words/hina/sul) · stream (first signal's) · campaign (reference, optional) · segment (choice: hot, campaign, potential) · below_threshold (yes/no) · state (choice, the eight of P1-27; transitions only through one function — INV-5, A5) · state_history (who, when, from, to) · territory, sul (reference) · contact_clock, completion_clock (start, promise_at, stopped_at, overdue yes/no) · follow_up_date (date) · flags (list) · hina_attempts (list) · last_season_tag · rejection (reason choice, who, when, admin_action).

**Score** — lead (reference) · value (whole number 0–100) · weights_version (reference) · engine_version_hash (text, req — INV-8, A1) · contributions (list of ingredient, points) · adjustments (list of adjustment, points) · reasons (three, text, ur and en) · scored_at.

**Outcome** — lead · kind (choice: converted, not_converted, unreachable, below_threshold, rejected) · value (money, req for converted — INV-6) · product (reference, req for converted) · quantity (whole number, req for converted) · receipt (photo, PII, req for converted until POS) · reason (choice, req for not_converted; the five of P1-32) · comment (text) · closed_by (reference, req) · closed_at (date-time, req).

**Hina call** — lead · attempt (whole number 1–3) · at · outcome (choice: answered, no_answer, wrong_number, refused) · acreage, crop, intent returned · summary (text, PII) · no audio, no transcript.

**Flag** — from_user, to_user, lead · note (text) · due (date) · sent_at · actioned_at.

**Campaign** — id · name · kind (choice: brand, crop_programme) · portfolio (choice: insecticides, fungicides, herbicides, biologicals_seed_care) · brand or programme (text) · product (reference) · crop · starts, ends (date) · contact_promise, completion_promise (hours/days, req) · budget, spend (money; change history) · npi (yes/no) · campaign_id_convention (text, per D3).

**Product** — id · name · portfolio · brand · treats (list of crop, problem).

**Sales structure** — zone · region · territory · bsa · sul (reference; exactly one per territory) · change history. **Location** — province · district · tehsil · village · bsa. **Franchise** — name · position · range_km (number) · territory. **Timing** — crop · problem · months (list).

**User** — id · name · syngenta_email (text, unique, must be a Syngenta address; the login) · role (choice: sul, rsm, zm, head_of_sales, leadership, pm, marketing, admin) · scope (territory / region / zone / portfolio / all) · language · active.

**Settings** (each versioned: value, previous, who, when) — acreage_threshold (20) · contact_promise_hot (24 h), _potential (72 h) · completion_promise_hot (7 d), _potential (14 d) · weights (30/25/20/15/10) · age_decay_per_day (2), age_grace_hours (48), age_floor · reachability_penalty (15) · serviceability_penalty (10) · fold_size (20) · hina_attempts (3), hina_days (2) · season_start (date) · retention_seasons (2).

**Audit entry** — who · when · action (choice) · record (reference) · before, after (for settings) — append-only, never edited.

### A.3 Technical non-functionals

- Webhook streams acknowledge within 100 ms and hand the work to a queue; extraction, Hina hand-off, scoring and routing run in workers with retries and a dead-letter queue that is replayable and alerted (A3). P6-9's burst is a queue-depth number, not an outage.
- Idempotency is a unique constraint on (stream, source_event_id) at the write, not a check in code (A4, INV-3).
- Consent basis is a NOT NULL column derived from the signal (A6, INV-1). Every grower row carries it from the first migration.
- Scope is enforced in the query layer: one function reads leads for a user and applies the hierarchy filter; no screen queries leads any other way (A8, INV-7).
- Lifecycle transitions live in one function; states are an enum (A5, INV-5, INV-6).
- Scoring is a pure function `score(lead, weights, now) → {value, segment, reasons, engineVersion}` with no database, network or clock inside (A1, INV-8); a season can be replayed against a new weights version before it ships.
- Weights and every setting live in the database, versioned; the engine reads the active version (A10).
- PII columns are tagged in the schema; logs, exports and the warehouse redact by rule; a phone number never appears in a log line (A7, PROCESS §12).
- The SUL app is offline-first from its first screen: local store, an outbox of actions, sync on reconnect, server timestamp wins on the record, the officer's entry is kept in the history (A9).
- Money is integer paisa in storage, whole rupees on screen; time is UTC in storage, Asia/Karachi on screen (`CLAUDE.md`).
- Config from environment only, every variable documented in `.env.example` (`CLAUDE.md`; AR-19). No dead code, no swallowed errors (AR-14, AR-20).
- Residency: all grower data at rest in Pakistan (P6-12) — a Phase 3 hosting constraint.
- Login: Syngenta email address plus a Synapse password, registration restricted to the Syngenta email domain (P6-16); SSO deferred (6.3.2).
- Hina: an outbound integration (Synapse → third party: ordered lead batch with attempt limit) and an inbound one (third party → Synapse: structured answers per attempt, summary text); every inbound is idempotent on (lead, attempt); every call is an audit entry (P5-8).

### A.4 Keeper map — audit §9 behaviours, where each landed

| Keeper | Row(s) | Note |
|---|---|---|
| K1 Call and Navigate inline, each leaving a trace | P2-12, J2.2, J2.3, J2.6 | WhatsApp added |
| K2 Structured reason on non-conversion; proof photo on conversion | P1-30, P1-32, J3.2, J4.1 | Reasons are the canvas five (DR-1); receipt required until POS |
| K3 "Report this scan" with reason; admin-only removal | P1-35, P1-36, J11 | Four fixed reasons; Admin review list |
| K4 Honest reporting: incomplete-data banner, export off on partial read, About sheet, "as of" + count, unresolved rows counted | P3-8, P6-19, J20.5 | — |
| K5 Revenue stated as a floor with the unvalued count beside it | P3-8, P6-19 | Re-read: under INV-6 every conversion has a value; the "floor" idea survives as unresolved rows (unknown acreage, unmatched village) counted openly beside every total |
| K6 KPI definitions in one place; a sign-off page that reconciles them | P3-2 | — |
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

DR-1 to DR-8 in 1.9 · DR-9 to DR-14 in 2.7 · DR-15 to DR-18 in 3.7 · DR-19
to DR-22 in 4.8 · DR-23 to DR-28 in 5.11 · DR-29 to DR-31 in 6.6. Each
records the spec's position, the canvas's or the audit's, and why; none is
resolved in a row. The session 2.2 review reads this index first.

### A.7 Question log — index

Every question asked in session 2.1, its answer and date, is in the part it
belongs to (1.8, 2.6, 3.6, 4.7, 5.10, 6.5). Ahsan's words are verbatim in
`docs/notes/spec-input-2026-09-15.md`, `-16.md`, `-17.md`, `-18.md`.

### A.8 Audit §8 unknowns carried into this specification

| Audit §8 | Carried as |
|---|---|
| 8.6 Where the spreadsheets came from | Every stream "to confirm with the system owner" (P4-13); the M2 spike proves the first |
| 8.7 The intent behind Isabion Gold Campaign | Campaigns are records Marketing defines and Admin creates (P3-16); no campaign is named in the spec |
| 8.1–8.5, 8.8–8.11 | Base44-specific (sandbox isolation, run history, platform defaults, live data, build, `functionsVersion`, MCP consent page, deny rules, master currency); not specification questions |

### A.9 Quality and evidence rules the build inherits

`pnpm check` green on every PR; test run count non-zero; schema package 100% type coverage; scoring package 100% test coverage; every invariant-guarding test names the invariant; no real grower name or number anywhere; PR descriptions carry evidence (PROCESS.md §1, §11, §12).
