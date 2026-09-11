# Synapse — product & architecture canvas (v2.0)

> **What this file is.** The single source of truth for *what Synapse is and how
> it is shaped*. Extracted from the Synapse System Canvas v2.0. An earlier
> long-form page titled "Synapse Architecture" is superseded and must not be
> used as a source.
>
> **Precedence.** `CLAUDE.md` and `docs/PROCESS.md` are the operative rules.
> This file is the architecture truth. Where they conflict, the rules win and
> the conflict gets reported.
>
> **How to read it.** Four zones, one direction of travel: Capture → Decide →
> Act → See, sitting on a Platform & control layer. Nine layers, L1–L9.

---

## The one-sentence product

Every channel where a grower shows commercial demand converges into one ranked,
explainable queue of scored leads, routed to the Sales Officer who owns that
beat, held to a clock, and closed with a captured PKR value that trains the
scoring engine.

**Primary user:** Sales Officer, in the field, offline-first, on a low-end
Android, in Urdu or a regional language.

**Scope:** 9 sources · 9 layers · 6 dashboards · 1 closed loop.

**Pilot:** Crop Doctor + WhatsApp + one NPI campaign, two zones, Engine v1
(rules-based scoring). The Pilot is the go-live subset. It is not the same as
**Capture**, the first build scope, which is all nine connectors plus Grower 360
(see `02-build-playbook.md` §Capture in milestones).

---

## Zone 01 — CAPTURE

*Every channel where a grower shows demand, normalised into one event and
resolved to one grower.*

### L1 · Sources — where a grower raises a hand

Nine inbound channels Syngenta Pakistan **already operates**. None is a new
investment; each produces demand signal today that dies where it lands.

**Architectural rule: every source is optional.** Synapse must run correctly
with three connected and six disconnected. No source is on another source's
critical path. This is what lets the Pilot ship in one crop season rather than
waiting for the slowest system owner.

Confidence flags: `[confirmed]` the capability publicly exists and the pattern
is standard · `[validate]` needs a session with the system owner · `[open]` a
question for review, not something to discover during build.

#### Family: Cropwise Grower

| Source | Method | Signals it carries | Feeds | Status |
|---|---|---|---|---|
| **Crop Doctor scans** | REST — Cropwise Open Platform | Crop, diagnosis, severity, confidence, geo, grower ID | Need severity (25) · product mapping · territory | `[validate]` confirm Pakistan tenant data scope + rate limits |
| **In-app community** | REST + LLM intent classification | Crop, problem described, intent language, engagement | Purchase intent (30) · need severity (25) | `[validate]` API access to community content |
| **Savera AI Agent** | REST + LLM extraction on transcripts | Diagnosis, product discussed, acreage if stated, buying questions | Intent (30) · severity (25) · acreage · product mapping | `[validate]` transcript access; consent-sensitive |

*Crop Doctor* is the highest-volume, highest-quality signal in the estate — but
it has the **weakest stated intent**: the grower asked for a diagnosis, not a
price. That is precisely why it usually lands High-Potential, not Hot.

*Savera AI Agent* is the richest single source: no other channel hands over
need, value and intent in one conversation. It is also the most
consent-sensitive, because the grower came for advice, not a sales call.

#### Family: Social & messaging

| Source | Method | Signals | Feeds | Status |
|---|---|---|---|---|
| **WhatsApp inbound** | WhatsApp Cloud API webhook via BSP + LLM intent | Message text, intent, verified number, opt-in status | Intent (30) · reachability modifier | `[confirmed]` advisory already live |
| **Facebook** | Meta Graph API webhook | Lead-form fields, DM intent, campaign + ad ID | Campaign attribution · intent (30) | `[confirmed]` standard pattern |
| **TikTok** | TikTok Ads lead-generation API / webhook | Lead-form fields, campaign ID | Campaign attribution · intent (30) | `[validate]` confirm lead-gen availability for the PK account |

WhatsApp is the lowest-friction high-intent channel available and the natural
Pilot source. It is also where the acreage callback runs, and where opt-in
status is cleanest — the grower messaged us first. Lead-form leads arrive
structured and shallow; DMs arrive unstructured and deep; both need the LLM
intent step, for different reasons.

