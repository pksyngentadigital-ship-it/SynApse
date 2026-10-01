# SPEC.md — adversarial review, round 1

Date: 2026-09-29 · Task: SYN-11 · Document: `docs/SPEC.md` v0.9 (not edited by this review) · Brief: `docs/reviews/spec-r1-brief.md` · Plan: `docs/reviews/spec-r1-plan.md` · Working files: `docs/reviews/spec-r1-raw/` (seven raw lens reports, `merges.md`, `verdicts.md`, `STATE.md`)

**Lenses.** R1 Field · R2 Sales leadership · R3 Marketing · R4 Product · R5 Trust · R6 Build · R7 Open.

**Counts** (from the raw files and from the rows of `verdicts.md`, counted by script on 2026-09-29, not from memory):

- Findings raised: **208** (R1 23 · R2 24 · R3 17 · R4 16 · R5 26 · R6 67 · R7 35).
- Merged before the skeptic pass (same defect, same rows; `merges.md`): 19. Distinct claims, one skeptic each: **189**. (`merges.md`'s header says 20 merged and 188 claims; F-R6-38 was later un-merged and given its own skeptic, so the figures are 19 and 189.)
- Skeptic verdicts: **136 survived**, **53 refuted**. Counting the merged findings with their canonical: 150 of the 208 raised findings survive and 58 are refuted.
- Surviving claims by filed severity: 4 blocker · 100 major · 32 minor.
- After deduplicating surviving claims on the same defect: **126 entries** (4 blocker · 92 major · 30 minor). Eight entries combine two or three surviving claims; each keeps every lens.

**Which model judged what.**

| Work | Model |
|---|---|
| Attack plan, seven lens reviews, merge list | Fable 5.1 session (the lens-reviewer agent is pinned to an Opus-class model in `.claude/agents/lens-reviewer.md`) |
| Skeptics on every finding in R1 to R6, and on F-R7-2, 3, 5, 6, 7, 9, 11 | **Fable 5.1** |
| Skeptics on F-R7-12 to F-R7-34 (23 findings: 13 survived, 10 refuted) | **Opus 5.5** |
| This write-up | Opus 5.5 |

Process note: PROCESS.md §8 assigns document-review skeptics to the strongest model. Running the last 23 on Opus 5.5 was Ahsan's decision after usage limits stopped the run four times. Each entry below names the model of its skeptic.

**Triage.** Every TRIAGE line below carries Ahsan's decision, copied from `docs/reviews/spec-r1-raw/triage.md` (collected 30 Sept to 1 Oct; the record of his words). Applied in SPEC.md v1.0.

**How to read an entry.** Rows, the quoted line, the consequence and the proposed fix come from the raw lens report. Where the skeptic showed a raw sentence to be false, that sentence has been replaced and the change is stated under "Changed from the raw report". Severity is as filed; where the skeptic questioned it, both views are given. Proposed fixes are the reviewer's drafts, not decisions; several need Ahsan's call and say so.

Contents: 1 Surviving findings · 2 Narrower claims from refuted findings · 3 Refuted, and why · 4 Coverage · 5 Requirements with zero findings · 6 D1–D9 touched · 7 Top 5 by severity

---

## 1. Surviving findings

Ordered blocker → major → minor, then by lens. `S`-numbers are for triage only; the finding IDs trace to the raw files.

### Blockers (4)

#### S1 · F-R2-1 · BLOCKER · R2 Sales leadership
**Claim.** A dial counts as contact, so the contact on-time rate measures dialling (S11)

**Rows.** J2.2, J2.3, J2.4, P1-28, P1-39, P5-27, P1-43, P5-31, 5.3 Reachability

**Quoted.** J2.2 "Taps Call | The phone dials; the lead moves to Contacted; the call is in the history with time; the contact clock stops"  
Second line: J2.4 "Taps "No answer": one failed attempt logged; the lead stays where it was"

**Consequence.** When the SUL taps "No answer", J2.2 has already moved the lead to Contacted and stopped the contact clock. So "stays where it was" means it stays Contacted. An SUL who dials every lead at 07:00 and hangs up scores 100% "contacted on time". The spec knows the difference between trying and reaching. The Reachability adjustment counts only "no Hina or SUL contact that reached the grower", but the clock does not use that difference. J2.4's "stays where it was" reads consistently as "stays Contacted", so there is one behaviour, and it is the wrong one: no row ties Contacted or the contact clock to a contact that reached the grower.

**Proposed fix (reviewer's).** P1-28 (rewrite): "A call or WhatsApp from inside the lead logs an attempt. The lead moves to Contacted, and the contact clock stops, only when the SUL marks the attempt 'Reached'. 'No answer' leaves the state and both clocks unchanged. The contact on-time rate counts reached contacts only."

**Decision check.** none. The 2026-09-15 clock decision ("stops at the first contact") does not say whether an unanswered dial is a contact.

**Skeptic (Fable 5.1).** Survived. No row ties the contact clock or Contacted to a contact that reached the grower; J2.2 fires on the dial; the reached/attempted distinction exists only for scoring (5.3).

**Skeptic's caveats.** "contradiction" label could be "absent rule"; J2.4 reads consistently as "stays Contacted"

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Label: "absent rule" fits better than "contradiction". The raw "two behaviours" sentence is replaced because J2.4 reads consistently. The blocker grading stands.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Reached only: Contacted and the contact clock stop only when the SUL marks "Reached"; the rate counts reached contacts

#### S2 · F-R5-12 · BLOCKER · R5 Trust
**Claim.** The SUL's personal phone holds the whole territory offline with no encryption, app lock, screenshot rule or lost-phone procedure

**Rows.** 2.1, P2-8, P6-6, J9.1, J13.5, P3-3, J14.3, P2-10

**Quoted.** 2.1 "One app on the SUL's own Android phone."  
Second line: P2-8 "The app works fully offline: reads and writes. Everything in the territory is on the phone"

**Consequence.** Named scenario: an SUL's phone is lost on a bus. It holds every grower name, number, village and position in the territory, plus the photo outbox, with no requirement for:
- encryption at rest;
- an app PIN or biometric lock;
- remote wipe;
- a way for anyone to report the loss.

The same applies to RSM phones opening full cards with numbers (J14.3). Views are logged, but nothing blocks screenshots or screen recording. The data then sits outside Synapse's control and residency.

**Proposed fix (reviewer's).** New row P6-6a: "The offline store is encrypted at rest. The app opens only after a device PIN or biometric check. Screens showing a grower's name, number or receipt block screenshots and screen recording. Admin can revoke a device, which wipes Synapse's data at the next connection. An SUL reports a lost phone to Admin, who revokes it the same day, and the revocation is in the audit trail."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. P2-8/P6-6 mandate all territory PII on a personal phone; zero rule hits for encrypt, PIN, biometric, wipe, screenshot, revoke; 6.3.2 does not defer device security; plan R5-A3 commissioned it.

**Skeptic's caveats.** Severity and the P6-6a wording are the author's proposals

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Device rules go into SPEC as P6-6a

#### S3 · F-R5-13 · BLOCKER · R5 Trust · R7 Open
**Claim.** No offboarding path: nobody is named to deactivate a leaver, and nothing purges the phone, so a moved or departed SUL keeps out-of-scope data (INV-7)

**Rows.** P1-6, J21.1, P2-17, P6-16, A.2 User, P7-2, P6-4

**Quoted.** P2-17 "A change of territory by Admin changes what the SUL sees at the next sync, and the old leads are no longer on their phone."  
Second line: J21.1 "A new SUL joins | IT gives the login; Admin sets the role and assigns the territory; the SUL's phone shows that territory at the next sync"

**Consequence.** The spec only covers joining. A.2 User has "active" but no row says:
- who sets it (IT or Admin, P1-6);
- when (the leaving date or later);
- what it does to an offline phone.

A resigned SUL who never syncs again keeps the territory's growers indefinitely, and so does a moved SUL whose phone stays offline. That breaks INV-7 ("A user never sees a lead outside their hierarchy scope"). With the password-only login (P6-16), the old account also stays valid unless someone happens to act.

**Proposed fix (reviewer's).** New step J21.1a and row P6-16a: "When a user leaves or changes role, Country IT tells Admin on the day. Admin deactivates the account, which ends every session at once. The app's local data expires if the phone has not synced for <n> hours and is wiped at the next connection. Every deactivation is in the audit trail."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. A.2 User has `active` with no row that sets it, names a trigger, owner, timing or session end; P2-17's purge is sync-conditional, so a phone that never syncs keeps the territory (INV-7); plan R5-A3 commissioned it (also covers merged F-R7-8).

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R7-8 (R7 Open, major) — No path for a user who leaves; the Synapse password outlives the corporate account.

**See also.** F-R5-21 (S52) is the periodic review that would catch what this misses; F-R5-12 (S2) is the device side.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Leaver path with phone-data expiry after N hours unsynced (Ahsan sets N)

#### S4 · F-R6-47 + F-R6-48 + F-R6-49 · BLOCKER · R6 Build
**Claim.** The lead state model is incomplete: states some leads need are missing, transitions the journeys use are not drawn, and a reassigned lead has no clock rule

**Rows.** 1.5 diagram, P1-27, P1-35, J21.6, P1-20, P5-1, P7-6, A.2 Lead.state, A.2 Outcome.kind, J2.4, J3.1, P1-33, P5-27, P5-31

**Why one entry.** One state model (1.5, P1-27, A.2 Lead.state, P5-27). The skeptics asked for F-R6-49 to land with F-R6-47; F-R6-48 is the transition half of the same table.

**Severity.** Filed as F-R6-47 blocker, F-R6-48 major, F-R6-49 major; the entry takes the highest.


##### F-R6-47 · blocker as filed · R6 Build — The state list lacks Rejected and every pre-routing state; Admin's re-entry transition is undefined (S10)

**Rows.** 1.5 diagram, P1-27, P1-35, J21.6, P1-20, P5-1, P7-6, A.2 Lead.state, A.2 Outcome.kind

**Quoted.** "1.5 | Any open state → Rejected (SUL, reason) → Admin review"  
Second line: "P1-27 | Eight states: **New** (routed, untouched), … **Closed: below threshold**. One way in to each; every move logged."

**Consequence.** A.2 fixes `state` to "the eight of P1-27", but three kinds of lead still need a state:
- **Rejected:** the diagram has this state, while A.2 records `rejected` only as an Outcome kind.
- **Pre-routing leads:** held for Hina (P5-1), in the pool (P7-6), and kept as below-threshold leads (P1-20). These exist before "New (routed)".
- **Admin's re-entry:** J21.6 "reassigns" or "merges" a rejected lead, but there is no transition for either.

A builder following A.2 cannot represent these leads without a hidden flag (AR-10) or an undefined transition. That breaks INV-5.

**Proposed fix (reviewer's).** P1-27 (replace): "Eleven states: Held (waiting for Hina or the pool), New … Closed: below threshold, Rejected. Admin's reassign moves Rejected → New for the new SUL; merge moves it to Closed: merged into <lead>." Update the 1.5 diagram and A.2.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. 1.5 draws Rejected as a state and forbids hidden flags; P1-27 and A.2 close the enum at eight without it and define New as already routed; held/pooled/rejected leads exist only as side fields, the very pattern AR-10 prohibits; no re-entry transition (INV-5).

**Skeptic's caveats.** For the below-threshold case the state exists and only the entry transition is missing, so check the "eleven states" count in the fix


##### F-R6-48 · major as filed · R6 Build — The 1.5 arrows contradict the journeys: converted from Visit planned, unreachable from New

**Rows.** 1.5 diagram, P1-27, J2.4, J3.1, P1-33

**Quoted.** "1.5 | New → Contacted → Visit planned → Follow-up → Completed: converted … → Closed: unreachable (after 3 failed attempts, reason)"  
Second line: "J2.4 | … Taps "No answer": one failed attempt logged; the lead stays where it was; after the third failed attempt the card offers "Close as unreachable""

**Consequence.** The diagram only lets Follow-up close, but J2.4 closes unreachable from New and J3.1 logs an outcome at the farm from Visit planned. "One way in to each" is also false for "Any open state → Closed: below threshold". A transition function (INV-5, A.3) built from the diagram rejects the journeys.

**Proposed fix (reviewer's).** Replace the 1.5 diagram with a transition table (from-state, action, to-state, who) that lists every move the journeys make; delete "One way in to each".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. The diagram hangs converted, not converted and unreachable off Follow-up only and reserves "Any open state" for two other rows; J3.3, J4.2 and J2.4 end leads from earlier states; A.2 routes every change through one function (INV-5).

**Skeptic's caveats.** "unreachable from New" is one reading (may be Contacted, seam S11); "one way in to each" is false or doubtful under either reading


##### F-R6-49 · major as filed · R6 Build — Clocks after Admin reassigns a rejected lead (S32)

**Rows.** P5-27, J21.6, P5-31, P1-35

**Quoted.** "P5-27 | Both clocks start when the lead reaches the SUL (routing, pool assignment, or handover from Hina). … Rejected stops both."  
Second line: "J21.6 | … Admin reassigns to a territory, merges with another lead, or removes with a logged reason"

**Consequence.** Admin reassignment is not among P5-27's clock starts. It is unclear whether the new SUL gets fresh clocks, resumed clocks, or none (a lead with no promise), and whether the lead re-enters P5-31's denominator, which excludes "rejected".

**Proposed fix (reviewer's).** P5-27 (append): "Admin's reassignment of a rejected lead starts both clocks afresh for the new SUL; the rejected episode stays out of the on-time denominator."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P5-27 enumerates clock starts without Admin reassignment and stops both on reject with no rule to restart; A.2 holds one start/stop per clock; every other entry path states its clock start.

**Skeptic's caveats.** Keep the clock rule here and the gaming angle under F-R2-3; land with F-R6-47 (state a reassigned lead re-enters); fix should also cover reassignment back to the same SUL


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Add the missing states and a transition table; a reassigned lead gets fresh clocks, rejected episode stays out of the rate

### Majors (92)

#### S5 · F-R1-1 · MAJOR · R1 Field
**Claim.** "Reaches the SUL" means routed on the server, so the clock runs while the lead is invisible on an offline phone

**Rows.** P1-39, P5-27, J1.1, J9.1, P4-3, P5-31

**Quoted.** P5-27 "Both clocks start when the lead reaches the SUL (routing, pool assignment, or handover from Hina)."  
Second line: J1.1 "Home with three segments and counts from last night's sync; "last updated 22:40""

**Consequence.** Scenario: the phone syncs Sunday 22:40 and the SUL leaves signal Monday 07:00 (J9.1). A WhatsApp price question with 30 acres of cotton has no gap, so it is routed Monday 09:00 (P5-1). The phone next syncs Monday 20:00. Under P5-27 contact is due Tuesday 09:00. If "reaches" means the phone received it, contact is due Tuesday 20:00. So the SUL gets 13 of the 24 hours. Every SUL who works out of signal in the daytime gets a lower on-time rate than one who sits in town, and the Pilot's headline number (P1-43) measures signal coverage, not follow-up. The rule itself is definite (a server event), so this shortfall is built in, not left to the builder.

**Proposed fix (reviewer's).** P5-27a: "A lead reaches the SUL when their phone first receives it. The lead records both the routing time and the delivery time, and both clocks start at delivery. The RSM sees leads routed but not yet delivered."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. Five rows fix the clock start at a server event (routing/assignment/handover) and nothing records or offsets phone delivery; offline-all-day is the spec's own designed case.

**Skeptic's caveats.** Drop the sentence "a builder has no rule for which timestamp starts the clock" — the rule is definite (server event); the consequence is deterministic

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). The rule is definite (a server event), so the shortfall is deterministic, not a builder's guess.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Phone time: clocks start on phone receipt and stop at the phone's logged time; a synced on-time action withdraws the breach notice; a server re-score never overrides an SUL outcome

#### S6 · F-R1-2 · MAJOR · R1 Field · R2 Sales leadership
**Claim.** A contact logged offline has no stop time, and managers get a breach notice for a call made on time

**Rows.** P1-39, P5-29, P5-31, J9.2, J3.4, J5.1, P2-8, P6-6

**Quoted.** P5-29 "Overdue on either clock: badge on the lead and summary; one notification each to the SUL, RSM and ZM per lead"  
Second line: J9.2 "Each is saved on the phone at once with "will send when online""

**Consequence.** Scenario: routed Monday 09:00. The SUL calls on voice (one bar, no data) Tuesday 08:30, and Contacted waits in the outbox. At Tuesday 09:01 the server sees no contact, marks the lead overdue and notifies the RSM and ZM. The phone syncs at 19:00. The spec does not say whether the clock stopped at 08:30 (phone time) or 19:00 (server receipt). If 08:30, managers were already told about a breach that never happened, and "one notification … per lead" gives no way to withdraw it. If 19:00, an honest on-time contact counts as late in P5-31. The two readings produce different on-time rates and different RSM behaviour.

**Proposed fix (reviewer's).** P5-27b: "An action logged offline stops its clock at the time it was logged on the phone. When a synced action shows a promise was met, the overdue mark and the managers' notification for that lead are withdrawn."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. No row names phone-logged vs server-received time for a clock stop; A.3 "server timestamp wins" is a conflict rule that makes the honest contact late; no withdrawal for P5-29 notifications.

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R2-19 (R2 Sales leadership, major) — Which timestamp stops a clock for an offline entry is not specified, so SULs can backdate by changing the phone's clock.

**See also.** F-R6-54 (S82) is the record-conflict half of the same offline sync rule; the clock-time half is here.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Phone time: clocks start on phone receipt and stop at the phone's logged time; a synced on-time action withdraws the breach notice; a server re-score never overrides an SUL outcome

#### S7 · F-R1-4 · MAJOR · R1 Field
**Claim.** Sunday-only pause guarantees breaches over Eid, and nothing can add a pause day

**Rows.** P5-30, P1-38, P5-29, P1-43, A.2 Settings

**Quoted.** P5-30 "Clocks count calendar hours and days but **pause on Sundays**; public holidays count."  
Second line: A.2 "**Settings** (each versioned: value, previous, who, when) — acreage_threshold (20) · contact_promise_hot (24 h), _potential (72 h) · …" (no pause-day setting)

**Consequence.** Scenario: Eid falls Wednesday to Friday. A Hot lead is routed Tuesday 19:00, so contact is due Wednesday 19:00, which is Eid day 1. Completion is due the next Wednesday 19:00, and three of its seven counted days are Eid. Each such lead either takes an Eid-day call or breaches, and the RSM and ZM are notified during Eid. The Eid week's on-time rate drops for a reason no SUL controls, and the dashboard cannot say why. Friday half-days also count in full. The pause is not a setting, so changing it takes a code change (compare AR-15).

**Proposed fix (reviewer's).** Revise P5-30: "Clocks pause on Sundays and on the dates Admin lists as pause days (for example Eid ul-Fitr and Eid ul-Adha); the list is an Admin setting and every change is logged."

**Decision check.** none (P5-30 is an R-marked answer, 5.10 Q13). What it leaves unspecified is multi-day religious holidays and how the pause is held.

**Skeptic (Fable 5.1).** Survived. P5-30 "Skip Sundays only" is a question-log answer, not D1–D9; no pause-day setting exists; the plan itself commissioned the Eid attack.

**Skeptic's caveats.** Label should read "present rule, absent setting"; the fix reverses an Ahsan answer, so it is a question for him

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Holiday list: Admin keeps yearly pause days that clocks also skip; working week defined once; changes logged (amends 5.10 Q13)

#### S8 · F-R1-5 · MAJOR · R1 Field · R6 Build
**Claim.** A manager's flag has no way to be answered or cleared, so flagged leads stay at the top for good

**Rows.** J1.3, J14.4, J5.2, P2-2, P5-20, 2.2 Act and log, A.2 Flag

**Quoted.** J14.4 "the flag and the SUL's response are in the lead's history"  
Second line: 2.2 Act and log "Call, WhatsApp, Navigate; log contact, visit planned, follow-up, converted, not converted, unreachable, reject; ask and log acreage; correct a grower's number"

**Consequence.** The SUL has no "respond to flag" action, and nothing says what sets the flag's "actioned_at" (A.2). Flagged leads sort above everything (P5-20 "flagged leads first"). Each flag an RSM sends pins a lead above due-today leads until the lead closes. After a few weeks of flags the top of every list is old flags, and the ranking the SUL relies on is gone.

**Proposed fix (reviewer's).** P2-23: "A flag is actioned when the SUL logs any state change on the lead after it, or taps "Reply" with one line. An actioned flag stops sorting the lead to the top and shows as answered to the manager."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P3-4/A.2 promise a response and actioned_at, but 2.2's SUL action list has no reply and nothing clears "flagged first" (P2-2, P5-20).

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R6-11 (R6 Build, major) — P3-4: "actioned" is undefined for a flag.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All SUL-app fixes, including the receipt duplicate check and RSM sampling

#### S9 · F-R1-8 · MAJOR · R1 Field · R6 Build
**Claim.** "Two taps" is false for follow-up and not converted as the journeys describe them, and "one tap" is false for reject

**Rows.** P2-3, J3.1, J4.1, J4.2, P2-21, P1-35, J11.1, J11.2

**Quoted.** P2-3 "Contacted, visit planned, follow-up, not converted: two taps each."  
Second line: J3.1 "Three choices: Converted · Not converted · Follow-up needed" (after "taps "Log outcome"")

**Consequence.** Tap counts. Follow-up is Log outcome, then Follow-up needed, then pick a date (P2-21 "a date the SUL sets"): at least 3. Not converted is Log outcome, Not converted, pick reason, confirm: 4 if the confirm counts as a tap, 3 if not. Even starting from J4.1's own "Taps "Not converted"" it is 3, yet J4.2 says "two taps in total". Reject: P1-35 says "vanishes … after one tap", but J11 is Not a valid lead, pick reason, confirm: 3. Contacted (J2.2, auto on Call) and Visit planned (J2.5) do meet two taps. A builder cannot meet P2-3 and the journeys at once, and a tester cannot pass either.

**Proposed fix (reviewer's).** Revise P2-3's example to state counts from the lead card: "Contacted: one tap; visit planned: two; follow-up: three (Follow-up, date, confirm); not converted: three (Not converted, reason, confirm)". Change P1-35's example to "vanishes from the SUL's list once the reason is picked".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. Under the spec's own J2.5 counting convention, not-converted and follow-up are three taps and reject at least two; P1-35 contradicts itself.

**Skeptic's caveats.** Exact counts (4, 3) depend on whether "confirms" is a tap

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Exact counts depend on whether "confirm" is a tap; the contradiction holds either way.

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R6-18 (R6 Build, minor) — P2-3 two-tap count contradicts the journeys it cites.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All SUL-app fixes, including the receipt duplicate check and RSM sampling

#### S10 · F-R1-11 · MAJOR · R1 Field
**Claim.** Overdue leads are not in the ranking, so they can fall below the fold on the SUL's list while at the top of the RSM's

**Rows.** P5-20, P2-2, P1-23, P1-40, P2-21, P6-18, J14.1

**Quoted.** P5-20 "Inside every segment: flagged leads first, then today's due leads (contact promise, completion promise or follow-up date today), then by score, then by age. The first **20** leads are on the list; the rest sit under "more leads", one tap away."

**Consequence.** A lead whose promise passed yesterday is not "due today", and neither is a missed follow-up ("follow-up missed", P2-21). Both drop back into score order. A low-scored Potential lead three days overdue sits below 20 others under "more leads". The RSM sees it first (J14.1 "overdue leads first"). The SUL's own list hides the one lead their manager is chasing.

**Proposed fix (reviewer's).** Revise P5-20: "flagged leads first, then overdue leads (oldest breach first), then today's due leads, then by score, then by age; no overdue or due-today lead is ever below the fold."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P5-20 has no overdue tier; P2-21 itself separates due-today (sorts up) from missed (badge only); age decay sinks overdue leads.

**See also.** F-R4-5 (R4, refuted) left the same narrower claim: P5-20's "today's due" tier excludes leads overdue since before today. It is carried here.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All SUL-app fixes, including the receipt duplicate check and RSM sampling

#### S11 · F-R1-16 · MAJOR · R1 Field
**Claim.** "Wrong contact" is both a not-converted reason and a reject reason, with different clock and rate effects

**Rows.** P1-32, P1-35, J4.1, J11.1, J8, P5-27, P5-31

**Quoted.** P1-32 "no need · no budget · no stock at the franchise · bought a competitor · wrong contact"  
Second line: P1-35 "not my territory · duplicate of another lead · internal or test entry · wrong contact details"

**Consequence.** An honest SUL who finds the number wrong has three instructions: change the number (J8), Not converted: wrong contact (the lead is completed and stays in the on-time denominator), or Reject: wrong contact details (both clocks stop and the lead leaves the denominator, P5-27 and P5-31). Different SULs will choose differently for the same fact, so per-source rejection counts (P1-35) and not-converted reasons will not compare across territories. Gaming is R2's; this is the honest divergence.

**Proposed fix (reviewer's).** P1-35a: "A wrong number is handled one way: Change number (J8) when the SUL has the right one; Reject: wrong contact details when they do not. "Wrong contact" on the not-converted list means the grower was reached but gave false details."

**Decision check.** touches D4. What it leaves unspecified is which path a wrong number takes.

**Skeptic (Fable 5.1).** Survived. "wrong contact" (P1-32) and "wrong contact details" (P1-35) are two live SUL actions with different clock and denominator effects; D4 covers only the SUL who knows the right number.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): One wrong-number path; Admin merge with a surviving record, logged and undoable; a typed number matching a grower with a different name or village held as a possible match; a written match rule; "verified" defined in one line; keeps D4

#### S12 · F-R1-17 · MAJOR · R1 Field · R5 Trust
**Claim.** Hina's "wrong number" and "refused" outcomes have no rule; the only named mark says "no answer"

**Rows.** P5-3, P5-5, P5-6, 5.3 Reachability, P7-6

**Quoted.** P5-3 "the outcome of each attempt (answered, no answer, wrong number, refused)"  
Second line: P5-6 "A lead Hina could not reach is routed anyway, with its gaps still open, marked "Hina: no answer after 3 attempts"; the SUL asks on the call."

**Consequence.** The spec does not say whether Hina stops after "wrong number" (or calls a stranger twice more), or whether "refused" ends her attempts. Whatever she does, the lead is then routed to the SUL, who calls the same wrong number, or a grower who refused, under a card whose only mark says "no answer" (the actual outcome is in the lead history, not on the card mark). The reachability adjustment only covers "never confirmed", not a number shown to be wrong.

**Proposed fix (reviewer's).** P5-6a: "A Hina "wrong number" ends her attempts and the lead is treated as having no number (P4-18, Admin's "no contact" list). A "refused" ends her attempts and the lead is routed marked "Grower refused Hina's call, <date>"."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. wrong_number and refused are legal A.2 outcomes but no row ends attempts, routes or marks them; P5-6's only mark is "no answer".

**Skeptic's caveats.** Outcomes are visible in lead history, not on the card mark

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats).

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R5-4 (R5 Trust, major) — Hina's "refused" outcome has no rule: she may call twice more, and the SUL is not told.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Hina "wrong number" ends her attempts and the lead goes to the no-contact list; "refused" ends her attempts and the lead routes marked "Grower refused Hina's call, <date>"

#### S13 · F-R1-18 · MAJOR · R1 Field
**Claim.** The call-centre form lacks name, location and a stated intent, so every call-centre lead is called again by Hina

**Rows.** P4-14, 4.2 Call centre, P1-14, P4-9, P5-1, P7-5, P7-6, A.2 Grower

**Quoted.** P4-14 "if it has no way out, agents get a short Synapse form (number, crop, acreage, what they asked)."  
Second line: P7-5 "A stream that gives none must give a complete address — village, tehsil, district — which Synapse converts to a coordinate"

**Consequence.** The form has no village, tehsil or district, so every form lead lacks a usable location. It goes to the pool or to Hina (P5-1 and P7-6), who asks what the agent could have asked in the same call. "What they asked" is free text read by AI (P4-9). A human agent who just heard "I want to buy" has no pick for it, so unsure readings also go to Hina. The form has no name either, although 4.2 lists "grower" in the agent's note and A.2 makes Grower "name (text, PII, req)". A grower who rang the call centre gets a second call from a machine asking the same things.

**Proposed fix (reviewer's).** Revise P4-14: "…a short Synapse form: number, grower's name, village, tehsil and district, crop, acreage, and intent as a pick (wants to buy / advice only) with what they asked."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P4-14's form has no address fields; P7-5 makes a complete address mandatory; P5-1/P7-6 then hold every such lead for Hina.

**Skeptic's caveats.** Applies to the P4-14 fallback form, not the platform feed

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Fuller call-centre form and an agent role. Ahsan's words: "call center is the part of DBO; and DBO team looks after it" — so the agent access sits with DBO (see S51) rather than as a separate stakeholder

#### S14 · F-R1-19 · MAJOR · R1 Field · R7 Open
**Claim.** The call-centre agent has no role or login, and never sees what became of the lead

**Rows.** P4-14, 1.2, P1-1, P6-16, A.2 User

**Quoted.** A.2 User "role (choice: sul, rsm, zm, head_of_sales, leadership, pm, marketing, admin)"  
Second line: P6-16 "Staff register and log in with their Syngenta email address and a Synapse password."

**Consequence.** If the M2 spike chooses the Synapse form, agents need to reach it. They are not one of the eight stakeholders, have no role, and may be outsourced staff without a Syngenta email. A builder must either leave the form unauthenticated (an open way to create leads) or invent a role the spec does not have. No row gives the agent a view of whether a lead was contacted or converted; this half rests on the persona brief, not a spec rule.

**Proposed fix (reviewer's).** P1-5a: "A call-centre agent has their own login and the role "call_centre"; they see only the capture form and the leads they captured, with each one's state; registration rules for non-Syngenta staff are named by Admin."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P4-14 names a Synapse screen for agents; A.2 User's closed role list and P6-16's Syngenta-email rule give the agent no role or login; the eight-personas decision predates the form fallback.

**Skeptic's caveats.** The "never sees the outcome" half rests on the persona brief, not a spec rule

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats).

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R7-10 (R7 Open, major) — The call-centre fallback form creates a ninth user with no role, scope or login.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Fuller call-centre form and an agent role. Ahsan's words: "call center is the part of DBO; and DBO team looks after it" — so the agent access sits with DBO (see S51) rather than as a separate stakeholder

#### S15 · F-R1-20 · MAJOR · R1 Field
**Claim.** Data strings on SUL screens have no language rule, and an Urdu search for a village may find nothing

**Rows.** P2-9, P6-7, P5-3, J12.1, J1.3, J14.4, J6.3, 4.5 Products, A.2 Location, A.2 Hina call

**Quoted.** P2-9 "Every label, reason list and notification in the chosen language."  
Second line: J12.1 "The SUL searches by name, number or village and opens the grower's profile and timeline"

**Consequence.** With the app in Urdu, these strings have no rule:
- Hina's summary (P5-3; A.2 holds one "summary (text)", and the example is in English).
- The RSM's flag note, written on English-only screens (P6-7, J14.4).
- Marketing's talk track (J6.3).
- Product and campaign names.
- Village names: A.2 Location holds one "village" text field in no stated script. An SUL typing a village in Urdu script against a Latin-script list gets no result, and the same for grower names.

**Proposed fix (reviewer's).** P2-9a: "Village and grower names are held and searchable in Urdu and Latin script. Hina returns her summary in Urdu and English. Flag notes, talk tracks, product and campaign names are shown as written, and the card marks them "as written"."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P2-9/P6-7 enumerate what is localised and what is "as sent"; Hina's summary, flag notes, names and the location list fall in neither; no cross-script search rule exists.

**Skeptic's caveats.** Product/campaign names are the weakest element; Hina summary language and name/village search script are load-bearing

**See also.** F-R6-15 (S111) keeps the length bound of Hina's summary; its language half is folded in here.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Cross-script name and village search; Hina summary in Urdu and English; flag notes, talk tracks, product names shown as written and marked

#### S16 · F-R1-23 · MAJOR · R1 Field
**Claim.** S23: the "Last season" tab is a list of growers to start the season in P1-17, but a list of this season's leads in P5-19

**Rows.** P1-17, P5-19, 2.2 Segment list, J12.2, P1-12, P1-26

**Quoted.** P1-17 "Inside Potential, a separate tab shows **last season's growers**: those converted last season and those never touched last season, so the SUL can start the season from known ground."  
Second line: P5-19 "Inside it, "Last season" holds this season's leads from growers converted or never touched last season."

**Consequence.** Under P1-17 the tab is a list of growers the SUL can act on before any signal. Those growers have no lead this season, so there is nothing to log against, no clock, and no lead holding this season's consent record (P1-12). The SUL cannot create one (J12.2). Under P5-19 the tab is empty at season start, which defeats "start the season from known ground". It also takes returning growers' due leads out of the "This season" tab, where the SUL looks first. Two builds, two different screens.

**Proposed fix (reviewer's).** Revise P1-17 to match P5-19: "Inside Potential, a "Last season" tab holds this season's leads from growers who converted or were never reached last season; it lists no grower without a lead this season (J12.2). Due leads in it also count on the Potential tile."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P1-17's purpose clause ("start the season from known ground") is only satisfiable by a proactive grower list; P5-19 makes the tab this season's leads; no precedence rule; the 17 Sept source note is ambiguous.

**Skeptic's caveats.** Fix direction is a question for Ahsan, not a copy-edit

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): The tab holds this season's leads from last-season growers (P1-17 matched to P5-19)

#### S17 · F-R2-2 · MAJOR · R2 Sales leadership
**Claim.** Three "No answer" taps in ten minutes close a lead as unreachable

**Rows.** P1-33, J2.4, P5-2, P5-6, P5-27, P1-34

**Quoted.** P1-33 "after three failed contact attempts, each logged, the SUL closes the lead with a reason from the dropdown."  
Second line: P5-2 "with what limit: **3 attempts over 2 days**, both Admin settings."

**Consequence.** Hina's three attempts fall inside a two-day window (a ceiling, not a minimum spacing). The SUL's three attempts have no spacing rule and no window. A lead Hina already failed to reach (P5-6) can be closed "unreachable" minutes after it arrives. That stops the completion clock (P5-27) and closes the lead (P1-34). No manager view counts unreachable closures per SUL. The "dropdown" reason list is not given anywhere in the spec.

**Proposed fix (reviewer's).** P1-33 (rewrite): "After three failed attempts on at least two different days, the first and last at least 24 hours apart (Admin settings, as for Hina, P5-2), the lead offers 'Close as unreachable' with the reasons: no answer · number switched off · number not in service. Unreachable closures per SUL show on the RSM's SUL view (J14.2)."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P1-33/J2.4 have no attempt spacing and no unreachable reason list (A.2 has reasons only for not_converted); no J14–J22 row counts unreachable closures per SUL.

**Skeptic's caveats.** Two overstatements: P5-2 is a ceiling window, not a minimum spacing; P1-34 closes the lead, not the grower

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Two overstatements removed: P5-2 is a ceiling window, not a minimum spacing; P1-34 closes the lead, not the grower.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All four closure and gaming fixes; Admin alone still sets settings

#### S18 · F-R2-3 · MAJOR · R2 Sales leadership
**Claim.** Rejecting a lead removes its breach from the on-time rate, and rejections are never counted per SUL

**Rows.** P1-35, J11.2, J21.6, P5-27, P5-31, J14.2, 6.1 Outcome

**Quoted.** P5-31 "Leads waiting for Hina, held, below threshold or rejected are not in the denominator."  
Second line: P1-35 "Rejections are counted per source."

**Consequence.** An SUL can tap "not my territory" on a lead that is already overdue. The lead leaves both denominators, so the breach disappears after the fact. The RSM's SUL view (J14.2) shows no rejections. Admin's list (J21.6) shows "reason and source", not who rejected it. If Admin finds the rejection was wrong, Admin can reassign the lead (J21.6), but no rule restores its due times or counts the miss. The spec records the rejecting SUL (6.1 Outcome "Rejected: reason, SUL, Admin's action"), but no view uses it.

**Proposed fix (reviewer's).** P5-31a: "A lead rejected after either of its promises has passed stays in the denominator as missed." P1-35a: "Rejections are also counted per SUL on the RSM's SUL view; a rejection Admin finds invalid returns the lead to that SUL with its original due times and counts as missed."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P5-31 excludes rejected leads with no time qualifier; 1.5 allows reject from any open state; J14.2 and J21.6 show no per-SUL rejection count although 6.1 Outcome records the SUL.

**Skeptic's caveats.** Trim "no action sends the lead back": Admin can reassign (J21.6), but no rule restores due times or counts the miss (overlaps F-R6-49)

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats).

**See also.** The state-model entry (S4) holds the clock rule for a reassigned lead (F-R6-49); the gaming angle stays here.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All four closure and gaming fixes; Admin alone still sets settings

#### S19 · F-R2-4 · MAJOR · R2 Sales leadership
**Claim.** Logging 12 acres closes the lead, may erase its breach, and drops the grower for good; nobody can undo it and no manager sees it

**Rows.** P1-22, J7.4, P4-20, P5-4, P5-31, J21.5, P2-19

**Quoted.** P1-22 "If it is below the threshold, the lead the SUL is working is **closed at once** (state "Closed: below threshold"), and that grower's later leads are not routed to the SUL."  
Second line: J21.5 "Every lead held back for known acreage under the threshold, by source and campaign; nothing to action, everything to count"

**Consequence.** An SUL holding an overdue lead with 30 acres confirmed by Hina can log 12 acres:
- The completion clock stops.
- P5-31's "below threshold … not in the denominator" can be read to erase the breach.
- The SUL's entry overwrites Hina's figure. P4-20 and P5-4 only protect confirmed acreage against *estimates*.
- The grower is never routed to any SUL again.
- J8.2 gives Admin an undo for a number change; no row gives one for acreage.
- J21.5 groups by source and campaign, not by SUL, and no RSM view shows these closures.

**Proposed fix (reviewer's).** P1-22a: "An SUL's entry that lowers a confirmed acreage across the threshold is shown to the RSM with the previous value and who confirmed it; Admin can undo it as for a number change (J8.2); a below-threshold closure after a promise passed counts as missed (P5-31); J21.5 shows the SUL who logged each closure."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P1-22 is unconditional; P4-20/P5-4 protect confirmed values against estimates only; undo exists only for number changes; no transition out of Closed; P3-12/J14 show below-threshold closures to no manager.

**Skeptic's caveats.** Mechanism does not need Hina; the state change is in the lead history, the gap is undo and manager visibility; denominator sub-point overlaps F-R2-3/F-R2-6

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All four closure and gaming fixes; Admin alone still sets settings

#### S20 · F-R2-5 · MAJOR · R2 Sales leadership
**Claim.** Any receipt photo is accepted and nobody is told to check it

**Rows.** P1-30, J3.2, P6-14, 3.5 D7, 1.7 D7

**Quoted.** J3.2 "Asks for, all required: PKR value, receipt photo (camera or gallery), product (pick-list), quantity"  
Second line: P6-14 "A receipt photo can be opened by the SUL who logged it and by everyone above them in the sales line up to Head of Sales; each opening is logged."

**Consequence.** Because the photo can come from the gallery, one receipt can be attached to many conversions. The PKR typed does not have to match the receipt. No row checks for duplicate images, samples conversions, or makes anyone responsible for comparing the photo with the value. Each such "Converted" stops the completion clock on time and adds PKR to every dashboard (3.5: "Every PKR figure on every dashboard is self-declared with a receipt"). Managers will manage on that PKR whether or not it is tied to pay.

**Proposed fix (reviewer's).** P1-30a: "Synapse refuses a receipt image already attached to another conversion." P6-14a: "Each week a random sample of conversions (Admin setting, starting 5%) lands on the RSM's list to check the receipt against value, product and quantity; the share checked and the share failed show beside PKR on every manager view until D7 is decided."

**Decision check.** touches D7. What D7 leaves unspecified: who checks a Pilot receipt against the declared value, and how often.

**Skeptic (Fable 5.1).** Survived. J3.2 permits gallery images; no duplicate-image rule, sampling or comparison anywhere; P6-14 logs openings but names no check; D7 leaves who checks unspecified and the plan names this attack.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All SUL-app fixes, including the receipt duplicate check and RSM sampling

#### S21 · F-R2-6 · MAJOR · R2 Sales leadership · R6 Build
**Claim.** The headline on-time rate has two denominators, "due" has three meanings, and the numerator's "completed" is undefined (S12)

**Rows.** P1-43, P5-31, P3-5, P3-2, P5-20, P2-21, P1-39, P5-27

**Quoted.** P1-43 "leads contacted within their contact promise ÷ leads due, and leads completed within their completion promise ÷ leads due."  
Second line: P5-31 "contacted within the contact promise ÷ leads that reached the SUL; completed within the completion promise ÷ leads that reached the SUL"

**Consequence.** Take a weekly view and a Potential lead routed on Monday. It is in P5-31's denominator ("reached the SUL") but not in P1-43's, because its 14-day promise does not fall due that week. The two rows produce different numbers for the headline figure.
- P5-20 defines "due" as "contact promise, completion promise or follow-up date today", and P2-21 says a follow-up date "counts as due". So an SUL who sets no follow-up dates shrinks the denominator.
- P1-39 stops the completion clock at "completed (converted or not converted) or closed". P5-31's numerator counts "completed". Whether Closed: unreachable is on time, missed, or excluded is not stated.
- This breaks P3-2, "One definition per number, everywhere".

**Proposed fix (reviewer's).** P5-31 (rewrite, the single definition): "For a period, the denominator is every lead that reached an SUL and whose promise ended in the period or whose clock stopped in it; the numerator is those whose clock stopped before the promise. Converted, not converted and Closed: unreachable stop the completion clock and count as completed; follow-up dates never enter the rate." P1-43 cites P5-31 and gives no formula of its own.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P1-43 "÷ leads due" and P5-31 "÷ leads that reached the SUL" are never reconciled; no definitions page exists despite P3-2; P5-27 stops the clock on Closed while P5-31 counts only "completed".

**Skeptic's caveats.** The follow-up-date sub-point holds only under P5-20's reading of "due"

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R6-29 (R6 Build, major) — On-time denominator: "leads due" versus "leads that reached the SUL".

**See also.** F-R2-1 (S1) decides what counts as contacted; F-R2-24 (S103) lists the views that drop the completion rate.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept (unparked 2026-10-01)): One formula in P5-31: of the leads whose deadline fell in the period or that were finished in it, the share finished on time; Closed: unreachable counts as finished; follow-up dates don't count; P1-43 points to it; J14.2, J16.1 and J22.1 add "completed on time"

#### S22 · F-R2-7 · MAJOR · R2 Sales leadership
**Claim.** The completion promises cannot be checked against the stated volume; the spec gives no Pilot headcount, and at plausible numbers only two-tap "no need" meets them

**Rows.** P1-38, P6-9, 1.1 Pilot, P1-32, P2-3, P2-21, P5-32, P5-34

**Quoted.** P6-9 "Up to 1,000 leads a day on a normal day. A campaign launch of 10,000 leads in twenty minutes loses nothing and slows nothing the SUL sees."  
Second line: P1-38 "**Completion:** Hot within 7 days, Campaign per campaign, Potential within 14 days."

**Consequence.** The spec never says how many SULs or territories the Pilot's two zones have. It also does not say whether 1,000 a day is national or Pilot volume. So nobody can test the promises.
- Named scenario, using the plan's persona (8 SULs per RSM, 3 regions per ZM): 2 × 3 × 8 = 48 SULs.
  - If all 1,000 leads were routed in the Pilot: 1,000 ÷ 48 ≈ 21 new leads per SUL per day, so about 21 completions per SUL per day just to stand still.
  - If half are below threshold: about 10 a day.
  - One campaign burst: 10,000 ÷ 48 ≈ 208 leads per SUL under one completion promise.
- On day 13, an SUL with 80 open scans dials each one (Contacted) and logs "Not converted: no need". That is two taps each (P2-3), 160 taps in total.
- P5-32 keeps every one as a real loss. After a season, P5-34 would propose lowering the Crop Doctor and crop-need weights, because the scans were never worked.
- No row separates "not worked" from "lost".

**Proposed fix (reviewer's).** P6-9a: "The Pilot's SUL count and expected routed leads per SUL per day are stated here; the completion promises are checked against them before go-live." P5-32a: "A not-converted outcome with no visit planned and no reached contact is kept as 'not worked', not as a loss, and never feeds P5-34; its share per SUL shows on the RSM's SUL view."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. No SUL/territory count, no Pilot/national scope on P6-9's 1,000 a day, and P5-32 labels every not-converted lead identically.

**Skeptic's caveats.** The 48-SUL arithmetic uses the plan's persona, not a spec number (stated as such)

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Pilot column in A.1 plus a Pilot section: zones named before M8, training, last sync to RSMs, exit and Wave 2 gate (no duplicate of Phase 9), D2 fallback, SUL headcount, "not live" zones; Ahsan marks Pilot rows Second half: Applied 2026-10-01 after the SYN-11 scope check: a not-converted lead with no reached contact and no visit planned is kept as "not worked", never feeds the engine's weight proposals, and its share per SUL shows on the RSM's SUL view (SPEC P5-32, J14.2)

#### S23 · F-R2-8 · MAJOR · R2 Sales leadership
**Claim.** No human path covers the open leads of an SUL on leave or who has resigned

**Rows.** P1-3, P1-29, P1-41, P3-4, P3-19, P7-2, P7-9, P7-11, P5-27, P5-30, J21.1, J21.6, 6.1 User

**Quoted.** P7-11 "Open leads stay with their SUL."  
Second line: P1-29 "Only the SUL who owns the lead, or Admin, can move it. Managers flag; they do not move." Also P1-3 "Every SUL owns exactly one territory and every territory has exactly one SUL".

**Consequence.** - Leave: SUL X in T-14 takes 14 days off with 60 open leads. Clocks pause on Sundays only (P5-30). Every Hot lead breaches within 24 hours, with a notification per lead to X, the RSM and the ZM (P5-29). The RSM can only flag X, who is away (P3-4). P1-3 forbids a second SUL covering T-14.
- No row lets Admin reassign an open lead that has not been rejected. J21.6 covers rejected leads only.
- Resignation: Admin sets X inactive (6.1 User "active or not"). T-14 becomes a gap (P7-2) and new leads go to the pool (P7-9). The 60 open leads "stay with their SUL", who can no longer log in. They breach, notify a deactivated user, and sit in the denominator for good.
- P5-27 does not say what the clocks do on any move.

**Proposed fix (reviewer's).** J21.9: "An SUL leaves or goes on leave: on the RSM's request, Admin moves that SUL's open leads to a named SUL; a covering SUL may hold a second territory until a set end date; every move is logged with who, why and when." P5-27a: "On a move, an uncontacted lead's contact clock restarts; the completion due time stays; breaches before the move stay with the first SUL." P1-3 gains "except for cover with an end date (J21.9)".

**Decision check.** none of D1–D9. The 2026-09-15 decision forbids automatic and rule-based reassignment. What it leaves unspecified: a deliberate, human move when the owner is absent or gone.

**Skeptic (Fable 5.1).** Survived. P3-19 affirmatively keeps open leads with an SUL even on an SUL-assignment change; deactivation is modelled with no consequence row; J21.6 reassigns rejected leads only; the 2026-09-15 decision forbids only automatic/rule-based reassignment.

**Skeptic's caveats.** The "covering SUL holds a second territory" clause of the fix bends P1-3/P7-2 and the 2026-09-28 decision

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Human moves only: Admin moves open leads on the RSM's request, logged; territory SUL optional; no-location lead goes to Hina first; bulk re-place after a bad boundary file; queues show oldest item and alert

#### S24 · F-R2-9 · MAJOR · R2 Sales leadership
**Claim.** Moving an SUL to another territory orphans their open leads (P2-17 vs P3-19 and P7-11) (S14)

**Rows.** P2-17, P3-19, P7-11, P5-26, J21.1, INV-7

**Quoted.** P2-17 "A change of territory by Admin changes what the SUL sees at the next sync, and the old leads are no longer on their phone."  
Second line: P3-19 "Admin's territory edits (zones, regions, territories, BSAs, SUL assignment) never change a grower's record; a boundary change re-routes future leads only. Open leads stay with the SUL who has them."

**Consequence.** P3-19 explicitly covers a change of SUL assignment and keeps open leads with the SUL. P2-17 takes those leads off the SUL's phone. Builder A keeps ownership with an SUL who can no longer see the leads: they are orphaned, clocks run and breaches accrue to that SUL. Builder B moves the leads with the territory, which is a reassignment no row allows, and the clocks for the new SUL are undefined.

**Proposed fix (reviewer's).** P2-17 (add): "When Admin moves an SUL to another territory, their open leads in the old territory pass to its next SUL (or the regional pool if none) as a logged move under J21.9; P3-19, P5-26 and P7-11 apply to boundary changes, not to a change of SUL."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. A.2 Lead carries `sul` and `territory` separately; P2-17 hides the old leads while P3-19/P7-11 keep the moved SUL as owner with clocks running; no Admin path moves a non-rejected lead.

**Skeptic's caveats.** The proposed automatic pass-to-next-SUL is rule-based reassignment and must be weighed against the 2026-09-15 decision

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Human moves only: Admin moves open leads on the RSM's request, logged; territory SUL optional; no-location lead goes to Hina first; bulk re-place after a bad boundary file; queues show oldest item and alert

#### S25 · F-R2-11 · MAJOR · R2 Sales leadership
**Claim.** A flag is defined as a flag on a lead, but Head of Sales, ZMs and PMs cannot see leads and flag territories

**Rows.** P3-4, P1-41, J16.3, J16.4, J17.2, J17.4, J19.3, 6.1 Flag, P5-29

**Quoted.** P3-4 "The **flag** is the one way a manager acts on a lead: a note and a due-by day, one level down only (Head of Sales → ZM → RSM → SUL; PM → ZM → RSM → SUL)."  
Second line: J16.3 "Territory-level numbers and the SUL's name; no grower names or numbers, no lead cards"

**Consequence.** Head of Sales (J17.2), the ZM (J16.3) and PMs (J19.4) cannot open a lead card. The ZM and Head of Sales do see leads in a list (J17.3) or a notification (P5-29), but no row lets a flag be raised from either. Yet 6.1's Flag record requires a "lead". The ZM is notified per breached lead (P5-29) and cannot open it. J19.3 flags about "a territory behind on a campaign". The spec does not say:
- what a territory flag is;
- when it counts as "actioned";
- whether "the ZM flags the RSM, the RSM the SUL" means one flag passed down or a chain of separate flags.
A builder must either expose leads (breaking P3-3 and DR-17) or invent a record.

**Proposed fix (reviewer's).** P3-4a: "A flag is on a lead (RSM → SUL) or on a territory or region (Head of Sales, ZM, PM → one level down). A lead flag is actioned at the SUL's next state change or note on that lead; a territory or region flag when its receiver replies or flags down. A flag passed down is a new flag linked to the one above, so the first sender sees each step." 6.1 Flag: "lead, territory or region".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. A.2 Flag's only object field is `lead`; J19.3 has the PM flag a territory; J16.3 gives the ZM no lead cards yet J16.4 flags; 1.2 says the ZM "flags a lead", widening the contradiction.

**Skeptic's caveats.** "cannot pick one" slightly overstated for ZM/Head of Sales (J17.3 list, P5-29 notification) but no row lets a flag be raised from either

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats).

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Flags on a lead (RSM → SUL) or on a territory or region (Head of Sales, ZM, PM → one level down); lead flag answered at the SUL's next action; territory flag when the receiver replies or flags down; flags passed down are linked

#### S26 · F-R2-12 · MAJOR · R2 Sales leadership · R3 Marketing
**Claim.** Managers have no target or reference, and "behind" is undefined in three rows

**Rows.** J14.1, J14.2, J16.1, J16.2, J17.1, J19.3, J22.1, P3-6, 1.2 (RSM, ZM, Head of Sales)

**Quoted.** J22.1 "and the one SUL or territory (or brand, for a PM) most behind"  
Second line: J16.2 "Sees Region B behind | Two numbers set apart: leads received per territory (supply) and the on-time rates (follow-up), so the ZM can tell which is short"

**Consequence.** No row defines a target, quota, expected rate, pipeline, forecast or comparator. "Behind" (J16.2, J19.3, J22.1) and "short" (J16.2, P3-6) are left to the builder: lowest on-time rate, lowest PKR, or most overdue? A weekly WhatsApp names one SUL on that invented basis. An RSM with no target on the screen will manage from an outside target sheet. Head of Sales reports a rate upward with nothing to read it against.

**Proposed fix (reviewer's).** P3-21: "Each clock has an on-time target (Admin setting agreed by Head of Sales; starting 80% contact, 60% completion) shown beside every on-time rate. 'Behind' is furthest below that target among units with at least 10 leads due (Admin setting). 'Short of leads' is leads received per territory below the zone median for the period. Synapse holds no sales volume target (listed in 6.3.2)."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. Zero hits for "target" or "quota" in the spec; J22.1 is machine-generated and must pick one unit on a rule no row gives; 6.3.2 does not park targets; D7 forbids incentive links, not comparators.

**Skeptic's caveats.** Fix must be scoped to manager views or it collides with P2-11 and Part 2 Q3

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R3-16 (R3 Marketing, major) — "Most behind" in the PM's weekly WhatsApp has no definition.

**See also.** F-R2-13 (refuted) left the narrower claim that J22.1 must say which number "most behind" uses and whether the named unit is an SUL or a territory; this entry's fix answers it.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, widened): Targets per the recommendation, with Ahsan's additions: Admin/DBO enter targets on Head of Sales' recommendation (he does not enter them); targets also for leads converted, sales value and leads followed up; Admin can change the target rules or disable any target parameter. "Behind" measured against targets on manager views only (P2-11 stands). Needs a DECISIONS entry at apply time; check the sales-value target against D7 (no PKR linked to incentives)

#### S27 · F-R2-14 · MAJOR · R2 Sales leadership
**Claim.** RSMs and ZMs get one push per breached lead per clock, round the clock, and nothing detects muting

**Rows.** P3-14, P5-29, P1-41, P1-42, J5.1, J5.4, J17.3

**Quoted.** P3-14 "RSM and ZM get one per breached lead; Head of Sales receives breaches as one daily digest at 8 am."  
Second line: J5.4 "Has not completed a Hot lead in 7 days | "Overdue: completion" badge and the same notifications"

**Consequence.** An RSM with 8 SULs and 40 overdue leads a day gets 40 pushes a day, or up to 80 because each lead can breach both clocks (J5.4). A ZM with three regions gets about 120 to 240 a day. Clocks count by the hour, so a Hot lead routed at 02:00 breaches at 02:00. A campaign burst (P6-9) makes breaches arrive together. Head of Sales was given a digest for exactly this reason; RSMs and ZMs were not. Android lets any user mute an app, and no row notices. The 2026-09-15 decision names visibility up the line as the pressure that replaces reassignment. Once muted, the per-lead push is gone and nobody is told; only the lagged aggregate views (J14.1, J16.1, P3-5) remain.

**Proposed fix (reviewer's).** P3-14 (rewrite): "RSM and ZM receive breaches as a digest at 08:00 and 14:00 (Admin settings) with counts by SUL, plus one push per breached Hot contact promise; no push between 21:00 and 07:00 Pakistan time; the manager above sees when each report last opened their breach list."

**Decision check.** none (the notify-only decision stands; its delivery is unspecified)

**Skeptic (Fable 5.1).** Survived. No row bounds volume, time of day or acknowledgement of RSM/ZM breach pushes; J17.3 shows the spec treats per-lead volume as a problem at Head of Sales scale only; Q10 is a question-log answer, not D1–D9.

**Skeptic's caveats.** "once muted nobody knows" overstated: J14.1/J16.1 and P3-5 keep a lagged aggregate view

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats).

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): RSM/ZM breach digest at 08:00 and 14:00 (Admin settings) with counts by SUL, a push only for a breached Hot contact promise, no pushes 21:00–07:00, the manager above sees when each report last opened the breach list

#### S28 · F-R2-15 · MAJOR · R2 Sales leadership · R6 Build
**Claim.** Raising the threshold gives an existing 22-acre Hot lead three possible fates, and nobody below Head of Sales is told (S24)

**Rows.** P1-19, P5-13, P5-14, P5-16, P2-19, P3-10, J17.5, J21.2, AR-26

**Quoted.** P1-19 "Admin changes 20 to 25; from then on Hot needs 25, and the audit trail shows who changed it and when."  
Second line: P5-13 "Re-scoring can move a lead up a segment; the SUL is told when it does." Third line: P2-19 "The SUL never sees a lead whose grower's known acreage is below the threshold"

**Consequence.** After the change, a Hot lead at 22 acres could:
- stay Hot, reading "from then on" as new leads only;
- drop silently to Potential at the next daily re-score (P5-13), because a move down is never announced;
- vanish from the SUL's phone, possibly after a visit was planned, as P2-19 and AR-26 require.
P5-14's "for new scores" does not list the threshold. Only Head of Sales is notified (P3-10, J21.2). SULs' Hot counts and managers' rates shift overnight with no note. Lowering 20 to 15 leaves open whether below-threshold leads are routed after the fact.

**Proposed fix (reviewer's).** P1-19a: "A threshold change applies to leads that reach an SUL after it; leads already routed keep their segment and promises; below-threshold leads are not routed retroactively. SULs, RSMs and ZMs are notified, and every rate spanning the date is marked 'threshold changed on …'."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P1-19, 1.5+INV-5 and P2-19 each imply a different fate for an already-routed lead on a threshold raise; P5-13 tells the SUL only on a move up; P5-14's "new scores" list omits the threshold; seam S24 was opened for this.

**Skeptic's caveats.** The fix's "routed leads keep their segment" collides with DECISIONS 2026-09-16 "never shown to any sales user" — Ahsan's call; notification strand overlaps F-R2-18

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R6-56 (R6 Build, major) — Threshold change: "for new scores" plus the daily re-score re-segments every lead within a day.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): New leads only; a move up restarts clocks under the new promise, a move down keeps earlier due times

#### S29 · F-R2-16 · MAJOR · R2 Sales leadership · R6 Build
**Claim.** No row says which promise applies after a lead changes segment, which gives SULs a reason not to confirm intent

**Rows.** P1-24, P5-13, J7.3, P4-9, P1-38, P5-27, P5-28

**Quoted.** P1-24 "Any new signal on an existing lead re-scores it and can move it up a segment."  
Second line: P5-27 "Both clocks start when the lead reaches the SUL (routing, pool assignment, or handover from Hina)."

**Consequence.** A Potential lead is routed Monday 09:00, with contact due Thursday 09:00. On Wednesday it becomes Hot (P1-24). Contact could now be due at Monday +24 hours (already breached, notifying the RSM and ZM at once), Wednesday +24 hours, or still Thursday. Completion could be 7 days or 14, from either date. If the Hot promise runs from routing, the SUL's own "wants to buy" tap (P4-9) can make a lead instantly overdue. The rational SUL stops confirming intent, which hollows out Hot and the examples P5-35 learns from.

**Proposed fix (reviewer's).** P5-27a: "When a lead moves up a segment, both clocks restart at the move under the new segment's promises; a move down keeps the earlier due times; the move and new due times are in the history."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. Every clock-start rule names routing, pool or Hina handover only; promises are keyed to segment; no row connects a segment move to a promise or start time, and P1-24's own example guarantees the move.

**Skeptic's caveats.** "a move down" in the fix is not described by the spec (fix text only)

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R6-57 (R6 Build, major) — A segment move does not say whether the lead's promises change.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): New leads only; a move up restarts clocks under the new promise, a move down keeps earlier due times

#### S30 · F-R2-17 · MAJOR · R2 Sales leadership
**Claim.** Marketing sets campaign promises that feed the sales force's single on-time rate, with no floor and no split by segment

**Rows.** J20.3, P3-16, P5-28, P3-10, P3-5, P1-38, 1.2 Head of Sales

**Quoted.** J20.3 "Gives Admin the name (brand-level or a crop programme), portfolio, brand or programme, product, crop, dates, its contact and completion promises, and budget; Admin creates it"  
Second line: P3-5 "Two on-time rates, contact and completion, contact first, at every level."

**Consequence.** A Marketing campaign with a 4-hour contact promise and 10,000 leads lowers every SUL's single headline rate. Nobody in the sales line agrees the promise; Head of Sales is only notified afterwards (P3-10). The rate is never split by segment, so an RSM cannot see that a campaign caused the drop.

**Proposed fix (reviewer's).** P5-28a: "A campaign's promises cannot be shorter than a floor (Admin setting agreed by Head of Sales; starting 24 hours and 7 days); every on-time rate can be split by segment, and campaigns with non-default promises are named beside it."

**Decision check.** none. 3.6 Q7 settles that Admin alone changes settings; this finding is about the missing floor and split, not the editor.

**Skeptic (Fable 5.1).** Survived. Marketing's promise is transcribed by Admin with no floor and no sales-side check; the on-time rate has no segment or campaign cut anywhere (P5-33 splits conversion, not on-time).

**Skeptic's caveats.** The fix's "agreed by Head of Sales" reintroduces a second approver against 3.6 Q7; reword

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All four closure and gaming fixes; Admin alone still sets settings

#### S31 · F-R2-20 · MAJOR · R2 Sales leadership
**Claim.** Walk-in sales make good SULs look idle, and routing walk-ins through WhatsApp inflates the numbers

**Rows.** J12.2, J14.2, J16.2, P3-6, J18.1, P5-33, P5-1, 6.3.2

**Quoted.** J12.2 "The SUL sells as today and the sale is not a Synapse lead."  
Second line: J14.2 "That SUL's numbers for the period (received, contacted on time, completed, converted, PKR, overdue now) and their three segment counts"

**Consequence.** An SUL who converts thirty walk-ins a month looks idle to the RSM. "Received" is supply the SUL does not control, yet it sits among the SUL's performance numbers. P3-6 separates supply only on ZM and Head of Sales views. The RSM's obvious instruction is "get your growers to message the Syngenta WhatsApp". The walk-in's message "price, 30 acres cotton" routes at once when it carries a usable location (P5-1, P7-6), is Hot, and is converted the same day with a receipt. Without a location the loop closes within two days via Hina, which a 24-hour window would partly miss. No row flags a conversion minutes after the first signal. Leadership's funnel (J18.1) and "engine beats a plain list" (P5-33) then count sales that would have happened anyway.

**Proposed fix (reviewer's).** J14.2a: "Conversions logged within 24 hours of the lead's first signal are counted separately as 'same-day conversions' on every manager and leadership view; J14.2 shows leads received apart from the SUL's performance numbers, labelled 'supply'."

**Decision check.** none (J12.2 stands; its consequence for manager views is unspecified)

**Skeptic (Fable 5.1).** Survived. J14.2 lists "received" among performance numbers; P3-6 separates supply on ZM/Head of Sales views only; every step of the WhatsApp walk-in loop is allowed row by row; no same-day or incrementality rule exists.

**Skeptic's caveats.** "routes at once" holds only with a usable location (P7-6); otherwise the loop closes within two days, which a 24 h window would partly miss

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats).

**TRIAGE:** ( ) accept  (x) reject — reason: Ahsan: "Synapse is not for managing SULs' own created leads; we may add this at a later stage." Listed in 6.3.2 as out of scope, returning on Ahsan's request  ( ) park — trigger:  
**Ahsan's decision** (out of scope (cleared 2026-10-01)): Ahsan: "Synapse is not for managing SULs' own created leads; we may add this at a later stage." Listed in 6.3.2 as out of scope, returning on Ahsan's request

#### S32 · F-R3-1 · MAJOR · R3 Marketing
**Claim.** A merged lead keeps one stream and one campaign, and nothing says which campaign or channel gets the credit

**Rows.** P1-8, P1-24, P4-4, P5-17, P5-9, P1-38, A.2 Lead, J20.1, P3-2

**Quoted.** A.2 Lead: "stream (first signal's) · campaign (reference, optional)"  
Second line: P1-24: "Any new signal on an existing lead re-scores it and can move it up a segment."

**Consequence.** Named scenario (synthetic grower G-1):
- Monday: G-1 scans in Crop Doctor. This makes a Potential lead with stream = Crop Doctor and no campaign.
- Wednesday: G-1 fills a Facebook form for campaign "Dhaan ki Shaan". P1-8 merges it into the same lead.
- Friday: G-1 replies to a Marketing WhatsApp campaign B. P5-9 says this is a campaign signal, and it merges again.
- The lead has one `campaign` field. No row says whether Wednesday's signal sets it, or whether Friday's overwrites it. So the conversion goes to Dhaan ki Shaan, to B, or to neither, depending on how the builder chose.
- J20.1 "by channel" credits a paid Facebook lead to Crop Doctor, because the stream is the first signal's.
- If a later campaign signal does attach, P5-17 ("whatever else is true") pulls a Hot lead out of Hot into Campaign. The campaign then claims a sale the grower was already making, and P1-38 does not say which promise now runs.
- P3-2's check ("Marketing's converted count for a campaign equals the sum of the RSMs' converted counts for it") cannot be defined.

**Proposed fix (reviewer's).** New row P1-8a: "A lead is attributed to the first campaign whose signal merged into it; every other campaign that touched it is listed on the lead as 'also touched by'. Marketing analytics counts the lead once, against the attributed campaign, and shows an 'also touched' count beside each campaign. A campaign lead's channel is the stream of the signal that carried its campaign, not the lead's first stream." (ASSUMPTION: first-touch recommended. It keeps the SUL's segment stable; Marketing may choose last-touch-before-contact.)

**Decision check.** touches D3. What it leaves unspecified is attribution when two campaigns reach one lead. D3 covers how a campaign is read, not which one wins.

**Skeptic (Fable 5.1).** Survived. A.2 Lead gives `stream` a derivation ("first signal's") and `campaign` none; P4-20's precedence rule scopes itself to name, village, acreage; D3 settles the identifier, not which campaign a merged lead reports under.

**Skeptic's caveats.** The two-campaign branch cannot arise in the single-campaign Pilot, but the non-campaign-first/campaign-second branch does; the "which promise" sub-point is R2/R6's

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, amended): Last campaign wins: the most recent campaign signal before first contact gets the credit (not the reviewer's first-touch); other campaigns listed as "also touched"; channel = the stream that carried the credited campaign

#### S33 · F-R3-5 · MAJOR · R3 Marketing
**Claim.** J6.3 shows a talk track that no record holds and no journey supplies

**Rows.** J6.3, P3-16, J20.3, J21.3, 6.1 Campaign, A.2 Campaign

**Quoted.** J6.3: "The lead card, with the campaign, its product and its talk track where Marketing supplied one"  
Second line: J20.3: "Gives Admin the name (brand-level or a crop programme), portfolio, brand or programme, product, crop, dates, its contact and completion promises, and budget; Admin creates it"

**Consequence.** A builder following P3-16 and A.2 builds no talk-track field, so J6.3 cannot pass. Marketing has no path to supply one, either on the definition (J20.3) or in Admin (J21.3).

**Proposed fix (reviewer's).** Add "talk track (text, ur and en, optional)" to P3-16, J20.3, J21.3, 6.1 Campaign and A.2 Campaign.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. "talk track" exists in J6.3 only; no record, journey or DR gives it a field or a supply path.

**Skeptic's caveats.** Severity fairly minor (J6.3 is conditional)

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Optional talk-track field on the campaign record, supplied when available

#### S34 · F-R3-6 · MAJOR · R3 Marketing
**Claim.** Leads of an ended campaign stay in the Campaign segment but vanish from the list of campaigns

**Rows.** J6.1, J19.1, J19.2, P5-17, P1-13, P3-16, A.2 Campaign, 1.1 design principle

**Quoted.** J6.1: "One entry per live campaign in the territory, with lead counts"  
Second line: P5-17: "**Campaign**: the lead carries a campaign → Campaign segment, whatever else is true;"

**Consequence.** - A campaign ends on 30 Oct and one of its leads is open, with its completion promise running.
- The lead counts in the Campaign tile (P1-13), but it sits under no campaign entry.
- J19.1 shows the PM "live campaigns" only, so the ended campaign's late conversions drop off the PM's first screen in the reporting period where they happen.
- No row says whether a form fill after `ends` still carries the campaign.

**Proposed fix (reviewer's).** J6.1 becomes "One entry per campaign with open leads in the territory, live or ended; ended ones marked 'ended'". J19.1 "live" becomes "live or with activity in the period". Add P3-16a: "A signal arriving after a campaign's end date still carries the campaign and is counted to it, labelled 'after end'."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. A.2 gives campaigns an `ends` date; clocks outlive it (P5-28, P1-34); "live" is undefined; no row places an ended campaign's open leads on any screen or settles post-`ends` attribution.

**Skeptic's caveats.** Evidence label better "undefined term plus absent rule"; the 1.1 "cap" point is stretched

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). The raw sentence tying this to 1.1's "never hides a lead behind a cap" is stretched and is dropped. Evidence label is better "undefined term ('live') plus absent rule".

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): SUL list shows every campaign with open leads (ended ones marked); PMs see campaigns live or active in the period; a signal after the end date still carries the campaign, labelled "after end"

#### S35 · F-R3-7 · MAJOR · R3 Marketing
**Claim.** "Campaign unknown" is a held reason in the records, but P4-11 says the lead still arrives

**Rows.** P4-11, A.2 Signal, 6.1 Signal, J21.4, 4.6 D3, 6.4 D3

**Quoted.** P4-11: "If the campaign cannot be read, the lead still arrives, marked "campaign unknown", and is listed for Admin."  
Second line: A.2 Signal: "held_reason (choice: none, no_number, campaign_unknown, invalid; text detail)"; 6.1 Signal: "whether it was held (no number, campaign unknown, invalid) and why"

**Consequence.** There are two behaviours, and each is written down. Under A.2, a campaign signal whose campaign cannot be read is held and never reaches an SUL. Under P4-11, it is routed. 6.4 D3 ("leads arrive 'campaign unknown' until then") covers every campaign lead before D3 is agreed in M5.

**Proposed fix (reviewer's).** Remove campaign_unknown from held_reason in A.2 and 6.1. Add to A.2 Signal a separate "campaign_status (choice: read, unknown)". A campaign-unknown signal is routed like any other.

**Decision check.** touches D3. What it leaves unspecified is whether an unread campaign holds the signal.

**Skeptic (Fable 5.1).** Survived. "Held" means "not routed until fixed" everywhere else (P4-5, P4-18, P5-7, P5-31); 6.1 and A.2 list campaign_unknown as a held reason while P4-11 and both D3 rows say it arrives; nothing reconciles them; 6.1 is body text, not skippable appendix.

**Skeptic's caveats.** "possibly blocker" overstated; major is right (three rows say arrives against two record descriptions)

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, reversed): Hold it: a campaign signal whose campaign cannot be read is held until it is read; P4-11 and the D3 rows change to match (the reviewer proposed routing). Consequence to note at apply time: until D3 is agreed in M5, the Pilot's campaign leads are held

#### S36 · F-R3-8 · MAJOR · R3 Marketing
**Claim.** Campaign-unknown leads are never re-attributed, and Marketing is never told how many there were

**Rows.** P4-11, P4-8, J21.3, J21.4, J20.1, P3-8, P6-19, 3.5 D3, 6.4 D3

**Quoted.** J21.3: "leads carrying that campaign appear under it from then on"  
Second line: P3-8: "unresolved rows (unmatched village, unknown acreage) counted openly, never hidden."

**Consequence.** - Leads that arrive "campaign unknown", before D3 or while a convention is misapplied, are routed as Hot or Potential with those promises. No row, and no Admin action in J21, attaches the campaign later, even though P4-8 keeps the raw signal that would allow it.
- The count appears only on Admin's Connections page ("3 leads with unknown campaign this week"). It is not in J20.1 and not in P3-8's list of unresolved rows.
- The campaign's leads, conversions and cost per lead are understated with no label, on the exact number Marketing defends.

**Proposed fix (reviewer's).** New row P4-11a: "When the convention can read a held raw signal (D3 agreed, or a mapping fixed), Admin re-reads the campaign-unknown signals of a stream in one action; each lead gains its campaign for reporting, keeps its segment and clocks, and the change is logged." Add "campaign unknown" to P3-8's unresolved rows. Show it on J20.1 per stream and period.

**Decision check.** touches D3. What it leaves unspecified is what happens to leads that arrived before it.

**Skeptic (Fable 5.1).** Survived. P4-11 routes (not holds) campaign-unknown leads so P4-5's "held signals flow through" does not reach them; J21.3 is forward-only; J20.1, P3-8 and P6-19 omit a campaign-unknown count.

**Skeptic's caveats.** A.2 Signal lists campaign_unknown as a held reason while P4-11 routes it (owned by F-R3-7)

**See also.** F-R6-58 (refuted) proposed a fix that conflicts with this one; put the choice to Ahsan once, here.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, reframed): After Ahsan's question (answered: "unknown" means the signal carries no readable campaign ID): Admin releases held campaign-unknown signals in one action once readable, each carrying its campaign; Marketing sees a count held per campaign stream

#### S37 · F-R3-9 · MAJOR · R3 Marketing
**Claim.** Cost per lead has no defined numerator period and no defined denominator

**Rows.** J20.2, J20.1, J20.4, P3-2, P3-7, P1-20, P4-18, P1-35, A.2 Campaign

**Quoted.** J20.2: "Cost per lead and cost per converted lead where spend was entered; "no spend entered" otherwise"  
Second line: J20.1: "Every campaign: leads (routed and below threshold, labelled), …"; P4-18: "counted in source and campaign totals as "no contact""

**Consequence.** - The denominator could be routed leads only, routed plus below-threshold, or also no-contact, rejected and campaign-unknown. Each choice gives a different cost per lead for the same campaign.
- Spend is one lifetime figure updated monthly (J20.4; A.2 "budget, spend (money; change history)"). "This week's" cost per lead (P3-7 presets) therefore divides a lifetime spend by one week's leads.
- Campaigns cannot be compared, and P3-2 cannot be met.

**Proposed fix (reviewer's).** New row P3-2b: "Cost per lead = the campaign's spend to date ÷ every lead attributed to it to date (routed, below threshold, no contact; rejected excluded), shown for the campaign's life, not for a period preset; cost per converted lead = the same spend ÷ its conversions to date. The definitions page states both."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. J20.2 gives no formula; J20.1, P4-18 and P1-35 offer three candidate lead sets; spend is one lifetime field (J20.4) against P3-7's per-period rule; the spec states formulas elsewhere (P5-31) but not here.

**Skeptic's caveats.** The fix's divisor and "lifetime not period" are Ahsan's choice

**TRIAGE:** ( ) accept  (x) reject — reason: Ahsan: "let's not manage cost per lead type things at this stage; we will do later if required." Cost per lead and cost per converted lead move out of J20.2/P3-16 into 6.3.2, returning when Ahsan asks; spend can still be entered on the campaign  ( ) park — trigger:  
**Ahsan's decision** (out of scope (cleared 2026-10-01)): Ahsan: "let's not manage cost per lead type things at this stage; we will do later if required." Cost per lead and cost per converted lead move out of J20.2/P3-16 into 6.3.2, returning when Ahsan asks; spend can still be entered on the campaign

#### S38 · F-R3-15 · MAJOR · R3 Marketing
**Claim.** Lead-form data is used for purposes the forms' own privacy notice must cover, and no row makes Marketing's forms say so

**Rows.** 4.2 Facebook, 4.2 TikTok, P4-23, P5-1, P5-8, 5.2

**Quoted.** 4.2 Facebook: "Filled a lead form on an ad, or messaged the page | Form fields, message intent, campaign and ad | … | Marketing (the ad account)"  
Second line: P5-1: "A lead that has a number and is missing acreage, crop, clear purchase intent or a usable location (Part 7, P7-6) is **held for Hina** before any SUL sees it."

**Consequence.** - A Facebook or TikTok form lead can be phoned by a third party's AI agent (Hina) and then by a field SUL.
- Meta's Lead Ads Terms require every lead form to link the advertiser's privacy policy, and the advertiser's use of the lead data to be consistent with it. TikTok's lead-generation instant forms also require a privacy-policy link.
- Nothing ties the Marketing-owned ad account's form notice to how Synapse uses the data. A mismatch is Marketing's exposure on the ad account, and no row says who checks it.

**Proposed fix (reviewer's).** New row P4-13a: "Before a Facebook or TikTok form stream is connected, Marketing confirms the form's linked privacy notice covers follow-up by Syngenta field staff and by an automated calling agent run by a third party; the stream stays 'not yet connected' until confirmed."

**Decision check.** touches D1. What it leaves unspecified is the platform's condition on form data; D1's basis is not argued.

**Skeptic (Fable 5.1).** Survived. No row mentions a privacy notice or platform terms; P4-13's "to confirm with the system owner" is a connection-proof step; D1 settles Synapse's recorded basis, not the ad form's notice; the plan commissioned this attack.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (legal action, no SPEC row): Record as a Syngenta Legal check that the Facebook and TikTok form privacy notices cover follow-up by staff and by Hina; not a SPEC row

#### S39 · F-R4-1 · MAJOR · R4 Product
**Claim.** The Pilot designates no sales-outcome measure and no baseline; its only success number is a process metric

**Rows.** P1-43, 1.1, 1.2 (Country Leadership), P5-31

**Quoted.** P1-43 "The **on-time rate** is the Pilot's headline number and appears on every manager's view, reported for both clocks with contact first"  
Second line: 1.1 "What the SUL logs — contacted, visited, converted with a PKR value, not converted with a reason — closes the loop"

**Consequence.** Conversions and PKR are displayed (J18.1, P5-33), but none is designated as a Pilot success measure, so at the end of the Pilot no agreed number says whether Synapse sold more. The spec never records a baseline: conversion of digital leads today (Smart Agro Lite), or PKR per SUL in the Pilot zones the season before. It sets no target for either. On-time rates can reach 90% while conversions stay flat, and the Wave 2 decision would then rest on a compliance number. In month 3 the Product Leader cannot say whether the product works or only whether SULs tap Call.

**Proposed fix (reviewer's).** New row P1-44: "The Pilot is judged on three numbers, each against a baseline taken in the two Pilot zones in the season before go-live and recorded in DECISIONS before go-live: the two on-time rates (P1-43), the conversion rate of routed leads, and converted PKR per SUL per month. The target for each is written beside its baseline."

**Decision check.** touches the 2026-09-15 clock decision ("The on-time rate … is the Pilot's headline number"). This finding keeps it as the headline. What the decision leaves unspecified is any outcome measure or baseline.

**Skeptic (Fable 5.1).** Survived. Only P1-43 names a Pilot success number; conversions/PKR are displayed (J18.1, P5-33) but never designated as a Pilot criterion, and no baseline or target exists in SPEC, DECISIONS or PLAN.

**Skeptic's caveats.** "no sales-outcome measure" overstates: outcomes are measured, not designated; the gap is inherited from the canvas

**Changed from the raw report.** The claim and consequence were edited where the skeptic showed the raw text false or overstated (see the caveats). "No sales-outcome measure" overstated: outcomes are measured, not designated. The gap is inherited from the canvas.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Outcome measure against a pre-go-live baseline, plain list = arrival order among contacted leads, signal-to-first-contact time, monthly summary contents, previous-period comparison; Ahsan sets targets

#### S40 · F-R4-2 · MAJOR · R4 Product
**Claim.** "Engine versus a plain list" never defines the plain list, and P5-33's proxy is biased toward the engine by the fold and by the segment rules

**Rows.** 1.2 (Country Leadership), J18.1, P5-33, P5-20, P5-15, P6-18

**Quoted.** P5-33 "Leadership's "does the engine beat a plain list" is the conversion rate of the top-scored tenth of leads against the bottom tenth."  
Second line: P5-20 "The first **20** leads are on the list; the rest sit under "more leads", one tap away."

**Consequence.** No plain list appears anywhere: not arrival order, not random, not the Smart Agro Lite list. The number labelled "engine vs plain list" (1.2, J18.1) compares the engine with itself.
- The bottom tenth is where the design puts the least attention. It sits under the fold (P5-20), it is the oldest (age decay of -2 a day), and it is mostly Potential with unknown acreage (acreage, weighted 25, "unknown scores zero").
- The top tenth is mostly Hot, on a 24-hour contact and 7-day completion promise.
- So the gap measures SUL attention and the Hot definition, not ranking quality. It will favour the engine every month by construction.
- Leadership will read "engine wins" even if the scorecard adds nothing over the three Hot conditions.

**Proposed fix (reviewer's).** Replace the second clause of P5-33 with: "The plain list is arrival order. Leadership's comparison is the conversion rate by score tenth among leads the SUL contacted within the contact promise, so attention does not create the gap; the share of each tenth that was contacted is shown beside it, and a tenth with fewer than 30 contacted leads shows 'too few to compare'."

**Decision check.** touches 2026-09-15 (ranked segments, fold). What it leaves unspecified is how the engine's value is measured when the fold decides attention.

**Skeptic (Fable 5.1).** Survived. "plain list" appears only in 1.2, J18.1, P5-33 and is never defined; nothing conditions the decile comparison on contact or attention while P5-28 and P5-18 build the differential in.

**Skeptic's caveats.** The "contradiction" label is inherited from the canvas's own wording, not spec-internal

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Outcome measure against a pre-go-live baseline, plain list = arrival order among contacted leads, signal-to-first-contact time, monthly summary contents, previous-period comparison; Ahsan sets targets

#### S41 · F-R4-3 · MAJOR · R4 Product · R7 Open
**Claim.** No number measures how long a grower waits; Hina's hold sits outside every clock and outside the headline

**Rows.** P5-31, P5-10, P1-43, P5-5

**Quoted.** P5-31 "Leads waiting for Hina, held, below threshold or rejected are not in the denominator."  
Second line: P5-10 "Hina's contact does not count as the SUL's contact; the SUL's contact clock starts at handover and stops at the SUL's first contact."

**Consequence.** A diseased-crop Crop Doctor grower can wait up to 2 days for Hina (P5-5) and then up to 72 hours for the Potential contact promise. That is about 5 days, and it is reported as 100% on time. For any lead held for Hina, the headline cannot show the delay DR-23 says "the session 2.2 delivery lens will weigh". No screen gives anyone a number to weigh it with.

**Proposed fix (reviewer's).** New row P5-31a: "Time from the grower's signal to the SUL's first contact is reported beside the on-time rates at every level, split into Hina's hold and the SUL's clock, as a median and the share over 72 hours."

**Decision check.** touches the 2026-09-21 Hina decision. What it leaves unspecified is how the hold is measured.

**Skeptic (Fable 5.1).** Survived. Every Hina number is a count or a bound (P5-8, P5-5); no row reports the hold as a duration; DR-23 commits this round to weighing the delay with nothing to weigh it by.

**Skeptic's caveats.** "nearly every Pilot lead" leans on F-R4-4; the core claim holds for any held lead

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "Nearly every Pilot lead" leaned on F-R4-4, which was refuted; the claim holds for any held lead.

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R7-4 (R7 Open, major) — No number measures the wait before a lead reaches the SUL, so outages, Hina holds and pool waits are invisible.

**See also.** F-R7-6 (S87) is the same out-of-hours scenario seen from support hours; kept separate because the defect differs (no alert, against no measure).

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Outcome measure against a pre-go-live baseline, plain list = arrival order among contacted leads, signal-to-first-contact time, monthly summary contents, previous-period comparison; Ahsan sets targets

#### S42 · F-R4-6 · MAJOR · R4 Product
**Claim.** The Pilot has no row-level scope: everything it needs is "Post-Capture", in a build scope that has no milestones

**Rows.** 1.1, P1-43, 6.3.1, A.1 (milestone column), P2-1, P2-20, P2-21, P3-2, P3-17, P3-18, J21.5a (S28 second half)

**Quoted.** 1.1 "This document specifies the whole product; the appendix says what Capture builds."  
Second line: A.1 ""Post-Capture" means specified now, built in the Act scope after M8." · 6.3.1 "Built after Capture, as specified in Parts 2, 3 and 5: the full SUL app, the manager, leadership, marketing and Admin dashboards, flags, the weekly and monthly summaries"

**Consequence.** The Pilot's headline (P1-43) needs SUL logging and "every manager's view", and all of it is Post-Capture. PLAN.md has no Act milestones. No row says which Post-Capture rows the Pilot needs. So the Pilot either waits for the whole Act scope, or goes live on M1's "one-page list", which has no states or clocks. Nobody can date the Pilot, and every capability below becomes a Pilot prerequisite by default.

Scope verdicts (Pilot = Crop Doctor + WhatsApp + one campaign, two zones):

| Capability | Pilot needs it? | Why, and the row that would move it |
|---|---|---|
| Working map, "also serves understanding and analytics" (P2-20, J13) | No | J1.4 already plans "from the three lists, or from the map"; the analytics clause has no stakeholder, journey or number. 6.3.2 row: "Map view (P2-20, J13) — after the Pilot." |
| E-commerce stream (P4-27a) | No | See F-R4-7 |
| Last-season tab (P1-17) | No | See F-R4-8 |
| Follow-up date (P2-21) | Yes | Part of the state model and the completion clock |
| BSAs and digitised boundaries (Part 7) | Yes, for routing (P7-7) | BSA as a map filter only with the map |
| Address geocoding (P7-14) | Yes | Places Hina's returned addresses (P7-6) |
| Hina (5.2) | Yes, as P5-1 is written | See F-R4-13 |
| Weekly WhatsApp summaries (P3-17, J22) | No | Dashboards suffice for two zones; 6.3.2 row |
| Monthly email (P3-18) | Dashboard page only | 6.3.2 row for the email |
| Reconciliation view (P3-2, second sentence) | No | P6-1 makes the totals agree by construction; the definitions page stays |
| Map pins by category | No | Goes with the map |
| Hand-confirmed "no contact" matches (P4-19, J21.5a) | No | The list and count suffice; 6.3.2 row |

**Proposed fix (reviewer's).** Add a "Pilot" column (yes / after the Pilot) to A.1. Add 6.3.0: "The Pilot needs: the SUL app's home, segment lists, lead card, act-and-log, both clocks, offline, My summary; the RSM dashboard with flags; the Head of Sales on-time view; Admin settings, connections, rejected, below-threshold and pool; Hina phase 1. Everything else in Parts 2 and 3 follows the Pilot." Mark the "No" rows in the table above as after the Pilot.

**Decision check.** none (naming 2026-09-11 says "Capture is not the Pilot" but never says what the Pilot builds)

**Skeptic (Fable 5.1).** Survived. The 2026-09-11 decision defines the Pilot by streams, zones and engine, not by which product rows ship; every row P1-43 needs is Post-Capture; PLAN.md is Capture-only and Act has no milestones; no Pilot column in A.1.

**Skeptic's caveats.** The per-capability scope table is proposal material; some "No" verdicts push against Ahsan's 18/21 Sept row answers

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Pilot column in A.1 plus a Pilot section: zones named before M8, training, last sync to RSMs, exit and Wave 2 gate (no duplicate of Phase 9), D2 fallback, SUL headcount, "not live" zones; Ahsan marks Pilot rows

#### S43 · F-R4-9 · MAJOR · R4 Product
**Claim.** No rollout or adoption rules: Pilot zones unnamed, no training, no adoption owner, no exit criteria, no Wave 2 gate

**Rows.** 1.1, P2-11, P1-41, P3-4, P6-17, P6-21

**Quoted.** 1.1 "The Pilot is the go-live subset (Crop Doctor, WhatsApp and one campaign, two zones, the first scorecard)."  
Second line: P6-17 "DBO watches the portal daily and handles the below-threshold, no-contact, rejected and pool lists and SUL support" · P1-41 "The RSM and ZM follow up with their direct report inside Synapse by flagging the lead"

**Consequence.** A search of SPEC.md and PLAN.md finds none of the following:
- which two zones (so it cannot be checked whether they lie inside the Punjab and Sindh boundaries);
- training for SULs or managers;
- who owns adoption;
- how RSMs learn that follow-up now happens by flag inside Synapse rather than by phone (P6-17 gives support to SULs only);
- what makes the Pilot end or pass;
- what gates Wave 2;
- any adoption measure. Last sync per SUL appears only to the SUL (J1.1), so an SUL who stops opening the app surfaces only as falling on-time rates weeks later.

P2-11 removes points, and the spec offers nothing else the SUL gains. That makes the missing adoption owner the month-3 risk.

**Proposed fix (reviewer's).** New rows:
- P6-22: "The two Pilot zones are named here before M8."
- P6-23: "Before go-live every SUL, RSM and ZM in the Pilot zones is trained in person by DBO. The RSM and ZM session covers the flag as their one way to act (P3-4)."
- P6-24: "The last sync time of every SUL is on the RSM's view; an SUL not synced for 2 working days is flagged to the RSM."
- P6-25: "The Pilot ends after one crop season or 16 weeks. Wave 2 goes ahead only if the numbers in P1-44 meet their targets; Ahsan and Head of Sales decide, recorded in DECISIONS."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. Zones unnamed (7.1 lists four), no training row, DBO supports SULs only, no last-sync on manager views, no Pilot exit or Wave 2 gate anywhere in SPEC, PLAN, DECISIONS or the delivery process (whose gates are QA/infra).

**Skeptic's caveats.** The fix cites a non-existent P1-44; reference P1-43 or the target rows Ahsan sets; do not duplicate the Phase 9 go/no-go

**See also.** F-R4-15 (refuted) left a narrower claim carried here: no row ties go-live to data readiness (boundaries, village-to-BSA assignment, franchise points, an SUL per territory), and P7-14's converter is unnamed with no date.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Pilot column in A.1 plus a Pilot section: zones named before M8, training, last sync to RSMs, exit and Wave 2 gate (no duplicate of Phase 9), D2 fallback, SUL headcount, "not live" zones; Ahsan marks Pilot rows

#### S44 · F-R4-10 · MAJOR · R4 Product
**Claim.** The monthly leadership summary's contents are undefined; "the unflattering numbers" cannot be tested

**Rows.** P3-18, J18.2, P6-21

**Quoted.** P3-18 "The monthly leadership summary is produced by Synapse on the first working day of the month, includes the unflattering numbers, and never names a grower."

**Consequence.** Leadership's one deliverable has no content list. A builder picks the page, and "unflattering" cannot be checked against P6-21 ("proven by something Ahsan can watch").

**Proposed fix (reviewer's).** Replace P3-18's middle clause with: "…holds, for the month and the month before: leads received by source and campaign, conversions and PKR by zone and portfolio, both on-time rates by zone, time from signal to first contact (P5-31a), the engine-versus-plain-list comparison (P5-33), and the counts of below-threshold, no-contact, pool, rejected and Hina-waiting leads, each shown whether it rose or fell…"

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P3-18's observable is the bare cross-reference "J18.2", which names delivery mechanics only; the canvas line it cites (model lift, "including when unflattering") was not carried into the page; no row lists its contents.

**Skeptic's caveats.** The fix's extra items (P5-31a, queue counts, deltas) have no input behind them and need Ahsan's mark

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Outcome measure against a pre-go-live baseline, plain list = arrival order among contacted leads, signal-to-first-contact time, monthly summary contents, previous-period comparison; Ahsan sets targets

#### S45 · F-R4-14 · MAJOR · R4 Product
**Claim.** No row says what the Pilot is if D2 stays open and Crop Doctor cannot connect

**Rows.** 1.1, 6.4 D2, 4.6 D2, P4-1, P4-12, P1-25 (S28 first half)

**Quoted.** 6.4 D2 "Connecting the three Cropwise streams; the M2 spike may use WhatsApp instead"  
Second line: 4.6 D2 "The three Cropwise streams cannot be connected until answered; they are specified here regardless."

**Consequence.** D2 has been "Filed, awaiting reply" since 21 Sept, with "recipient and date to be added". The fallback in 6.4 covers the M2 spike, not the Pilot. If D2 is unanswered at go-live, the Pilot loses its main stream and the D9 healthy-scan rule. What remains is WhatsApp plus one campaign, which arrives marked "campaign unknown" while D3 is open (P4-11). P4-1 guarantees Synapse runs with any subset. Nothing says whether the Pilot still goes live, in the same zones, with the same measures, or who decides and when.

**Proposed fix (reviewer's).** New row in 6.4 (or 1.1): "If D2 is unanswered at M6, the Pilot goes live on WhatsApp and the one campaign in the same two zones, Crop Doctor joins as the first Wave 2 addition, and the Pilot's measures (P1-44) are judged on those streams; Ahsan confirms at M6."

**Decision check.** touches D2 (open). What it leaves unspecified is the Pilot's shape while it stays open.

**Skeptic (Fable 5.1).** Survived. 6.4 D2's WhatsApp fallback is scoped to the M2 spike by its own words; P4-1 guarantees Synapse runs, not what the Pilot is; D2 is an open action with no recipient or date; seam S28 pre-registered the question.

**Skeptic's caveats.** Cosmetic errors in the fix: no P1-44 exists; "at M6" is a Capture milestone; "campaign blocked by D3" overstated

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "Campaign blocked by D3" was overstated. The fix has cosmetic errors: no P1-44 exists, and "at M6" is a Capture milestone.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Pilot column in A.1 plus a Pilot section: zones named before M8, training, last sync to RSMs, exit and Wave 2 gate (no duplicate of Phase 9), D2 fallback, SUL headcount, "not live" zones; Ahsan marks Pilot rows

#### S46 · F-R5-3 + F-R7-12 · MAJOR · R5 Trust · R7 Open
**Claim.** Nobody at Syngenta governs what Hina says in Syngenta's name: no disclosure rule, no script or persona approval, no way to stop a script

**Rows.** P5-2, P5-3, P5-8, 5.2 intro, P1-21, 5.9

**Why one entry.** Both attack P5-2's "Hina decides only how she runs each call": R5 on what the grower must be told, R7 on who at Syngenta approves and can stop the script. One row on Hina's script covers both, as the F-R5-3 skeptic noted.


##### F-R5-3 · major as filed · R5 Trust — Hina's call has no rule on disclosure: AI, on behalf of Syngenta, where the number came from

**Rows.** P5-2, P5-3, P5-8, 5.2 intro, P1-21

**Quoted.** P5-2 "Synapse decides which leads Hina calls, in what order (score, then age) and with what limit … Hina decides only how she runs each call."

**Consequence.** Everything a grower hears from an automated voice agent is left to a third party. The spec does not require her to:
- say she is an AI;
- say she calls for Syngenta;
- say why she has the number ("you scanned a crop in Crop Doctor").
Under PTA's regulations on unsolicited and telemarketing communication (Protection from Spam, Unsolicited, Fraudulent and Obnoxious Communication Regulations, 2009; the exact clause is for Syngenta Legal to confirm), a qualifying sales call is telemarketing. The spec has no rule on the caller line either.

**Proposed fix (reviewer's).** New row P5-2a: "Every Hina call opens by saying it is an automated assistant calling for Syngenta Pakistan, and names the stream and date of the grower's contact (the consent basis). The opening script is approved by Syngenta Legal and held in Admin. Hina calls only from a line registered as PTA requires."

**Decision check.** touches D1. D1 grounds the call; what it leaves unspecified is what the grower is told.

**Skeptic (Fable 5.1).** Survived. No row, note or decision names what Hina tells the grower or the caller line; D1 grounds the right to call, not its content; the plan assigned this attack to R5-A1.

**Skeptic's caveats.** The PTA citation is at regulation level with the clause left to Legal (weakens "major", not the claim); overlaps F-R7-12 on script approval (R5 owns disclosure, R7 brand)


##### F-R7-12 · major as filed · R7 Open — No one in Syngenta approves what Hina says in Syngenta's name

**Rows.** P5-2, P5-3, P5-8, 5.9

**Quoted.** P5-2 "Hina decides only how she runs each call."

**Consequence.** An AI voice calls growers as Syngenta, and the third party alone decides its greeting, persona, product talk and whether it quotes prices. No row gives Marketing or brand approval of the script, a change log, or a way to stop a script. Every call carries this brand exposure from the Pilot onward.

**Proposed fix (reviewer's).** P5-2b "Hina's script and persona are approved by Marketing before first use and after every change; the approved version is recorded on the connection; a call made on an unapproved version is a connection failure."

**Decision check.** none

**Skeptic (Opus 5.5).** Survived. P5-2 gives Hina call conduct and DECISIONS 2026-09-21 says a third party runs her, but no decision, DR (23, 24, 28) or 6.3.2 entry takes script or persona approval away from Syngenta; P5-8 and the Admin portal only show Hina's health, with no stop control.


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, amended): Ahsan: no disclosure concern. What Hina says is controlled and approved by Marketing for campaign leads, and by Admin/DBO for non-campaign leads; approved version recorded, and they can stop it. No required disclosure line

#### S47 · F-R5-7 · MAJOR · R5 Trust
**Claim.** There is no processor rule for any third party that receives grower data: Hina's vendor, the intent reader, the WhatsApp provider, the address service

**Rows.** P6-12, P5-3, P5-8, A.3 (Hina), P4-8, P4-9, P5-35, 4.2 WhatsApp inbound, P4-27a, P6-17

**Quoted.** P5-3 "No recording and no transcript enter Synapse."  
Second line: P6-12 "**Residency.** Grower data is stored in Pakistan."

**Consequence.** The two lines together say nothing about Hina's vendor:
- A.3 sends the vendor "ordered lead batch" (grower name and number).
- The vendor makes the calls, so recordings and transcripts may exist on its side, in any country, kept for any period.

The same gap applies to two more parties:
- The intent reader (P4-9) reads grower words (PII). It is probably a model API; nothing says where it runs.
- The WhatsApp provider carries every inbound message.

No row requires a data processing agreement or states where each party keeps the data, for how long, or who signs. P6-17 makes Admin "the escalation point to the third parties (Hina, hosting)", which is operations, not contracting. P6-12 governs only what Synapse stores, so every processor sits outside it.

**Proposed fix (reviewer's).** New row P6-12a: "Every third party that receives grower data (Hina's provider, the messaging provider, any intent-reading or geocoding service) is listed in Admin with what it receives, where it keeps it, for how long, and a signed data processing agreement. The agreement is signed by Syngenta Pakistan Legal and names deletion of recordings and transcripts within <n> days. No connection goes live without its entry."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. The spec ships grower data to Hina's vendor (A.3 batch), the messaging provider and the geocoder (P7-14) and no row states where they keep it, for how long, or who signs; P6-12/A.3 govern Synapse's own storage.

**Skeptic's caveats.** "e-commerce feed" is a weak example (Synapse pulls from it); the other four parties carry the claim

**Changed from the raw report.** The claim was edited where the skeptic showed the raw text false or overstated (see the caveats). "E-commerce feed" is a weak example (Synapse pulls from it) and is dropped from the title; the other parties carry the claim.

**See also.** F-R5-8 (refuted) left a narrower claim carried here: P7-14 should cross-reference this entry's P6-12a so an outside address service cannot be chosen before its entry exists. F-R7-11 (S89) is the same data-handling gap for the Hina vendor alone (seam S18).

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Vendor register in Admin: what each third party receives, where and how long it keeps it, signed processing agreement (Legal signs; recordings deleted within N days); no connection goes live without its entry

#### S48 · F-R5-14 · MAJOR · R5 Trust
**Claim.** "Email plus a Synapse password" has no rules: no proof the registrant owns the email, no password policy, no lockout, no session length, no offline session limit, no MFA

**Rows.** P6-16, P1-6, A.3 (Login), 6.3.2 SSO row

**Quoted.** P6-16 "Staff register and log in with their Syngenta email address and a Synapse password." | "The login screen asks for a Syngenta email; a non-Syngenta address cannot register."

**Consequence.** The only stated check is the domain. Nothing requires the registrant to prove they own the mailbox, so anyone can register with a colleague's Syngenta address. Nothing says how "Country IT confirms who may have an account" (P1-6) is enforced before registration. Also unspecified:
- password strength and reset;
- lockout after failed tries;
- session length on phone and desktop;
- how long an offline app stays unlocked;
- a second factor for Admin, the role that can export and undo number changes.

**Proposed fix (reviewer's).** Amend P6-16: "Registration sends a one-time link to the Syngenta mailbox, and the account works only after Country IT's list confirms it. Passwords of at least 12 characters, reset by mailbox link. Lockout after 5 failures. Sessions expire after <n> days on the SUL app (offline included) and <n> hours on the portal. Admin logins need a second factor."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. P6-16 is the only login rule and A.3 restates it; no mailbox verification, password policy, lockout, session or offline-unlock length, or MFA anywhere; 6.3.2 defers SSO only; plan R5-A3 directed the attack.

**Skeptic's caveats.** J21.1 "IT gives the login" contradicts P6-16's self-registration (seam S8, R6)

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Mailbox confirmation link plus IT's list; minimum password length and mailbox reset; lockout after 5 failures; session limits (app incl. offline, portal); second factor for Admin; Ahsan sets numbers

#### S49 · F-R5-15 · MAJOR · R5 Trust
**Claim.** The receipt photo (personal) is taken "camera or gallery", so copies land in the phone's gallery and cloud photo backup

**Rows.** J3.2, P1-30, P6-14, 6.1 Outcome, J9.2

**Quoted.** J3.2 "Asks for, all required: PKR value, receipt photo (camera or gallery), product (pick-list), quantity"

**Consequence.** 6.1 marks the receipt "(personal)" and P6-14 logs every opening. A photo taken with the phone's camera app, or picked from the gallery, stays in the SUL's personal gallery and is copied by the phone's cloud backup: outside Synapse, outside Pakistan if cloud backup is on, never logged, never removed by P6-11.

**Proposed fix (reviewer's).** Amend J3.2: "receipt photo, taken inside the app's own camera and stored only in the app's encrypted store; no gallery pick; no copy left on the device after it is sent."

**Decision check.** touches D7 (receipt as proof). D7 leaves how the receipt is captured unspecified.

**Skeptic (Fable 5.1).** Survived. J3.2 permits "camera or gallery"; the receipt is marked personal/PII (6.1, A.2) and every Synapse rule governs the copy inside Synapse; nothing covers or defers the on-device copy.

**Skeptic's caveats.** "outside Pakistan" rests on cloud backup being on (inference)

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats).

**TRIAGE:** ( ) accept  (x) reject — reason: Keep receipt capture from both gallery and camera  ( ) park — trigger:  
**Ahsan's decision** (reject): Keep receipt capture from both gallery and camera

#### S50 · F-R5-18 + F-R7-22 · MAJOR · R5 Trust · R7 Open
**Claim.** The retention period can be changed by one Admin with no bounds, no preview, no delay and no recovery

**Rows.** P6-11, 4.5 Settings, A.2 Settings, P3-10, A.2 Settings retention_seasons, 3.6 Q7

**Why one entry.** Same row (P6-11) and same setting (retention_seasons): R5 asks for bounds, R7 for a preview, a delay and a floor. The floor overlaps; the upper bound is R5's alone.

**Severity.** Filed as F-R5-18 minor, F-R7-22 major; the entry takes the highest.


##### F-R5-18 · minor as filed · R5 Trust — The retention period is an Admin setting with no bounds and no Legal owner

**Rows.** P6-11, 4.5 Settings, A.2 Settings, P3-10

**Quoted.** P6-11 "The period is an Admin setting; every removal is logged."

**Consequence.** One Admin, acting alone (P3-10), can set retention_seasons to 99 and keep personal data indefinitely, or to 0 and anonymise the active base. Head of Sales is told afterwards (4.5). A privacy control is treated as an operational setting.

**Proposed fix (reviewer's).** Amend P6-11: "The period is an Admin setting between 1 and 3 seasons. A change needs Syngenta Legal's written approval, recorded on the change."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. retention_seasons has a default and no range (A.2 gives ranges elsewhere); 4.5 and P6-17 let one Admin change it with Head of Sales told afterwards; the 2026-09-17 decision keeps it an Admin setting and gives no bounds.

**Skeptic's caveats.** The Legal-approver half reverses 3.6 Q7 ("Admin alone") and is a question for Ahsan; the floor overlaps F-R7-22; the unique part is the upper bound


##### F-R7-22 · major as filed · R7 Open — Shortening retention cannot be undone, and there is no preview, delay or minimum

**Rows.** P6-11, A.2 Settings retention_seasons, P3-10, 4.5 Settings, 3.6 Q7

**Quoted.** P6-11 "The period is an Admin setting; every removal is logged."  
Second line: P3-10 "Settings changes … are made by Admin alone, take effect at once"

**Consequence.** If Admin changes retention from 2 to 1 (or mistypes 0), the next removal run (P6-11 does not say when it runs) removes the name, number, location and receipts of every grower inactive for one crop year. A revert restores none of it. Nothing shows the count before saving.

**Proposed fix (reviewer's).** P6-11a "A shorter retention period shows the number of growers it would anonymise before it is saved and applies from the next season start; until then it can be reverted and nothing is removed; the minimum is one season."

**Decision check.** none. The fix keeps "Admin alone" (3.6 Q7) and adds a preview and a delay, not a second person.

**Skeptic (Opus 5.5).** Survived. P6-11 and DECISIONS 2026-09-17 make the period an Admin setting with logged removals and nothing more; A.2 gives retention_seasons a default and no lower bound; 4.5 logs changes but guards none; no preview, minimum, delay or restore anywhere; the fix keeps Admin alone and argues against no decision.

**Skeptic's caveats.** "Anonymises at once" is inferred, not quoted: P3-10/J21.2 "take effect at once" names threshold, promises, weights and campaign promises, not retention, and P6-11 never says when removal runs; the rest holds whatever the timing

**Changed from the raw report.** The claim and consequence were edited where the skeptic showed the raw text false or overstated (see the caveats). "Anonymises at once" is an inference: P3-10's "take effect at once" names threshold, promises, weights and campaign promises, not retention. The rest holds whatever the timing.


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Retention range 1–3 seasons; preview of growers affected before saving; a shorter period applies from the next season start and can be reverted until then; Admin alone decides

#### S51 · F-R5-20 · MAJOR · R5 Trust
**Claim.** DBO works the Admin portal every day but has no role, and P1-5 says Admin is the digital team

**Rows.** P1-5, P1-6, P6-17, P7-15, 4.5 Sales structure, A.2 User, P1-36, J21.6, P3-11

**Quoted.** P1-5 "Admin is the digital team on its own login, never combined with a sales or marketing role"  
Second line: P6-17 "DBO watches the portal daily and handles the below-threshold, no-contact, rejected and pool lists and SUL support; the digital team (Admin) owns settings". A.2 User "role (choice: sul, rsm, zm, head_of_sales, leadership, pm, marketing, admin)"

**Consequence.** DBO is not the digital team (P6-17 separates them) and has no role. A builder either gives DBO the admin role, with settings, the full audit trail, exports and number undo, against P1-5's separation and least privilege, or leaves DBO unable to do its job. P1-36 ("Removal is Admin's alone") and J21.6 give removal of rejected leads to Admin, while P6-17 gives the rejected list to DBO. P6-17's "pool lists" also conflicts with P3-11 ("The regional pool is the RSM's"); that overlap is noted only.

**Proposed fix (reviewer's).** Add role `dbo` to A.2 User and a row P1-5a: "DBO has its own role: edit the sales structure and village-to-BSA assignment, and work the below-threshold, no-contact and rejected lists. It cannot change settings, export, undo number changes, remove leads or read the audit trail."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. The spec separates DBO from Admin in five places yet A.2's closed role list has only `admin` for the portal; a builder must over-grant (against P3-10, P1-36, P6-17) or give DBO no login.

**Skeptic's caveats.** "Decision check: none" is wrong: a ninth role touches the 2026-09-16 eight-personas decision, so the fix needs a DECISIONS entry or a permission set under admin

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Own "dbo" role: sales structure and village-to-BSA, daily lists, targets on Head of Sales' recommendation (S26), non-campaign Hina scripts (S46), call-centre access (S13/S14); no settings, exports, number undo, removals or audit trail. Needs a DECISIONS entry (eight personas)

#### S52 · F-R5-21 · MAJOR · R5 Trust · R6 Build
**Claim.** No access review: nobody periodically confirms who still holds which role and scope

**Rows.** P1-5, P1-6, P6-16, J21, 3.2 Admin portal, A.2 User

**Quoted.** 3.2 Admin portal "Users and roles; territories and BSAs; settings … audit trail"

**Consequence.** The canvas's platform-and-control layer (Z00) carries access review, and A.1 maps P1-5, P1-6 and P6-10 to P6-17 to "Z00", but no row brings it across. An RSM who moved region, a PM who left, or an Admin second login (P1-5's own example of a PM with two logins) keeps access until someone notices. Combined with F-R5-13, nothing requires or prompts removal of stale access.

**Proposed fix (reviewer's).** New row P6-16b: "Every quarter Admin sends Country IT the list of active users with role and scope. IT confirms or removes each within 10 working days, and the review and its changes are in the audit trail."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. The only access control is one-time confirmation at registration; canvas Z00's access review is dropped with no DR; 6.3.2 defers SSO only (also covers merged F-R6-64).

**Skeptic's caveats.** "nothing ever removes stale access" too strong — nothing requires or prompts removal; severity contested (R6 rated minor); the fix's numbers are proposals

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Severity contested: R6 filed the same gap (F-R6-64) as minor. The fix's numbers are proposals.

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R6-64 (R6 Build, minor) — Access review in Admin dropped without a DR.

**See also.** F-R5-13 (S3) is the leaver path.

**TRIAGE:** ( ) accept  (x) reject — reason: Ahsan: Admin manages all role changes, additions and removals, based on the communications received; no periodic review. (The canvas's access review stays dropped; whether to note it in the DR register is open for apply time)  ( ) park — trigger:  
**Ahsan's decision** (reject): Ahsan: Admin manages all role changes, additions and removals, based on the communications received; no periodic review. (The canvas's access review stays dropped; whether to note it in the DR register is open for apply time)

#### S53 · F-R5-22 · MAJOR · R5 Trust
**Claim.** The audit lists leave out role, scope and activation changes, merges, match confirmations and reassignments, and User keeps no change history

**Rows.** P1-5, P6-15, P3-13, J21.8, 6.1 Audit entry, A.2 User, A.2 Audit entry, P4-19, J21.6

**Quoted.** 6.1 Audit entry "what (a settings change, a flag, a number change and its undo, a removal, a manager opening a grower's number or a receipt, an export, a Hina call, an automated read, a login)"  
Second line: P1-5 "every Admin action is recorded with who and when"

**Consequence.** A.2 makes action a fixed-list "choice", and a builder builds it from the 6.1 list. Several actions are left out:
- granting a role or scope, activating or deactivating a user;
- merging leads (J21.6) and reassigning a rejected lead;
- confirming a "possible match" (P4-19: "for a person to confirm").

A.2 User has no change history, unlike Settings and Sales structure. The most security-relevant actions, such as someone granting themselves an RSM scope, are unlogged even though P1-5 says every Admin action is recorded. J21.8 and P6-15 also differ from each other (J21.8 leaves out logins and receipt openings).

**Proposed fix (reviewer's).** Amend 6.1 Audit entry, P6-15 and J21.8 to one list that adds: "a user's role, scope or active state changed; a lead merged, reassigned or removed; a possible match confirmed or declined". Add "change history (who, when, before, after)" to A.2 User.

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. The three audit enumerations (6.1, P6-15, J21.8) disagree with each other and with P1-5; none lists role/scope/active changes, merges or match confirmations; 4.5's Users row alone lacks the "every change logged" clause.

**Skeptic's caveats.** SUL territory assignment is covered by Sales structure history; Admin's action on a rejected lead is partly on the lead; the "one list" fix should be built from every "logged" row

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): One audit list used everywhere, adding role, scope and active changes, merges, reassignments, removals and match confirmations; user accounts keep a change history

#### S54 · F-R5-23 · MAJOR · R5 Trust
**Claim.** An RSM can open any grower's number in the region; the view is logged, but nothing limits it and nobody is required to read the log

**Rows.** P3-3, J14.3, P6-10, P6-14, P6-15, P3-9

**Quoted.** J14.3 "The full lead card, grower name and number included; every view of a number is logged"

**Consequence.** P3-3 lets the RSM "open a full lead card, grower number included" for any lead in the region, not only overdue or flagged ones, which is all J14.3 needs. The log is "readable by Admin" (P6-15), but no one must review it and nothing flags unusual volume. An RSM could harvest a region's numbers one card at a time (exports are blocked, screenshots are not; see F-R5-12). A log nobody reads does not protect anything.

**Proposed fix (reviewer's).** Amend P3-3: "The RSM opens a grower's number only from an overdue, flagged or pool lead." New row P6-15b: "Admin reviews number and receipt views weekly; more than <n> views by one user in a day raises an alert to Admin."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. P3-3 has no qualifier on which leads an RSM opens (P6-14 shows RSMs opening converted leads); P6-15 is "readable by Admin", not reviewed; the audit trail is not on DBO's daily list; no volume alert.

**Skeptic's caveats.** Narrowing P3-3 cuts across Ahsan's 18 Sept "full card for RSM is fine" and P6-14, so that half needs his decision; severity arguable

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, narrow): After clarification: RSMs see a grower's number only on overdue, flagged or pool leads. Changes Ahsan's 18 Sept "full card for RSM is fine", so it needs a DECISIONS entry at apply time

#### S55 · F-R5-25 · MAJOR · R5 Trust
**Claim.** Admin can "merge" a rejected duplicate, but no rule covers merging two growers who both have numbers

**Rows.** P1-35, J21.6, P4-16, P4-17, A.2 Grower, P1-37, P4-20

**Quoted.** J21.6 "Admin reassigns to a territory, merges with another lead, or removes with a logged reason"  
Second line: P4-17 "a number already on another grower cannot be saved on a second one"; A.2 Grower "mobile (text, PII, req, unique across growers …)"

**Consequence.** The real duplicate is one person with two phones, which means two grower records. Merging their leads means merging the growers, but a grower holds exactly one mobile (A.2), so one number must be dropped. The spec does not say:
- which number survives;
- whose name, confirmed acreage, new/existing mark and history win;
- whether the dropped number is kept, so the next signal from it does not create the duplicate again;
- whether the merge can be undone.

Merge is also not in the audit list (F-R5-22).

**Proposed fix (reviewer's).** New row P4-17b: "Admin merges two growers by choosing the surviving record. The other's signals, leads and history move to it; its number is kept on the survivor as a known alternate that routes future signals to it; conflicting confirmed values keep the more recent with both shown; the merge is logged and can be undone by Admin."

**Decision check.** touches D4. D4 leaves unspecified how one person with two numbers is handled under one number, one grower.

**Skeptic (Fable 5.1).** Survived. One open lead per grower (5.3) means a "duplicate" is two leads on two numbered grower records; no row says which number survives, what happens to the second record, or whether merge can be undone; 6.3.2 parks split, not merge.

**Skeptic's caveats.** Label should be "absent rule"; P4-20 partly covers value conflicts; the fix's "known alternate" number conflicts with "one per grower" and needs a DECISIONS entry

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): One wrong-number path; Admin merge with a surviving record, logged and undoable; a typed number matching a grower with a different name or village held as a possible match; a written match rule; "verified" defined in one line; keeps D4

#### S56 · F-R5-26 · MAJOR · R5 Trust
**Claim.** D4 keys the grower on a verified number, but the spec keys it on any number, so a mistyped form number attaches a stranger's signal to an existing grower

**Rows.** P4-16, 5.3 Reachability, P1-8, P4-18, A.2 Grower, 4.2 Facebook/TikTok/Call centre

**Quoted.** P4-16 "A grower is identified by their mobile number. One number belongs to exactly one grower."  
Second line: 5.3 Reachability "−15 while the grower's number has never been confirmed: no message received from it, no Hina or SUL contact that reached the grower | Numbers typed into forms until confirmed". DECISIONS 2026-09-18 D4: "A grower is identified by their verified mobile number."

**Consequence.** A Facebook or TikTok form with a mistyped digit that matches an existing grower's real number merges into that grower's lead. The card shows the real grower's name, the SUL calls them about someone else's need, and the stranger's words, crop and possibly acreage go on the wrong grower's timeline. INV-2 and D4 both say "verified", and the spec never defines verification or treats unverified numbers differently when matching.

**Proposed fix (reviewer's).** Amend P4-16: "A signal carrying an unconfirmed number (typed into a form) that matches an existing grower whose name or village differs is held as a 'possible match' (P4-19) instead of joining that grower."

**Decision check.** touches D4. D4 says "verified" and leaves the meaning of verification and the handling of unverified numbers unspecified.

**Skeptic (Fable 5.1).** Survived. D4 and INV-2 say "verified"; P4-16 keys on any number; 5.3 Reachability shows growers keyed on never-confirmed numbers by design; "verified" is defined nowhere; A.2 has no verified flag or hold reason.

**Skeptic's caveats.** Frequency likely rare; the fix's "name or village differs" trigger would also catch the family-phone case D4 accepted; needs a one-line clarification of "verified" from Ahsan

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): One wrong-number path; Admin merge with a surviving record, logged and undoable; a typed number matching a grower with a different name or village held as a possible match; a written match rule; "verified" defined in one line; keeps D4

#### S57 · F-R6-1 + F-R6-25 · MAJOR · R6 Build
**Claim.** P4-3's delivery promise has no number for pushed streams, no schedule for pulled ones, and was never scoped for Hina's hold

**Rows.** P4-3, 4.1, P5-1, P5-5, P5-24

**Why one entry.** One edit to P4-3 closes both, as both skeptics noted.


##### F-R6-1 · major as filed · R6 Build — P4-3 gives no latency number for pushed streams and no schedule for pulled ones

**Rows.** P4-3, 4.1

**Quoted.** "P4-3 | A signal becomes a lead on the SUL's phone within minutes of the grower acting, for streams that push (WhatsApp, Facebook, TikTok, campaigns), and within the schedule for streams that are pulled (Cropwise streams, call centre)."

**Consequence.** A test cannot tell pass from fail. "Within minutes" only gets a number from its example (10:02 → 10:05). "The schedule" for Cropwise, the call centre and e-commerce is never set anywhere: not in 4.2, A.2 Settings or A.3. A builder has to pick a poll interval, and the Pilot's Crop Doctor latency has no target.

**Proposed fix (reviewer's).** P4-3 (replace): "…reaches the SUL's phone within 3 minutes of the grower acting for pushed streams with no gap (P5-1); pulled streams are polled every N minutes, an Admin setting per stream (starting 15), and reach the phone within one poll interval plus 3 minutes." Add `poll_interval_min` per stream to A.2 Settings.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. "Schedule" for pulled streams has no value anywhere in SPEC, PLAN, canvas or DECISIONS; 4.6 says the Cropwise streams are "specified here regardless"; Crop Doctor is a Pilot stream.

**Skeptic's caveats.** The pushed half is weaker: the example implies three minutes and only needs promoting into the rule; merge the P4-3 fix with F-R6-25


##### F-R6-25 · major as filed · R6 Build — "Within minutes" versus held for Hina for up to two days (S5)

**Rows.** P4-3, 4.1, P5-1, P5-5, P5-24

**Quoted.** "P4-3 | A signal becomes a lead on the SUL's phone within minutes of the grower acting"  
Second line: "P5-5 | … | Two days after arrival at most, the lead is on the SUL's phone or closed."

**Consequence.** A latency test on a pushed lead with a gap fails by design. Most Facebook and TikTok form leads carry no acreage, so they fall under Hina. Five places (P5-1, P5-24 and AR-25 among them) say Hina's hold governs; P4-3 is the one row never revised to say so.

**Proposed fix (reviewer's).** P4-3 (scope): "…within 3 minutes for a lead with no gap (P5-1); a lead with a gap reaches the SUL at Hina's handover (P5-5)."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P4-3 is the one unrevised canvas-sourced row (its neighbour P4-9 carries "Revised 21 Sept for Hina"); the "no gap" qualifier lives in P5-1, P5-24, AR-25 but was never carried back, so a latency test written from P4-3 fails by design.

**Skeptic's caveats.** "cannot tell which rule governs" overstated (five places say Hina's hold governs); 4.1 is not itself contradictory; one edit to P4-3 closes this and F-R6-1

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "Cannot tell which rule governs" overstated; 4.1 is not itself contradictory. One edit to P4-3 closes this and F-R6-1.


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Pushed no-gap leads within N minutes; pulled streams checked every M minutes (Admin setting per stream), arriving within one check plus N; gap leads arrive at Hina handover; Ahsan sets N and M

#### S58 · F-R6-2 · MAJOR · R6 Build
**Claim.** P4-19 "only when it is clear" has no match rule

**Rows.** P4-19, P4-18, J21.5a

**Quoted.** "P4-19 | A match by name, village and crop is made only when it is clear; a doubtful match is not made, and the signal is held rather than attached to the wrong grower."

**Consequence.** Identity resolution (Capture M3/M6) has no acceptance test. A builder picks their own fuzzy-match algorithm and cut-off. Urdu and English name spellings of one grower either merge wrongly, which corrupts the one-grower record (INV-2 territory), or never merge, which inflates the "no contact" list.

**Proposed fix (reviewer's).** P4-19 (replace): "A no-number signal joins an existing grower automatically only when village and crop match exactly and the name matches after normalisation (transliteration and spelling rules listed in the Appendix). Any weaker match is shown to Admin as 'possible match' and never attached without a person confirming."

**Decision check.** touches D4. What it leaves unspecified: the match rule for no-number signals.

**Skeptic (Fable 5.1).** Survived. P4-18's automatic-attach branch is gated by "clear", defined nowhere; Crop Doctor (a Pilot stream) can deliver a no-number signal; D4 uses the same undefined word.

**Skeptic's caveats.** "INV-2 territory" is loose (not a literal INV-2 breach); the fix points to Appendix transliteration rules that do not exist yet

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): One wrong-number path; Admin merge with a surviving record, logged and undoable; a typed number matching a grower with a different name or village held as a possible match; a written match rule; "verified" defined in one line; keeps D4

#### S59 · F-R6-3 + F-R6-37 · MAJOR · R6 Build
**Claim.** A converted address has no rule for a low-confidence or ambiguous result, so it can place a lead in the wrong village

**Rows.** P7-5, P7-12, A.2 Lead placement, P7-6, P7-14

**Why one entry.** Both are the missing rule for an uncertain conversion under P7-5; the F-R6-3 skeptic noted one row could close both.


##### F-R6-3 · major as filed · R6 Build — P7-5 records conversion confidence but no confidence below which the lead is not routed

**Rows.** P7-5, P7-12, A.2 Lead placement

**Quoted.** "P7-5 | … which Synapse converts to a coordinate and records how sure the conversion is."

**Consequence.** A.2 has `conversion_confidence (number, optional)` but no row uses it. A geocode at village centroid, tehsil centroid or district centroid gets routed the same way, so an address that only resolves to a tehsil centre lands in a random village's territory. Nothing distinguishes "place" from "pool".

**Proposed fix (reviewer's).** New P7-5a: "A converted address places the lead only when the service resolves it to a village (confidence ≥ an Admin setting, starting 0.8); a result resolved only to tehsil or district, or below the setting, sends the lead to the regional pool marked 'address not resolved to a village'."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. A.2 stores conversion_confidence and no rule reads it; P7-7 places every coordinate regardless of origin; every pool rule (P7-6, P7-9, P5-23, P7-8) needs a condition a low-confidence converted coordinate does not meet.

**Skeptic's caveats.** The fix's "0.8" is invented and needs Ahsan; the resolution-level half (village vs tehsil/district) can be specified now; possible overlap with F-R6-37


##### F-R6-37 · major as filed · R6 Build — Converted addresses have no rule for ambiguity; the spec's own Hina example is incomplete

**Rows.** P7-5, P7-6, P7-14

**Quoted.** "P7-6 | … | Hina's summary: "village: Chak 12, tehsil Sahiwal"; the lead then places."  
Second line: "P7-5 | A stream that gives none must give a complete address — village, tehsil, district"

**Consequence.** The example has no district, so by P7-5 it is incomplete and should not place. Numbered chaks repeat across the canal colonies. The spec does not say what happens when the address matches more than one village, or matches under different transliterations, so a builder takes the geocoder's first hit and misroutes.

**Proposed fix (reviewer's).** New P7-5b: "An address that matches more than one village, or none, is not placed; the lead goes to the regional pool with the candidates listed for the RSM." Correct the P7-6 example to include a district.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. Only zero-match (P5-23, P7-17) and "record the confidence" (P7-5) are covered; nothing covers two or more matches; P7-6's own example places a lead on an address P7-5 calls incomplete.

**Skeptic's caveats.** The fix's "or none" is already covered by P5-23; sits close to F-R6-3 (one row could close both); chak and tehsil name repetition should be confirmed with DBO


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Ambiguous or coarse addresses go to the pool with candidates; franchise change swept through 5.3, 5.9, 6.4 and 6.3.1 (Ahsan picks the serviceability test); confirm-location action with history; name the held list

#### S60 · F-R6-4 + F-R6-23 + F-R6-27 · MAJOR · R6 Build
**Claim.** Part 7's franchise-point change was not swept back through 5.3 serviceability, the D6 decision rows and 6.3.1

**Rows.** 5.3 Serviceability, P7-3, P5-25, A.2 Settings, DR-27, DECISIONS 2026-09-21 (seam S21), 5.9 D6, 6.4 D6, P7-8, 7.4 D6, 6.3.1, A.1 P5-25, A.1 P7-3, A.1 P7-8

**Why one entry.** Same root cause, per the F-R6-27 skeptic: the 28 Sept revision updated P5-25 and P4-29 but left 5.3's range test, the 5.9 and 6.4 D6 rows and 6.3.1 as they were.


##### F-R6-4 · major as filed · R6 Build — Serviceability has two definitions and no range number

**Rows.** 5.3 Serviceability, P7-3, P5-25, A.2 Settings, DR-27, DECISIONS 2026-09-21 (seam S21)

**Quoted.** "5.3 | **Serviceability** | −10 where no franchise is within serviceable range of the grower's location | Needs the franchise list (5.5)"  
Second line: "P7-3 | … a BSA with no franchise takes the serviceability adjustment and shows the nearest franchise in the territory."

**Consequence.** 5.3 is a distance test and P7-3 is a BSA-membership test. They disagree for a grower in a BSA whose franchise is 45 km away (P7-3: no penalty; 5.3: depends on a range). They also disagree for a grower 2 km from a franchise in the next BSA (P7-3: penalty; 5.3: none). The range lived on the 21 Sept franchise list. P7-3 replaced that list with name and coordinate. A.2 BSA and Settings carry no range, and DR-27 still says "locations and range". 5.3's distance test cannot be computed without a range; only P7-3's membership test can.

**Proposed fix (reviewer's).** 5.3 Serviceability (replace): "−10 where the grower's BSA has no franchise and no franchise point in the territory lies within `serviceable_range_km` (Admin setting, starting 25 km) of the grower's coordinate". Add `serviceable_range_km` to A.2 Settings and correct DR-27's note.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. 5.3 keeps a distance test ("within serviceable range") while P7-3 uses BSA membership; the 28 Sept decision removed the franchise list that held the range and no row, record or setting replaced it; DR-27's note is stale.

**Skeptic's caveats.** "cannot be computed" overstated: P7-3 alone is computable; which test and what number is Ahsan's decision

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "Cannot be computed" overstated: P7-3 alone is computable. Which test and what number is Ahsan's decision.


##### F-R6-23 · major as filed · R6 Build — The D6 rows say "no routing depends on a franchise"; P7-8 routes by franchise point

**Rows.** 5.9 D6, 6.4 D6, P5-25, P7-8, 7.4 D6

**Quoted.** "5.9 | D6 | … | The franchise list (P5-25) names which territory a franchise serves; the conflict rule is still open and no routing depends on a franchise."  
Second line: "P7-8 | Outside the digitised areas: the lead goes to the territory of the BSA whose **franchise point is nearest** to the coordinate"

**Consequence.** The decision tables tell the reader D6 blocks nothing. In fact, routing outside Punjab and Sindh depends entirely on franchise points (P5-25 says so too).

**Proposed fix (reviewer's).** 5.9 and 6.4 D6 (replace): "Routing outside the digitised areas uses franchise points (P7-8); D6 decides who owns the relationship, not where a lead routes."

**Decision check.** touches D6. What it leaves unspecified: whether a D6 ruling may move a franchise point between BSAs, and therefore routing.

**Skeptic (Fable 5.1).** Survived. 5.9 and 6.4 D6 rows say "no routing depends on a franchise"; P7-8 and P5-25 route outside the digitised areas by franchise point; the 28 Sept revision updated P5-25/P4-29 and left the D6 rows untouched.

**Skeptic's caveats.** 7.4 D6 does not carry the phrase; "a late D6 ruling moves franchises" is not evidenced; severity contestable (a builder would follow P7-8)

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). 7.4 D6 does not carry the phrase. An unevidenced sentence about a late D6 ruling changing routing is dropped. Severity contestable (a builder would follow P7-8).


##### F-R6-27 · major as filed · R6 Build — 6.3.1 puts franchise and serviceability after Capture; A.1 puts them in Capture M3 (S7)

**Rows.** 6.3.1, A.1 P5-25, A.1 P7-3, A.1 P7-8, 5.3 Serviceability

**Quoted.** "6.3.1 | Built after Capture, as specified in Parts 2, 3 and 5: … the franchise list and serviceability, the learning engine's proposals."  
Second line: "A.1 | P7-3 | … | Capture: M3 (routing), M7 (masters); boundaries and conversion M3"

**Consequence.** Routing outside Punjab and Sindh (P7-8, Capture M3) cannot run without franchise points. Scoring at M8 "weights" either includes the −10 or does not. The milestone plan built from A.1 and the scope statement in 6.3.1 disagree. (R4-A6 owns the Pilot consequence.)

**Proposed fix (reviewer's).** 6.3.1: "Franchise points per BSA are built in Capture M3 for routing; the serviceability adjustment and 'nearest franchise' on the card are built after Capture." Mark A.1 5.3 Serviceability accordingly.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. 6.3.1 puts "the franchise list and serviceability" after Capture while A.1 marks P5-25, P7-3 and P7-8 Capture M3, and A.1 defines Post-Capture as after M8; 6.3.1 was not revised on 28 Sept.

**Skeptic's caveats.** The franchise half is a hard contradiction; the serviceability half is weaker (A.1 has no row for it); same root cause as F-R6-23 and F-R6-4


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Ambiguous or coarse addresses go to the pool with candidates; franchise change swept through 5.3, 5.9, 6.4 and 6.3.1 (Ahsan picks the serviceability test); confirm-location action with history; name the held list

#### S61 · F-R6-5 · MAJOR · R6 Build
**Claim.** P2-10/P6-8: "usable on 2G/3G" and "the field's current phones" are unmeasured

**Rows.** P2-10, P6-8

**Quoted.** "P2-10 | … and is usable on 2G/3G. No iPhone in the Pilot. | Installs and works on the field's current phones."

**Consequence.** There is no number to test "usable" against: no first-sync size or time, no per-action send size, no timeout. There is also no device list or survey row naming the field's phones. So the acceptance sentence cannot be run against a real target, and the Android 9 / 2 GB floor is unverified against what SULs carry.

**Proposed fix (reviewer's).** P2-10 (append): "Usable on 2G/3G means: a logged action sends in under 10 s at 64 kbps; a full-territory first sync completes in under 15 min at 256 kbps; delta syncs under 500 KB/day. The Pilot device list (make, model, Android version, RAM) comes from a DBO survey of the two Pilot zones before M8 (new row P2-10a)."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. No number behind "usable on 2G/3G" and no device list or survey behind "the field's current phones"; first sync and photo outbox still cross the slow link despite full offline.

**Skeptic's caveats.** The fix's numbers are the reviewer's; severity not assessed (P2-10 is Post-Capture, P6-8 is M8)

**TRIAGE:** ( ) accept  ( ) reject — reason:  (x) park — trigger: Trigger: Phase 4 — 2G/3G numbers and the DBO device survey become UX acceptance inputs  
**Ahsan's decision** (park (confirmed 2026-10-01)): Trigger: Phase 4 — 2G/3G numbers and the DBO device survey become UX acceptance inputs

#### S62 · F-R6-6 · MAJOR · R6 Build
**Claim.** P6-9 "slows nothing the SUL sees" and "in order" are undefined

**Rows.** P6-9, P4-3, P5-2

**Quoted.** "P6-9 | … A campaign launch of 10,000 leads in twenty minutes loses nothing and slows nothing the SUL sees. Every lead arrives, in order, whatever the volume."

**Consequence.** The row has no latency target during the burst, so its "slows nothing" half is untestable ("loses nothing" is testable, PLAN M8). Nothing says whether P4-3's "within minutes" still holds. "In order" has no key: occurred_at, receipt order, or Hina's score-then-age order (P5-2). An M8 burst test cannot assert either property.

**Proposed fix (reviewer's).** P6-9 (replace second and third sentences): "During a burst of 10,000 leads in 20 minutes, every no-gap lead reaches its SUL within 10 minutes of arrival, and SUL app actions keep their normal response time; leads for one SUL appear in `occurred_at` order."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. The only burst numbers (zero loss, 100 ms ack) measure the ingest edge; A.3 says the burst is queue depth with no drain bound; no row names an ordering key.

**Skeptic's caveats.** "loses nothing" is testable (PLAN M8); the fix's numbers are the reviewer's and need Ahsan; "normal response time" is itself unmeasured

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). The fix's numbers are the reviewer's and need Ahsan; the fix's "normal response time" is itself unmeasured.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): During a burst, no-gap leads reach the SUL within N minutes and the app stays as fast as normal; each SUL's leads appear in the order growers acted; Ahsan sets N

#### S63 · F-R6-7 + F-R6-41 · MAJOR · R6 Build
**Claim.** The scorecard cannot be computed from the spec: no points per level, no value for "large" or the age floor, no rule for missing crop-need severity

**Rows.** 5.3 (all five ingredients, Age), P5-14, P5-15, A.2 Settings, 5.3 Crop need, 4.2 Crop Doctor row, 6.1 Signal, P6-2, P6-20

**Why one entry.** Both leave `score()` unwritable from 5.3; the F-R6-41 skeptic asked for one fix so 5.3 gets one table.


##### F-R6-7 · major as filed · R6 Build — Every scorecard scale is ordinal with no points; age floor and "large" have no value

**Rows.** 5.3 (all five ingredients, Age), P5-14, P5-15, A.2 Settings

**Quoted.** "5.3 | **25** | Acreage | … | Under threshold → threshold → large"  
Second line: "A.2 Settings | … age_decay_per_day (2), age_grace_hours (48), age_floor ·"

**Consequence.** `score(lead, weights, now)` (A.3) cannot be written from the spec. No ingredient says how many of its points each level earns: intent's four levels, acreage's "large", crop need's three levels, timing's three. `age_floor` has no starting value. 5.3 implies age counts from the latest signal but never states it, nor whether Hina's hold uses up the 48-hour grace. A.9 requires 100% test coverage of the scoring package, so the builder will encode invented numbers and the tests will prove the invention.

**Proposed fix (reviewer's).** New table 5.3a, "Points per level": one row per ingredient level giving the fraction of the weight earned (e.g. intent: passive 0, problem 0.33, product 0.67, price 1.0; acreage: under 0, threshold 0.5, ≥ 50 acres 1.0, linear between). Set `age_floor` to a starting value (e.g. 20). State "age counts from the lead's latest signal".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. 5.3 gives only ordinal scales; no points per level, no acre value for "large", `age_floor` is the one setting with no starting value; the 2026-09-21 decision itself gives none.

**Skeptic's caveats.** Age-origin sub-claim weakened: 5.3 implies "from the latest signal" but never states it, nor whether Hina's hold uses up the 48 h grace; fix numbers are Ahsan's to set

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Age-origin point weakened as above. The fix's numbers are Ahsan's to set.


##### F-R6-41 · major as filed · R6 Build — Crop need: no rule when severity is absent, and no mapping from words or numbers to its three levels

**Rows.** 5.3 Crop need, 4.2 Crop Doctor row, 6.1 Signal, P6-2, P6-20

**Quoted.** "5.3 | **20** | Crop need | … | Crop Doctor diagnosis, severity and confidence; agronomic words in the message | Healthy or preventive → confirmed early → active and spreading"

**Consequence.** Whether Cropwise returns severity for the Pakistan tenant is unconfirmed (the canvas marks Crop Doctor `[validate]`; 4.2 says "to confirm"). Savera, community, WhatsApp, forms and the call centre give no severity at all. Nothing says how a severity number or a message maps to the three levels, or what a missing severity scores. Timing says "middle value" and acreage says "zero"; crop need says nothing. P6-2 forbids reading a blank diagnosis as healthy and P6-20 forbids an invented default (an explicit scoring rule for "unknown" is allowed), so for most leads the ingredient is uncomputable until such a rule is written.

**Proposed fix (reviewer's).** 5.3 Crop need, Read from (append): "Severity from Crop Doctor mapped by a table in Admin (e.g. 0–0.3 early, >0.3 active); without severity, 'problem named' scores the middle level and 'no problem or unknown' scores zero, and the reason says 'need not known'."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. Severity is optional (A.2, 6.1); acreage and timing carry explicit missing-value rules and crop need does not; P6-2 forbids reading a blank diagnosis as healthy, which blocks the implicit fallback; no words-to-level or number-to-level mapping exists.

**Skeptic's caveats.** "P6-20 forbids a default" overstated (an explicit scoring rule for unknown is allowed); write the fix together with F-R6-7 so 5.3 gets one table

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Write the fix together with F-R6-7 so 5.3 gets one table.


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, deferred detail): The builder proposes the points-per-level table (including missing severity and age origin) during the build, for Ahsan's approval; SPEC records that the table is required

#### S64 · F-R6-8 · MAJOR · R6 Build
**Claim.** Weights are editable one at a time with no sum rule; the spec's own example breaks 0–100

**Rows.** 5.3 intro, P5-14, P5-34, J21.2

**Quoted.** "P5-34 | … "Scoring weights changed on 1 Mar: acreage 25 → 30. Reason: …""  
Second line: "5.3 | 0 to 100 from five ingredients, then four adjustments."

**Consequence.** With no compensating change the weights sum to 105, so a lead can score above 100. Nothing says whether Admin must keep the sum at 100, whether scores are clamped, or whether weights are normalised. Two builders will produce two engines.

**Proposed fix (reviewer's).** P5-14 (append): "The five weights must sum to 100; Admin saves a weights version only when they do. The score after adjustments is clamped to 0–100."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. The canvas's "weights sum to 100" was dropped with no DR; A.2 states the 0–100 range with no mechanism; adjustments alone can push a score outside the range.

**Skeptic's caveats.** Label should be "absent rule plus canvas departure"; weights are one versioned set, so validate-on-save fits; the clamp is needed independently of the sum rule

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Weights saved only when they total 100; final score clamped to 0–100

#### S65 · F-R6-9 · MAJOR · R6 Build
**Claim.** P5-11: no rule for which three reasons are "top", or where their text comes from

**Rows.** P5-11, P2-4, A.2 Score

**Quoted.** "P5-11 | Every score carries its version and its breakdown, and shows its **top three reasons** in plain words in the SUL's language."

**Consequence.** Nothing says whether reasons rank by contribution size or whether negative adjustments (−15 unconfirmed number) can be a reason. A.3's pure scoring function rules out generated text, but no template list or owner for the Urdu and English wording exists. "Plain words" is unmeasurable.

**Proposed fix (reviewer's).** P5-11 (append): "The three reasons are the three largest positive contributions, then the largest adjustment if it exceeds 10 points; each reason is a fixed template per ingredient level and adjustment, held in Urdu and English in the Appendix, with the grower's values filled in."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. No selection rule for the three reasons (ranking basis, whether adjustments are eligible, tie-break) and no source or owner for the ur/en wording; A.2 stores contributions and adjustments as separate lists unlinked to reasons.

**Skeptic's caveats.** "INV-8 cannot be tested" overstated (A.2 Score supplies hash and breakdown); A.3's pure function rules out generated text; the fix's choices need Ahsan

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "INV-8 cannot be tested" overstated (A.2 Score supplies version and breakdown). The fix's choices need Ahsan.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Three largest positive contributions plus the largest penalty over 10 points; fixed Urdu/English sentence per level with values filled in; Marketing or Admin owns the wording

#### S66 · F-R6-12 · MAJOR · R6 Build
**Claim.** P3-8/P6-19: "incomplete data" has no definition, yet it switches exports off

**Rows.** P3-8, P6-19

**Quoted.** "P3-8 | Honest reporting: a non-dismissible notice when data is incomplete; export off while it is"

**Consequence.** A builder cannot write the condition. Is it a failing stream or a held signal? The only meaning in the spec ("partial read", A.4 K4) points at a client-side fetch that AR-12 and P6-1 forbid. Exports either never switch off or are always off.

**Proposed fix (reviewer's).** P3-8 (append): "Data is incomplete when any connected stream is failing, any signal has been held more than 1 hour, or the last successful aggregation is older than 1 hour; the notice names which."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. The only meaning in the spec ("partial read", A.4 K4) points at a client-side fetch that AR-12 and P6-1 forbid; nothing replaces it; P6-19's observable is a bare cross-reference to P3-8.

**Skeptic's caveats.** Drop "unmatched village" and "unsynced phone" from the candidate meanings; the fix's one-hour numbers are Ahsan's; "any failing stream switches exports off" sits awkwardly beside P4-6/INV-9

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "Unmatched village" and "unsynced phone" dropped from the candidate meanings. The fix's one-hour numbers are Ahsan's; "any failing stream switches exports off" sits awkwardly beside P4-6 and INV-9.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept (unparked 2026-10-01)): After clarification (export = download as spreadsheet): data is incomplete when a connected feed is failing or dashboard figures are older than N hours (Ahsan sets N); the dashboard warning names the cause; downloads stay allowed but the file carries the same warning (P3-8's "export off" changes)

#### S67 · F-R6-13 · MAJOR · R6 Build
**Claim.** P4-27a: whether an e-commerce purchase can create a lead is not stated

**Rows.** P4-27a, 4.2 E-commerce row, P1-7

**Quoted.** "P4-27a | … A confirmed 30-acre grower's online order appears on their timeline and re-scores their lead"

**Consequence.** The example assumes an open lead. For a qualifying grower with no open lead, the builder cannot tell whether a purchase creates a lead. If it does, an SUL gets a 14-day completion clock to sell to someone who has just bought. P1-7's "nine streams" suggests it does not.

**Proposed fix (reviewer's).** P4-27a (append): "A purchase never creates a lead; it joins the grower's timeline, feeds the history ingredient, and re-scores an open lead if one exists."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. No line states the rule; P1-7/5.3/P4-3 lean "no lead" while 4.1, P1-34 and P1-26 lean "lead"; where the spec means "signal but no lead" it says so (P1-25), and it does not here.

**Skeptic's caveats.** Severity contestable (e-commerce is not a Pilot stream); dedupe the fix with F-R6-26; "a purchase never creates a lead" is a product choice for Ahsan

**See also.** Fix together with F-R6-26 (S113): the stream count depends on whether a purchase can create a lead.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): A purchase never creates a lead: timeline, history score, re-scores an open lead; streams read "9 lead streams + 1 purchase stream"

#### S68 · F-R6-14 + F-R6-16 · MAJOR · R6 Build
**Claim.** Four rows have a "What you would see" that nobody can watch (P5-32, P4-12, P6-18, P5-35)

**Rows.** P5-32, P6-21, P5-33, P4-12, P6-18, P5-35

**Why one entry.** Same defect under P6-21's evidence rule on different rows; the F-R6-16 skeptic suggested merging.

**Severity.** Filed as F-R6-14 major, F-R6-16 minor; the entry takes the highest.


##### F-R6-14 · major as filed · R6 Build — P5-32 "Nothing visible" breaks P6-21's evidence rule

**Rows.** P5-32, P6-21, P5-33

**Quoted.** "P5-32 | … | Nothing visible; the engine's memory."  
Second line: "P6-21 | **Evidence.** Every rule in this document is proven by something Ahsan can watch: a screen, a count, a test that names the rule."

**Consequence.** The labelled-example store that P5-33 lift and every later engine depend on has no observable acceptance. If it is silently not written during the Pilot season, nobody knows until the learning engine has no data.

**Proposed fix (reviewer's).** P5-32 "What you would see" (replace): "Admin's Connections page shows 'Labelled examples: 4,120 (converted 610 · not converted 1,900 · unreachable 1,410 · below threshold 200)', and it equals the closed-lead count."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P5-32's observable names no screen, count or test; the only other "Nothing visible" row (P7-14) names the audit trail; A.2 has no labelled-example record and A.9 forces named tests for invariants only.

**Skeptic's caveats.** The lift-depends-on-the-store link is the reviewer's inference; the fix must say which count the examples equal (rejected is not in P5-32's list)


##### F-R6-16 · minor as filed · R6 Build — Rows whose "What you would see" cannot be watched

**Rows.** P4-12, P6-18, P5-35

**Quoted.** "P4-12 | A healthy Crop Doctor scan becomes a lead only when … (Part 1, P1-25). Below it or unknown: history only. | — |"  
Second line: "P6-18 | **No clutter.** Every SUL screen answers one question"

**Consequence.** P4-12 has a dash. P6-18's "answers one question" cannot be tested. P5-35 points to P4-9, which shows nothing about intent reading improving. Each fails P6-21.

**Proposed fix (reviewer's).** P4-12 see: "A healthy scan from a 6-acre grower shows on the timeline as 'Scan: healthy — no lead (below threshold)'." P6-18: drop "answers one question" or list each screen's question. P5-35 see: "Intent examples count per week on Admin's Connections page."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P4-12 is the only numbered row whose observable is a dash; nothing backs P6-18's "answers one question" or P5-35's examples being kept; R6-A1 commissioned this class.

**Skeptic's caveats.** P4-12 is mostly cosmetic (P1-25 covers the lead/no-lead half); could merge with F-R6-14; "Decision check" should say touches D9


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Connections shows learning-example counts by outcome and intent examples per week; P4-12 gets a timeline example; P6-18 lists each screen's question or drops the phrase

#### S69 · F-R6-19 · MAJOR · R6 Build
**Claim.** P1-2 allows automated WhatsApp to growers, which P5-9 forbids; P1-2 omits Hina (S1)

**Rows.** P1-2, P5-9, 6.3.2

**Quoted.** "P1-2 | Growers are never users. They are reached by an SUL, or by an automated WhatsApp message under the rules in Part 5."  
Second line: "P5-9 | Synapse sends **no automated WhatsApp message** to growers in phase 1. Hina is the only automated contact."

**Consequence.** A builder reading Part 1 builds a WhatsApp template sender. P1-2's list of ways to reach a grower also leaves out Hina's automated voice call, the only automated contact that actually exists.

**Proposed fix (reviewer's).** P1-2 (replace second sentence): "They are reached by their SUL, or by Hina's automated call under the rules in Part 5; Synapse sends them no automated WhatsApp message in this phase."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P1-2 still names automated WhatsApp to growers and omits Hina; P5-9, 6.3.2 and the 2026-09-21 decision forbid and park it; P1-2 has no revision note unlike its neighbours.

**Skeptic's caveats.** "DR check: none" inaccurate (DR-24/25 record the canvas departure; this is spec-vs-spec); severity may be a stale-row wording defect rather than major

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S70 · F-R6-21 · MAJOR · R6 Build
**Claim.** 2.5 still shows D1 open and suppresses Cropwise leads (S3)

**Rows.** 2.5 D1, P2-19, 1.7 D1, 4.6 D1, 6.4 D1

**Quoted.** "2.5 | D1 | Consent for advisory-captured data | Open | P2-19: Cropwise-sourced leads absent until decided."  
Second line: "4.6 | D1 | … | **Decided 2026-09-18** — any contact with Syngenta is the consent basis | P4-23; Cropwise-sourced growers routed from day one"

**Consequence.** A builder of the SUL app (Part 2) hides every Crop Doctor, Savera and community lead. Crop Doctor is a Pilot stream.

**Proposed fix (reviewer's).** 2.5 D1 (replace): "Decided 2026-09-18 | P2-19: every lead carries its consent basis; Cropwise-sourced leads are shown from day one."

**Decision check.** touches D1. What it leaves unspecified: nothing; the table is stale.

**Skeptic (Fable 5.1).** Survived. 2.5's D1 row is stale against DECISIONS 2026-09-18 and three sibling tables; no precedence rule or revision note lets a reader resolve it; P1-12 carries a revision note, 2.5 does not.

**Skeptic's caveats.** The harmful behaviour arises only if a builder implements 2.5's gloss of P2-19 as a source filter; the numbered rows alone would show the leads

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S71 · F-R6-22 · MAJOR · R6 Build
**Claim.** 1.7 and 2.5 still show D4 open, and 1.7 promises a split action (S3)

**Rows.** 1.7 D4, 2.5 D4, 4.6 D4, 6.4 D4, P4-17

**Quoted.** "1.7 | D4 | … | Open — recommended yes; confirmed in M3 | P1-8 assumes it; a split action exists for shared numbers (Part 4)."  
Second line: "4.6 | D4 | … | **Decided 2026-09-18** — one number, one grower, no split, SUL corrects | P4-16 to P4-18."

**Consequence.** Every other mention says there is no split, so a builder is unlikely to build one; the live risk is 1.7's "confirmed in M3", which reads as identity resolution still unconfirmed.

**Proposed fix (reviewer's).** 1.7 D4 and 2.5 D4 (replace): "Decided 2026-09-18 — one number, one grower; no split action; the SUL corrects a wrong number (P4-17)."

**Decision check.** touches D4. What it leaves unspecified: nothing; the tables are stale.

**Skeptic (Fable 5.1).** Survived. 1.7 and 2.5 list D4 Open and 1.7 says a split action exists, against 4.6, 6.4, P4-17, 6.3.2 and DECISIONS 2026-09-18; 1.7's D1 row was updated after that date, so the table is maintained and the D4 row was missed.

**Skeptic's caveats.** Builder impact limited: every other mention says no split; the live risk is "confirmed in M3" reading as unconfirmed identity; severity arguably minor

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Builder impact is limited as above; severity arguably minor.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S72 · F-R6-24 · MAJOR · R6 Build
**Claim.** "Exactly one SUL" is a schema constraint, yet a territory with no SUL is a routing case (S4)

**Rows.** P1-3, P7-2, P7-9, J14.5, A.2 Sales structure, P5-22

**Quoted.** "A.2 | Sales structure — … sul (reference; exactly one per territory)"  
Second line: "P7-9 | A **structure gap** — … a territory with no SUL — sends the lead to the regional pool for the RSM"

**Consequence.** If a builder makes `sul` NOT NULL (A.2 and P1-3), the Territories page cannot hold the gap that P7-2 and J14.5 display, and P7-9's routing branch is dead code. If `sul` is nullable, P1-3 is false.

**Proposed fix (reviewer's).** P1-3 (replace): "A territory has at most one SUL; a territory with none is a gap (P7-2) and its leads go to the regional pool (P7-9)." A.2: "sul (reference, optional; at most one per territory)".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P1-3, the 7.1 table and A.2 say "exactly one" SUL with no optional marker (A.2 uses "optional" elsewhere); six rows require a vacant territory to be representable.

**Skeptic's caveats.** A.2 does not mark `sul` as req, so a Part 7 reader would build it nullable (severity); the fix must keep "every SUL owns exactly one territory" and also touch 7.1 and P5-22

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Human moves only: Admin moves open leads on the RSM's request, logged; territory SUL optional; no-location lead goes to Hina first; bulk re-place after a bad boundary file; queues show oldest item and alert

#### S73 · F-R6-30 · MAJOR · R6 Build
**Claim.** List order has three definitions

**Rows.** P5-20, P2-2, P1-23, P1-18, P5-17, P2-21, J1.3

**Quoted.** "P5-20 | Inside every segment: flagged leads first, then today's due leads … then by score, then by age."  
Second line: "P5-17 | … tagged "meets Hot conditions" and first in its campaign when it does."

**Consequence.** In a campaign list, a flagged lead and a Hot-tagged lead both claim first place. A sort-order test cannot be written.

**Proposed fix (reviewer's).** P5-20 (replace): "Inside every segment and every campaign: flagged, then due today (including follow-up dates), then Hot-tagged (campaigns only), then by score, then by age." Make P1-18, P2-2 and P2-21 cite P5-20 rather than restate it.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P5-20 ("flagged first") and P5-17/P1-18 ("Hot-tagged first in its campaign") are both R-marked and collide on a flagged campaign lead, a path J19.3 designs; no row ranks them.

**Skeptic's caveats.** The follow-up "third claimant" is already in P5-20's due tier, so two claimants, not three; untestable for campaign lists only; grouping by product/crop leaves "first" ambiguous too

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). The follow-up "third claimant" is already inside P5-20's due tier, so there are two claimants, not three. The gap is untestable for campaign lists only; grouping by product or crop leaves "first" ambiguous too.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All SUL-app fixes, including the receipt duplicate check and RSM sampling

#### S74 · F-R6-39 · MAJOR · R6 Build
**Claim.** Intent reading in regional and transliterated Urdu has no accuracy target or sample test

**Rows.** P4-9, P4-10, P5-21, P5-35

**Quoted.** "P4-9 | Intent is read from the grower's words in Urdu, English, regional languages and transliterated Urdu."

**Consequence.** Hot gates on intent (INV-4) and "unsure" sends a lead to Hina. No row sets an accuracy floor, a labelled sample set, or a gate before the Pilot. The canvas names exactly this as the risk: "regional-language and transliterated-Urdu accuracy — test on real message samples early". The Pilot could ship a classifier that marks most Roman-Urdu messages "unclear", flooding Hina.

**Proposed fix (reviewer's).** New P4-9a: "Before the Pilot, intent reading is tested on at least 500 real, anonymised messages labelled by the field, split by language; it ships only if 'buy' precision is at least 0.85 and 'unclear' is at most 25%; the result is recorded in the M2 or M8 evidence."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P4-9's fallback handles only the "unsure" direction; no accuracy floor, sample set or pre-Pilot gate; PLAN M4's contract test checks payload shape; the canvas names this exact risk.

**Skeptic's caveats.** The false-"buy" direction (INV-4 exposure) is the more serious one and is missing from the finding; fix numbers need Ahsan; "real anonymised messages" must be reconciled with PROCESS §12; the gate belongs in M4

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Intent reading tested before the Pilot on anonymised real messages labelled by the field, split by language, with accuracy and "unclear" bars Ahsan sets; gate in M4

#### S75 · F-R6-42 · MAJOR · R6 Build
**Claim.** The timing table has no region; one set of months cannot fit Hyderabad and Lahore

**Rows.** 5.3 Season timing, 6.1 Timing table, A.2 Timing, 4.5 Products

**Quoted.** "5.3 | **15** | Season timing | … | A crop-and-window table (crop, problem, months) owned by Marketing in Admin"

**Consequence.** Sowing dates, and so spray windows, differ between lower Sindh and central Punjab, and all four zones are in scope. A table keyed only by crop and problem scores "window open now" for leads in one province while the window is closed or not yet open in the other. That produces the misleading reason "Spray window open for cotton whitefly" (P5-11 example).

**Proposed fix (reviewer's).** A.2 Timing (replace): "crop · problem · zone (or province) · months"; 5.3: "…a crop-, problem- and zone-specific window table; a missing zone row falls back to the national row."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. The timing table is keyed by crop and problem only in 5.3, 6.1 and A.2; four zones span Sindh and Punjab; the 2026-09-21 entry decided owner and neutral default, not regional variation; the canvas treated timing as local.

**Skeptic's caveats.** "Decision check" should cite DECISIONS 2026-09-21 (table shape), so the fix is an amendment for Ahsan; the agronomic premise is not verifiable in the repo; severity depends on the Pilot zones

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Timing table gets a zone (or province) column; missing zone falls back to the national row

#### S76 · F-R6-43 · MAJOR · R6 Build
**Claim.** "Last season's status" is undefined for a grower with more than one lead in a crop year

**Rows.** P1-26, P1-17, P5-19, P6-13, A.2 Grower.last_season_status, 5.3 Grower history

**Quoted.** "A.2 | Grower — … last_season_status (choice: converted / not converted / unreachable / untouched / none)"  
Second line: "P6-13 | **Season.** One season a year: a crop year of twelve months from a start date Admin sets."

**Consequence.** A grower who converted on Kharif cotton and was unreachable on Rabi wheat in the same crop year has two outcomes and one field. The card tag (P1-26), the Last season tab (P1-17) and the history ingredient each pick one, and nothing says which.

**Proposed fix (reviewer's).** P1-26 (append): "Last season's status is 'converted' if any lead converted in the previous crop year (with the sum of PKR), else the latest outcome of that year."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P1-34 and J4.3 create several leads per grower per crop year; A.2 stores one last_season_status with no derivation rule; the card tag, the tab and the history ingredient all read it.

**Skeptic's caveats.** Divergence risk is between Grower.last_season_status and Lead.last_season_tag; no Pilot consequence unless the Pilot spans a season start (see F-R4-8); "sum of PKR" in the fix needs Ahsan

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Status = converted if any lead converted that crop year, else latest outcome; tab appears from the first season start after go-live

#### S77 · F-R6-44 · MAJOR · R6 Build
**Claim.** Healthy-scan leads (D9) have no recommended product, yet P2-7 promises one on every card

**Rows.** P1-25, P2-7, J2.1, 5.3 Crop need, 4.5 Products, P1-38

**Quoted.** "P2-7 | The consent basis and the recommended product are shown on every lead card. … | "Suggested: <product> for <problem>""  
Second line: "J2.1 | … recommended product where known (no PKR estimate)"

**Consequence.** A healthy 40-acre scan (P1-25) has no problem. `Product.treats (crop, problem)` has no preventive entry, and crop need scores it at the bottom ("Healthy or preventive"). Yet it carries a 14-day completion clock (P1-38). D9's own reason explains why the lead exists, but P2-7 and J2.1 disagree on whether the card must show a product.

**Proposed fix (reviewer's).** P2-7 (replace first sentence): "The consent basis is shown on every lead card; a recommended product is shown where the crop and problem match a Product row, including preventive rows (problem = 'preventive') for healthy scans."

**Decision check.** touches D9. What it leaves unspecified: what the SUL offers on a healthy-scan lead.

**Skeptic (Fable 5.1).** Survived. P2-7 ("every lead card") and J2.1 ("where known") are both R-marked and give different rules for the same card field; Ahsan's answer said neither; a healthy-scan lead has no crop+problem to match a Product row.

**Skeptic's caveats.** "nothing to offer" is answered by D9's own reason; preventive Product rows are new scope for Ahsan; the gap also covers "diagnosis unknown" scans

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "Nothing to offer" is answered by D9's reason and is replaced. Preventive Product rows are new scope for Ahsan. The gap also covers "diagnosis unknown" scans.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All SUL-app fixes, including the receipt duplicate check and RSM sampling

#### S78 · F-R6-45 · MAJOR · R6 Build
**Claim.** No registration or label check on product recommendations

**Rows.** P2-7, 4.5 Products, A.2 Product, J3.2

**Quoted.** "A.2 | **Product** — id · name · portfolio · brand · treats (list of crop, problem)."

**Consequence.** Marketing and the PMs enter `treats` freely. Nothing requires a treats row to match a crop the product is registered for in Pakistan, so "Suggested: <product> for <problem>" can recommend an off-label use on the lead card.

**Proposed fix (reviewer's).** A.2 Product.treats (replace): "list of (crop, problem, registration reference)"; new P4-31: "A product is suggested only for a crop and problem on its Pakistan registration; Admin cannot save a treats row without a registration reference."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. The Products list is the sole source of the on-card recommendation and nothing constrains a `treats` row; P4-28 checks completeness only; DR-22 covers price and dose; 6.3.2 parks nothing on registration.

**Skeptic's caveats.** Severity contestable (shown to a trained SUL, Post-Capture); J3.2 is tangential; one registration regime may not fit every portfolio (biologicals, seed care); no R5 legal companion was filed

**See also.** F-R7-19 (S92) asks for an agronomic approver on the same list.

**TRIAGE:** ( ) accept  (x) reject — reason: Ahsan: "SULs should allow off label recommendations." No registration check on product suggestions  ( ) park — trigger:  
**Ahsan's decision** (reject): Ahsan: "SULs should allow off label recommendations." No registration check on product suggestions

#### S79 · F-R6-46 · MAJOR · R6 Build
**Claim.** Threshold on total acreage or per-crop acreage is not stated (S22)

**Rows.** P1-19, P1-22, P1-14, P1-25, J7.2, P4-21, A.2 Grower.acreage

**Quoted.** "P1-19 | … the same number applies everywhere the threshold is used (Hot, hiding, healthy scans)."  
Second line: "J7.2 | … Enters a number, optionally per crop; saved as **confirmed** on the grower"

**Consequence.** Take a grower with 15 acres of cotton and 10 of wheat, and a cotton lead. On total acreage (25) the lead is Hot. On the lead's crop (15) it is closed "below threshold", and P1-22 then stops routing that grower's later leads until a later verified value replaces the figure (P4-20). Excluding a grower depends on an interpretation the spec never makes.

**Proposed fix (reviewer's).** P1-19 (append): "The threshold is compared with the grower's total acreage across crops; where only per-crop figures exist, their sum." (Or per crop, but stated.)

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. A.2 stores acreage as a per-crop list with no total; Lead.below_threshold is "derived" with no derivation rule; the spec's own examples point both ways (P1-14 "30 acres of cotton" vs P1-20 "a 5-acre grower").

**Skeptic's caveats.** "permanent exclusion" slightly strong (P4-20 lets a later verified value replace it); "their sum" can exceed farm size where crops share land across seasons, so the basis is Ahsan's decision

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "Permanent exclusion" slightly strong, as above. A per-crop sum can exceed farm size where crops share land across seasons, so the basis is Ahsan's decision.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Threshold compared with total acreage across crops; where only per-crop figures exist, their sum

#### S80 · F-R6-50 · MAJOR · R6 Build
**Claim.** A lead with no location: Hina first or pool first, and which region's pool? (S13)

**Rows.** P5-1, P7-6, P5-23, P3-11, P5-7, P7-11

**Quoted.** "P7-6 | A lead with neither a coordinate nor a complete address goes to the regional pool, and the missing location is one of the gaps Hina asks the grower for"  
Second line: "P5-1 | A lead that has a number and is missing … a usable location (Part 7, P7-6) is **held for Hina** before any SUL sees it."

**Consequence.** Both rows claim the lead. If it is in the pool, the RSM can assign it (P3-11) while Hina is still calling, and then Hina's answer arrives for a lead already with an SUL. Worse, with no location, no region can be derived, so "the regional pool" has no region.

**Proposed fix (reviewer's).** P7-6 (replace): "A lead with no coordinate and no complete address is held for Hina (P5-1); only if Hina cannot get a location does it go to Admin's 'no location' list, or to the region of the stream's campaign or of the SUL who last served the grower, if any."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P7-6 sends a no-location lead to the regional pool while P5-1/P5-24 hold it for Hina; no row bars RSM assignment mid-hold; no row names a region for a lead with no coordinate; WhatsApp inbound (a Pilot stream) carries no location.

**Skeptic's caveats.** Bites only for growers with no location on record; the fix departs from Ahsan's 28 Sept "pool and Hina" answer and needs his decision

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Human moves only: Admin moves open leads on the RSM's request, logged; territory SUL optional; no-location lead goes to Hina first; bulk re-place after a bad boundary file; queues show oldest item and alert

#### S81 · F-R6-52 · MAJOR · R6 Build
**Claim.** "Reading intent never delays a lead", yet routing waits on the reading

**Rows.** P4-10, P4-9, P5-1, 5.1

**Quoted.** "P4-10 | Reading intent never delays a lead. The lead exists first; the reading follows. | A lead arrives with "reading…" and updates within a minute."  
Second line: "P5-1 | … A lead with no gap is routed at once."

**Consequence.** A lead is gap-free only when intent is clear, which is known only after the reading. So either the lead is routed "reading…" and must later be pulled back from the SUL to Hina if the reading comes back unsure (unspecified), or routing waits on the model call that P4-10 forbids.

**Proposed fix (reviewer's).** P4-10 (replace): "The lead record exists before the reading; routing waits for the reading for at most 60 seconds, after which the lead is treated as 'intent unclear' (P4-9)."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. A lead is gap-free only once intent is read; routed-with-"reading…" contradicts P5-1/P5-24, and waiting on the reading contradicts P4-10's "AI never in the delivery path", AR-25 and P4-3; A.3 puts extraction ahead of routing; no timeout or fallback exists.

**Skeptic's caveats.** The fix's 60 seconds is the reviewer's number; the fix must also touch AR-25 and P4-10's observable

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Lead created at once; routing waits at most N seconds for the intent read, then treats intent as unclear; P4-10 wording corrected; Ahsan sets N

#### S82 · F-R6-54 · MAJOR · R1 Field · R6 Build
**Claim.** Offline sync: "server's version wins" is undefined per server change, and clocks have no event time

**Rows.** J9.3, P6-6, A.3 offline line, P1-39, P1-29, P2-17, P1-36, P1-24

**Quoted.** "J9.3 | … if the same lead changed on the server meanwhile, the server's version wins on the record but the SUL's entry is kept in the history, never discarded"  
Second line: "A.3 | … sync on reconnect, server timestamp wins on the record"

**Consequence.** Two problems.

1. **Which server changes override the SUL's entry.** Server-side changes to a lead the SUL owns include re-score or segment move (P1-24), Admin removal (P1-36), territory change (P2-17: "old leads are no longer on their phone"), and threshold change. Under "server wins", an offline Converted (INV-6) on such a lead lands only in history, and the sale is absent from every count.
2. **Which time stops a clock.** If the server timestamp is used, a call made at 10:00 and synced at 18:00 marks a 24-hour Hot lead overdue.

**Proposed fix (reviewer's).** J9.3 (replace): "State changes by the SUL apply in logged order with the device's event time (checked against server receipt); only Admin removal or a change of territory overrides them, and then the entry goes to Admin's review list. Clocks stop at the event time."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. J9.3's "server's version wins" is lead-level with "changed" undefined, and P5-13's daily re-score makes it true for ordinary leads, so an offline Converted can sit in history only (covers merged F-R1-3).

**Skeptic's caveats.** The clock-time half is F-R1-2's; the fix departs from playbook rule A9 cited by A.3 and "checked against server receipt" gives no tolerance

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R1-3 (R1 Field, major) — The "server wins" conflict rule can wipe an offline conversion from the record.

**See also.** F-R1-2 (S6) holds the clock-time half.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Phone time: clocks start on phone receipt and stop at the phone's logged time; a synced on-time action withdraws the breach notice; a server re-score never overrides an SUL outcome

#### S83 · F-R6-55 · MAJOR · R6 Build
**Claim.** P7-10's SUL-confirmed location has no action, field or history (S25)

**Rows.** P7-10, 2.2 Act and log, A.2 Grower.position

**Quoted.** "P7-10 | The grower's location is the **most recent** coordinate from any signal, unless an SUL has **confirmed** the location on the profile; a confirmed location is not overwritten."  
Second line: "2.2 | **Act and log** | Call, WhatsApp, Navigate; log contact, visit planned, follow-up, converted, not converted, unreachable, reject; ask and log acreage; correct a grower's number"

**Consequence.** No action, journey or schema field lets an SUL confirm a location. A.2's `position (PII, optional)` has no status, source or history, although P7-10 requires "every change … in the history with its source". The rule cannot be built or tested.

**Proposed fix (reviewer's).** 2.2 Act and log: add "confirm the grower's location (phone GPS at the farm)". A.2 Grower: "position (PII) · position_status (from_signal / confirmed_sul) · position history (value, source, who, when)".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P7-10's confirmed branch is a decided rule (2026-09-28) with no action, journey, field or audit entry behind it: 2.2's action list has no location action and A.2 Grower.position has no status, source or history, unlike mobile and acreage.

**Skeptic's caveats.** True of the confirmed branch and history clause only; the default branch (most recent coordinate) is buildable

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Ambiguous or coarse addresses go to the pool with candidates; franchise change swept through 5.3, 5.9, 6.4 and 6.3.1 (Ahsan picks the serviceability test); confirm-location action with history; name the held list

#### S84 · F-R6-65 · MAJOR · R6 Build
**Claim.** Per-source credential vault and webhook signature verification are absent from A.3

**Rows.** A.3, P4-1, P4-5

**Quoted.** "A.3 | Webhook streams acknowledge within 100 ms and hand the work to a queue; extraction, Hina hand-off, scoring and routing run in workers with retries and a dead-letter queue"  
Second line: "per-source credentials in the vault" · "signature verification per provider"

**Consequence.** For WhatsApp, Meta, TikTok and campaigns, PLAN.md M4 builds signature verification into the connector template, so the gap there is a missing A.3 line and DR. For Hina's inbound nothing requires the call results to be authenticated, so a builder following A.3 accepts unsigned posts and forged answers can reshape leads and the one-grower record. There is no DR.

**Proposed fix (reviewer's).** A.3 (new line): "Every inbound webhook, Hina's included, verifies the provider's signature before acknowledging; an unsigned or invalid request is rejected and counted in Connections. Each stream's credentials live in a secrets vault, one per source, rotated by Admin."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. A.3 carries three of the four notes in the canvas L2 webhook cell and drops signature verification with no DR; SPEC.md has no hit for signature, vault, credential or secret; nothing requires Hina's inbound to be authenticated.

**Skeptic's caveats.** Consequence overstated for WhatsApp, Meta, TikTok and campaigns: PLAN.md M4 builds signature verification into the connector template. Unmitigated only for Hina's inbound. Vault half is closer to a missing cross-reference (playbook and Phase 3 INFRA.md own secrets). "Rotated by Admin" in the fix is the reviewer's invention and sits badly with PROCESS G3. Severity: Hina half major, provider half minor

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Severity split: Hina half major, provider half minor. The vault half is closer to a missing cross-reference (the playbook and Phase 3 INFRA.md own secrets). "Rotated by Admin" in the fix is the reviewer's invention and sits badly with PROCESS G3.

**See also.** F-R7-11 (S89) covers the Hina vendor's contract; this entry covers authenticating what Hina sends.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): After a plain-language explanation: every inbound feed, Hina's included, must carry a valid signature or is rejected and counted on Connections; key storage goes to Phase 3 INFRA.md; "rotated by Admin" dropped

#### S85 · F-R7-3 · MAJOR · R7 Open
**Claim.** A wrong boundary file: no bulk or Admin-initiated way to find and re-place the leads placed under it

**Rows.** P7-16, P7-11, P7-12, A.2 Lead placement, A.2 Boundary, P1-35, J21.6

**Quoted.** P7-16 "A new boundary file is loaded as a whole; the load is logged and the previous version kept."  
Second line: A.2 "**Lead placement** — lead · method (choice: boundary, converted_address, nearest_franchise, pool_assigned) · village · bsa · territory · distance_km (number, optional) · conversion_confidence (number, optional)."

**Consequence.** "Previous version kept" allows a restore only in two steps, by reloading the kept file. The placement record carries no boundary `file_version`; the affected leads can be derived from method, routing time and Boundary.loaded_at, but no row gives Admin that list. P7-11 ("a later change … of the structure moves future leads only. Open leads stay with their SUL") keeps every misplaced lead with the wrong SUL. The only remedy is each SUL rejecting "not my territory" one lead at a time, and Admin reassigning them one at a time (J21.6).

**Proposed fix (reviewer's).** P7-16a "Admin can restore the previous boundary version in one step. Every placement records the boundary file version it used, and a restore lists the open leads placed under the withdrawn version for Admin to re-place in bulk, each move logged." Add `boundary_file_version` to A.2 Lead placement.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P7-16 keeps the previous boundary version but no row makes it active again, lists leads placed under a bad file, or lets Admin move a non-rejected lead; P7-11, P3-19 and P5-26 freeze the misplacements.

**Skeptic's caveats.** Title overstates: a one-at-a-time path exists via P1-35 and J21.6, so the gap is "no bulk or Admin-initiated way". Restore is possible in two steps by reloading the kept file. Affected leads are derivable from method, routing time and Boundary.loaded_at, so file_version on the placement is one fix, not the only one. The bulk re-place is an exception to P3-19 (marked R), P7-11 and P5-26 and needs Ahsan's decision

**Changed from the raw report.** The claim and consequence were edited where the skeptic showed the raw text false or overstated (see the caveats). Title and consequence narrowed: a one-at-a-time path exists via P1-35 and J21.6, and file_version is one fix, not the only one. The bulk re-place is an exception to P3-19 (R-marked), P7-11 and P5-26 and needs Ahsan's decision.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Human moves only: Admin moves open leads on the RSM's request, logged; territory SUL optional; no-location lead goes to Hina first; bulk re-place after a bad boundary file; queues show oldest item and alert

#### S86 · F-R7-5 · MAJOR · R7 Open
**Claim.** The manual queues have no age, no backlog alert and no bound on their size

**Rows.** J21.5a, P4-18, P4-19, P3-11, J15, J21.6, P6-17, P6-9, P7-9

**Quoted.** J21.5a "Signals that arrived with no number and matched no grower, by source and campaign, with possible matches for a person to confirm"  
Second line: P6-9 "A campaign launch of 10,000 leads in twenty minutes loses nothing and slows nothing the SUL sees."

**Consequence.** P6-9 is written for automated ingestion. The same 10,000-lead burst creates human work with no bound. Forms without a village go to the pools (P7-5, P7-6), where each RSM assigns by hand. Doubtful matches go to DBO to confirm one at a time. Rejections go to Admin. None of these queues shows an age, has a target or raises an alert. A lead can sit in a pool with no clock (P5-23) indefinitely while every on-time rate stays green.

**Proposed fix (reviewer's).** P6-17a "Each manual list (no contact, possible matches, rejected, every regional pool) shows its count and the age of its oldest item. An item older than two working days is shown to its owner and to Admin as overdue, and the weekly summary counts it."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. Every row on the manual lists gives a count and none an age, target, alert or bound; pool leads are outside every breach path (P5-23, P5-31); P4-28 covers master-data lists and A.3 alerts only the dead-letter queue.

**Skeptic's caveats.** Burst pool load is smaller than implied (P7-6 also sends the gap to Hina); "shows its count" already exists; scope "overdue" to items a person can act on; the no-clock pool point is R2's

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Human moves only: Admin moves open leads on the RSM's request, logged; territory SUL optional; no-location lead goes to Hina first; bulk re-place after a bad boundary file; queues show oldest item and alert

#### S87 · F-R7-6 · MAJOR · R7 Open
**Claim.** Support hours leave failures after 18:00 and on non-working days unnoticed until the next working morning

**Rows.** P6-17, P4-15, P3-15, P5-8

**Quoted.** P6-17 "Support on working days, 9 to 6; the app and the clocks run every day."  
Second line: P6-17 (What you would see) "A failing stream is noticed by DBO the same morning."

**Consequence.** If WhatsApp or Hina fails at 18:10 on a Friday, DBO notices at 09:00 on the next working day. That is about 63 hours if working days are Monday to Friday, or about 39 hours if only Sunday is off ("working day" is undefined, F-R7-30), and longer over Eid. "The same morning" is true only for failures overnight between two working days. No row alerts anyone outside hours. P6-17 names the escalation point for Hina and hosting, but not for the WhatsApp provider or the address service, and gives no contact or response time for any.

**Proposed fix (reviewer's).** P6-17b "A stream, Hina or the address service failing for more than one hour sends an alert to the digital team's on-call contact at any hour; the vendor escalation contact and the expected response time are recorded per third party on Connections."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P6-17 gives support on working days 9 to 6 while the app runs every day; every health row is pull-only on the Admin portal; P3-14 and P2-15 hold no connection-failure notification; the only alert (A.3 dead-letter queue) has no recipient, no hours and no numbered row.

**Skeptic's caveats.** (1) "who calls the vendor" is a misread for Hina and hosting, which P6-17 names; the gap is the WhatsApp provider and address service, and no contact or response time for any. (2) "about 63 hours" assumes a two-day weekend; "working days" is undefined and P5-30 pauses Sundays only, so about 39 hours on that reading. (3) The fix is Ahsan's decision: add out-of-hours alert and on-call, or keep hours and correct the sentence to "next working morning". P1-42 limits the alert channel. Harm is delay, not loss

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Harm is delay, not loss. The fix is Ahsan's decision: add an out-of-hours alert and on-call, or keep the hours and correct the sentence to "next working morning". P1-42 limits the alert channel.

**See also.** F-R4-3 (S41) measures the wait; F-R7-30 (S124) defines the working day this entry depends on.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Failure over one hour alerts the digital team's on-call contact at any hour; each third party's escalation contact and response time recorded on Connections

#### S88 · F-R7-9 · MAJOR · R7 Open
**Claim.** The spec assumes every field SUL has a Syngenta email; nothing confirms it and there is no fallback

**Rows.** P1-6, P6-16, A.2 User, J21.1

**Quoted.** A.2 "syngenta_email (text, unique, must be a Syngenta address; the login)"  
Second line: P6-16 "a non-Syngenta address cannot register."

**Consequence.** If any Pilot SUL or RSM has no corporate mailbox (for example contract or distributor-payroll field staff), they cannot use Synapse and their territory is a gap from day one. The spec neither labels this an ASSUMPTION nor lists it as a dependency.

**Proposed fix (reviewer's).** Add to 6.4: "Dependency: every SUL and RSM in the Pilot zones holds a Syngenta email — Country IT confirms before M1 login work; if not, Ahsan decides the fallback."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. Syngenta email is the only way to register and log in (P1-6, P6-16, A.2, A.3); no line confirms every Pilot SUL and RSM holds one, no fallback, no assumption label; DR-18 covers SSO, not mailbox coverage.

**Skeptic's caveats.** Consequence is conditional: no document says staff without a mailbox exist, so present as an unverified precondition. Closes with one sentence if Country IT confirms coverage. The fix names 6.4, which is a decisions table, not a dependency list, so it needs a home chosen by Ahsan. J21.1 "IT gives the login" and P1-6 self-registration describe two different joining paths

**See also.** F-R5-14 (S48) covers the rules for the login this depends on. J21.1 "IT gives the login" and P1-6 self-registration describe two joining paths (seam S8).

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, as fact): Ahsan confirms every field SUL and RSM has a Syngenta email; state it in SPEC as a fact (no fallback needed)

#### S89 · F-R7-11 · MAJOR · R7 Open
**Claim.** The Hina vendor has no name, capacity, service level, data-handling terms or exit

**Rows.** 5.2 intro, P5-2, P5-3, P5-8, P6-17, A.3 (Hina)

**Quoted.** 5.2 "Hina is an AI voice agent built and run by a third party and connected to Synapse."  
Second line: P6-17 "the digital team (Admin) owns settings and is the escalation point to the third parties (Hina, hosting)."

**Consequence.** The 2-day bound in P5-5 holds only if the vendor can place calls as fast as leads arrive: up to 3,000 attempts a day normally and 15,000 a day in a burst (see F-R7-20). Nothing states that capacity. Nothing says what the vendor keeps: P5-3 bars audio and transcripts from *Synapse*, not from the vendor. Nothing says what happens to held leads if the vendor exits.

**Proposed fix (reviewer's).** P5-2a "The Hina vendor is named in the Admin connection with: calls per day it guarantees, time to first attempt, what it stores and for how long (no audio kept beyond [n] days), deletion when Synapse anonymises a grower, and a 30-day exit under which Hina can be turned off and held leads route at once (F-R7-1)."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. The Hina vendor has no name, capacity, service level, data-handling terms or exit rule anywhere in SPEC.md, DECISIONS.md or the input notes; P5-3 limits what Synapse receives, not what the vendor keeps; unlike P6-12 and P7-14 there is no pending marker.

**Skeptic's caveats.** Dedup notes: capacity consequence depends on F-R7-1's reading of P5-5; exit clause depends on F-R7-1 and volumes on F-R7-20; data-handling overlaps R5-A2 and seam S18, throughput overlaps R6-A3

**See also.** The data-handling half (what the vendor keeps) is F-R5-7's defect for one party (S47). Capacity links to the narrower claims of F-R4-13, F-R4-4 and F-R6-38 (section 2); volumes to F-R7-20 (S93). Authenticating Hina's inbound is F-R6-65 (S84).

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Hina connection records vendor name, calls per day, time to first attempt, storage and retention, deletion on anonymisation, and an exit: Admin can turn Hina off and held leads route at once

#### S90 · F-R7-16 · MAJOR · R7 Open
**Claim.** Required receipts build a record of each franchisee's selling prices that no one decided to hold

**Rows.** P1-30, J3.2, P6-14, P6-11, P1-31

**Quoted.** P6-14 "A receipt photo can be opened by the SUL who logged it and by everyone above them in the sales line up to Head of Sales; each opening is logged."

**Consequence.** Every conversion stores a Naya Savera franchisee's invoice: its price, any discount and the product, per grower. Anyone up to Head of Sales can open a single receipt (each opening logged, P6-14); no view collects the prices, and nothing forbids one. No row decides whether Syngenta may hold and use a reseller's selling prices, and no row says franchisees are told. Monitoring resellers' prices is a sensitive area under Pakistan's Competition Act 2010 (s.4, prohibited agreements on selling prices); legal should confirm.

**Proposed fix (reviewer's).** P6-14a "Receipts are evidence of the conversion only; their prices are never extracted, reported or used in any view; franchisees are told receipts are photographed; legal confirms before the Pilot."

**Decision check.** touches D7. What it leaves unspecified is the permitted use of receipt contents.

**Skeptic (Opus 5.5).** Survived. Every receipt rule covers who opens it (P6-14), how long it is kept (P6-11) and that it is the grower's PII (A.2 Outcome); none covers the franchisee's price data on it; no decision, DR or invariant covers it and the plan assigns this angle to R7-A2.

**Skeptic's caveats.** "Head of Sales can view these by territory" overstates: no view collects receipt prices, only single logged openings; the Competition Act s.4 point is for legal to confirm, not proven

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). The Competition Act s.4 point is for Legal to confirm, not proven; holding invoices is not itself a prohibited agreement.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Ahsan: "we just need an evidence of sale in shape of receipts; no need to go into prices." Receipts are evidence only; prices never extracted, reported or used; franchisees told receipts are photographed; Legal confirms before the Pilot

#### S91 · F-R7-17 · MAJOR · R7 Open
**Claim.** "No stock at the franchise" is captured but appears on no specified view, which defeats DR-1's stated reason

**Rows.** P1-32, J4.1, J4.2, DR-1, J14.2, J16.1, J18.1, J19.1, J20.1, P5-33

**Quoted.** DR-1 "Losses train the engine; "no stock" repeated across a district is a supply finding."  
Second line: P1-32 "requires one reason from a fixed list — no need · no budget · no stock at the franchise · bought a competitor · wrong contact"

**Consequence.** No manager, portfolio, marketing or leadership view shows not-converted reasons by district, BSA or franchise, and no supply or trade owner is named. The supply finding DR-1 gives as the reason for the list appears on no specified screen, count or owner (P3-9's Admin export, whose contents are unstated, could pull reasons in bulk). That is internally inconsistent.

**Proposed fix (reviewer's).** P3-6a "Not-converted reasons are counted by zone, region, territory and BSA on ZM, Head of Sales and PM views; 'no stock at the franchise' above [n] in a BSA in a week is flagged to the PM and DBO."

**Decision check.** none

**Skeptic (Opus 5.5).** Survived. DR-1 justifies the reason list by a "supply finding", but no Part 3 or Part 5 view counts not-converted reasons by area and no one is named to act; P5-33 is conversion by district, not reasons; DR-32 parks the stock feed, not reason reporting.

**Skeptic's caveats.** "can never be seen" is slightly overstated: P3-9's Admin export (contents unstated) could pull reasons in bulk, but no screen, count or owner exists

**Changed from the raw report.** The claim and consequence were edited where the skeptic showed the raw text false or overstated (see the caveats).

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, amended): Ahsan: no inventory threshold. All not-converted reasons are logged and reported to all stakeholders (counts by area); no alert

#### S92 · F-R7-19 · MAJOR · R7 Open
**Claim.** No agronomic owner: Marketing owns the "treats" list and the timing table

**Rows.** 5.3 Season timing, 4.5 Products, P2-7, J2.1, 4.7 Q12

**Quoted.** 5.3 "A crop-and-window table (crop, problem, months) owned by Marketing in Admin; scores the middle value until a row exists"  
Second line: 4.5 "Owner: Marketing with the Portfolio Managers; Admin enters changes and has full access"

**Consequence.** Every lead card shows "Suggested: <product> for <problem>" (P2-7) from the Products "treats" list, and scoring uses the timing table. Neither needs sign-off from anyone who owns agronomic truth. A wrong pairing reaches every lead card where a product is known (P2-7; J2.1 "where known").

**Proposed fix (reviewer's).** Revise 4.5 Products and Timing: "Owner: Marketing with the PMs; every 'treats' pairing and timing row is approved by Syngenta Pakistan's agronomy lead before it is used."

**Decision check.** none (the 2026-09-21 scoring entry names Marketing as owner of the timing table; this adds an approver and does not replace the owner)

**Skeptic (Opus 5.5).** Survived. Decisions (2026-09-21, 4.7 Q12) settle who owns products and the timing table, not who approves rows; P4-28 covers missing or rejected rows, not agronomic correctness; the PMs are defined commercially only; nothing requires agronomic sign-off.

**Skeptic's caveats.** Quote the Products owner in full ("Marketing with the Portfolio Managers"); "reaches every SUL conversation" overstates: P2-7 shows the suggestion only "where known"

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). The Products owner is "Marketing with the Portfolio Managers"; the spec defines the PMs commercially, not as the agronomic authority.

**See also.** F-R6-45 (S78) covers registration checks on the same list; F-R6-66 (S121) records the canvas departure on ownership.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, amended): PMs own and approve the agronomy (treats list and timing table); DBO manages if required. No separate agronomy lead

#### S93 · F-R7-20 · MAJOR · R7 Open
**Claim.** No row budgets any running cost; Hina alone can reach 90,000 call attempts a month

**Rows.** P5-2, P6-9, 4.2 Crop Doctor, P7-5, P7-14, P3-17, P6-12

**Quoted.** P6-9 "Up to 1,000 leads a day on a normal day. A campaign launch of 10,000 leads in twenty minutes loses nothing"  
Second line: P5-2 "**3 attempts over 2 days**, both Admin settings."

**Consequence.** Only leads with a number and a gap are held for Hina (P5-1), and a healthy scan with unknown acreage makes no lead (P1-25, P4-12), so the figures below are a ceiling, not the expected Crop Doctor load. Hina attempts are up to 1,000 × 3 = 3,000 a day and about 90,000 a month; at a 50% gap share that is 45,000 a month. One burst means up to 30,000 attempts within 2 days. At an illustrative PKR 20 per attempt that is PKR 0.9–1.8 million a month. Address conversions are up to 30,000 a month. WhatsApp business messages (P3-17) are small: roughly 4.3 a month × (RSMs + 4 ZMs + 1 Head of Sales + 4 PMs), and each needs an approved template. No row names a budget, a unit price or who pays.

**Proposed fix (reviewer's).** P6-24 "Running costs: each third party (Hina, address conversion, WhatsApp provider, hosting) is listed with its unit price, the monthly volume at P6-9's normal day and at one burst, and the budget owner; Connections shows month-to-date usage against it."

**Decision check.** none

**Skeptic (Opus 5.5).** Survived. Only campaign marketing spend is budgeted (P3-16, J20.2, A.2 Campaign); no row gives a unit price, volume budget or payer for Hina, address conversion, the WhatsApp provider or hosting; no 6.3.2 deferral, decision or DR covers running cost.

**Skeptic's caveats.** 90,000 attempts a month is a ceiling, not expected load: a healthy scan with unknown acreage creates no lead (P1-25, P4-12) and only leads with a number go to Hina (P5-1), which Cropwise supplies only "where it has it" (4.2)

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats).

**TRIAGE:** ( ) accept  (x) reject — reason: Budgets are managed outside Synapse  ( ) park — trigger:  
**Ahsan's decision** (reject): Budgets are managed outside Synapse

#### S94 · F-R7-23 · MAJOR · R7 Open
**Claim.** Moving the season start silently re-buckets every "last season" rule; stored tags go stale

**Rows.** P6-13, P1-17, P1-26, P5-19, P6-11, P2-13, A.2 Lead last_season_tag, A.2 Grower last_season_status

**Quoted.** P6-13 "One season a year: a crop year of twelve months from a start date Admin sets. "Last season" is the previous crop year"  
Second line: A.2 Lead "… last_season_tag …"

**Consequence.** The tag is stored on each lead, while the "Last season" tab and the two-crop-year inactivity count are computed from `season_start`. If Admin moves 1 April to 1 March, which leads count as "this season" changes, some growers may change tab, and the anonymisation clock shifts. No row says whether existing tags are recomputed.

**Proposed fix (reviewer's).** P6-13a "A change to the season start applies from the next season; tags already on leads are kept; the tab and the retention count use the season each lead was created in."

**Decision check.** none

**Skeptic (Opus 5.5).** Survived. season_start is an Admin-editable setting (A.2) that drives "this season" (P5-19), stored tags (P1-26, A.2) and the retention count (P6-11); P3-10 and P5-14 list which settings take effect at once and omit it; no rule says whether stored tags are recomputed.

**Skeptic's caveats.** Consequence overstates "tags and tab disagree": the Last season tab may derive from the stored tag; the other effects (which leads are this season, retention shift, no recompute rule) hold

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "Stored tags and the tab disagree" overstated: the tab may derive from the stored tag.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): A season-start change applies from the next season; existing tags kept; tabs and retention use each lead's creation season

#### S95 · F-R7-24 · MAJOR · R7 Open
**Claim.** "Take effect at once" for a changed promise does not say what happens to open leads' deadlines

**Rows.** P3-10, J21.2, P5-28, P1-38, A.2 Lead contact_clock/completion_clock, P5-29

**Quoted.** P3-10 "Settings changes (threshold, clock promises, weights, campaign promises) are made by Admin alone, take effect at once"  
Second line: A.2 Lead "contact_clock, completion_clock (start, promise_at, stopped_at, overdue yes/no)"

**Consequence.** `promise_at` is stored. If the change recomputes it, cutting Potential contact from 72 h to 24 h makes every open Potential lead older than 24 h overdue at once. That triggers one notification per lead to the SUL, RSM and ZM (P5-29) and a retroactive drop in on-time rates. If it does not recompute, "at once" is false for open leads. A builder must guess which.

**Proposed fix (reviewer's).** P3-10a "A changed promise applies to leads that reach an SUL after the change; open leads keep the promise_at they were given; the same holds for a campaign's promises edited mid-campaign."

**Decision check.** none

**Skeptic (Opus 5.5).** Survived. The spec states an in-flight rule for threshold (P1-19), weights (P5-14) and structure (P7-11, P3-19) but none for clock promises; promise_at is stored (A.2) and "take effect at once" (P3-10) reads either way; no decision or DR settles it.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): New leads only; a move up restarts clocks under the new promise, a move down keeps earlier due times

#### S96 · F-R7-31 · MAJOR · R7 Open
**Claim.** "phase 1 / phase 2 / this phase / second phase" break the naming decision; a builder would look up the wrong thing (seam S30)

**Rows.** 5.2 title and intro, P5-7, P5-9, 5.8, 5.9, 5.10 Q5/Q6/Q10, DR-25, 6.3.1, 6.3.2 (heading, rows), J8 intro, J12.2, 2.6 Q4, DR-13, P4-24, 4.7 Q10, 6.4 D1/D6, P7-14, 7.5 Q8

**Quoted.** 5.8 "### 5.8 Hina in phase 2 — recorded, not specified"  
Second line: DECISIONS 2026-09-11 ""Phase" means a delivery phase 0–11 and nothing else."

**Consequence.** A builder reading "phase 2" looks up delivery Phase 2, which is the specification phase now under way (STATUS.md: "Phase 2, session 2.1"). They would read "Hina (phase 1)" as the Base44 audit. "This phase" has at least three meanings:
- P7-14 "built in this phase, not left to Phase 3" means Capture (M3).
- 6.3.2 "Out of scope for this phase" means the product until an unnamed change request.
- P4-24 and J8 "in this phase" give no end.
6.3.2 gives a "Returns when" condition for each parked item, but several say "Phase 2", spelled like the delivery phase under way now, so the conditions themselves are ambiguous. The spec never uses "Wave". (DECISIONS' own 2026-09-18 and 09-21 entries repeat the misuse.)

**Proposed fix (reviewer's).** Replace throughout: "Hina (phase 1)" → "Hina, gap-filling"; "Hina in phase 2" → "Hina as an AI SUL — a future change request, not scheduled"; "in this phase" / "Out of scope for this phase" → "in this specification (Pilot to Wave 3) unless a change request says otherwise"; P7-14 "built in this phase" → "built in Capture (M3)"; "next year or phase 2" → "a future change request".

**Decision check.** none

**Skeptic (Opus 5.5).** Survived. DECISIONS 2026-09-11 says "Phase" means a delivery phase 0–11 and nothing else; SPEC uses product-stage "phase 1/2", "this phase" and "Phase 2" (5.2, 5.8, 6.3.2, P7-14), and P7-14 mixes both meanings in one sentence; the only local definition (5.2) does not reach 6.3.2 or P7-14.

**Skeptic's caveats.** "Nothing says whether opt-out, split action or walk-in leads stay out through Wave 2 and 3" overstates: SPEC 58–59 specifies the whole product and 6.3.2 gives a "Returns when" condition per item; only the "phase" wording in those conditions is ambiguous

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "Nothing says whether … stay out through Wave 2 and Wave 3" overstated and replaced; only the "phase" wording in the conditions is ambiguous.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

### Minors (30)

#### S97 · F-R1-7 · MINOR · R1 Field
**Claim.** The conversion form holds one product and a whole number with no unit

**Rows.** P1-30, J3.2, J3.3, A.2 Outcome

**Quoted.** A.2 "product (reference, req for converted) · quantity (whole number, req for converted)"

**Consequence.** A real receipt often has an insecticide and a fungicide, or 1.5 litres or 250 ml packs. The SUL must pick one product and type a unitless whole number, so the product attribution and quantity are wrong on honest entries. It is also unclear whether the PKR value is the receipt total or one product's share.

**Proposed fix (reviewer's).** Revise P1-30: "A conversion carries one or more product lines, each with product, quantity and unit as on the pack; the PKR value is the receipt total."

**Decision check.** touches D7. What it leaves unspecified is the multi-product receipt.

**Skeptic (Fable 5.1).** Survived. A.2 Outcome holds one product and a unitless whole number; Product has no pack size; D7 and DR-14 fix "required", not shape.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All SUL-app fixes, including the receipt duplicate check and RSM sampling

#### S98 · F-R1-10 · MINOR · R1 Field
**Claim.** J2.1 puts a score on the SUL card; P5-12 forbids any score number on SUL screens

**Rows.** J2.1, P1-10, P5-12

**Quoted.** J2.1 "score with top three reasons in the SUL's language"  
Second line: P5-12 "No score number on any SUL screen"

**Consequence.** A builder working from J2.1 and P1-10 ("score with its top three reasons") shows the number. P5-12 (21 Sept) says not to, so the two rows give two instructions for the SUL's card.

**Proposed fix (reviewer's).** Revise J2.1 and P1-10 to read "top three reasons in the SUL's language (no score number, P5-12)".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. J2.1 and P1-10 keep "score" (glossary: "the number") on the SUL card; P5-12 (21 Sept) forbids it; no revision note or precedence rule reconciles them.

**Skeptic's caveats.** Plan §9 would class this major, filed as minor

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All SUL-app fixes, including the receipt duplicate check and RSM sampling

#### S99 · F-R1-22 · MINOR · R1 Field
**Claim.** The SUL's notification list leaves out the scoring-weight notice that P5-34 sends to SULs

**Rows.** P2-15, P5-34, P1-42

**Quoted.** P2-15 "Notifications: a new Hot lead, a lead moved up a segment, overdue on either clock, a manager's flag. In-app and push only."  
Second line: P5-34 "Head of Sales, ZMs, RSMs and SULs are all notified of an applied change"

**Consequence.** A builder working from P2-15 omits the notice. A builder working from P5-34 sends an Admin-written English "Reason: …" to an Urdu-mode SUL, against P2-9's "every … notification in the chosen language".

**Proposed fix (reviewer's).** Revise P2-15 to add "an applied change to the scoring weights (P5-34), with its reason in the SUL's language".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P2-15 and the 2.2 Notifications row give the SUL four notification types; P5-34 (21 Sept decision) adds a weight-change notice to SULs; never reconciled.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): All SUL-app fixes, including the receipt duplicate check and RSM sampling

#### S100 · F-R2-18 · MINOR · R2 Sales leadership
**Claim.** A weight change notifies different people depending on who made it

**Rows.** P5-14, P5-34, J21.2, P3-10

**Quoted.** P5-14 "every change is recorded with who, when and the previous value, takes effect at once for new scores, and notifies Head of Sales."  
Second line: P5-34 "Admin applies or rejects; Head of Sales, ZMs, RSMs and SULs are all notified of an applied change"

**Consequence.** When Admin applies an engine proposal, everyone is told. When Admin changes the same weight by hand, only Head of Sales is told, and every SUL's list is silently re-ordered.

**Proposed fix (reviewer's).** P5-14 (end): "…and notifies Head of Sales, ZMs, RSMs and SULs, as in P5-34."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. The two recipient lists come from two Ahsan answers (3.6 Q7 on 18 Sept; 21 Sept for applied proposals), neither a D-decision or DR; no row says a hand-made weight change deserves fewer recipients.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, widened): Any weight change, by hand or from a proposal, notifies the same list, and Ahsan adds that all stakeholders are notified

#### S101 · F-R2-21 · MINOR · R2 Sales leadership
**Claim.** Two Pilot zones on a four-zone "national" view

**Rows.** 1.1 Pilot, J17.1, J18.1, P3-6, P7-1

**Quoted.** 1.1 "The Pilot is the go-live subset (Crop Doctor, WhatsApp and one campaign, two zones, the first scorecard)."  
Second line: J17.1 "All zones side by side on the same numbers, plus national on-time rates for both clocks"

**Consequence.** The two zones that are not live either show zeros, which P3-6 reads as "short of leads", or are dropped silently while two zones are labelled "national".

**Proposed fix (reviewer's).** P3-22: "A zone, region or territory not live shows 'not live', never zeros; 'national' is labelled with the live zones ('National — Pilot, 2 of 4 zones')."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P3-8, P7-2 and P6-20 each key on a different condition (incomplete data, unassigned person, missing value); none fires for a staffed zone with no Pilot streams; no live/active attribute on a zone.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Pilot column in A.1 plus a Pilot section: zones named before M8, training, last sync to RSMs, exit and Wave 2 gate (no duplicate of Phase 9), D2 fallback, SUL headcount, "not live" zones; Ahsan marks Pilot rows

#### S102 · F-R2-22 · MINOR · R2 Sales leadership
**Claim.** "Year" and "quarter" are not tied to the crop year

**Rows.** P3-7, P2-16, J10.2, P6-13, P3-2

**Quoted.** P3-7 "Period presets everywhere: today, this week, month to date, quarter, year, custom; every number says its period."  
Second line: P6-13 "One season a year: a crop year of twelve months from a start date Admin sets."

**Consequence.** "Year" could be the calendar year or the crop year starting 1 April, and "quarter" either. The week's start day is not stated either. Head of Sales and Leadership can get two "year" totals, against P3-2.

**Proposed fix (reviewer's).** P3-7a: "'Year' and 'quarter' are calendar; 'Season' is a separate preset for the crop year (P6-13); a week runs Monday to Sunday, Pakistan time."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. No row defines the "year"/"quarter" presets against the Admin-set crop year (P6-13) or the week's first day; A.2 has no period type; P3-2 promises one definition.

**Skeptic's caveats.** "Pakistan time" in the fix is already P6-5

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): "Year" and "quarter" are calendar periods; a separate "Season" preset for the crop year; weeks run Monday to Sunday

#### S103 · F-R2-24 · MINOR · R2 Sales leadership
**Claim.** The completion on-time rate is missing from views that P3-5 says show both rates

**Rows.** P3-5, J14.2, J16.1, J22.1, P1-43

**Quoted.** P3-5 "Two on-time rates, contact and completion, contact first, at every level."  
Second line: J16.1 "leads received, contacted on time, completed, converted, PKR, overdue — for the chosen period"

**Consequence.** J14.2, J16.1 and J22.1 list "contacted on time" and a plain "completed" count, not "completed on time". A builder following the journeys drops the Pilot's second headline rate from the SUL, region and weekly views.

**Proposed fix (reviewer's).** J14.2, J16.1 and J22.1: replace "completed" with "completed, completed on time".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. J14.2 and J22.1 list "completed" without "completed on time" and no other row supplies the SUL-level or weekly completion rate that P3-5/P5-31 require.

**Skeptic's caveats.** J16.1 is mitigated by J16.2/P3-6 (consistency edit only)

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept (unparked 2026-10-01)): One formula in P5-31: of the leads whose deadline fell in the period or that were finished in it, the share finished on time; Closed: unreachable counts as finished; follow-up dates don't count; P1-43 points to it; J14.2, J16.1 and J22.1 add "completed on time"

#### S104 · F-R3-12 · MINOR · R3 Marketing
**Claim.** "Never … village" does not say whether an aggregate count by village is allowed

**Rows.** P1-4, P3-9, J20.5, P3-3

**Quoted.** P1-4: "Marketing and Portfolio Managers see campaigns, brands and totals, never a grower's name, number or village."  
Second line: J20.5: "Aggregate figures to a spreadsheet, never a grower's name, number or village;"

**Consequence.** One builder allows a "leads per village" aggregate export, which works as a targeting list at village grain. Another forbids all geography below the zone. P1-4 reads either way, and neither row names the lowest geography Marketing may see.

**Proposed fix (reviewer's).** P1-4 becomes: "… never a grower's name or number, and no figure below district level."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. No row, decision or DR states the lowest geographic grain in Marketing's views or exports; J20.5's "aggregate figures" is unbounded and P5-33 computes by district with no viewer named.

**Skeptic's caveats.** The fix as drafted in P1-4 would break the PM's territory drill; scope it to Marketing or exports

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, amended): Marketing and PMs both keep the zone → region → territory drill; nothing finer than territory (no village-level counts or exports)

#### S105 · F-R4-8 · MINOR · R4 Product
**Claim.** The "Last season" tab and tag are empty until the first season start after go-live, because nothing can bring last season in

**Rows.** P1-17, P1-26, P4-27, P4-2, P6-13, P5-19

**Quoted.** P1-17 "Inside Potential, a separate tab shows **last season's growers**: those converted last season and those never touched last season, so the SUL can start the season from known ground."  
Second line: P4-27 "Nothing is stored about a grower that no stream or SUL gave." · P6-13 ""Last season" is the previous crop year"

**Consequence.** In the first crop year Synapse runs there is no previous crop year inside Synapse. Smart Agro Lite history cannot enter: there is no upload (P4-2) and no outside data (P4-27). So the tab and P1-26's "Last season: converted, PKR 85,000" tag are empty until the first season start after go-live. The promise to "start the season from known ground" fails. (S23, proactive list versus signal-driven, is R1's.)

**Proposed fix (reviewer's).** Add to P1-17: "The tab appears from Synapse's second crop year; it is not built for the Pilot."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. No import, migration or backfill path exists (P4-2, P4-27, P1-7, AR-23, Base44 read-only decision); A.2's `last_season_status: none` anticipates the state; no row says what the tab shows before a second crop year.

**Skeptic's caveats.** "empty for 12 months" is exact only if go-live coincides with season start; provable statement is "empty until the first season start after go-live"

**Changed from the raw report.** The claim and consequence were edited where the skeptic showed the raw text false or overstated (see the caveats). "Empty for 12 months" is exact only if go-live coincides with the season start; the provable statement is used.

**See also.** F-R1-23 (S16) asks what the tab is; F-R6-43 (S76) what "last season's status" means.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Status = converted if any lead converted that crop year, else latest outcome; tab appears from the first season start after go-live

#### S106 · F-R4-11 · MINOR · R4 Product
**Claim.** Leadership's "whether the funnel is growing" has no growth number

**Rows.** 1.2 (Country Leadership), J18.1, P3-7

**Quoted.** J18.1 "National funnel by source and by campaign; conversions and PKR by zone and by portfolio; on-time rates; leads below threshold as a count; whether the scoring engine beats a plain list"

**Consequence.** "Growing" needs a comparison with an earlier period. P3-7 gives single-period presets, and J18.1 lists no change from a previous period, so Leadership reads growth by eye across two screens.

**Proposed fix (reviewer's).** Append to J18.1: "each figure beside the same figure for the previous period and its change".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. 1.2's "funnel is growing" needs a cross-period comparison; J18.1, P3-18, P3-7 and P5-33 give no prior-period figure or trend; the only trend line is J10.1 on the SUL summary; nothing defers it.

**Skeptic's caveats.** The "no comparison (17 Sept)" answer binds J10 only

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Outcome measure against a pre-go-live baseline, plain list = arrival order among contacted leads, signal-to-first-contact time, monthly summary contents, previous-period comparison; Ahsan sets targets

#### S107 · F-R4-16 · MINOR · R4 Product
**Claim.** 1.1 changes the Pilot's "one NPI campaign" to "one campaign" with no DR

**Rows.** 1.1, 4.2 (NPI campaign, Brand campaign)

**Quoted.** 1.1 "The Pilot is the go-live subset (Crop Doctor, WhatsApp and one campaign, two zones, the first scorecard)."  
Second line: DECISIONS 2026-09-11 "The Pilot is Crop Doctor + WhatsApp + one NPI campaign, two zones, Engine v1." (the canvas line 29 says the same)

**Consequence.** 4.2 has two separate campaign streams, NPI and Brand. The Brand campaign stream arrives the same way as the NPI one, so the difference is the NPI flag and its reporting, not the connector; the canvas departure has no DR in 1.9.

**Proposed fix (reviewer's).** 1.1: "…WhatsApp and one NPI campaign…". Or, if a brand campaign is allowed, add DR-34 recording the change.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. 1.1 drops "NPI" from the 2026-09-11 Pilot definition; no DR or later DECISIONS entry records the change; plan rule 3 says a canvas departure with no DR stands.

**Skeptic's caveats.** "cannot tell which connector" overstated: Brand campaign arrives "as above"; the difference is the NPI flag and reporting

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats).

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, amended): Ahsan: "there could be one or multiple campaigns running at a time; either it's NPI or just a brand campaign; we are just tagging if it's NPI." The Pilot allows one or more campaigns, NPI being a tag. Changes the 2026-09-11 "one NPI campaign" wording, so it needs a DECISIONS entry and a DR at apply time

#### S108 · F-R5-6 · MINOR · R5 Trust
**Claim.** The consent basis is "one per lead" in 6.1 but a column on "every grower row" in A.3

**Rows.** 6.1 Consent basis, A.2 Signal, A.3

**Quoted.** 6.1 "**Consent basis** (one per lead) | The stream and the date of the grower's own contact with Syngenta that the lead came from"  
Second line: A.3 "Consent basis is a NOT NULL column derived from the signal (A6, INV-1). Every grower row carries it from the first migration."

**Consequence.** A builder puts the basis on the grower, so one old contact covers every later lead. That is the opposite of per-lead consent. A.2 puts it on the signal ("never null on a lead"), so there are three placements.

**Proposed fix (reviewer's).** A.3: "Consent basis is a NOT NULL column on every lead, derived from the signal that created it (A6, INV-1)."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. Three placements of the consent basis (6.1 per lead, A.2 on Signal, A.3 on every grower row) cannot be one schema; D1 entry says per lead.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, amended): Consent per lead. Ahsan adds: "any incoming lead will be considered with the consent done; no need to keep and manage the consent separately." Confirmed reading: consent = the incoming contact, auto-stamped (stream and date) on every lead; no manual consent management; INV-1 holds

#### S109 · F-R5-11 · MINOR · R5 Trust
**Claim.** E-commerce "does not enter Synapse" cannot hold unless the filter runs on the e-commerce side, and the spec does not say where it runs

**Rows.** P4-27a, 4.2 E-commerce, P4-27

**Quoted.** P4-27a "A confirmed 30-acre grower's online order appears on their timeline and re-scores their lead; a 10-acre or unconfirmed grower's order does not enter Synapse."

**Consequence.** The only mechanism given is a scheduled pull. Unless Synapse asks the platform by number, it receives every purchase with its number to decide whether the buyer is a confirmed grower at or above the threshold, so every buyer's number and order enters Synapse, if only briefly. The row's promise is false unless the e-commerce side does the filtering.

**Proposed fix (reviewer's).** Amend P4-27a: "Synapse sends the e-commerce platform the list of eligible numbers, and the platform returns purchases for those numbers only. No other purchase is received, queued or logged."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. The only mechanism is a scheduled pull whose cited canvas pattern is a watermark poll; a builder can pass the visible acceptance with pull-all-then-discard; A.3 has no e-commerce line.

**Skeptic's caveats.** "must receive every purchase" overstated (Synapse can ask by number); logs leg already covered by A.3; the fix sends eligible numbers outward, itself a personal-data flow

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). "Must receive every purchase" overstated (Synapse can ask by number); the logs leg is covered by A.3. The fix sends eligible numbers outward, itself a personal-data flow.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Keep the pull; orders from buyers who are not confirmed growers at or above the threshold are discarded on arrival, never stored or logged

#### S110 · F-R5-19 · MINOR · R5 Trust
**Claim.** "Only what the streams and SULs gave" leaves out Hina and the geocoder, both of which put data on the grower

**Rows.** P4-27, P6-10, P5-4, P7-5, 6.1 Grower

**Quoted.** P4-27 "The profile holds only what the streams and the SUL put there."  
Second line: P5-4 "Acreage from Hina is marked **confirmed by Hina** and treated like an SUL's confirmation: it stays on the grower"

**Consequence.** Hina is neither a stream nor an SUL (4.2 lists no Hina stream), and a converted address yields a derived coordinate (P7-5). P6-10 repeats "Only what the streams and SULs gave". The personal-data inventory Legal reads is therefore incomplete.

**Proposed fix (reviewer's).** Amend P4-27 and P6-10: "Only what the streams, Hina and the SUL gave, and coordinates converted from a given address."

**Decision check.** none.

**Skeptic (Fable 5.1).** Survived. P4-27/P6-10 say only streams and SULs give data; P5-4 stores Hina-given acreage on the grower and three lines separate Hina from the streams.

**Skeptic's caveats.** The record list Legal reads already contains Hina data, so the defect is the two rule sentences; the geocoder half rests on inference; P4-27 carries Ahsan's R mark, so the amendment needs his sign-off

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): P4-27 and P6-10 read "only what the streams, Hina and the SUL gave, and coordinates converted from a given address"

#### S111 · F-R6-15 · MINOR · R6 Build
**Claim.** P5-3 "short plain-words summary" has no length

**Rows.** P5-3, 6.1 Hina call

**Quoted.** "P5-3 | … and a short plain-words summary. No recording and no transcript enter Synapse."

**Consequence.** The inbound integration contract has no field limit, so "no transcript enters Synapse" cannot be tested: nothing stops a long summary being a transcript in all but name.

**Proposed fix (reviewer's).** P5-3 (append): "The summary is at most 300 characters, in Urdu, with an English version when the third party provides one; Synapse rejects and logs a longer one."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. "Short" has no number, so "no transcript enters Synapse" cannot be tested; A.2 holds one text field with no language while Score reasons are explicitly "ur and en"; P6-7's "summary in both" predates Hina.

**Skeptic's caveats.** The language half merges into F-R1-20; unique content is the length bound; the fix's "300 characters, in Urdu, rejects longer" needs Ahsan and must not drop the structured answers

**Changed from the raw report.** The claim and consequence were edited where the skeptic showed the raw text false or overstated (see the caveats). The language half is folded into F-R1-20; this entry keeps the length bound. The fix's "300 characters, in Urdu, rejects longer" needs Ahsan and must not drop the structured answers.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Hina's summary has a maximum length Ahsan sets; longer ones rejected and logged; structured answers unaffected

#### S112 · F-R6-17 · MINOR · R6 Build
**Claim.** "Acreage band" is used twice and never defined

**Rows.** P5-33, P6-11

**Quoted.** "P6-11 | … crops, acreage band, district and outcomes stay without identity."

**Consequence.** Anonymisation and the lift breakdown both need band edges. A builder picks them, and anonymised history stops matching the monitoring bands.

**Proposed fix (reviewer's).** A.2 Settings: `acreage_bands` (starting: <threshold · threshold–49 · 50–99 · 100+).

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. "Acreage band" appears only in P5-33 and P6-11, the latter an irreversible anonymisation step; no definition, field or setting; the source note has no edges either (owner of the band definition after F-R3-11's refutation).

**Skeptic's caveats.** Band edges are Ahsan's decision; a changeable setting needs a rule for bands already written into anonymised records

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Band edges one Admin setting (starting: under threshold · threshold–49 · 50–99 · 100+); bands already in anonymised records stay as written

#### S113 · F-R6-26 · MINOR · R6 Build
**Claim.** Nine streams versus ten (S6)

**Rows.** P1-7, 1.1, 4.1, P4-1, J21.4, 4.2, A.2 Signal

**Quoted.** "P4-1 | … | Admin's Connections page shows nine rows; three "connected", six "not yet connected""  
Second line: "A.2 | Signal — id · stream (choice: the ten in 4.2)"

**Consequence.** A Connections page built to P4-1 or J21.4 has no e-commerce row, so e-commerce health (P4-15) goes unwatched. The spec never says whether "nine" means lead streams and "ten" signal streams.

**Proposed fix (reviewer's).** P1-7: "…through one of nine lead streams; e-commerce purchases are a tenth, signal-only stream (P4-27a)." P4-1 and J21.4: "ten rows".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. 1.1, P1-7, 4.1, P4-1 and J21.4 say nine; 4.2, P4-27a and A.2 say ten; P4-15 and P3-15 point back at the stale J21.4; the 21 Sept addition was never propagated.

**Skeptic's caveats.** The fix must also touch 1.1 and 4.1; "ten rows" ignores Hina on the same page; "signal-only" is Ahsan's call (F-R6-13); DECISIONS and PLAN carry the same stale "nine"

**See also.** Fix together with F-R6-13 (S67).

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S114 · F-R6-28 · MINOR · R6 Build · R7 Open
**Claim.** A.1's "verbatim" Came-from column has drifted on seven rows, one to the opposite decision (S8)

**Rows.** P6-16, P1-6, P2-22, P4-29, P5-22, P5-25, J21.7

**Quoted.** "A.1 | P6-16 | … | Canvas (SSO where available); Your answer (21 Sept, keep SSO)"  
Second line: "P6-16 | … | Your answer (21 Sept, login); Canvas (SSO where available, deferred)"

**Consequence.** A.1 promises the column is "verbatim so the two never drift". A.1 records the opposite provenance ("keep SSO"); SSO-out is stated in four other places, so the harm is a false provenance record, not a wrong build. The other drifts are:
- P1-6: "17 Sept" vs "17, 21 Sept"
- P2-22: "note (18 Sept)" vs "notes (18, 25 Sept)"
- P4-29: "17 Sept" vs "17, 28 Sept"
- P5-22: "17 Sept" vs "17, 28 Sept"
- P5-25: "21 Sept, adjustments and franchise list" vs "21, 28 Sept"
- J21.7: "17, 18 Sept" vs "17, 18, 28 Sept; Part 7"

**Proposed fix (reviewer's).** Regenerate A.1's last column from the body rows. Add to A.9: "A.1 Came-from equals the body cell, checked on every spec change."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. A mechanical comparison of all 275 row IDs finds exactly seven drifted Came-from cells, all rows revised on 21, 25 or 28 Sept; no rule says which copy wins (also covers merged F-R7-35).

**Skeptic's caveats.** Consequence overstated: SSO-out is stated in four other places, so the harm is a false provenance record, not a wrong build; where the consistency check lives (A.9) is a separate choice

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Consequence narrowed as above. Where the consistency check lives (A.9) is a separate choice.

**Also raised as** (merged before the skeptic pass; the verdict covers them): F-R7-35 (R7 Open, minor) — A.1 says its "Came from" column is verbatim; at least seven rows differ.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S115 · F-R6-32 · MINOR · R6 Build
**Claim.** Hina attempts are an Admin setting but hard-coded 1–3 in the schema

**Rows.** P5-2, P5-14, A.2 Hina call, A.2 Settings

**Quoted.** "A.2 | Hina call — lead · attempt (whole number 1–3)"  
Second line: "P5-2 | … **3 attempts over 2 days**, both Admin settings."

**Consequence.** If Admin raises attempts to 4, the fourth inbound record fails validation, and the hard range contradicts A.3 ("every setting live in the database") and P5-14.

**Proposed fix (reviewer's).** A.2: "attempt (whole number, 1 to the active `hina_attempts` setting)".

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. A.2's "whole number 1–3" is a hard range in the same notation as Score 0–100; hina_attempts is a versioned setting with no ceiling; the Hina decision calls 3 a "starting setting".

**Skeptic's caveats.** Re-anchor from AR-15 to A.3 ("every setting live in the database") and P5-14; no Pilot consequence unless Admin changes the setting

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats). Re-anchored from AR-15 to A.3 and P5-14. No Pilot consequence unless Admin changes the setting.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S116 · F-R6-34 · MINOR · R6 Build
**Claim.** "Six clock promises" in settings; A.2 Settings holds four

**Rows.** P1-38, 4.5 Settings, 6.1 Settings, A.2 Settings, P5-28

**Quoted.** "P1-38 | … Admin's settings page lists all six promises."  
Second line: "A.2 | Settings … contact_promise_hot (24 h), _potential (72 h) · completion_promise_hot (7 d), _potential (14 d)"

**Consequence.** The campaign promises live on each Campaign record, not in Settings. A test for "six on the settings page" fails, or a builder adds two meaningless global campaign settings.

**Proposed fix (reviewer's).** P1-38 "What you would see": "Admin's settings page lists the four Hot and Potential promises; each campaign's two promises are on its campaign record."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. 6.1 Settings says the record holds six clock promises and defers field detail to A.2, which holds four; the campaign promises sit on the Campaign record; nothing reconciles the count.

**Skeptic's caveats.** The fix must also correct 4.5 and 6.1, not only P1-38; the plan itself repeats "six promises" at R7-A4

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S117 · F-R6-59 · MINOR · R6 Build
**Claim.** P7-9 sends out-of-Pakistan coordinates to "Admin's list" without naming one

**Rows.** P7-9, 3.2 Admin portal, P4-7

**Quoted.** "P7-9 | … A coordinate outside Pakistan or in no zone goes to Admin's list and is not routed."

**Consequence.** The Admin portal has below-threshold, no-contact, rejected and pool lists; none takes these. A builder invents one, or drops the lead into "no contact", which is wrong because the lead has a number. P4-7's "location invalid" hold may be the intended list; the spec does not say.

**Proposed fix (reviewer's).** P7-9: "…goes to Admin's 'held signals' list with 'location outside the structure' (P4-5, P4-7)."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P7-9's "Admin's list" has no cross-reference; the same phrase means the below-threshold list in P3-12 and P5-16; P7-17's gap lists omit the case; three defensible readings with different behaviour.

**Skeptic's caveats.** The finding omits the Connections held list as a candidate; label choice ("location invalid" vs new) is Ahsan's and A.2 held_reason must match

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Ambiguous or coarse addresses go to the pool with candidates; franchise change swept through 5.3, 5.9, 6.4 and 6.3.1 (Ahsan picks the serviceability test); confirm-location action with history; name the held list

#### S118 · F-R6-60 · MINOR · R6 Build
**Claim.** Unreachable: three attempts instead of two, and "Closed" instead of "returns to the pool" — no DR

**Rows.** P1-33, P1-34, 1.5

**Quoted.** "P1-33 | **Closed: unreachable** — after three failed contact attempts, each logged, the SUL closes the lead"  
Second line: "**Unreachable → nurture** | After two failed contact attempts. Returns to the pool, re-scored on the next signal. … Also flags contact-data quality back to the source."

**Consequence.** The departure is unrecorded, and so is the dropped contact-data-quality flag back to the source.

**Proposed fix (reviewer's).** New DR-34: "Spec: unreachable after three SUL attempts, closed; a new signal makes a new lead (P1-34). Canvas: after two attempts, back to the pool, re-scored on the next signal, flags contact quality to the source. Your answer, 17 Sept."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. P1-33/P1-34 (three attempts, closed) depart from canvas L8 (two attempts, back to the pool, contact-quality flag to the source); the 17 Sept note confirms it was deliberate; no DR records the canvas position.

**Skeptic's caveats.** The "→ nurture" half follows from DR-4; contact quality is partly kept via P1-35/P1-32 reasons, so the DR should not imply it is lost entirely

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S119 · F-R6-61 · MINOR · R6 Build
**Claim.** Grower 360 fields dropped without a DR: CNIC key, UC, franchise affinity

**Rows.** P4-19, P4-21, 6.1 Grower

**Quoted.** "P4-21 | The grower's profile holds: name, number, village and location (province, district, tehsil, village, and map position where a source gave one), crops grown, acreage …"  
Second line: "Secondary: name + village + crop (fuzzy); CNIC where available." / "district/tehsil/UC, preferred language, franchise affinity"

**Consequence.** The secondary identity key and two profile fields are silently gone. (Farm geometry is not included: the canvas itself removed farm mapping, 6.3.3.)

**Proposed fix (reviewer's).** New DR-35: "Spec: secondary match by name, village and crop only; no CNIC, no union council, no franchise affinity (P4-19, P4-21, P4-27). Canvas: CNIC where available; UC; franchise affinity."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. CNIC, union council and franchise affinity are in canvas L3 and absent from the spec with zero hits and no DR; neither of the header's two mechanisms was used.

**Skeptic's caveats.** "Decision check" should cite D4 and the 17 Sept location answer; only the CNIC part of the secondary key is gone

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S120 · F-R6-63 · MINOR · R6 Build
**Claim.** Model monitoring cut to lift only; PM score distribution per campaign dropped

**Rows.** P5-33, J19.1, J19.2

**Quoted.** "P5-33 | … Leadership's "does the engine beat a plain list" is the conversion rate of the top-scored tenth of leads against the bottom tenth."  
Second line: "Model monitoring: lift, drift, score distribution over time"

**Consequence.** There is no drift watch and no score-distribution view (Z00), and the PM dashboard lacks "Score distribution and converted value per campaign" (Z04). No DR records either.

**Proposed fix (reviewer's).** New DR-37: "Spec: lift and conversion breakdowns only; no drift or score-distribution monitoring; PMs see conversions, not score distribution. Canvas: lift, drift, distribution over time; PM score distribution per campaign." Or add the views to P5-33 and J19.2.

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. Canvas Z00 (drift, score distribution over time) and Z04 (PM score distribution per campaign) are absent; "distribution" does not occur in the spec; no DR, decision or out-of-scope row records the drop.

**Skeptic's caveats.** Only the score-distribution half of the Z04 phrase is missing (converted value is present); P5-33 also watches six conversion breakdowns; DR number assigned at consolidation

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S121 · F-R6-66 · MINOR · R6 Build
**Claim.** Agronomy removed as owner of window table and weights; timing inputs cut to months — no DR

**Rows.** 5.3 Season timing, P3-10, 4.7 q12

**Quoted.** "5.3 | **15** | Season timing | … | A crop-and-window table (crop, problem, months) owned by Marketing in Admin"  
Second line: "Inputs: Crop Doctor diagnosis, crop calendar, sowing date, weather. Agronomy team owns the severity and window tables." (and canvas L5: "Weights … set by agronomy and sales leadership in the admin console")

**Consequence.** The ownership move to Marketing and Admin is decided (DECISIONS 2026-09-21) but unrecorded as a departure. So is dropping sowing date, weather, crop stage and district pest pressure. Reviewers cannot see that no agronomist signs the window table or the weights.

**Proposed fix (reviewer's).** New DR-39: "Spec: Marketing owns the timing table (crop, problem, months); Admin sets weights; no sowing date, weather or pest-pressure inputs. Canvas: agronomy owns severity and window tables; agronomy and sales leadership set weights. Your answer, 21 Sept."

**Decision check.** none (the decision stands; only the DR is missing)

**Skeptic (Fable 5.1).** Survived. The timing-table owner moved from agronomy to Marketing, weights are Admin-set, and sowing date, weather, crop stage and pest pressure are dropped; three places record what Ahsan chose and none records the canvas position.

**Skeptic's caveats.** The DR must cite 18 Sept for Admin-alone weights and 21 Sept for the timing owner; DECISIONS 2026-09-21's "Why" wrongly calls the timing owner a canvas gap (needs a new entry, not an edit)

**See also.** F-R7-19 (S92) asks who approves the table's content today.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S122 · F-R6-67 · MINOR · R6 Build
**Claim.** Need severity and value weights swapped (25↔20) with no DR

**Rows.** 5.3 weights, 5.10 q1

**Quoted.** "5.3 | **25** | Acreage | … / **20** | Crop need"  
Second line: "**25** | Need severity" · "**20** | Opportunity value"

**Consequence.** DECISIONS 2026-09-17 says "the canvas weights stay as the starting point", with acreage replacing value. The spec instead gives acreage severity's 25 and cuts crop need to 20. DR-26 records the substitution, not the swap.

**Proposed fix (reviewer's).** DR-26 note (append): "Acreage also takes 25 and crop need 20, the reverse of the canvas's severity 25 and value 20 (your answer, 21 Sept)."

**Decision check.** none

**Skeptic (Fable 5.1).** Survived. The spec gives acreage 25 and crop need 20 against the canvas's severity 25 and value 20; DR-26 records the substitution, not the weights; the crop-need row credits "Canvas" for a weight that is not the canvas's.

**Skeptic's caveats.** The spec's weights match DECISIONS 2026-09-21; only the register entry is missing

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S123 · F-R7-29 · MINOR · R7 Open
**Claim.** No accessibility row for the SUL app

**Rows.** 2.4, P2-3, P2-10, P6-8

**Quoted.** P2-3 "A normal outcome is logged in two taps."

**Consequence.** No row covers sunlight contrast, one-handed reach, large system font (Urdu Nastaliq at 130% scale), touch-target size or voice input for field users, some of them older, working outdoors. Phase 4 layout has no requirement to meet.

**Proposed fix (reviewer's).** P2-23 "The SUL app stays usable at the phone's largest font size, in direct sunlight (high-contrast theme) and one-handed (primary actions in the lower half), and accepts the phone's voice keyboard in text fields."

**Decision check.** none

**Skeptic (Opus 5.5).** Survived. SPEC 221 defers screen states and layout to Phase 4, not what screens must support; no row, decision, DR or 6.3.2/6.3.3 entry names font scaling, contrast, reach, touch target or voice input; P2-10 "usable on 2G/3G" is network, not user.

**Skeptic's caveats.** The Phase 4 guide (03-delivery-process.md) already plans low-end Android constraints and field-officer sessions, so the fix is a Phase 4 acceptance input, consistent with minor

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept (unparked 2026-10-01)): One SPEC row now: SUL app readable at the phone's largest text size, clear in bright sunlight, usable one-handed, voice typing in text boxes

#### S124 · F-R7-30 · MINOR · R7 Open
**Claim.** "Working day" is undefined and no holiday calendar exists, although rows depend on one

**Rows.** P3-18, J18.2, P6-17, 6.5 Q10

**Quoted.** P3-18 "The monthly leadership summary is produced by Synapse on the first working day of the month"

**Consequence.** Whether Saturday is a working day, and which dates (Eid, 14 August) are holidays, decides when the summary sends and when support exists. No setting or list holds them.

**Proposed fix (reviewer's).** P6-13b "Working days are Monday to [Friday|Saturday]; Admin keeps a holiday list each year; 'working day' everywhere reads from it."

**Decision check.** none

**Skeptic (Opus 5.5).** Survived. "Working day" appears in P3-18, J18.2, P6-17 and 6.5 Q10 and is defined nowhere; no working-week or holiday setting in A.2; no decision or DR parks it; P5-30 governs clocks, not "working day".

**Skeptic's caveats.** Citing P5-30 as needing a holiday list is a misread: clocks are fully specified (pause Sundays, holidays count); gap is limited to P3-18, J18.2, P6-17, 6.5 Q10

**Changed from the raw report.** The rows was edited where the skeptic showed the raw text false or overstated (see the caveats). P5-30 removed from Rows: citing it was a misread (clocks pause Sundays and holidays count, fully specified).

**See also.** F-R7-6 (S87) depends on this definition.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Holiday list: Admin keeps yearly pause days that clocks also skip; working week defined once; changes logged (amends 5.10 Q13)

#### S125 · F-R7-32 · MINOR · R7 Open
**Claim.** Part 7 was added, but the header, the DR index and the question-log index were not updated (seam S9)

**Rows.** header, A.6, A.7, 7.5, 7.6

**Quoted.** A.6 "DR-1 to DR-8 in 1.9 · DR-9 to DR-14 in 2.7 · DR-15 to DR-18 in 3.7 · DR-19 to DR-22 in 4.8 · DR-23 to DR-28 in 5.11 · DR-29 to DR-31 in 6.6."  
Second line: header "A technical appendix follows Part 6 and can be skipped."

**Consequence.** Other problems from the same cause:
- A.6 omits DR-32 and DR-33 (7.6), yet "The session 2.2 review reads this index first."
- A.7 lists "(1.8, 2.6, 3.6, 4.7, 5.10, 6.5)", omitting 7.5, and cites notes -15 to -18 but not -25.md (which exists).
- The appendix now follows Part 7.
- DR-33 records a departure from the spec's own Part 5 rather than from the canvas or audit, which the register's own definition in A.6 does not cover.

**Proposed fix (reviewer's).** A.6 "… DR-29 to DR-31 in 6.6 · DR-32 to DR-33 in 7.6"; A.7 add "7.5" and "`-25.md`"; header "follows Part 7".

**Decision check.** none

**Skeptic (Opus 5.5).** Survived. Header says the appendix "follows Part 6", A.6 stops at DR-31 though DR-32/33 exist in 7.6, and A.7 omits 7.5 and -25.md, which exists and is cited in the header; A.7's "session 2.1" wording does not exclude Part 7; no decision or DR excuses the stale indexes.

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

#### S126 · F-R7-33 · MINOR · R7 Open
**Claim.** Part 2 numbering is out of order

**Rows.** P2-22, P2-21, 2.6 Q10, Q6

**Quoted.** 2.4 "| P2-22 | A **BSA** (Basic Sales Unit Area) …" appears before "| P2-21 | Follow-up is a date the SUL sets."; 2.6 "| 10 | What is a BSA? |" appears before "| 6 | How does follow-up work? |"

**Consequence.** Every row is present and adjacent, so a reader skips and double-counts nothing, and no tooling that expects ascending IDs is named; the defect is cosmetic sequencing. A.1 repeats the same order.

**Proposed fix (reviewer's).** Move P2-22 after P2-21 and Q10 after Q9, in both 2.4/2.6 and A.1; IDs unchanged.

**Decision check.** none

**Skeptic (Opus 5.5).** Survived. P2-22 sits above P2-21 in 2.4 and A.1, and question 10 above question 6 in 2.6 (same date, so not by date); no ordering rule, decision or DR explains it; plan §0 rule 7 assigns the defect to R7-A6.

**Skeptic's caveats.** Consequence overstated: every row is present and adjacent, so a reader skips and double-counts nothing, and no tooling expecting ascending IDs is named; cosmetic sequencing, consistent with minor

**Changed from the raw report.** The consequence was edited where the skeptic showed the raw text false or overstated (see the caveats).

**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Document hygiene, accepted in chat

---

## 2. Narrower claims from refuted findings

A refuted finding stays refuted. Where its skeptic recorded a smaller claim that is true, it is listed here with its parent so it can be accepted as a smaller item. Claims already carried inside a surviving entry are marked and need no separate mark.

### 2.1 Substantive

#### N1 · from F-R1-13 (R1 Field, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** Every Crop Doctor scan goes to Hina, and a grower who says "advice only" is still put on an SUL's contact clock

**Narrower claim.** No per-grower frequency cap across successive leads: after closure P1-34 makes a new lead with an intent gap, so a weekly scanner is held for Hina again (minor absent rule)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, amended): Ahsan: if the grower's earlier scan and Hina call already meet the handover criteria, Hina does not call again; the new lead goes straight to its segment with the latest activity

#### N2 · from F-R4-13 (R4 Product, filed blocker; skeptic Fable 5.1)
**Parent claim (refuted).** If Hina is not connected, down or behind, gap leads are held with no time limit: the "bound" is stated in attempts, not time

**Narrower claim.** P5-5/P5-6 do not literally name window expiry with fewer than three attempts as a handover trigger, and no row says Synapse runs with Hina not connected (P4-1 covers streams only) — minor wording row

**Note.** Also covers F-R6-51 and F-R7-1 (merged into F-R4-13) and the first residue of F-R6-38.


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Two lines: window expiry hands the lead over whatever the attempt count; Synapse works with Hina off

#### N3 · from F-R5-16 (R5 Trust, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** Retention removes "name, number, location and receipts", but the raw signal, grower words, Hina summaries and old-number history are kept "unchanged"

**Narrower claim.** MAJOR narrower claim: Signal.raw ("the original as received, unchanged") carries name and number but has no (personal)/PII mark, so retention and P6-3 do not reach it; mark `raw` personal or strip it at retention


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Signal.raw marked personal: name and number removed at anonymisation, never in exports

#### N4 · from F-R5-17 (R5 Trust, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** No retention for personal data outside an inactive grower: "no contact" signals, removed and rejected leads, an active grower's old PII, the audit trail, learning examples

**Narrower claim.** MAJOR-to-minor narrower claim: (1) an unmatched "no contact" signal holds name, village and words with no grower, so P6-11 can never fire on it; (2) Admin "removal" (P1-36) is undefined — what is deleted, what is kept for INV-3


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Unmatched no-number messages deleted after N months (Ahsan sets N); Admin "remove" deletes the lead's personal data and keeps only the technical ID that prevents duplicates

#### N5 · from F-R6-10 (R6 Build, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** P1-14 "clear purchase intent" has three examples and no rule; the franchise example has no object

**Narrower claim.** MAJOR-ish narrower claim: P4-9's "when Synapse is unsure" is unmeasured — A.2 stores an intent confidence number but no row or setting gives the cut-off at which "buy" becomes "unclear"; fix belongs on P4-9 plus A.2 Settings


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Admin setting for the minimum confidence for "buy"; starting value proposed with the S74 test

#### N6 · from F-R6-20 (R6 Build, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** No WhatsApp to staff in the Pilot versus a weekly WhatsApp summary to managers (S2)

**Narrower claim.** (1) MAJOR-ish absent rule: the weekly summary is Synapse's only outbound WhatsApp and nothing provides for it — no provider row, no template, no A.3 line, no staff mobile field on A.2 User; (2) P1-42 wording could point at P3-17


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Weekly WhatsApp summary provided for: sending service and approved template on Connections, staff mobile field, P1-42 names it as the one exception

#### N7 · from F-R6-36 (R6 Build, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** Village boundaries: no source, format, licence or late-arrival rule

**Narrower claim.** (1) no row records provenance or usage rights of the boundary files, incl. shipping them to SUL phones (question for Ahsan); (2) P7-7 "inside Punjab and Sindh" vs P4-29 "inside a digitised village boundary" wording


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (scope change): Ahsan: village boundaries are not shown to SULs; SULs get a Google map showing their leads with navigation; boundaries may be shown later if required. Boundaries stay server-side for routing. Changes P7-4 ("drawn on the SUL's map") and the offline map budget; needs a DECISIONS entry at apply time

#### N8 · from F-R7-2 (R7 Open, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** Address-to-coordinate service failure: no rule, and no health line

**Narrower claim.** (1) address conversion has no health line on Connections and is not among P6-17's escalation third parties; (2) hold-and-retry exists only in A.3's technical words, and P7-17's "unmatched addresses" does not separate "no match" from "service unavailable". Rests on appendix text, not a numbered row


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Address service health on Connections; unplaced addresses labelled "no match" or "service unavailable, retrying"

#### N9 · from F-R7-7 (R7 Open, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** No row sets uptime, backup, restore or incident handling

**Narrower claim.** (1) No document says what a restore must do to keep P6-11 anonymisations, the P6-15 audit trail and already-synced phone actions true; carry forward to INFRA.md. (2) No availability target is named in any phase deliverable. If the deferral must be stated inside SPEC.md, this survives as a minor editorial gap: one line in 6.3 pointing to INFRA.md and RUNBOOK.md

**Note.** Carry part (1) forward to docs/INFRA.md at Phase 3.


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, to Phase 3): Restore requirements (anonymisations stay, audit trail intact, synced phone actions kept) and an uptime target go to the Phase 3 infrastructure document; one SPEC line points there

#### N10 · from F-R7-13 (R7 Open, filed minor; skeptic Opus 5.5)
**Parent claim (refuted).** No IT security review or group privacy sign-off before go-live

**Narrower claim.** No document requires a check against Syngenta's group privacy standard before the Pilot goes live; the Phase 9 security review is an agent review with an IT lens, not Syngenta IT's own, and IT signs only "if involved"; neither is a dependency with an owner and date


**TRIAGE:** ( ) accept  (x) reject — reason: No group privacy check or IT sign-off dependency added  ( ) park — trigger:  
**Ahsan's decision** (reject): No group privacy check or IT sign-off dependency added

#### N11 · from F-R7-18 (R7 Open, filed minor; skeptic Opus 5.5)
**Parent claim (refuted).** Franchise name and coordinate are not tagged personal although franchisees are often sole proprietors

**Narrower claim.** The spec does not say whether a franchise's name and coordinate are personal or business data (6.1 Sales structure and A.2 BSA carry no PII mark; P7-13 classifies only the grower's coordinate), and no row records franchisees were told; a classification question for R5 or Ahsan

**Note.** A classification question for R5 or Ahsan; DBO already owns the data.


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Franchise name and location are business data (public point of sale) owned by DBO

#### N12 · from F-R7-25 (R7 Open, filed minor; skeptic Opus 5.5)
**Parent claim (refuted).** The other settings have no valid range, no rule for work in flight, and three have no change notification

**Narrower claim.** (1) No setting has a minimum or maximum, so fold 0, 0 Hina attempts, a 0-hour promise or a 0 km cap are not ruled out (P4-7 and P6-20 cover signal values, not settings); (2) P5-14 does not say whether a new hina_attempts or hina_days applies to batches already sent (A.3); (3) the 4.5 and 6.1 settings lists are incomplete against A.2

**Note.** Part (1)'s floor overlaps the retention entry (S50).


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Every setting gets a minimum and maximum in the spec; a change to Hina's limits applies to leads sent after the change

#### N13 · from F-R7-27 (R7 Open, filed major; skeptic Opus 5.5)
**Parent claim (refuted).** Hina's calling language is unspecified, and the grower's language can only be Urdu or English

**Narrower claim.** No SPEC row states Hina calls in Urdu (only the decision rationale); the Hina outbound batch (A.3) does not pass the grower's recorded language (P4-21), so that field has no consumer on the Hina path; minor wording and seam gap


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, amended): Ahsan: Hina always calls in Urdu; the record and summary for the SUL are in English and Urdu

### 2.2 Small (wording, cross-references, minor gaps)

#### N14 · from F-R1-6 (R1 Field, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** The sale happens at the franchise after the visit, but no honest tap covers "will buy", and "Not converted" seals the lead for the season

**Narrower claim.** J5 has no step showing a late completion after J5.4 (minor)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): One journey line showing a late completion counts as completed, but late

#### N15 · from F-R1-9 (R1 Field, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** The lead card's acceptance line cannot be tested, and puts the history both on the card and one tap away

**Narrower claim.** Reword "without scrolling to another screen" to 2.2's "on one screen, without opening another"


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Lead-card rule reworded to "on one screen, without opening another"

#### N16 · from F-R1-12 (R1 Field, filed minor; skeptic Fable 5.1)
**Parent claim (refuted).** "Period views everywhere a number is shown" would put a period picker on the home screen

**Narrower claim.** P2-16 wording could say "on My summary (managers: P3-7)"


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): P2-16 reworded: period views are on My summary (managers: P3-7)

#### N17 · from F-R1-14 (R1 Field, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** "Band karo" is said to trigger no action, but the spec's signal rules push the lead up, reset its age, or make a new lead

**Narrower claim.** P4-25 "takes no action" could read "takes no opt-out action; scored like any other signal" (wording)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): P4-25 reworded: "takes no opt-out action; the message is scored like any other"; D1 unchanged

#### N18 · from F-R1-15 (R1 Field, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** When the grower's real number is already on another grower, J8.2 refuses and leaves the SUL with no next step

**Narrower claim.** J8.2 could cross-reference P1-35 and J21.6 in one line


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): J8.2 points to P1-35 and J21.6 (reject as duplicate, Admin merges)

#### N19 · from F-R1-21 (R1 Field, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** The 150 MB limit cannot be tested: no size is given for the map, photos, boundaries or history it must hold

**Narrower claim.** P2-10/P6-8 do not say whether the unsent photo outbox counts inside the 150 MB (minor)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Unsent receipt photos count inside the 150 MB, compressed to fit

#### N20 · from F-R2-10 (R2 Sales leadership, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** Assigning a lead from the pool puts it on an SUL whose scope excludes it

**Narrower claim.** P3-11/J15.2 could state in words that a pool-assigned placement takes the chosen SUL's territory; A.2 marks village/bsa non-optional though a pool lead has none


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Pool-assigned lead takes the chosen SUL's territory; village and BSA optional for pool leads

#### N21 · from F-R2-23 (R2 Sales leadership, filed minor; skeptic Fable 5.1)
**Parent claim (refuted).** A flag written without signal has no defined behaviour on the "phone first" RSM app

**Narrower claim.** AR-14's unscoped "retried, never dropped" sits uneasily beside P3-20 (wording scope)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): AR-14 "retried, never dropped" limited to the SUL app; dashboards show a failed action as failed

#### N22 · from F-R3-3 (R3 Marketing, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** A campaign holds one product and one crop, yet its leads are "grouped by product and by crop", and a lead has no product (seam S15)

**Narrower claim.** P1-15/J6.2/J19.2 do not say whether "by product" keys on the lead's recommended product or the campaign's; recommended product is not listed as a derived value on A.2 Lead (minor absent rule)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): "By product" means the lead's recommended product, listed as a derived field on the lead

#### N23 · from F-R3-4 (R3 Marketing, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** "NPI campaign" and "Brand campaign" are streams while Facebook and TikTok also carry campaigns, so "by channel" has no field

**Narrower claim.** A one-line gloss "channel = stream" at J20.1 or A.2 would close the vocabulary gap


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): One-line note: channel = stream

#### N24 · from F-R3-10 (R3 Marketing, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** PKR on Marketing's screen is self-declared, and no row makes the screen say so

**Narrower claim.** Exports (J20.5) carry no number definitions in the file (minor)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Every export carries a definitions sheet or footer for its numbers

#### N25 · from F-R3-11 (R3 Marketing, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** Marketing's analytics cannot answer Marketing's one stated goal: no geography, crop, acreage band or last-season cut

**Narrower claim.** (a) "acreage band" (P5-33, P6-11) is defined nowhere and survives anonymisation, so bands must be specified once (see F-R6-17); (b) Marketing is the only analytics persona with no geographic or last-season cut (minor, unspecified)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Marketing can split campaign figures by last-season status (bands per S112, geography per S104)

#### N26 · from F-R3-13 (R3 Marketing, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** Replies to Marketing's own WhatsApp campaigns have no stream that carries a campaign

**Narrower claim.** Which 4.2 stream such a reply is recorded under is unstated and affects J20.1's channel cut (minor, resolve with D3)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): A reply to Marketing's own WhatsApp campaign is filed under WhatsApp and credited to the campaign; detail settled with D3 in M5

#### N27 · from F-R3-14 (R3 Marketing, filed blocker; skeptic Fable 5.1)
**Parent claim (refuted).** A STOP sent to Syngenta's WhatsApp Business number is seen only by Synapse, which tells nobody; the number is then in breach of WhatsApp's opt-out rule

**Narrower claim.** P5-9/4.2 do not say which number Marketing's outside campaigns use or that opt-out duties sit with its owner


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): One line: Marketing's campaigns use the number its owner names in 4.2; that owner handles opt-out requests outside Synapse; D1 unchanged

#### N28 · from F-R3-17 (R3 Marketing, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** The "below threshold" count mixes three origins and hides unknown acreage, so Marketing cannot tell a small-farmer campaign from a form with no acreage field

**Narrower claim.** J20.1 lists routed outcomes as only contacted/converted/PKR, so Closed: below threshold / unreachable are invisible in campaign analytics; the definitions page should distinguish the P5-16 total from the routed Closed state (minor)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Campaign figures show "closed: below threshold" and "closed: unreachable"; definitions page separates below threshold on arrival from closed below threshold later

#### N29 · from F-R4-7 (R4 Product, filed minor; skeptic Fable 5.1)
**Parent claim (refuted).** The e-commerce stream is scheduled into Capture although the Pilot does not use it

**Narrower claim.** The tenth stream has no build milestone in PLAN.md (S6, R6's — see F-R6-26)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, PLAN change): E-commerce purchase stream gets a build milestone in PLAN.md after the Pilot streams

#### N30 · from F-R4-12 (R4 Product, filed minor; skeptic Fable 5.1)
**Parent claim (refuted).** Marketing's goal cannot be answered in the Pilot, and the spec does not say what Marketing gets from it

**Narrower claim.** No Pilot-versus-Wave-2 mapping of screens for any stakeholder (general gap, belongs with F-R4-6/F-R4-9)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (covered): Answered by the S42 Pilot column; no separate change

#### N31 · from F-R5-1 (R5 Trust, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** "The grower's own contact" is not defined for signals Syngenta started (call-backs, replies to Marketing's outbound WhatsApp)

**Narrower claim.** 4.2 WhatsApp inbound captures "whether they messaged first" and no row consumes it (minor dangling datum)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Remove the unused "whether they messaged first" field from the WhatsApp stream

#### N32 · from F-R5-5 (R5 Trust, filed blocker; skeptic Fable 5.1)
**Parent claim (refuted).** A STOP on Syngenta's WhatsApp Business number is held with no action and no Legal confirmation of the position is recorded

**Narrower claim.** D1's record names no individual or date beyond "leadership via Ahsan" — housekeeping already assigned, not a spec row


**TRIAGE:** ( ) accept  (x) reject — reason: Ahsan, on being asked for the name and date: "Leadership via Ahsan" is enough  ( ) park — trigger:  
**Ahsan's decision** (reject): Ahsan, on being asked for the name and date: "Leadership via Ahsan" is enough

#### N33 · from F-R5-9 (R5 Trust, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** P6-12 residency has no scope (backups, queues, logs, the offline phone) and no fallback when the host has no Pakistan region

**Narrower claim.** P6-12's "Confirmed in Phase 3" cell could state that the AWS default will need a D5 substitution (editorial)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept (unparked 2026-10-01)): One neutral line in P6-12: the hosting that meets Pakistan storage is decided in tech.md from Syngenta's recommended stack; no hosting choice made now

#### N34 · from F-R5-24 (R5 Trust, filed major; skeptic Fable 5.1)
**Parent claim (refuted).** Nothing detects or counts a shared-number merge in error, so the un-park trigger for a split can never fire; Hina's "wrong number" has no rule

**Narrower claim.** No reason code or count separates "two people on one phone" from "wrong number" (minor measurement gap); Hina "wrong number" is F-R1-17's


**TRIAGE:** ( ) accept  (x) reject — reason: No "shared phone" reason; field feedback outside Synapse is enough  ( ) park — trigger:  
**Ahsan's decision** (reject): No "shared phone" reason; field feedback outside Synapse is enough

#### N35 · from F-R6-31 (R6 Build, filed minor; skeptic Fable 5.1)
**Parent claim (refuted).** The fold is "low scores" in two rows and "the first 20" in another

**Narrower claim.** (a) stale "low scores below a fold" wording in P1-23, P2-2, 2.2 and DR-4 (tidy); (b) P5-20 does not say whether due or flagged leads beyond position 20 sit under "more leads"


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Flagged, overdue and due-today leads are never hidden behind "More leads", even past 20; the four old "low scores below the fold" sentences are tidied

#### N36 · from F-R6-35 (R6 Build, filed minor; skeptic Fable 5.1)
**Parent claim (refuted).** "One named owner" per list, but two lists name two owners

**Narrower claim.** Products "Marketing with the Portfolio Managers" spans two roles with no per-part split, so the notice recipient is undetermined (minor); P4-28's "one named owner" wording is literally untrue of the location row


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Product-row notices go to the PM of that product's portfolio; P4-28 reads "each part of a list has one named owner"

#### N37 · from F-R6-53 (R6 Build, filed minor; skeptic Fable 5.1)
**Parent claim (refuted).** Hina's queue is ordered by a score that 5.1 says does not exist yet

**Narrower claim.** 5.1 does not say in words that a lead is scored on arrival (one-clause wording fix)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): 5.1: a lead is scored on arrival (for Hina's order) and re-scored after Hina

#### N38 · from F-R6-62 (R6 Build, filed minor; skeptic Fable 5.1)
**Parent claim (refuted).** The reachability adjustment is redefined with no opt-in input and no DR

**Narrower claim.** No DR names the reachability adjustment and the row credits the canvas for wording it does not use (one clause on DR-19)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (rule change): Ahsan: "if there is no valid number; we won't route and show the lead to SUL; nothing can be done on it; instead this lead will be closed." Confirmed: the lead is closed as "no valid number" and never routed; a later signal from the same grower with a valid number becomes a normal lead carrying the earlier history. Replaces P4-18's "no contact" hold; at apply time reconcile with S12 (Hina wrong number) and N4(a) (deletion of unmatched messages)

#### N39 · from F-R7-14 (R7 Open, filed minor; skeptic Opus 5.5)
**Parent claim (refuted).** Finance owns none of the money figures: the reconciliation view has no sign-off, spend has no source

**Narrower claim.** A.4 K6 uses the audit's page name "a sign-off page" with Note "—" and does not say P3-2 calls it the reconciliation view; minor wording


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): A.4 K6 uses "reconciliation view"

#### N40 · from F-R7-15 (R7 Open, filed minor; skeptic Opus 5.5)
**Parent claim (refuted).** PKR display rules are incomplete: grouping, large totals and fractional figures

**Narrower claim.** No rule picks thousand (1,250,000) or lakh (12,50,000) grouping, and none gives a rounding method for derived money such as cost per lead and cost per converted lead (J20.2); minor; one clause in P6-5


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): Lakh grouping (PKR 12,50,000); calculated amounts rounded half up to whole rupees

#### N41 · from F-R7-21 (R7 Open, filed major; skeptic Opus 5.5)
**Parent claim (refuted).** The D5 row says "Nothing here", but the residency rule forces a change to the default AWS stack

**Narrower claim.** The 6.4 D5 row's "Nothing here" does not cross-refer to P6-12, though the Phase 3 stack revisit is where the residency hosting choice is made (missing cross-reference, no content change)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept (unparked 2026-10-01)): The 6.4 D5 row points to P6-12 with the same neutral line (hosting decided in tech.md)

#### N42 · from F-R7-26 (R7 Open, filed major; skeptic Opus 5.5)
**Parent claim (refuted).** "In Urdu" has no localisation rules: direction, script, digits, date format

**Narrower claim.** The only Urdu display example (P2-5 "Contact by Tue 09:00 · Complete by Mon 25th") is English-style and no row picks Western or Urdu digits; a minor choice for UX.md in Phase 4


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, amended): Ahsan: "same english style everywhere; no urdu style." Western digits and English-style dates and times in both languages

#### N43 · from F-R7-28 (R7 Open, filed minor; skeptic Opus 5.5)
**Parent claim (refuted).** Manager-side language is undefined: RSM lead-card reasons, the WhatsApp summary, and User.language (seam S27)

**Narrower claim.** The weekly WhatsApp summary (J22.1, P3-17) is a message, not a screen, and no row states its language (English only by inference from Q11); User.language is set for every role but has an effect only for SULs (P2-9); fix is to state both, not add a setting


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept): One line each: the weekly summary is in English; the language setting applies to the SUL app only

#### N44 · from F-R7-34 (R7 Open, filed minor; skeptic Opus 5.5)
**Parent claim (refuted).** The Mark column is empty on 162 of 189 numbered rows while the header's marking rules still read as live

**Narrower claim.** The "How to mark" paragraph is drafting-time instruction that will be stale at the v1.0 cut, with no step recorded to retire it (tidy-up for the v1.0 edit); P1-27 is in the 1.8 Q7 answer list but its Mark cell is blank while the other five carry R (cosmetic)


**TRIAGE:** (x) accept  ( ) reject — reason:  ( ) park — trigger:  
**Ahsan's decision** (accept, at v1.0): At the v1.0 cut, "How to mark" becomes "every row was approved with its part; changes after v1.0 are change requests"; P1-27 marked R

### 2.3 Already carried inside a surviving entry

- **F-R2-13** (R2 Sales leadership): J22.1 under-specified: which number "most behind" uses (see F-R2-12) and whether the named unit is SUL or territory per reader; forwardable WhatsApp naming is seam S2 (R6/R5) → carried in **F-R2-12 (S26)**.
- **F-R3-2** (R3 Marketing): Whether J19.2 "by product" keys on Outcome product or a lead product is seam S15 (F-R3-3) → carried in **the narrower claim of F-R3-3 (section 2.2)**.
- **F-R4-4** (R4 Product): (a) no Hina capacity row — true, R6's to file (F-R6-38 un-merged and sent to its own skeptic); (b) P5-1's example could say "from a grower whose location is known" → carried in **F-R7-11 (S89) for capacity; part (b) is example wording**.
- **F-R4-5** (R4 Product): P5-20's "today's due" tier excludes leads overdue since before today (owned by F-R1-11); ZM views carry no per-territory open-lead count (minor) → carried in **F-R1-11 (S10)**.
- **F-R4-15** (R4 Product): No row ties go-live to data readiness and P7-14's converter is unnamed with no date — a rollout-gate gap to merge into F-R4-9 → carried in **F-R4-9 (S43)**.
- **F-R5-8** (R5 Trust): P7-14 should cross-reference F-R5-7's P6-12a so the outside option cannot be taken before the provider's entry exists (fold into F-R5-7) → carried in **F-R5-7 (S47)**.
- **F-R6-38** (R6 Build): (1) window expiry with fewer than three attempts is not literally a handover trigger and "no answer after 3 attempts" would be untrue for a lead never called (same residue as F-R4-13); (2) the absent capacity figure is F-R7-11's → carried in **F-R4-13's narrower claim (section 2.1) and F-R7-11 (S89)**.
- **F-R6-58** (R6 Build): No Admin action attaches a campaign later (F-R3-8); no row equates "no campaign" with "campaign unknown" (wording); the F-R6-58 and F-R3-8 fixes conflict, so put the choice to Ahsan once under F-R3-8 → carried in **F-R3-8 (S36), where the conflicting fixes are put to Ahsan once**.

Refuted with no narrower claim: F-R5-2 (skeptic's note: Testability of "about that need" is R6-A1's).

---

## 3. Refuted, and why

One line each: ID, the claim, which of the four refutations killed it (plan §0 rules 2 and 3 count as out of scope: a finding that argues against a recorded decision, or only restates a disagreement-register entry), and the skeptic's reason. A refuted canonical finding refutes the findings merged into it.

- **F-R1-6** (R1 Field, major; Fable 5.1) — The sale happens at the franchise after the visit, but no honest tap covers "will buy", and "Not converted" seals the lead for the season. **Already handled.** Follow-up with a date (P2-21), clock runs, breach notifies only (J5.4), Converted logged late counts in P1-43; the "close as no stock" chain is gaming, outside R1; a day-7 stop tap argues against the clock decision.
- **F-R1-9** (R1 Field, major; Fable 5.1) — The lead card's acceptance line cannot be tested, and puts the history both on the card and one tap away. **Misread.** "history" on the card (P2-12 lines) and the grower's full timeline one tap away (P2-13, separate module in 2.2) are not two instructions; viewport fit is Phase 4 layout (2.3).
- **F-R1-12** (R1 Field, minor; Fable 5.1) — "Period views everywhere a number is shown" would put a period picker on the home screen. **Misread.** P2-16's own observable is "J10.2" (My summary); P3-7 resolves "everywhere" to dashboards; home counts are state, not period aggregates.
- **F-R1-13** (R1 Field, major; Fable 5.1) — Every Crop Doctor scan goes to Hina, and a grower who says "advice only" is still put on an SUL's contact clock. **Out of scope (argues against the 2026-09-21 Hina and 2026-09-15 clock decisions, rule 2).** Argues against the 2026-09-21 Hina decision and the 2026-09-15 clock decision: holding every intent-gap scan and routing "advice only" to Potential with a 72 h promise is the decided design; "advice only" is already a P5-3/A.2 value; contact count is the sum of two decided limits.
- **F-R1-14** (R1 Field, major; Fable 5.1) — "Band karo" is said to trigger no action, but the spec's signal rules push the lead up, reset its age, or make a new lead. **Out of scope (argues against D1, rule 2).** Argues against D1: P4-24 and 4.6 row 10 say a stop message is "a message on the lead like any other" and "no opt-out"; one behaviour, not two.
- **F-R1-15** (R1 Field, major; Fable 5.1) — When the grower's real number is already on another grower, J8.2 refuses and leaves the SUL with no next step. **Already handled.** P1-35 "wrong contact details"/"duplicate" sends the lead to Admin who merges (J21.6); P5-27 stops both clocks on reject; the refusal screen's wording is Phase 4 layout (2.3).
- **F-R1-21** (R1 Field, major; Fable 5.1) — The 150 MB limit cannot be tested: no size is given for the map, photos, boundaries or history it must hold. **Misread.** Misread of testability for feasibility: 150 MB is a black-box storage test; component sizing is a builder choice; the feasibility argument is seam S20, owned by R6 (F-R6-40). Merged into it and refuted with it: F-R6-40 (R6 Build).
- **F-R2-10** (R2 Sales leadership, major; Fable 5.1) — Assigning a lead from the pool puts it on an SUL whose scope excludes it. **Misread.** A lead's territory is a placement record written at routing (P7-11, P7-12, A.2 required territory), and pool assignment is one of its four methods, so the lead is "of" the chosen SUL's territory under P2-17 and passes INV-7; P5-27 already treats pool assignment as reaching the SUL.
- **F-R2-13** (R2 Sales leadership, major; Fable 5.1) — The weekly WhatsApp names the bottom SUL, despite the no-leaderboard rule (S29). **Misread.** P2-11 "no leaderboards" is scoped to what the SUL sees; P1-1, P3-1, J14.1, J16.2 have every manager see the level below named and compared; upward visibility is the 2026-09-15 decision's stated pressure; R2 was told not to re-argue DR-11. Merged into it and refuted with it: F-R5-10 (R5 Trust).
- **F-R2-23** (R2 Sales leadership, minor; Fable 5.1) — A flag written without signal has no defined behaviour on the "phone first" RSM app. **Already handled.** P3-20 "nothing is cached for offline use" is the rule; the flag lives on the dashboard surface that needs signal; a failed write is shown per AR-14; the fix reverses an approved 15 Sept row.
- **F-R3-2** (R3 Marketing, major; Fable 5.1) — Nothing says whether a sale of a product other than the campaign's counts for the campaign. **Already handled.** Already handled by composition: a conversion is a lead state (P1-27, J3.3), a campaign's leads are the leads carrying it (J21.3, P5-17), and P3-2 forbids a narrower definition on any screen; J19.2's by-product breakdown only has content if other-product conversions count.
- **F-R3-3** (R3 Marketing, major; Fable 5.1) — A campaign holds one product and one crop, yet its leads are "grouped by product and by crop", and a lead has no product (seam S15). **Misread.** A.2/6.1 Lead store `crop`; every card shows a recommended product (J2.1, P2-7) derived from Products.treats; the "spans several products" premise is the reviewer's.
- **F-R3-4** (R3 Marketing, major; Fable 5.1) — "NPI campaign" and "Brand campaign" are streams while Facebook and TikTok also carry campaigns, so "by channel" has no field. **Misread.** "channel" is the spec's plural word for the 4.2 streams (1.1, P1-7), so Signal.stream/Lead.stream is the field; a Meta form arrives on stream=facebook with the campaign reference and Campaign.npi flags NPI-ness; NPI/Brand rows are landing-page connections (P4-1).
- **F-R3-10** (R3 Marketing, major; Fable 5.1) — PKR on Marketing's screen is self-declared, and no row makes the screen say so. **Misread.** Misread of D7's scope: DECISIONS says D7 blocks only incentive linkage; 1.7 D7 makes self-declared-with-receipt the Pilot's sanctioned value; P3-2's definitions page is the spec's mechanism for saying what a number means.
- **F-R3-11** (R3 Marketing, major; Fable 5.1) — Marketing's analytics cannot answer Marketing's one stated goal: no geography, crop, acreage band or last-season cut. **Misread.** P1-4's own example gives Marketing a crop cut; the quoted 1.2 row pairs the goal with campaign/portfolio/brand/channel totals and J20.2 compares campaigns; "where" as geography is the reviewer's reading.
- **F-R3-13** (R3 Marketing, major; Fable 5.1) — Replies to Marketing's own WhatsApp campaigns have no stream that carries a campaign. **Misread.** P5-9 files WhatsApp campaign replies as campaign signals, not WhatsApp inbound; P4-11 and the D3 rows give the interim "campaign unknown" behaviour for every channel; the WhatsApp leg of the ID convention is D3 itself (open, M5).
- **F-R3-14** (R3 Marketing, blocker; Fable 5.1) — A STOP sent to Syngenta's WhatsApp Business number is seen only by Synapse, which tells nobody; the number is then in breach of WhatsApp's opt-out rule. **Already handled.** Synapse never sends from the business number and 4.2 names its owner (digital team); channel opt-out is parked (6.3.2, DR-19).
- **F-R3-17** (R3 Marketing, major; Fable 5.1) — The "below threshold" count mixes three origins and hides unknown acreage, so Marketing cannot tell a small-farmer campaign from a form with no acreage field. **Already handled.** P3-8 requires unknown-acreage counted openly on every summary; P1-20 + P5-16 define the below-threshold total as never-routed leads, so an SUL-closed lead is not in it (P1-22's example says so); Hina closes most no-acreage leads into the same bucket.
- **F-R4-4** (R4 Product, major; Fable 5.1) — Almost all Pilot volume is held for Hina; P5-1's own "routed at once" example has a gap, and Hina's capacity is never stated. **Out of scope (restates the 2026-09-21 Hina decision and DR-23, rule 3).** Restates the 2026-09-21 Hina decision and DR-23 at Pilot scale (P5-1's own example is a Crop Doctor scan); the example "contradiction" needs an added "new grower" the line does not contain and sits on seam S13 (R6); capacity is R6-A3/R7-A2's; P5-8 already shows leads waiting.
- **F-R4-5** (R4 Product, major; Fable 5.1) — Month 3: with no cap and a 20-lead fold, the backlog drops out of sight, because overdue leads do not count as "due today". **Already handled; the backlog model restates DR-4 (rule 3).** Overdue leads are badged, counted, notified, mapped and first on the RSM's screen; J14.2 gives the RSM each SUL's segment counts; the backlog model rests on the finding's own supply assumption, which is the cap argument DR-4 records.
- **F-R4-7** (R4 Product, minor; Fable 5.1) — The e-commerce stream is scheduled into Capture although the Pilot does not use it. **Out of scope (argues against the 2026-09-11 Pilot decision, rule 2).** Argues against the 2026-09-11 decision "Capture is not the Pilot; Capture is all connectors"; the same argument would eject six other streams; moving P4-27a to 6.3.2 reverses Ahsan's 21 Sept addition.
- **F-R4-12** (R4 Product, minor; Fable 5.1) — Marketing's goal cannot be answered in the Pilot, and the spec does not say what Marketing gets from it. **Misread.** "where spend goes" is answered per channel, portfolio, brand, product and crop (J20.1, P1-4), all of which exist for one campaign arriving through several streams; the fix is derivable from 1.1 + J20.2.
- **F-R4-13** (R4 Product, blocker; Fable 5.1) — If Hina is not connected, down or behind, gap leads are held with no time limit: the "bound" is stated in attempts, not time. **Misread.** P5-2 sets the limit as attempts AND days, both Admin settings owned by Synapse; P5-5's example fixes "two days after arrival at most"; DR-23 and the 2026-09-21 decision name the wait as time-bounded (applies also to merged F-R6-51, F-R7-1). Merged into it and refuted with it: F-R6-51 (R6 Build), F-R7-1 (R7 Open).
- **F-R4-15** (R4 Product, major; Fable 5.1) — Location data for the Pilot zones is assumed ready; every shortfall sends leads to the RSM to route by hand, and nothing gates go-live on readiness. **Misread.** P4-29/P7-8 route a coordinate in no loaded boundary by nearest franchise; a missing franchise is not a routing gap in digitised areas (P7-3, P7-9); P7-16, P7-17 and P4-28 already show what is missing; boundaries and conversion are sequenced into M3.
- **F-R5-1** (R5 Trust, major; Fable 5.1) — "The grower's own contact" is not defined for signals Syngenta started (call-backs, replies to Marketing's outbound WhatsApp). **Out of scope (argues against D1, rule 2).** Argues against D1 ("any contact through any stream"): holding replies of unknown list source narrows the decision; the "who started" field is the canvas source/scope DR-19 records as dropped; P1-12 already redirects to P4-23.
- **F-R5-2** (R5 Trust, major; Fable 5.1) — The consent basis has no scope ("about that need") and no expiry. **Out of scope (restates DR-19, rule 3); the scenario cannot occur.** "No scope" restates DR-19 verbatim (canvas scope field dropped, recorded); "expiry" is the narrowing D1's reversal-cost paragraph describes; the 2024-scan-in-2026 scenario cannot occur because the basis is per lead and every new-season lead comes from a new signal (P5-19, P1-26, P1-34).
- **F-R5-5** (R5 Trust, blocker; Fable 5.1) — A STOP on Syngenta's WhatsApp Business number is held with no action and no Legal confirmation of the position is recorded. **Out of scope (argues against D1, rule 2).** P4-25b is an opt-out mechanism by another name, which D1 (21 Sept) rules out and DR-19 pre-registers; P4-25a asks the settled decision to be re-validated; the "no named decision-maker" gap is already recorded in DECISIONS and assigned to Ahsan; the shared-number premise is asserted, not in the spec.
- **F-R5-8** (R5 Trust, major; Fable 5.1) — The address is personal data (P7-13) yet goes to "an outside mapping service" (P7-14), and P7-14 implies that is safe. **Misread.** P7-13 forbids three destinations (export, summary, log) and a geocode call is none; P7-14 already strips every grower identifier; the DPA gap is F-R5-7's.
- **F-R5-9** (R5 Trust, major; Fable 5.1) — P6-12 residency has no scope (backups, queues, logs, the offline phone) and no fallback when the host has no Pakistan region. **Already handled.** A.3 "all grower data at rest in Pakistan" is the scope statement; the fallback is parked to Phase 3 with Ahsan as decider and a D5 substitution entry as the process.
- **F-R5-16** (R5 Trust, major; Fable 5.1) — Retention removes "name, number, location and receipts", but the raw signal, grower words, Hina summaries and old-number history are kept "unchanged". **Already handled.** 6.1's preamble makes retention removal apply to every item marked (personal), which covers words, Hina summary and number history; A.2 audit entry holds references and settings values only; three lines forbid a number in a log line.
- **F-R5-17** (R5 Trust, major; Fable 5.1) — No retention for personal data outside an inactive grower: "no contact" signals, removed and rejected leads, an active grower's old PII, the audit trail, learning examples. **Out of scope (argues against the 2026-09-17 inactivity decision, rule 2); already handled for the rest.** Three of five sub-claims fail: age-based removal argues against the 2026-09-17 inactivity decision; P6-15 states the audit period (permanent); learning examples are covered by P6-11 "stay without identity".
- **F-R5-24** (R5 Trust, major; Fable 5.1) — Nothing detects or counts a shared-number merge in error, so the un-park trigger for a split can never fire; Hina's "wrong number" has no rule. **Misread.** Misread of D4: its un-park trigger is a human field report raised as a change request, not an in-product counter; the field can report via P1-32's comment, P1-35's Admin list and DBO support; P4-20 and AR-5 block silent renames.
- **F-R6-10** (R6 Build, major; Fable 5.1) — P1-14 "clear purchase intent" has three examples and no rule; the franchise example has no object. **Already handled.** P4-9 and P5-21 map the three-valued intent reading onto the gate ("unclear" is never Hot until Hina or the SUL's tap); P1-14 carries its own positive and negative test case; the franchise example is Ahsan's 15 Sept wording and Hot separately needs crop.
- **F-R6-20** (R6 Build, major; Fable 5.1) — No WhatsApp to staff in the Pilot versus a weekly WhatsApp summary to managers (S2). **Misread.** P1-42 restricts "notification", an enumerated set (P2-15, P3-14); the weekly summary is a separate module (3.2) and noun (P6-7); both rows are Ahsan's same-day answers.
- **F-R6-31** (R6 Build, minor; Fable 5.1) — The fold is "low scores" in two rows and "the first 20" in another. **Misread.** P1-23/P2-2 give no score threshold and describe a positional cut in a ranked list; P5-20 plus fold_size (20) supply the only number (answered 21 Sept); P5-20 folds the lowest-scoring due leads, not "regardless of score".
- **F-R6-35** (R6 Build, minor; Fable 5.1) — "One named owner" per list, but two lists name two owners. **Already handled.** The location list's ownership is split by named part with one owner each (4.5, P7-15, P7-16, DECISIONS 2026-09-28), which is what the fix asks for.
- **F-R6-36** (R6 Build, major; Fable 5.1) — Village boundaries: no source, format, licence or late-arrival rule. **Already handled.** Ahsan's 25 Sept note says the boundaries exist (so "ASSUMPTION" is wrong); P7-16/4.5 name Admin as owner; A.2 Boundary gives polygon format; P4-29 routes a coordinate in no polygon by nearest franchise, not to the pool.
- **F-R6-38** (R6 Build, major; Fable 5.1) — No Hina capacity row, yet P6-9's burst and P5-5's "two days at most" both need one. **Misread.** The two-day limit is a Synapse-owned setting that holds whatever the vendor's capacity; over-capacity leads are called in score-then-age order and the rest route with gaps open (P5-2, P5-5, P5-6); neither P5-5 nor P6-9 depends on a capacity number.
- **F-R6-53** (R6 Build, minor; Fable 5.1) — Hina's queue is ordered by a score that 5.1 says does not exist yet. **Misread.** P5-13 re-scores "on every answer from Hina", which presupposes a score on arrival; the scorecard is defined on a lead with gaps (unknown scores zero / middle value); A.2 Score and A.3 answer stored, P5-1 answers visible, P5-5 answers segmented.
- **F-R6-58** (R6 Build, major; Fable 5.1) — "Campaign unknown" leads have no segment, and the Pilot's campaign is unknown until D3. **Already handled.** 5.4 is a complete partition keyed on "carries a campaign", so a campaign-unknown lead lands in Hot or Potential by P5-18/P5-19; the Pilot sentence restates the spec's own D3 rows.
- **F-R6-62** (R6 Build, minor; Fable 5.1) — The reachability adjustment is redefined with no opt-in input and no DR. **Misread.** 4.2 WhatsApp still reads "whether they messaged first" and 5.3 lifts the penalty on "message received from it", which is the canvas's own definition of opt-in; for other channels the arm is emptied by D1, a departure DR-19 records.
- **F-R7-2** (R7 Open, major; Fable 5.1) — Address-to-coordinate service failure: no rule, and no health line. **Already handled.** Geocoding is part of routing, which runs in workers with retries and an alerted, replayable dead-letter queue; P7-6/P5-1 rule out Hina for a complete address and P5-23/P4-29 reserve the pool for no-match or no-address leads.
- **F-R7-7** (R7 Open, major; Fable 5.1) — No row sets uptime, backup, restore or incident handling. **Out of scope (deferred by the adopted delivery process to INFRA.md, M8 and Phase 9).** Out of scope by the adopted delivery process (DECISIONS 2026-09-11): backup and restore belong to docs/INFRA.md at Phase 3, the M8 restore drill, and RUNBOOK.md plus go/no-go at Phase 9; P6-6 makes no claim about server restore; P6-17, P4-5 and P4-15 give partial incident handling.
- **F-R7-13** (R7 Open, minor; Opus 5.5) — No IT security review or group privacy sign-off before go-live. **Already handled.** Already handled for the security half: the adopted delivery process (DECISIONS 2026-09-11) runs a security review at Phase 3 (ARCHITECTURE/INFRA review with "what Syngenta IT will ask") and at the Phase 9 go/no-go, signed by Syngenta IT if involved; a conjunction with one half handled does not survive as stated.
- **F-R7-14** (R7 Open, minor; Opus 5.5) — Finance owns none of the money figures: the reconciliation view has no sign-off, spend has no source. **Misread.** The audit's "Sign-off" keeper is the automated reconciliation page (base44-audit.md, /SignOff "every KPI with its population and reconciliation checks"), which P3-2 keeps; spend source is Ahsan's 3.6 Q6 answer (Marketing enters it); who vouches for PKR values is open D7; receipt removal is his 17 Sept retention answer.
- **F-R7-15** (R7 Open, minor; Opus 5.5) — PKR display rules are incomplete: grouping, large totals and fractional figures. **Misread; already handled.** Two of four legs fail: P6-5 already forbids abbreviating totals ("never 'PKR 85k'"), and A.2/A.3 state paisa storage twice, so "recorded" cannot fairly read as rupee storage (misread / already handled). Merged into it and refuted with it: F-R6-33 (R6 Build).
- **F-R7-18** (R7 Open, minor; Opus 5.5) — Franchise name and coordinate are not tagged personal although franchisees are often sole proprietors. **Misread.** P5-25 and DECISIONS 2026-09-28 name DBO as owner of franchise points; the sole-proprietor premise is uncited, and spec and decisions describe a franchise as a point of sale.
- **F-R7-21** (R7 Open, major; Opus 5.5) — The D5 row says "Nothing here", but the residency rule forces a change to the default AWS stack. **Misread; already handled.** The hosting choice is recorded three times as an open Phase 3 hosting constraint (P6-12, A.3, DR-31) and D5 already schedules the Phase 3 stack revisit with any substitution logged; asking D5 to govern P6-12 restates DR-31 (plan §0 rule 3); AWS region claims are unsourced.
- **F-R7-25** (R7 Open, minor; Opus 5.5) — The other settings have no valid range, no rule for work in flight, and three have no change notification. **Misread.** P3-14 notifies Head of Sales of any settings change (also 3.2 and 4.5), so "three settings have no change notification" is false and the fix's "every change notifies Head of Sales" already exists.
- **F-R7-26** (R7 Open, major; Opus 5.5) — "In Urdu" has no localisation rules: direction, script, digits, date format. **Out of scope (a named Phase 4 deliverable, docs/UX.md).** SPEC 2.3 hands layout to Phase 4, and the delivery process lists "Urdu/English rules" as a named Phase 4 deliverable in docs/UX.md; direction, font, mixed-direction strings, digits and date style are localisation rules planned there.
- **F-R7-27** (R7 Open, major; Opus 5.5) — Hina's calling language is unspecified, and the grower's language can only be Urdu or English. **Out of scope (argues against a recorded decision, rule 2).** Argues against a recorded decision: DECISIONS 2026-09-21 premises Hina on an Urdu call, P5-2 gives call conduct to Hina, and the ur/en grower language follows the 17 Sept deferral of regional languages (parked in 6.3.2); the Sindhi-speaker chain has no source row.
- **F-R7-28** (R7 Open, minor; Opus 5.5) — Manager-side language is undefined: RSM lead-card reasons, the WhatsApp summary, and User.language (seam S27). **Misread.** P6-7 and 6.5 Q11 set "English only" for every manager screen including J14.3's card, and A.2 Score stores reasons in Urdu and English; the fix's manager language choice argues against the recorded 21 Sept answer.
- **F-R7-34** (R7 Open, minor; Opus 5.5) — The Mark column is empty on 162 of 189 numbered rows while the header's marking rules still read as live. **Misread; already handled.** The header ties "needs a mark" only to ASSUMPTION rows, none remain, and the version line records every part approved, so a blank Mark means "approved with its part"; the fix's post-v1.0 change-request rule is already in the header; marking is correctly live at v0.9.

---

## 4. Coverage

Taken from each raw file's attack ledger. "Came back empty" means the lens attempted the attack on those rows and found nothing in lens.

**R1 Field** — 7 of 7 attacks (R1-A1 to A6, seam S23); 23 findings. Empty: P5-30's worked Sunday example is arithmetically right; J14.3 gives the SUL no instruction; Contacted (J2.2, one tap), Visit planned (two taps), ask-and-log, the P2-11 leaderboard ban and reaching a campaign lead; what the SUL says about how they got the number (P2-7's consent line answers it); the consent line in the call-back case; P2-4 and P5-11 (reasons stored in Urdu and English); P2-6 and P1-11 (acreage labels always given). Handed on: lost-phone rules (R5), 2.5's stale D1 row (R6), 5.9's stale franchise-list cite (R6/R7).

**R2 Sales leadership** — 6 of 6 attacks, seams S11, S12, S14, S24, S29; 24 findings. Empty: P1-31 (no franchise on a conversion) and the new/existing mark (no manager view reports it); P5-10 (Hina's contact correctly excluded); the season boundary against the 14-day clock; P7-8's beyond-cap pool; P1-18, P5-12, P7-17, P3-8/P6-19 in lens; P1-17 (S23 is R1's). Matrix rows read with no R2 finding: P1-1, P1-17, P1-18, P1-20, P1-27, P1-31, P1-37, P1-40, P2-14, P3-8, P4-29, P5-10, P5-12, P5-18, P5-22, P6-13, P6-19, P7-8, P7-17.

**R3 Marketing** — 6 of 6 attacks plus seam S15; 17 findings. Empty: P1-18 (a Hot-qualifying campaign lead sits in Campaign, consistent with P5-17); P4-4 (repeat form merges, correct under INV-3); P3-12 against P5-16; P5-28 against P3-16; P4-27 (no purchased lists); the WhatsApp opt-in rule for Marketing's own sends (outside Synapse). Rows owned with no finding: P1-18, P3-12, P4-4, P4-27, P5-16, P5-28. Handed on: small-cell re-identification in aggregate cuts (R5, not filed by R5).

**R4 Product** — 6 of 6 attacks plus seam S28; 16 findings. Empty: P5-15 and P5-34 (proposals are human-applied and logged); P1-25 and P4-12 (healthy scans with unknown acreage reduce Hina volume); P2-21, P7-14 and the Part 7 boundaries (needed for the Pilot); the SUL, RSM, ZM, Head of Sales, PM and Admin goals (each has a screen row and a number); D3 for delivery (campaign leads still arrive); the call-centre platform (not a Pilot stream). Handed on: the stale DECISIONS 2026-09-17 lines (PKR on the card, automated WhatsApp).

**R5 Trust** — 6 of 6 attacks, seams S16, S17, S18, S19, S31; 26 findings. Empty: Facebook DMs and forms (grower-started); Cropwise's global tenant beyond F-R5-7; the audit trail's own append-only rule against removal (A.2 limits before/after values to settings); P7-12 placement record; audit of Admin's number undo; P3-9 exports (P6-3); INV-2 against "no split". Searched the whole spec for encrypt, wipe, PIN, password, offboard, deactivat, session, MFA and screenshot: only the P6-16, A.3, 6.3.2 and DR-18 password lines.

**R6 Build** — 6 of 6 attacks, all 16 owned seams (S1–S8, S10, S13, S20–S22, S25, S26, S32); 67 findings. Empty: P1-9, P1-10, P1-37, P1-39 (examples testable); P5-30; P3-7, P3-15, P3-16, P6-1, P6-3, P6-4 (observable as written); the 4.2 Crop Doctor row does list severity and confidence; P1-8, P1-34, P3-19, P5-26, P7-11 (placement fixed at routing); farm geometry (the canvas removed it); "Hot fills the cap first" (no cap, DR-4); "measure SLA compliance before linking incentives" (kept).

**R7 Open** — 6 of 6 attacks plus seams S9, S27, S30; 35 findings. Empty: the D6 "SUL sells around the franchise" gap (no Pilot behaviour); push costs (in-app only); weights, age floor, adjustments, cap km and fold under change (versioned or display-only); DR-21 repeating DR-13 (self-declared); "Zonal Manager" vs "Zonal Sales Manager" (declared aliases); "Hina" in P1-21 (defined inline); P4-27a (valid inserted ID); no ASSUMPTION label still stands.

**Skeptics** — 189, one per distinct claim. Fable 5.1 judged 166 (R1 to R6 and F-R7-2, 3, 5, 6, 7, 9, 11); Opus 5.5 judged 23 (F-R7-12 to F-R7-34).

### What this review did not look at

- **Grower data-subject rights** (plan B20: a grower asking what is held about them, correction, deletion on request). Assigned to R5-A1; no R5 finding or ledger line records the attack, so it is untested.
- **The legal side of product recommendations** (plan B21). R6 found the registration gap (F-R6-45); no R5 companion was filed.
- **Small-cell re-identification** in Marketing's aggregate cuts. R3 handed it to R5; not filed.
- **External law and platform terms** (PECA 2016, PTA 2009 regulations, the draft PDPB, Meta and TikTok lead-form terms, WhatsApp Business policy, Competition Act 2010). Cited from the reviewers' general knowledge; no text was verified. Syngenta Legal should confirm each clause before any finding that rests on one is applied.
- **DECISIONS.md itself.** Not under review. Three lenses flagged that the 2026-09-17 entry still states "indicative PKR value on the lead card" and "automated WhatsApp follow-up", both superseded without a superseding entry; the 2026-09-21 entry's "Why" miscredits the timing-table owner (F-R6-66).
- **Screens and layout** (Phase 4), **stack, hosting and infrastructure** (Phase 3), PLAN.md beyond checking what is absent, the Base44 code, and any real field data or user. Every lens was an agent persona; no SUL, RSM, Marketing, IT or Legal person was consulted.
- **The canvas** was read in full only by R6-A6 (canvas departures); other lenses used it to confirm absences.

### Plan and brief defects found on the way

- Plan §3.6 says R3 is required on 31 rows; §11 lists R3 on 25.
- Plan R7-A4 repeats "six promises"; A.2 Settings holds four (the other two are on each campaign), the same error as F-R6-34.
- Plan §5 says "PECA 2016 s.20-class"; the direct-marketing unsubscribe clause is s.25.
- The brief counts 188 numbered rows and a register of DR-1 to DR-31; P4-27a makes 189 rows and the register runs to DR-33 (F-R7-32).
- `merges.md`'s header still says 20 merged and 188 claims; F-R6-38 was un-merged, so it is 19 and 189.

---

## 5. Requirements with zero findings

All 189 numbered rows (P1-1 … P7-17, plus P4-27a) minus every row cited in the Rows field of a surviving entry (including findings merged into a surviving canonical; ranges such as "P5-1 to P5-10" expanded; F-R7-30's P5-30 dropped per its skeptic). **27 rows** have no surviving finding. A row here was read by at least one lens (plan §11); zero findings means nothing survived against it, not that it is perfect.

- **Part 1** (4): P1-9, P1-11, P1-15, P1-16
- **Part 2** (5): P2-5, P2-6, P2-12, P2-14, P2-18
- **Part 3** (3): P3-1, P3-12, P3-20
- **Part 4** (7): P4-6, P4-13, P4-22, P4-25, P4-26, P4-28, P4-30
- **Part 5** (1): P5-18
- **Part 6** (3): P6-1, P6-3, P6-5
- **Part 7** (4): P7-4, P7-7, P7-13, P7-17

---

## 6. D1–D9 touched

For each decision, the surviving entries whose "Decision check" names it, and what each says the decision leaves unspecified. No surviving finding argues against a decision; those were refuted (section 3). D8 is withdrawn and unused.

**D1 — Consent basis for advisory-captured data (decided 2026-09-18).**

- S12 · F-R5-4: touches D1 and the no-opt-out rule. They leave unspecified how a refusal is handled and shown; this finding does not ask for an opt-out.
- S38 · F-R3-15: touches D1. What it leaves unspecified is the platform's condition on form data; D1's basis is not argued.
- S46 · F-R5-3: touches D1. D1 grounds the call; what it leaves unspecified is what the grower is told.
- S70 · F-R6-21: touches D1. What it leaves unspecified: nothing; the table is stale.

**D2 — Cropwise platform access for Pakistan (open, filed 21 Sept).**

- S45 · F-R4-14: touches D2 (open). What it leaves unspecified is the Pilot's shape while it stays open.

**D3 — Campaign ID convention (open, decided in M5).**

- S32 · F-R3-1: touches D3. What it leaves unspecified is attribution when two campaigns reach one lead. D3 covers how a campaign is read, not which one wins.
- S35 · F-R3-7: touches D3. What it leaves unspecified is whether an unread campaign holds the signal.
- S36 · F-R3-8: touches D3. What it leaves unspecified is what happens to leads that arrived before it.

**D4 — Mobile number as the grower's key; shared-number rule (decided 2026-09-18).**

- S11 · F-R1-16: touches D4. What it leaves unspecified is which path a wrong number takes.
- S55 · F-R5-25: touches D4. D4 leaves unspecified how one person with two numbers is handled under one number, one grower.
- S56 · F-R5-26: touches D4. D4 says "verified" and leaves the meaning of verification and the handling of unverified numbers unspecified.
- S58 · F-R6-2: touches D4. What it leaves unspecified: the match rule for no-number signals.
- S71 · F-R6-22: touches D4. What it leaves unspecified: nothing; the tables are stale.
- S119 · F-R6-61: The skeptic says the Decision check should cite D4: the canvas's CNIC secondary key is dropped with no DR.

**D5 — Syngenta's recommended stack (decided 2026-09-11, revisit Phase 3).**

- No surviving finding names it.

**D6 — Territory vs franchise catchment conflict (open).**

- S60 · F-R6-23: touches D6. What it leaves unspecified: whether a D6 ruling may move a franchise point between BSAs, and therefore routing.

**D7 — Conversion value: self-declared or reconciled (open).**

- S20 · F-R2-5: touches D7. What D7 leaves unspecified: who checks a Pilot receipt against the declared value, and how often.
- S49 · F-R5-15: touches D7 (receipt as proof). D7 leaves how the receipt is captured unspecified.
- S90 · F-R7-16: touches D7. What it leaves unspecified is the permitted use of receipt contents.
- S97 · F-R1-7: touches D7. What it leaves unspecified is the multi-product receipt.

**D8 — Withdrawn 2026-09-16; not used.**

- No surviving finding names it.

**D9 — Healthy Crop Doctor scan is a lead only at or above the threshold (decided 2026-09-15).**

- S68 · F-R6-16: The skeptic says P4-12's Decision check should name D9: the healthy-scan row's observable is a dash.
- S77 · F-R6-44: touches D9. What it leaves unspecified: what the SUL offers on a healthy-scan lead.

---

## 7. Top 5 by severity

The four surviving blockers, then the major with the widest consequence.

1. **S1 · F-R2-1 · BLOCKER · R2** — A dial counts as contact. J2.2 moves a lead to Contacted and stops the contact clock on the tap, so an SUL who dials every lead and hangs up is 100% on time. The Pilot's headline number (P1-43) would measure dialling, not reaching the grower.
2. **S4 · F-R6-47 + F-R6-48 + F-R6-49 · BLOCKER · R6** — The lead state model is incomplete. Rejected, held-for-Hina and pooled leads have no state in P1-27 or A.2, the 1.5 arrows forbid transitions the journeys use, and a reassigned lead has no clock rule. The single transition function INV-5 requires cannot be written from the spec.
3. **S2 · F-R5-12 · BLOCKER · R5** — The SUL's personal phone holds every grower name, number and position in the territory offline, with no encryption, app lock, screenshot rule, remote wipe or lost-phone report.
4. **S3 · F-R5-13 (+ F-R7-8) · BLOCKER · R5, R7** — No offboarding. Nobody is named to deactivate a leaver, the Synapse password outlives the corporate mailbox, and a phone that never syncs again keeps the territory's data (INV-7).
5. **S21 · F-R2-6 (+ F-R6-29) · MAJOR · R2, R6** — The headline on-time rate has two denominators (P1-43 "leads due", P5-31 "leads that reached the SUL"), "due" has three meanings, and "completed" is undefined. With #1, the Pilot's one success number is undefined in both its numerator and its denominator.

Next in line among the majors: F-R4-6 (S42: the Pilot has no row-level scope, so it cannot be dated); F-R1-2 and F-R6-54 (S6, S82: an offline entry has no stop time, and "server wins" can drop a logged conversion); F-R4-9 (S43: no rollout, adoption or exit rules).

