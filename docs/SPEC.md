# Synapse specification

Version: **v0.1 — Part 1 drafted, awaiting Ahsan's marks** · Owner: Ahsan ·
Task: SYN-9

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
| P1-30 | **Completed: converted** requires the PKR value and a **receipt photo** (required until point-of-sale integration exists), plus the new/existing mark. The closing SUL and date are recorded automatically. | The SUL cannot save "converted" without a value and a receipt; the record shows who closed it and when. | Your input (15 Sept); Invariant 6 | |
| P1-31 | Converted also records the **product**, **quantity** and **fulfilling franchise** where the SUL knows them. | Optional fields on the conversion screen; the card shows them when filled. | Canvas — not in your input; see DR-6 | |
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
| DR-6 | Conversion = PKR value + receipt (+ product, quantity, franchise if known) | Conversion = product, quantity, PKR, franchise, date, always | Canvas wanted a full sale record for the engine; the receipt gives evidence instead. |
| DR-7 | Eight stakeholders | Six dashboards | Head of Sales and Country Leadership exist and read the numbers. |
| DR-8 | Your 15 Sept note showed campaign leads under the threshold with their acreage; your 16 Sept note hides every under-threshold lead from SULs. The later note is followed (P1-15, P1-20). | — | Input versus input; mark P1-15 if campaign leads should be the exception. |

---

## Part 2 — The SUL's experience

*To be drafted after Part 1 is marked.* Modules, journeys and the rules that
hold on every SUL screen.

## Part 3 — Managers, leadership, marketing and admin

*To be drafted after Part 2 is marked.*

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