#### Family: Voice

| Source | Method | Signals | Feeds | Status |
|---|---|---|---|---|
| **Call-centre capture** | Contact-centre platform API or batch export | Agent disposition, crop, acreage, stated intent | All five families, at high confidence | `[open]` depends which platform the centre runs |

Agent-captured data is far cleaner than any transcript. The trade-off is that it
depends on agent behaviour, so the capture form must be short enough to actually
get filled in.

#### Family: Campaigns

| Source | Method | Signals | Feeds | Status |
|---|---|---|---|---|
| **NPI campaigns** | Webhook + agreed campaign ID convention | Campaign, product, creative, landing action | Campaign tier · portfolio + marketing dashboards | `[open]` campaign stack + ID convention undefined |
| **Brand-specific campaigns** | Webhook + agreed campaign ID convention | Campaign, brand, creative, landing action | Campaign tier · portfolio + marketing dashboards | `[open]` same ID convention decision |

NPI is why the Campaign tier exists separately: an NPI lead is about a product
the field has never sold, so talk track, objection handling and success measure
are all different. NPI performance is also the number country leadership watches
hardest after a launch, and today nothing shows whether launch spend became
launch sales.

**The critical requirement here is not technical:** one campaign ID convention,
agreed once and enforced at ingestion. If the ID is lost anywhere between the ad
and the invoice, no marketing dashboard on the roadmap can be built, however
good the rest of the system is.

### L2 · Ingestion — the connector layer

Four pipe types plus one deliberate exclusion. Output is **one canonical Lead
Event schema**. Idempotent on source event ID. Failure mode is queue-and-retry,
never silent drop.

| Component | What it does | Notes |
|---|---|---|
| **REST API connectors** | Scheduled/on-demand pulls from systems holding structured records: Cropwise Open Platform, e-commerce, master data | Poll with a watermark per source · per-source credentials in the vault · rate-limit aware, queued retry · health surfaced in admin |
| **Webhook listeners** | Push endpoints for real-time channels: Meta and TikTok lead forms, WhatsApp Cloud API, campaign platforms | Lead visible in the SO app within minutes · idempotent on source event ID, deduped at write · signature verification per provider · dead-letter queue, replayable, alerted |
| **Intent extraction AI** | LLM extraction of crop, problem and intent strength from WhatsApp text, social comments and DMs, community posts, chat transcripts — Urdu, English, regional | Low-confidence extractions are flagged, not silently scored · **risk:** regional-language and transliterated-Urdu accuracy — test on real message samples early |
| **Batch sync** | Scheduled loads for slow-moving data: franchise order book, territory and user master, product and price master | Nightly for masters, weekly/on-change for trade · rejected rows reported, never silently dropped · needs a named data steward per master |

#### The MCP exclusion — read this before IT raises it

Two different jobs, deliberately separated:

- **Bulk, reliable, auditable ingestion** belongs to APIs, webhooks and batch
  sync. These are the pipes and they must be transactional.
- **MCP is how the AI layer reaches systems on demand:** the enrichment agent
  asking the campaign platform what a campaign ID means, the SO assistant asking
  Grower 360 for history, an analyst querying the warehouse in plain language.

Both belong in the architecture. But putting MCP in the lead path would make
lead delivery depend on a model call — exactly where a lead system must not have
a soft failure. **A dropped lead is a lost sale nobody ever sees.**

### L3 · Grower 360 — one grower, not three records

**The load-bearing layer.** A farmer who scans whitefly in Cropwise, asks about
a product in the community, and messages the brand page on Facebook is three
records in three systems — and three leads to three officers unless something
resolves them first.

Everything above this layer counts *signals*. Everything below it counts
*growers*. Without it, "consolidate in one place" means collect in one place,
which is not the same promise. **Get this wrong and every number above it is
wrong.**

| Component | Detail |
|---|---|
| **Identity resolution** | Golden key: verified mobile number. Secondary: name + village + crop (fuzzy); CNIC where available. Survivorship: most recent verified value wins, with source recorded. Every incoming signal either matches a grower or creates one — nothing enters unattached. |
| **Grower profile** | Crops grown, acreage per crop, farm geometry, district/tehsil/UC, preferred language, franchise affinity. Refreshed by every new signal plus the acreage cascade. Retention governed by consent basis, not kept indefinitely by default. |
| **Interaction history** | Every scan, message, call, campaign touch, purchase and prior lead outcome in one timeline. Feeds grower history (10) and duplicate suppression. Prevents the most damaging failure mode: calling the same grower three times in a week about three signals that were really one intention. |
| **Consent & reachability** | Consent basis, scope, timestamp, source, opt-out state. Applies to every channel — call, WhatsApp, SMS, in-app. Feeds the reachability modifier (−15). |

**The hard case** is shared and family numbers, which are common and will
corrupt counts if ignored. The app needs an explicit *split* action so an
officer can separate two growers behind one number.

---

## Zone 02 — DECIDE

*Make the signal decidable, score it against five weighted families, and place
it in a tier that carries a promise.*

### L4 · Enrichment — make the signal decidable

A raw signal cannot be scored. "Farmer photographed a leaf" becomes decidable
only once we know the disease, the acreage behind it, the product that treats
it, the window it must be applied in, and the officer who covers that geography.
**This is the layer most likely to be underestimated in effort.**

| Component | Detail |
|---|---|
| **Acreage cascade** | Three steps, cheapest first: (1) grower profile — already declared or previously resolved; (2) extracted from conversation text — Savera agent, WhatsApp, community; (3) automated WhatsApp callback, **maximum 2 attempts**. If all three fail the lead is still worked but scores zero on value and **is capped below Hot** — Hot is a promise about value as well as intent. |
| **Agronomic context** | Diagnosis severity, crop stage, whether the spray window is open now, district pest pressure this week. Inputs: Crop Doctor diagnosis, crop calendar, sowing date, weather. Agronomy team owns the severity and window tables. |
| **Product & value mapping** | Diagnosis → SKU → dose per acre → price → indicative order value. Depends on product and price master, synced nightly. Two consequences: the lead can be ranked by money rather than enthusiasm, and the officer opens the card already knowing what to recommend. |
| **Territory mapping** | Geo → beat → SO → region → zone, plus nearest serviceable franchise and its stock position. Produces the serviceability modifier (−10). **Fragility: territory master drift is the top cause of misrouted leads** — leads sent to an officer who left three months ago. |

### L5 · The AI Scoring Engine

0–100 composite from five weighted families, adjusted by four modifiers.
Weights sum to 100 and are **set by agronomy and sales leadership in the admin
console** — not hard-coded, not hidden.

At launch this is a **deterministic scorecard, not machine learning**, and
saying so plainly is what makes the roadmap credible. The scorecard's job is to
generate the labelled outcomes a real model needs, and it stays live afterwards
as the explanation layer and the fallback.

#### The five signal families

| Weight | Family | What it measures | Read from | Scale |
|---:|---|---|---|---|
| **30** | Purchase intent | How explicitly the grower asked to buy | Message/comment text, call transcripts, lead forms, cart events; LLM classification with a confidence score | Passive scan → problem question → product question → price/purchase question |
| **25** | Need severity | How badly the crop needs intervention now | Crop Doctor diagnosis + confidence, agronomist notes, regional alerts | Preventive → confirmed early → active and spreading |
| **20** | Opportunity value | acreage × dose per acre × price for the recommended SKU | Acreage cascade + product/price master | Missing acreage scores **zero** here; the card marks value unknown rather than implying a number nobody can stand behind |
| **15** | Agronomic timing | Is the application window open? | Crop calendar, sowing date, weather, spray-window model | Window closed → opens soon → in window now |
| **10** | Grower history | Past purchases, loyalty scans, recency, prior lead outcomes | Grower 360 history, franchise purchase records | New → active app user → previous buyer |

**Why intent is heaviest:** it most reliably predicts a sale, *and* it decides
tier — without stated intent a lead cannot be Hot however high it scores.

**Why history is lightest, deliberately:** a first-time grower with a severe
problem on forty acres should outrank a loyal customer browsing out of season.
History breaks ties; it must not decide the queue, or the system quietly stops
finding new customers.

**Why timing matters:** it stops the queue filling with technically strong leads
nobody can act on. This is the family most often missing from lead scoring built
by people outside agriculture.

#### The four modifiers

Applied *after* the weighted sum, because they describe whether a lead is
**workable** rather than how attractive it is.

| Modifier | Effect |
|---|---|
| Recency decay | −2 per day after the first 48 hours. A three-week-old "what should I spray" is not a hot lead, and a queue that pretends otherwise loses the field in week one. |
| Reachability | −15 where there is no valid contact number or no opt-in |
| Serviceability | −10 where no franchise is in serviceable range. Demand we cannot fulfil is a distribution insight for the trade team, not a field task. |
| Duplicate suppression | Repeat signals **merge into** the existing lead and raise its score — they never create a second task |

#### Explainability — not a nice-to-have

Every score, rules-based or model-driven, ships with its **top three
contributing factors** in plain language on the lead card, in the officer's own
language, and on every dashboard drill-down.

An officer who cannot see why a lead is Hot stops trusting the ranking, and a
ranking the field does not trust is a very expensive list. It is also what makes
the weights *discussable* with sales leadership rather than imposed on them.

#### Model maturity

| Engine | What it is | When |
|---|---|---|
| **v1 — Rules** | Deterministic scorecard, weights set by agronomy and sales. No training data required, live day one, fully explainable. Real job: generating the labelled outcomes everything after depends on. | Months 0–4 |
| **v2 — Supervised** | Gradient-boosted model on officer dispositions and captured conversion value, predicting P(conversion) × expected value. Realistically needs one full season of closed outcomes before it beats the scorecard. | Months 4–9 |
| **v3 — Optimisation** | Per-brand uplift, next-best-product on the lead card, channel choice. | Months 9–18 |

**Guardrail: the scorecard is never switched off.** It is the fallback and the
explanation layer.

#### Continuous learning

Every closed lead — converted, lost with a reason, or unreachable — is written
back as a labelled example. The engine learns **which kinds of grower actually
convert**: which crops, acreage bands, districts, originating channel, prior
purchase history, and how quickly they were contacted.

Segment-level lift is monitored continuously, so if cotton growers over forty
acres from WhatsApp start converting at three times the queue average, the
engine sees it within weeks rather than at season end. Proposed weight
adjustments surface in the admin console for approval.

**Guardrail: no silent self-retuning.** The engine recommends, a human confirms,
every change is versioned and reversible.

### L6 · Tiers — each one a promise

A tier is not a label. It is a service-level commitment the field has to keep
and a manager can be measured on. That is the only reason a ranked queue changes
behaviour.

| Tier | Rule | Promise | Notes |
|---|---|---|---|
| **Hot** | Score ≥70 **AND** stated intent **AND** acreage known | Contact within 24h | All three conditions required. A 90-scoring lead where the grower never said they wanted to buy is a selling conversation, not an order to take — calling it Hot would teach the field the label means nothing. On breach: escalates to RSM, reassigned within 24h. |
| **High-Potential** | Score 45–69, or ≥70 without stated intent / known acreage | Contact within 72h | The largest tier and where field skill matters most. Talk track is different by design: agronomic advice first, product second. Resolving acreage or capturing intent can promote it to Hot. |
| **Campaign** | Carries an NPI or brand campaign ID; scored on the same 0–100 scale | The campaign's own SLA and script | Exists for attribution as much as prioritisation. Requires the one campaign ID convention, enforced at ingestion. |
| **Nurture** | Score below 45 | Automated content only — **no field task at all** | Not in the original sketch, and it is what makes the other three credible. If the queue includes everything, officers work it top-down until they run out of day and the ranking stops mattering. Any new signal re-scores and can promote it. |

---

## Zone 03 — ACT

*Put the right lead in the right officer's hand, hold a clock over it, and
capture what the sale was actually worth.*

### L7 · Routing & SLA

| Component | Detail |
|---|---|
| **Territory assignment** | Geo → beat → Sales Officer. Unmapped geography goes to the region pool. **Conflict rule to agree before build:** the officer owns the relationship, the franchise owns fulfilment, and both appear on the lead card. Without a stated rule this becomes a channel conflict in month one. |
| **Load balancing** | Daily lead cap per officer, configurable in admin; overflow to the region pool, visible to the RSM. Hot fills the cap before High-Potential. **The failure mode of a scoring engine that works** is dumping four hundred leads on one officer in week one — that officer stops opening the app and the pilot is over before the model has seen a single conversion. |
| **SLA clock & escalation** | Hot 24h · High-Potential 72h · Campaign per campaign. Breach visible to RSM, reassigned within 24h. This is the mechanism that converts a good score into a contacted grower; without it the queue is just a better-sorted list. **SLA compliance is the Pilot headline metric** — the cheapest possible proof the system changed field behaviour. Measure compliance before linking anything to incentives. |
| **Nurture automation** | WhatsApp templates, SMS, in-app content matched to crop, stage and local pest pressure. Any response re-scores the grower immediately. Bound by the same consent and opt-out rules. |

### L8 · Sales Officer mobile app — the only screen where data is created

Every number in Zone 04 is a sum of what happens on this screen, which makes it
the most important surface in the system and the one most often designed last.

**Two non-negotiables:** it works offline, because rural connectivity is not a
design assumption you get to make in Pakistan; and every lead shows *why* it was
scored.

| Component | Detail |
|---|---|
| **Ranked queue** | Three tabs — Hot / High-Potential / Campaign — today-first, SLA countdown per lead. Bounded by the daily cap so it is a **finishable** list. Sorted by score within tier, urgency-adjusted. |
| **Lead card** | Grower, crop, diagnosis, acreage, history, nearest franchise. Explains the top three scoring factors in the officer's language. Recommends a SKU and indicative order value. Flags estimated vs confirmed acreage, and the consent basis. |
| **Act & log** | Click-to-call and WhatsApp from inside the lead; log contacted / visit planned / follow-up set / completed / converted / lost. **Design rule: two taps to log a normal outcome.** Logging must be faster than not logging, or officers do the work and skip the record — and every dashboard above becomes fiction. |
| **Offline-first sync** | Queue, cards, grower history and product data cached; all actions and outcome logs queued and replayed on reconnect. Conflict: server timestamp wins, **officer's entry never discarded**. Target device: low-end Android, limited storage. |

### L8 · Outcome — closing the lead honestly

Three terminal states, all three useful. A conversion trains the model on what
works; a coded loss on what does not; an unreachable lead tells us the contact
data or channel is wrong. *A system that only records wins produces a model that
has never seen a failure, and dashboards nobody believes.*

| State | Detail |
|---|---|
| **Converted** | SKU, quantity, PKR value, fulfilling franchise, date. **Pilot: self-declared by the officer.** Wave 2 would reconcile against franchise invoice. |
| **Lost** | **Mandatory reason code** — no need / no budget / no stock / competitor / wrong contact. Free text optional; the code is not. Losses are more informative than wins for a young model, and "no stock" repeated across a district is a supply-chain finding no other system would surface. |
| **Unreachable → nurture** | After two failed contact attempts. Returns to the pool, re-scored on the next signal. Unreachable is a fact about the contact data, not about the grower's interest. Also flags contact-data quality back to the source. |

### The closed loop

Every outcome and its PKR value returns to the scoring engine, which learns
which grower profiles actually convert and re-tunes against them. **This is the
single line that turns a lead list into a system that gets sharper every
season.**

---

## Zone 04 — SEE

*One dataset, six lenses.*

**The rule that keeps these honest:** every level sees the level below it
**named**, plus its own total. A zonal manager sees regions, not just a zone
number — otherwise the dashboard shows a problem without showing where it is.
**Never aggregate past the person or territory behind it.**

Marketing and sales read the same conversion events. That is the point: it is
the only way a campaign's ROI and an officer's performance can be discussed from
the same number.

| Dashboard | Grain | The question it answers in five seconds | Key view |
|---|---|---|---|
| **Sales Officer** | Own leads only | Who do I call next, and how am I doing this month? | Mobile, inside the SO app. *Caution: visible performance data changes behaviour — design it deliberately.* |
| **Regional Sales Manager** | Territory and SO, named | Which of my officers is letting leads go cold? | SLA breaches first, then conversion value by officer |
| **Zonal Manager** | Region, drillable to territory | Is this region short of *leads*, or short of *follow-up*? | Those need completely different interventions; the dashboard must separate them |
| **Portfolio Manager** | Own brands and campaigns | Did my campaign generate leads that actually converted? | Score distribution and converted value per campaign — a campaign generating 10,000 leads that all scored under 45 is a finding, not a success |
| **Marketing** | Brand, campaign, channel | Where should next season's spend go? | Cost per converted lead by channel. Exists only if the campaign ID survives from ad to invoice |
| **Master analytics** | National, all sources, all tiers | Is the funnel growing, and is the engine getting better? | **Model lift — top decile vs bottom decile conversion.** The only honest measure of whether the AI beats a simple list. Report monthly to leadership, including when unflattering |

---

## Zone 00 — PLATFORM & CONTROL

*Cuts across every layer. This is the half of the architecture IT, legal and
audit will actually ask about.*

| Component | Detail |
|---|---|
| **Admin console** | Users, roles, territories, scoring weights, SLA thresholds, connectors and their health, full audit trail. Every weight change audited with who and when. *Putting weights in the console rather than in code is a deliberate product decision: weights the business can change are weights the business will trust.* |
| **Data platform** | Event bus, lake (raw signal for model training), warehouse (serves dashboards), **semantic layer** so every dashboard counts a conversion the same way. The semantic layer is the unglamorous piece that prevents two teams presenting two numbers from the same system in the same meeting. |
| **Identity & access** | Role-based, hierarchy-aware, SSO where available. Sales scope: own level plus everything beneath it, named. Marketing scope: campaign and aggregate — **not grower contact details**. Access review surfaced in admin. |
| **Consent & data protection** | Consent basis, scope, timestamp, source, opt-out. Enforces opt-out across call, WhatsApp, SMS, in-app. Governs retention, residency, and what the model may train on. |
| **Audit & observability** | Access log, weight changes, lead reassignments. Connector health surfaced *before* anyone notices missing leads. Model monitoring: lift, drift, score distribution over time — a scoring engine tuned on cotton in Punjab in one season will quietly stop being right, and the only early warning is watching lift decay. |

---

## Open decisions — do NOT let the build assume an answer

| ID | Decision | Consequence until decided |
|---|---|---|
| **D1** | **Consent basis for advisory-captured data used for sales contact.** Data captured to help a farmer diagnose a crop was gathered for advisory; using it to route a sales call is a different purpose. Needs a leadership position, not a product assumption. Recommendation: explicit consent language at capture plus a register the admin console can prove from. | M6 stores Cropwise events but creates **no growers** from them |
| **D2** | Who owns Cropwise Open Platform access for the Pakistan tenant — global digital or country IT | Determines the M6 timeline; the request goes in during M0 |
| **D3** | Campaign ID convention | Decided and signed by marketing in M5, before the second campaign connector |
| **D4** | Mobile number as golden key, and the shared-number rule | Recommended yes; confirmed in M3 before identity resolution ships |
| **D5** | Syngenta's recommended stack | Overrides the default stack and nothing else. Handled in Phase 3 |
| **D6** | Territory vs franchise catchment conflict rule | Recommended: SO owns relationship, franchise owns fulfilment. Confirm before rollout |
| **D7** | Conversion value: declared or reconciled | Gates whether conversion value can ever be linked to officer incentives |

## Consequences already accepted — do not re-open, but keep visible

- **IVR was removed as a source.** Growers who use neither the app nor WhatsApp
  reach Synapse only through call-centre capture — which depends on agents
  filling in a form.
- **Franchise data was removed.** Conversion value is self-declared by the
  officer and there is no reconciled-against-invoice path. **Conversion value
  must not be linked to officer incentives until one exists.**
- **Farm mapping was removed.** The acreage cascade is profile → conversation
  text → WhatsApp callback, and nothing else.

## Caveat on the numbers

Integration confidence flags are assumptions made without access to Syngenta's
internal system inventory. Replace public Cropwise Pakistan figures with
internal numbers before circulating anything externally.
