# Base44 audit — Smart Agro Lite

**Task:** SYN-8 · **Date:** 2026-09-13 · **App:** "Smart Agro Lite", Base44 app id
`69690a59f22f6e749b0986ec`, the only app on the account.

**What this is.** A read-only description of the product Syngenta Pakistan
uses today, written so that Phase 2 can specify Synapse against what exists
rather than against memory. Base44 is reference, never source: no code is
carried across, and the mirror it was read from lives outside the repo at
`~/synapse-reference/base44/` (never committed).

**How it was read.** Seven allowed Base44 MCP tools only (readme,
list_user_apps, list_directory, read_file, grep, list_entity_schemas,
list_api_catalog, describe_api). `query_entities` was never called: every
statement below is about **structure**, never a record. No tool that edits,
runs, checkpoints, deploys or executes was called. The full tool log is in
Appendix A. Paths below are relative to the mirror's `app/` folder unless
they start with `schemas/`.

**Confidence key.** Findings are from a complete mirror (150 of 150 files,
8 of 8 entity schemas). Where a finding depends on platform behaviour the
export cannot show, it is listed in §8 Unknowns rather than asserted.

---

## 0. Ten findings that matter most

1. **All authorisation is in the browser.** The SDK client is created with
   `requiresAuth: false`; role and territory scoping is a client-side filter
   over records already fetched. CropScan, which holds every grower name,
   phone and GPS point, has a schema rule for **delete only**. Any signed-in
   user receiving the full table over the wire is the design, not a bug.
2. **There is no consent anywhere.** No entity, field, screen or rule records
   a consent basis or an opt-in. Growers are called from imported spreadsheets.
3. **There is no lead scoring.** `hot_lead` is a yes/no column typed into the
   import sheet. No score, no factors, no tiers, no SLA, no engine version.
4. **Identity is a free-text phone number on each scan.** Grower records are
   keyed by phone but scans are never deduplicated; the product's own
   documentation says duplicates are counted "by design".
5. **Lifecycle is two states plus flags.** Pending → Completed, with
   `converted`, `is_reported` and `hot_lead` booleans, written by direct
   entity updates from five different call sites with diverging behaviour.
6. **Ingestion is one manual Excel import by an admin.** Every source (CDS,
   Community, WhatsApp chatbot, Savera, two campaigns) enters through the same
   spreadsheet path. Validation errors do not block the import.
7. **The back end is one scheduled job.** A 09:00 Asia/Karachi cron invokes
   one Deno function that asks a Claude agent to post a daily summary to
   WhatsApp. Whether it has ever fired cannot be determined from the export.
8. **Money is a float in PKR**, entered by the officer after the visit, with
   no SKU or quantity. Revenue KPIs are documented as "a floor, not a total".
9. **Two sources of truth for role and territory** (platform `User` and
   app-owned `UserDirectory`), reconciled one way at login inside a swallowed
   try/catch.
10. **The product documentation claims a mutation-tested reconciliation
    harness.** No test file, runner or script exists in the app.

---

## 1. Journey — each user type, step by step

Five roles exist on the `User` entity: `admin`, `user` (the Sales Unit Lead,
"SUL"), `zsm`, `rsm`, `product_manager`. The last three are view-only
"manager" roles. Growers are not users. A sixth participant, whoever holds
the WhatsApp number the daily summary goes to, is a recipient, not a user.

### 1.1 Sales Unit Lead (`user`) — the only role that works a lead

| Step | Screen | What happens |
|---|---|---|
| 1 | Base44 hosted login | Opens the app URL on a phone. No self-registration: an unregistered account lands on a "user not registered" page (`components/UserNotRegisteredError.jsx`). |
| 2 | AuthGuard wall | `components/auth/AuthGuard.jsx` looks the user up in `UserDirectory`, overrides the session role with the directory role, and admits only if `assigned_sales_units` is non-empty. Otherwise a "No Sales Units Assigned" wall. |
| 3 | Map (`/`) | Leaflet map of scan markers for the assigned units only (the one place scoping happens in the query, `pages/Map.jsx:228-236`). Default chips: "This Week", growers "New". Four marker colours: converted dark green, completed light green, open hot-lead orange, open red. Reported scans hidden. |
| 4 | Scan card (dialog on Map or List) | Farmer name, phone, village, crop, diagnosis (or, for Savera, a chat snippet), acre, hot-lead flame, grower New/Existing toggle, buttons Call · Navigate · Mark Complete · Report. |
| 5 | Scan card → Call | `call_count` +1 on the scan, one ActivityLog row of type `call`, then a `tel:` link. |
| 6 | Scan card → Navigate | `navigation_count` +1, ActivityLog `navigation`, Google Maps directions deep link. |
| 7 | Scan card → Mark Complete → "Did the farmer convert?" | **Yes:** value in PKR (must be > 0) and a proof photo (camera or gallery, required) → scan becomes Completed, `converted=true`, `conversion_value`, `proof_image_url`, `completed_by/at`; ActivityLog `completion` + `conversion`. **No:** one of four reasons (comment required for "Other") → Completed, `converted=false`, reason stored; ActivityLog `completion`. |
| 8 | Scan card → Report | Reason `my_scan` / `syngenta_team_scan` / `others` (+ comment) → `is_reported=true`, hidden from the map; only an admin can un-report or delete. |
| 9 | List (`/Farmers`) | The same scans as a paged list (20/page), search by name, phone or village, cascading location filters; the same card and actions. |
| 10 | Growers (`/Growers`) | One row per phone number seen in the SUL's scans, merged with the `Grower` entity; toggle New ⇄ Existing; a "backfill" button creates a New grower for every phone without one. |
| 11 | Dashboard (`/Dashboard`) | Overview tab only: scoped KPIs (scans, connected, conversions, revenue). |
| 12 | Profile (`/Profile`) | Identity, assigned units, gamification points, badges, leaderboard (top 5 + own rank), logout. |
| — | Offline | Writes from the Map, List and card are queued in localStorage and replayed on reconnect (`components/offline/*`). Reads are not cached: offline, the map is empty. |

### 1.2 Admin

| Step | Screen | What happens |
|---|---|---|
| 1 | Login | Session role `admin` passes AuthGuard with no directory lookup. |
| 2 | Admin (`/Admin`) · tab Excel Import | Upload `.xlsx/.xls/.csv` → header check for 16 expected columns → per-row checks (phone, Sales Unit, lat/long ranges) → preview → **Confirm is enabled even with errors** → `ImportBatch` created → `CropScan.bulkCreate` in batches of 50 with per-row fallback → batch closed with counts and the first 20 error reasons. Every imported scan starts Pending. |
| 3 | Admin · tab User Management | Edit role and the assignment arrays (units / zones / regions / sources by role), deactivate, "Sync Users" (creates a directory row for every User lacking one). Writes `User` then `UserDirectory`. |
| 4 | Admin · tab Territory Assignment | Pick a user, tick sales units from the SalesStructure master; writes `User.assigned_sales_units`, then best-effort `UserDirectory`. |
| 5 | Admin · tab Email Campaign | Subject, body, optional file (appended to the body as a link), recipients (all active users by default) → one `Core.SendEmail` per recipient in a serial loop → one `EmailLog` row. No error handling around the loop. |
| 6 | Admin · tab Reporting Dashboard | KPI summary. |
| 7 | Dashboard | All three tabs (Overview, Performance, Usage Analytics); unassigned-scans panel; reported scans with Restore / Delete / Delete all reported (no confirmation on the bulk delete). |
| 8 | Reports hub (`/Reports`) | Six reports (Executive Overview, Geography, Sales Team, Pipeline, Revenue Analysis, Category Performance), Sign-off (every KPI with its population and reconciliation checks) and Report Notes (metric definitions). Each has an XLSX export with an "About" sheet, disabled if the fetch was incomplete. |
| 9 | Map / List / Growers | All scans nationwide; can revert a Completed scan to Pending. |
| 10 | URL-only pages | `/Stats`, `/MonthlyPerformance`, `/ExportAllScans`, `/ExportIncipio`, `/ExportIsabionGold`, `/DownloadDocs`, `/DailyReport` — no navigation entry. |

### 1.3 Zonal Sales Manager (`zsm`) and Regional Sales Manager (`rsm`)

| Step | Screen | What happens |
|---|---|---|
| 1 | Login → AuthGuard | Admitted only with a non-empty `assigned_zones` (ZSM) or `assigned_regions` (RSM) in the directory. |
| 2 | Bottom nav | Dashboard · Map · Reports · Profile. No List, Growers or Admin entry. |
| 3 | Map | Whole CropScan table fetched, then filtered in the browser: ZSM by a zone *derived* from the SalesStructure master, RSM by `region`. Scan card without Call / Navigate / Complete / grower buttons. |
| 4 | Dashboard | All three tabs, scoped. |
| 5 | Reports | The six reports, Sign-off and Notes, scoped by the same filter. Also `/MonthlyPerformance`. |
| — | Leaks | `/Farmers` has no manager gate, so a manager who types the URL can complete and convert scans. `/ExportAllScans` and the two campaign exports have no role logic at all and download every scan nationwide. |

### 1.4 Product Manager (`product_manager`)

Identical to 1.3, scoped by `assigned_sources` against `scan_source` (a scan with
no source counts as CDS). The Map's source chips show only the assigned
sources. The assignable list has five sources; the entity enum has six
(Isabion Gold Campaign cannot be assigned).

### 1.5 The grower

Never touches the app. Their scan arrives in an admin's spreadsheet from an
upstream system (Crop Doctor export, community post, WhatsApp chatbot, Savera
transcript, a campaign sheet), gets a sales unit from the sheet, and appears
as a marker. They then receive a phone call or a farm visit from the SUL. No
consent is recorded, no message is ever sent to them by the app, and nothing
tells them a scan became a sales lead.

### 1.6 The WhatsApp summary recipient

Every day at 09:00 Asia/Karachi a scheduled workflow invokes a Deno function
that opens a conversation with the `daily_summary_agent` (model
`claude_opus_5`, read-only on CropScan, UserDirectory, SalesStructure) as the
**service role**, asking for yesterday's new scans, conversions and PKR, hot
leads, pending visits, source breakdown and top three sales units. A manager
can also connect to the same agent on WhatsApp through the link on
`/DailyReport` and ask questions. Delivery is unproven (§8).

---

## 2. Front end

Stack: Vite + React, `@base44/sdk`, react-query, react-router, react-leaflet
on OpenStreetMap tiles, recharts, shadcn/ui, `xlsx`. Mobile-first web app;
there is no native app. English UI with an Urdu `@font-face` for data values.

### 2.1 Screens

Every route is wrapped by `Layout` → `AuthGuard` (`Layout.jsx:23`). "Gate"
means a page-level role check; "scoped" means data filtered by role after
fetch (`lib/roleScope.js`). Seven routes are reachable by URL only.

| Route | Component | Who reaches it, and where enforced | Shows | Links to |
|---|---|---|---|---|
| `/`, `/Map` | `pages/Map.jsx` | All roles; scoped `Map.jsx:253`; SUL query pre-scoped `:228-236` | Marker map with quick filters (date, source, farm size, growers, more), stats strip (leads / on map / done / conv), scan card | Bottom nav |
| `/Dashboard` | `pages/Dashboard.jsx` | All; Performance and Usage tabs admin + managers `:102-104,238` | KPIs; source analytics; admin: unassigned-scans panel, reported scans with restore / delete | Bottom nav |
| `/Farmers` ("List") | `pages/Farmers.jsx` | All by URL; managers have no nav entry (`BottomNav.jsx:13-16`) and **no page gate**; scoped `:69` | Paged list, search, filter panel, scan card | Bottom nav |
| `/Growers` | `pages/Growers.jsx` | Admin + SUL; managers blocked `:149` | Grower directory merged with scans, New/Existing toggle, backfill | Bottom nav |
| `/Profile` | `pages/Profile.jsx` | All; sales-unit card hidden for admin `:119` | Identity, units, gamification, logout | Bottom nav |
| `/Admin` | `pages/Admin.jsx` | Admin only `:26` | Five tabs: reporting dashboard, Excel import, user management, territory assignment, email campaign | Bottom nav |
| `/Reports` | `pages/Reports.jsx` | Admin + managers `:32-34` | Hub with six report cards, Sign-off, Notes | Six reports, SignOff, ReportNotes |
| `/ExecutiveOverview` | `pages/ExecutiveOverview.jsx` | **No gate**; scoped `components/reports/useReportData.js:53` | Headline KPIs, 12-month trend, zone split | Reports, Notes |
| `/Geography` | `pages/Geography.jsx` | same | Zone → region → sales-unit drill-down | same |
| `/SalesTeam` | `pages/SalesTeam.jsx` | same | SUL leaderboard, headcount, territory coverage | same |
| `/Pipeline` | `pages/Pipeline.jsx` | same | Uncontacted and pending leads, ageing bands, alert when ≥50% never called | same |
| `/RevenueAnalysis` | `pages/RevenueAnalysis.jsx` | same | Value bands, contribution by crop and zone | same |
| `/CategoryPerformance` | `pages/CategoryPerformance.jsx` | same | Revenue and scans by source, export | same |
| `/SignOff` | `pages/SignOff.jsx` | same | Every KPI with its population and reconciliation checks (`lib/reconcile.js`) | same |
| `/ReportNotes` | `pages/ReportNotes.jsx` | same | Metric definitions | Reports |
| `/Stats` | `pages/Stats.jsx` | All by URL; admin-only conversion block `:93` | Scan totals, crop and disease distributions | none inbound |
| `/MonthlyPerformance` | `pages/MonthlyPerformance.jsx` | Admin + managers `:182`; URL only | Monthly leaderboard, top performers, CSV | none inbound |
| `/ExportAllScans` | `pages/ExportAllScans.jsx` | **Any signed-in user; no gate, no scope** `:68` | One-click XLSX of every scan | none |
| `/ExportIncipio`, `/ExportIsabionGold` | `pages/Export*.jsx` | same | XLSX of one campaign's scans | none |
| `/DownloadDocs` | `pages/DownloadDocs.jsx` | none | Downloads the product documentation markdown | none |
| `/DailyReport` | `pages/DailyReport.jsx` | none | WhatsApp connect link for the summary agent | none |
| `*` | `lib/PageNotFound.jsx` | — | 404 | `/` |

Not routed at all: `pages/OAuthConsent.jsx` (an MCP consent page whose config
file does not exist in the app), `components/ProtectedRoute.jsx` (never
imported).

### 2.2 Navigation

One fixed bottom tab bar (`components/navigation/BottomNav.jsx:6-25`) is the
only global navigation. Entries by role: SUL → Dashboard, Map, List, Growers,
Profile · Admin → the same plus Admin and Reports · managers → Dashboard, Map,
Reports, Profile. Report pages share `components/reports/ReportShell.jsx`
which adds back-links to the hub and Notes. Nothing links to the seven
URL-only pages. Navigation is the visibility rule; it is not the access rule
(§5 rows 35-38 and §1.3 leaks).

### 2.3 Forms

No form library and no shared validator: every check is a `disabled=`
predicate duplicated in the handler. Writes go straight to Base44 entities
from the browser.

| # | Form (file) | Fields | Validation | Writes |
|---|---|---|---|---|
| 1 | Convert — Yes (`components/scan/ScanCard.jsx` steps `question` → `upload`) | conversion value (number, min 1); proof image (camera capture or gallery, `accept="image/*"`) | value required and > 0 although labelled optional (`:41`); proof required (`:115,376`); no maximum, no file size or type check beyond `accept` | `Core.UploadFile` → `CropScan.update` via the parent (`pages/Map.jsx:337-364`, duplicated at `pages/Farmers.jsx:146-168`): `status`, `completed_by/at`, `converted=true`, `conversion_value`, `proof_image_url`. Two `ActivityLog.create` rows (`completion`, `conversion`). |
| 2 | Convert — No (`ScanCard.jsx` `ConversionNoReason`) | reason (four buttons, enum); comment (only for Other) | reason required; comment required and trimmed when Other (`:136,391-392`) | Same parent update with `converted=false`, `conversion_value=null`, `non_conversion_reason/comment`. One ActivityLog `completion`. |
| 3 | Report a scan (`ScanCard.jsx` `ReportContent`) | reason (three buttons, enum); comment when `others` | comment required when `others` (`:229,402-403`) | `CropScan.update`: `is_reported`, `report_reason/comment`, `reported_by/at`. Card auto-closes after 1.5 s. |
| 4 | Grower status toggle (`ScanCard.jsx:304-327`, `pages/Growers.jsx:92-111`) | one toggle New ⇄ Existing | null-status guard only | `Grower.update` if a row exists for the phone, else `Grower.create` (`phone_number`, names, `status`, `marked_by/at`). |
| 5 | Grower backfill (`pages/Growers.jsx:113-145`) | button | none | `Grower.bulkCreate` in chunks of 100, one New grower per scan phone lacking a row. |
| 6 | Email campaign (`components/admin/EmailCampaign.jsx`) | subject; body; attachment (any type); recipient multi-select over active users | subject and body required (`:87,247`); recipients unvalidated; no attachment limit; the "attachment" is a URL line appended to the body (`:93-95`) | `Core.SendEmail` per recipient in a serial loop (`:96`, hard-coded sender name), then one `EmailLog.create` including the recipient email list. No try/catch: one failure aborts the loop, leaves the UI stuck sending and writes no log. |
| 7 | Excel import (`components/admin/ExcelImport.jsx`) | file (`.xlsx/.xls/.csv`); preview; Confirm | 16 required headers (`:49-66,206`); per row: phone required (`:216`), Sales Unit required (`:220`), lat −90..90 (`:226`), long −180..180 (`:229`); Source matched case-insensitively against five values, unmatched passed through for the platform to reject (`:26-35`). **Errors do not block Confirm** (`:597-599`); the "valid rows" count over-subtracts when a row has several errors (`:407`). | `ImportBatch.create` (Processing) → `CropScan.bulkCreate` in 50s with per-row fallback on batch failure → `ImportBatch.update` with counts, Completed, first 20 errors (`:249,333,339,356`). |
| 7a | Import parsing rules | — | — | Sheet 0 only; row 1 headers; blank rows dropped. Date accepts a JS Date, an Excel serial or a string, coerced to UTC midnight, **defaulting to today on failure** (`:268-292`). Lat/long `parseFloat || 0`, so a bad value becomes 0 (`:319-320`). Acre NaN → null. Hot Lead = "yes" any case. A source tag in the disease column (community, campaign, whatsapp, "not detected") is re-routed to `scan_source` and the diagnosis forced to Healthy (`:16-47`). Header → field map: Farmer Crop Photo → `image_url`, Date → `scan_date`, Crop detected → `detected_crop`, Disease detected (EN) → `disease_diagnosis`, phone → `phone_number`, First/Last Name, Zone, Region, District, Tehsil, Sales Unit, Village/Mo → `village`, Lat/Long, BSA Name → `assigned_bsa_name`, Acre, Hot Lead, Source. |
| 7b | Fix existing scan dates (same file) | button | aborts if the paginated read was incomplete (`:104-108`) | `CropScan.update` on `scan_date` only, 20 at a time. |
| 8 | Edit user (`components/admin/UserManagement.jsx`) | name, email (read-only); role (five options); assignment checklists shown by role | none beyond "a user is selected" (`:166`); choosing a new role does not clear the old role's assignments | `User.update` (role, four arrays, `is_active:true` always, `:103,176`) then `UserDirectory.update` (`:122`). "User not found" is swallowed; other errors surface after the directory write. Deactivate writes `is_active:false`. "Sync Users" does `UserDirectory.bulkCreate`. |
| 9 | Territory assignment (`components/admin/TerritoryAssignment.jsx`) | user (single); sales units (checklist + search from the SalesStructure master) | user required (`:92`); zero units allowed | `User.update({assigned_sales_units})` (`:49`), then `UserDirectory` update or create — **errors swallowed** (`:66-68`). |
| 10 | Filters (`components/filters/FilterPanel.jsx`, `components/map/MapQuickFilters.jsx`, `components/reports/ReportDateFilter.jsx`) | crop, status, conversion, hot lead, acre min/max, date from/to, seven cascading location selects | none; min/max not cross-checked; cascade clears children | nothing (local state) |
| 11 | OAuth consent (`pages/OAuthConsent.jsx:82-95`) | approve / deny | none | `POST /api/apps/{appId}/mcp/authorize-grant`; not routed; dead. |

Writes outside any form: the Dashboard's admin delete / un-report / delete-all-
reported mutations (`pages/Dashboard.jsx:126-143`, no confirmation on the bulk
delete); the offline replay (`components/offline/offlineSync.jsx:56-65`); the
Call and Navigate counters (`ScanCard.jsx:352-362`).

---

## 3. Back end

The back end is almost nothing. Every read, write, import, export, email and
map runs in the browser through `@base44/sdk` against Base44's entity and
integration API. `src/api/base44Client.js` is a 14-line bootstrap with
`requiresAuth: false`. There is no `.env.example`; the only environment
variables are three Vite build-time values, undocumented.

### 3.1 Workflows

| Workflow | Trigger | Steps | Verdict |
|---|---|---|---|
| `Daily WhatsApp Summary` (`base44/workflows/Daily WhatsApp Summary.jsonc`) | Scheduled cron `0 9 * * *`, `Asia/Karachi`, never ends, no condition (`:26-41`) | One step: `invoke_backend_function` → `sendDailySummary` → end (`:11-23`) | Wired, unverifiable: definition is valid; no run history exists in the export. |

There are no other workflows, no event-triggered workflows, and no webhooks
(no `trigger_type: webhook`, no inbound endpoint, no signature verification).

### 3.2 Backend functions

| Function | Runtime | Called by | Does | Verdict |
|---|---|---|---|---|
| `sendDailySummary` (`base44/functions/sendDailySummary/entry.ts`, 23 lines) | Deno, `npm:@base44/sdk@0.8.44` (client pins `^0.8.48`) | Only the workflow above. No UI call: grep of `src/` for `base44.functions` returns nothing. | `createClientFromRequest(req)` → `asServiceRole` → `agents.createConversation` with `daily_summary_agent` → posts one hard-coded English prompt describing the report → returns `{success, conversation_id}` or HTTP 500 with the error message, which nothing reads. | Wired, unverifiable. |

### 3.3 Agents

| Agent | Config | Invoked by | Verdict |
|---|---|---|---|
| `daily_summary_agent` (`base44/agents/daily_summary_agent.jsonc`) | model `claude_opus_5`; read-only on CropScan, UserDirectory, SalesStructure; `allow_anonymous_access: false`; memory on; WhatsApp greeting set, Telegram and LINE empty | (a) the function above, as service role; (b) a human on WhatsApp via `base44.agents.getWhatsAppConnectURL('daily_summary_agent')` on `pages/DailyReport.jsx:8` | Wired, unverifiable. No record of sends exists (no EmailLog-style entity for agent output). |

### 3.4 Scheduled jobs and webhooks

- Scheduled: one, the 09:00 cron above.
- Webhooks: none inbound. The GitHub area of the platform API offers a sync
  webhook, but nothing in the app references it.
- `pages/OAuthConsent.jsx` expects `base44/mcp/config.json`; that file does
  not exist in the app. Dead as shipped.

### 3.5 Integrations

| Integration | Where | Credentials | Error handling | Verdict |
|---|---|---|---|---|
| Email, `Core.SendEmail` | `components/admin/EmailCampaign.jsx:96` | platform-managed | none: no try/catch around the per-recipient loop | Wired, fragile, unverifiable |
| File upload, `Core.UploadFile` | `EmailCampaign.jsx:75`, `components/scan/ScanCard.jsx:378` | platform | none; a rejected upload leaves the spinner on | Wired, unverifiable |
| LLM | no direct call (`InvokeLLM`, `ExtractData`, `GenerateImage` absent) | — | — | Only via the agent |
| WhatsApp | outbound only, via the agent | platform | — | Unverifiable |
| Excel import | `ExcelImport.jsx` (`xlsx` in the browser) | none | nested try/catch with per-row retry (`:289,335,341,376`) | Working, client-side |
| Excel export | `lib/exportXlsx.js`, `pages/ExportAllScans.jsx` | none | — | Working |
| Maps | react-leaflet, OSM tiles, marker icons from a CDN, Google Maps directions deep link | none (keyless) | — | Working; note `leaflet` itself is absent from `package.json` (peer dependency hoisting) |
| Base44 entities | ~38 call sites across `src/` | platform | mixed | Working; this is the real back end |
| Offline queue | `components/offline/offlineBase44.jsx` Proxy over create/update/delete/bulkCreate | none | optimistic `pending-<timestamp>` ids | Working, adopted by three files only (ScanCard, Farmers, Map); every other mutation bypasses it |
| Cropwise, Facebook, TikTok, call centre, any REST or webhook source | — | — | — | **Not attempted.** All sources arrive as spreadsheet rows. |
| Dead dependencies | `jspdf`, `html2canvas`, `@stripe/*`, `react-quill`, `canvas-confetti`, `react-markdown`, `@hello-pangea/dnd`, `three` in `package.json` | — | — | Zero imports |

### 3.6 Authentication and authorisation

- Base44 hosted login. `lib/AuthContext.jsx` handles `auth_required` (redirect)
  and `user_not_registered` (error page). No self-registration.
- `components/auth/AuthGuard.jsx` is the gate: admin passes on the session
  role; everyone else is looked up in `UserDirectory`, which **overrides** the
  session role and assignments because the session goes stale until re-login
  (`:25-36`). Access requires a non-empty assignment array for the role. For
  SULs the guard writes the directory's units back to the session with
  `auth.updateMe()` inside an empty catch (`:56-57`).
- Scoping: `lib/roleScope.js:14-41` filters fetched rows in memory. Only the
  SUL branch of the Map query filters server-side (one request per unit).
  Admin, ZSM, RSM and PM fetch the whole CropScan table
  (`lib/useCropScans.js:17`, `pages/Map.jsx:238`, `pages/SignOff.jsx:109`).
- `canActOnScans` (`roleScope.js:49-51`), the intended write gate, is defined
  and referenced nowhere.
- `useReportData.js:21` and `pages/Stats.jsx:24` scope on the raw session
  user, not the directory-corrected one, so a changed assignment scopes by
  stale values until re-login.

---

## 4. Data model

Source: `schemas/entities.json` from `list_entity_schemas` (8 entities), which
is byte-identical to `base44/entities/*.jsonc` in the app tree. No example
values exist in the schema. No record was read.

### 4.1 Entities

**CropScan** — the hub. 36 fields. Required: `phone_number`, `sales_unit`.

| Field | Type | Notes |
|---|---|---|
| `first_name`, `last_name` | string | grower name |
| `phone_number` | string, required | free text; the join key to Grower |
| `image_url`, `proof_image_url` | string (URL) | scan photo; proof of purchase |
| `scan_date`, `completed_at`, `reported_at` | string (date-time) | |
| `detected_crop` | string | |
| `disease_diagnosis` | string | for Savera holds a chat snippet |
| `scan_source` | enum: CDS, Community, Incipio Campaign, WhatsApp Chatbot, Savera, Isabion Gold Campaign | |
| `zone`, `region`, `district`, `tehsil`, `sales_unit` (required), `village` | string | free text, resolved against SalesStructure |
| `latitude`, `longitude` | number | |
| `acre` | number | |
| `assigned_bsa_name` | string | free-text staff name |
| `assigned_bsa_id` | string | described as "FK to User"; **never written** |
| `status` | enum Pending, Completed; default Pending | |
| `completed_by`, `reported_by` | string (user id) | |
| `converted` | boolean | |
| `conversion_value` | number | PKR, float |
| `call_count`, `navigation_count` | number, default 0 | |
| `import_batch_id` | string | |
| `is_reported`, `hot_lead` | boolean, default false | |
| `report_reason` | enum my_scan, syngenta_team_scan, others | |
| `report_comment`, `non_conversion_comment` | string | |
| `non_conversion_reason` | enum: Already purchased, Checking the App, Unaware of the Scan/Lead, Other | |

**Grower** — required `phone_number`, `status`. `phone_number` (string, "unique
key matched against CropScan.phone_number" by description only), `first_name`,
`last_name`, `status` (enum New, Existing; default New), `marked_by` (user
id), `marked_at` (date-time).

**ImportBatch** — required `file_name`. `uploaded_by`, `total_records`,
`successful_imports`, `failed_imports` (number), `status` (Processing,
Completed, Failed; default Processing), `error_log` (string). Write-only:
nothing in the app reads it.

**EmailLog** — required `subject`, `recipient_count`. `body`,
`recipient_emails` (comma-separated string), `attachment_url`,
`attachment_name`, `sent_by`, `status` (Sent, Failed; default Sent).

**ActivityLog** — required `activity_type`, `scan_id`, `sales_unit`,
`activity_date`. `activity_type` (enum call, navigation, completion,
conversion), `sul_user_id`, `sul_name`, `farmer_name`, `farmer_phone`,
`conversion_value`, `notes`. Grower name and phone are **copied** here from
the scan.

**UserDirectory** — required `user_id`. `full_name`, `email`, `role` (plain
string, no enum), `assigned_sales_units` / `assigned_zones` /
`assigned_regions` / `assigned_sources` (string arrays), `is_active` (default
true). A mirror of User, owned by the app.

**User** (platform entity, app-extended) — no required fields. `role` (enum
admin, zsm, rsm, product_manager, user; default user), `phone_number`, the
same four arrays, `is_active` (default true). `id`, `email`, `full_name`,
`created_date` etc. are platform built-ins, undeclared.

**SalesStructure** — required `zone`. `zone` (enum: four fixed city names),
`region`, `sales_unit`, `district`, `tehsil`, `province` (string; four
provinces named in prose, not as an enum). The entity description names a
seed workbook and month and calls itself the single source of truth for
resolving a scan's zone.

### 4.2 Row-level security in the schema

| Entity | read | create | update | delete |
|---|---|---|---|---|
| CropScan | open | open | open | admin |
| UserDirectory | admin **or** own row | admin | admin | admin |
| SalesStructure | open (`{}`) | admin (`write`) | admin | admin |
| Grower, ImportBatch, EmailLog, ActivityLog, User | no `rls` key at all | | | |

Whether an entity with no `rls` key is open or governed by a platform default
is not visible in the export (§8). The app's own documentation proposes a
CropScan read rule as "the suggested next hardening step", which implies none
exists today.

### 4.3 Relationships (all soft; no enforced foreign keys)

- CropScan.phone_number → Grower.phone_number (string match)
- CropScan.import_batch_id → ImportBatch.id
- CropScan.completed_by, reported_by, assigned_bsa_id → User.id
- CropScan.{zone, region, district, tehsil, sales_unit} → SalesStructure (string match, fuzzy in code)
- CropScan.scan_source → User/UserDirectory.assigned_sources
- ActivityLog.scan_id → CropScan.id; ActivityLog.sul_user_id → User.id
- Grower.marked_by, ImportBatch.uploaded_by → User.id
- UserDirectory.user_id → User.id (1:1 mirror)
- User.assigned_* → SalesStructure columns

### 4.4 Personal data and how it is marked

Not marked at all. No `pii`, `sensitive`, `masked` or redaction attribute
exists on any field, and there is no field-level rule. Grower name, phone, GPS
point, village and photos live on CropScan (read open to any signed-in user)
and are duplicated into ActivityLog (no rules at all). The only personal data
behind a read rule is staff name and email on UserDirectory.

### 4.5 Drift between schema and code

- Code writes no field that the schema lacks.
- Code reads platform built-ins the schema does not declare: `id`,
  `created_date`, `updated_date`, `created_by`, `created_by_id`,
  `User.full_name`, `User.email`.
- `CropScan.assigned_bsa_id` is dead: declared as a foreign key, never
  populated; assignment runs through `assigned_bsa_name` and unit scoping.
- Write-only fields: `ImportBatch.file_name/uploaded_by/total_records/
  error_log`; `ActivityLog.farmer_name/farmer_phone/notes`.
- `UserDirectory.role` has no enum while `User.role` does.
- `User.assigned_sources` and `UserManagement` offer five sources; the
  CropScan enum has six.

### 4.6 Where the schema disagrees with the canvas

| Canvas concept | In Smart Agro Lite |
|---|---|
| Canonical Lead Event with `sourceEventId` (L2) | CropScan is the spreadsheet row; no event id; no uniqueness constraint |
| Grower 360 keyed on a verified mobile (L3) | Grower keyed on a free-text phone; no verification; scans not attached to a grower record, only string-matched |
| Consent basis, scope, timestamp, opt-out (L3, Zone 00) | No field anywhere |
| Interaction history, one timeline per grower (L3) | ActivityLog per scan, four types, duplicated rows |
| Score, tier, factors, engine version (L5, L6) | `hot_lead` boolean; no score entity or fields |
| Lifecycle transitions (L7, L8) | `status` Pending/Completed plus `converted`, `is_reported` flags |
| Conversion = SKU, quantity, PKR, franchise, date (L8) | `conversion_value` float only, `completed_at` |
| Lost = one of five reason codes (L8) | Four reasons, different set |
| Territory: geo → beat → SO → region → zone (L4, L7) | Four fixed zones; text fields resolved by fuzzy match; sales_unit text on each row; no beat, no geo lookup, no franchise |
| Weights and SLAs in admin, versioned (Zone 00) | Not present |
| PII tagged in schema (A7) | Not present |
| Money in integer paisa (CLAUDE.md) | Float PKR |

---

## 5. Business rules

Every rule found, one sentence each, with the layer that enforces it and a
flag: **UI-ONLY** (the data layer would accept a violation through a direct
API call), **DATA-ONLY** (the schema or platform enforces it but no screen
shows it), **BOTH**. Paths are relative to the mirror's `app/` folder;
schema rows cite the per-entity `.jsonc`, which is identical to
`schemas/entities.json`.

Headline: of 177 rules, 19 live in the schema and 4 in the scheduled job.
The other 154 are client code. Every rule about who sees what, every
validity check on a conversion, every KPI definition and every threshold is
UI-ONLY.

### 5.1 Schema rules (entity layer)

| # | Rule | Where | Flag |
|---|---|---|---|
| 1 | A CropScan is invalid without phone_number and sales_unit. | CropScan.jsonc:181 | BOTH |
| 2 | Scan status is Pending or Completed; new scans default to Pending. | CropScan.jsonc:86-92 | BOTH |
| 3 | scan_source is one of six values (CDS, Community, Incipio Campaign, WhatsApp Chatbot, Savera, Isabion Gold Campaign). | CropScan.jsonc:36 | BOTH |
| 4 | report_reason is one of my_scan, syngenta_team_scan, others. | CropScan.jsonc:137 | BOTH |
| 5 | non_conversion_reason is one of four fixed reasons. | CropScan.jsonc:168 | BOTH |
| 6 | call_count and navigation_count start at 0. | CropScan.jsonc:118,123 | DATA-ONLY |
| 7 | is_reported and hot_lead start false. | CropScan.jsonc:132,163 | DATA-ONLY |
| 8 | Only an admin may delete a CropScan. | CropScan.jsonc:185-188 (RLS) | BOTH |
| 9 | A Grower needs phone_number and status; status is New or Existing, default New. | Grower.jsonc:17-38 | BOTH |
| 10 | A Grower is matched to scans by phone_number, described as the unique key but not constrained. | Grower.jsonc:3; pages/Growers.jsx:49 | BOTH |
| 11 | ImportBatch needs file_name; status is Processing, Completed or Failed, default Processing. | ImportBatch.jsonc:25-39 | BOTH |
| 12 | EmailLog needs subject and recipient_count; status Sent or Failed, default Sent. | EmailLog.jsonc:33-43 | DATA-ONLY |
| 13 | ActivityLog needs activity_type, scan_id, sales_unit, activity_date; type is call, navigation, completion or conversion. | ActivityLog.jsonc:7,53 | BOTH |
| 14 | UserDirectory is readable only by an admin or the user it describes. | UserDirectory.jsonc:58-70 (RLS) | DATA-ONLY |
| 15 | Only admins may create, update or delete a UserDirectory row. | UserDirectory.jsonc:71-84 (RLS) | BOTH |
| 16 | Users and directory rows are active unless explicitly deactivated. | User.jsonc:51; UserDirectory.jsonc:51 | DATA-ONLY |
| 17 | Role is admin, zsm, rsm, product_manager or user; default user. | User.jsonc:7-14 | BOTH |
| 18 | SalesStructure needs a zone; zone is exactly one of four canonical values. | SalesStructure.jsonc:27-37 | DATA-ONLY |
| 19 | SalesStructure is readable by all and writable by admins. | SalesStructure.jsonc:39-43 (RLS) | DATA-ONLY |

### 5.2 Access, roles and scoping

| # | Rule | Where | Flag |
|---|---|---|---|
| 20 | Admin sees every scan. | lib/roleScope.js:16 | UI-ONLY |
| 21 | ZSM sees only scans whose derived zone is in assigned_zones. | roleScope.js:17-24 | UI-ONLY |
| 22 | If the sales master has not loaded, ZSM falls back to raw zone matching. | roleScope.js:26 | UI-ONLY |
| 23 | RSM sees only scans whose region is in assigned_regions. | roleScope.js:28-31 | UI-ONLY |
| 24 | Product Manager sees only scans from assigned_sources. | roleScope.js:32-37 | UI-ONLY |
| 25 | A scan with no scan_source counts as CDS everywhere. | roleScope.js:36; pages/Map.jsx:290; pages/CategoryPerformance.jsx:34; pages/ExportIncipio.jsx:34 | UI-ONLY |
| 26 | SUL sees only scans in assigned_sales_units. | roleScope.js:38-40 | UI-ONLY |
| 27 | ZSM, RSM and PM are view-only analytics roles. | roleScope.js:44-46 | UI-ONLY |
| 28 | Only admin and SUL may call, navigate, complete or convert a scan (defined, never called). | roleScope.js:49-51 | UI-ONLY |
| 29 | Manager roles get no Call, Navigate, Complete or grower buttons on a scan card. | components/scan/ScanCard.jsx:284,534,545,556,585 | UI-ONLY |
| 30 | Only an admin can revert a completed visit to Pending. | ScanCard.jsx:595 | UI-ONLY |
| 31 | Unauthenticated users are redirected to login. | components/auth/AuthGuard.jsx:13-17 | BOTH (platform login) |
| 32 | For non-admins, the UserDirectory role overrides the session role. | AuthGuard.jsx:25-35 | UI-ONLY |
| 33 | A user with zero assignments for their role is denied the whole app. | AuthGuard.jsx:42,47,52,61 | UI-ONLY |
| 34 | A SUL's User.assigned_sales_units is re-synced from the directory at login when they differ. | AuthGuard.jsx:56-58 | UI-ONLY |
| 35 | The Admin portal is admin-only. | pages/Admin.jsx:26 | UI-ONLY |
| 36 | The Growers page is blocked for manager roles. | pages/Growers.jsx:149 | UI-ONLY |
| 37 | Reports are for admins and manager roles only. | pages/Reports.jsx:32-34 | UI-ONLY |
| 38 | Navigation: managers get no List, Growers or Admin; Reports only for admin and managers; Admin tab admin-only. | components/navigation/BottomNav.jsx:12-24 | UI-ONLY |
| 39 | Dashboard Performance and Usage tabs are for admin and managers only. | pages/Dashboard.jsx:104,247 | UI-ONLY |
| 40 | A SUL never loads the user directory. | Dashboard.jsx:70 | UI-ONLY |
| 41 | The Map fetches only the SUL's assigned units; every other role fetches everything and filters in the browser. | pages/Map.jsx:228-238 | UI-ONLY |
| 42 | A PM's source chips list only their assigned sources. | Map.jsx:394-400 | UI-ONLY |

### 5.3 Lead actions and lifecycle

| # | Rule | Where | Flag |
|---|---|---|---|
| 43 | Marking complete stamps status, completed_by and completed_at. | Map.jsx:341-345; pages/Farmers.jsx:150-154 | UI-ONLY |
| 44 | "Yes, converted" is blocked until a conversion value greater than zero is entered. | ScanCard.jsx:41 | UI-ONLY |
| 45 | A conversion cannot be confirmed without a proof-of-purchase image. | ScanCard.jsx:115,376 | UI-ONLY |
| 46 | A non-conversion requires a reason; reason "Other" requires a comment. | ScanCard.jsx:136,390-394 | UI-ONLY |
| 47 | Completing writes an ActivityLog completion; a conversion also writes a conversion row. | ScanCard.jsx:380-382 | UI-ONLY |
| 48 | A non-conversion logs the completion with the reason in notes. | ScanCard.jsx:396 | UI-ONLY |
| 49 | Activity-log write failures are swallowed and never block the action. | ScanCard.jsx:342 | UI-ONLY |
| 50 | Pressing Call increments call_count, logs, then dials. | ScanCard.jsx:352-356 | UI-ONLY |
| 51 | Pressing Navigate increments navigation_count, logs, then opens directions. | ScanCard.jsx:358-362 | UI-ONLY |
| 52 | Reverting clears completed_by/at, converted, conversion_value and the proof image. | Map.jsx:349-356; Farmers.jsx:158-165 | UI-ONLY |
| 53 | Reverting from the Map also deletes that scan's completion and conversion log rows; reverting from the List does not. | Map.jsx:357-360 vs Farmers.jsx:158-165 | UI-ONLY |
| 54 | Reporting a scan requires a reason ("others" requires a comment) and stamps reported_by/at. | ScanCard.jsx:229,401-411 | UI-ONLY |
| 55 | Reported scans are hidden from the map. | Map.jsx:321 | UI-ONLY |
| 56 | An admin can un-report (clearing all report fields) or bulk-delete reported scans. | Dashboard.jsx:126-143 + CropScan delete RLS | BOTH |
| 57 | A phone number with no Grower record is implicitly "New". | ScanCard.jsx:298; Growers.jsx:62; Map.jsx:313 | UI-ONLY |
| 58 | Toggling grower status flips New and Existing and stamps marked_by/at, creating the record if absent. | ScanCard.jsx:304-327; Growers.jsx:92-111 | UI-ONLY |
| 59 | The grower list shows only phones visible in the viewer's scoped scans. | Growers.jsx:44,69 | UI-ONLY |
| 60 | The merged grower list keeps the newest spelling per phone, one row per phone. | Growers.jsx:33-64 | UI-ONLY |
| 61 | Backfill creates a New grower for every scan phone with no record, 100 at a time. | Growers.jsx:113-139 | UI-ONLY |
| 62 | Map and List default the grower filter to "New". | Map.jsx:160; Farmers.jsx:42 | UI-ONLY |

### 5.4 Import

| # | Rule | Where | Flag |
|---|---|---|---|
| 63 | An import file must contain all 16 expected columns. | components/admin/ExcelImport.jsx:49-66,206-210 | UI-ONLY |
| 64 | An import row without phone or Sales Unit is an error. | ExcelImport.jsx:216-222 | BOTH |
| 65 | Latitude must be −90..90 and longitude −180..180. | ExcelImport.jsx:224-231 | UI-ONLY |
| 66 | Missing or unparsable coordinates import as 0 and are then excluded from the map. | ExcelImport.jsx:319-320; Map.jsx:328 | UI-ONLY |
| 67 | Scan dates normalise to UTC midnight; Excel serials are converted; an unparsable date becomes today. | ExcelImport.jsx:83-88,268-292 | UI-ONLY |
| 68 | A disease cell holding a source tag becomes diagnosis "Healthy" plus that scan_source. | ExcelImport.jsx:16-47 | UI-ONLY |
| 69 | A Source column value is matched case-insensitively to five valid sources and never overwrites the diagnosis. | ExcelImport.jsx:26-35,294-302 | UI-ONLY |
| 70 | Imported scans always start Pending and carry import_batch_id. | ExcelImport.jsx:327-328 | UI-ONLY |
| 71 | Hot Lead column equal to "yes" in any case sets hot_lead. | ExcelImport.jsx:326 | UI-ONLY |
| 72 | Acre imports as a number, or null when not numeric. | ExcelImport.jsx:322-325 | UI-ONLY |
| 73 | Import runs in batches of 50; a failed batch is retried row by row; the first 20 failures are recorded. | ExcelImport.jsx:261,332-348 | UI-ONLY |
| 74 | The batch is closed as Completed with success and failure counts and an error log. | ExcelImport.jsx:356-361 | UI-ONLY |
| 75 | The bulk date-fix aborts entirely unless the whole table could be read. | ExcelImport.jsx:103-108 | UI-ONLY |
| 76 | Validation errors do not block Confirm; rows with errors are still sent. | ExcelImport.jsx:597-599 | UI-ONLY |

### 5.5 Metrics and reporting

| # | Rule | Where | Flag |
|---|---|---|---|
| 77 | Connected means status Completed. | lib/metrics.js:24 | UI-ONLY |
| 78 | Conversion means converted is true, alone: never gated on status, never counted from ActivityLog. | metrics.js:34; lib/reconcile.js:60-64 | UI-ONLY |
| 79 | A conversion is "valued" only if conversion_value is a number; zero counts as recorded. | metrics.js:37-38 | UI-ONLY |
| 80 | Total Scans counts records, duplicates included by design. | metrics.js:89 | UI-ONLY |
| 81 | Pending equals total minus connected. | metrics.js:93 | UI-ONLY |
| 82 | Revenue is a floor: unvalued conversions contribute nothing and must be disclosed alongside. | metrics.js:102-103,352-356 | UI-ONLY |
| 83 | Call and navigation totals come from the CropScan counters, not the log. | metrics.js:105-109 | UI-ONLY |
| 84 | Diseased means not Savera, non-empty diagnosis, and not affirmatively healthy in English or Urdu. | lib/disease.js:12-20 | UI-ONLY |
| 85 | Healthy is affirmative only: a blank diagnosis is neither diseased nor healthy. | disease.js:25-32; metrics.js:115 | UI-ONLY |
| 86 | connectionRate = connected ÷ total. | metrics.js:125 | UI-ONLY |
| 87 | conversionRate (headline) = conversions ÷ connected. | metrics.js:128 | UI-ONLY |
| 88 | scanToConversionRate = conversions ÷ total. | metrics.js:131 | UI-ONLY |
| 89 | Average revenue divides by valued conversions only. | metrics.js:138-141 | UI-ONLY |
| 90 | Any rate with a zero denominator is 0, never NaN. | metrics.js:122 | UI-ONLY |
| 91 | Date filtering uses scan_date falling back to created_date; the end date covers the whole day; undated rows are excluded. | metrics.js:67-82 | UI-ONLY |
| 92 | The order of operations is always scope, then date filter, then measure. | components/reports/useReportData.js:53-66 | UI-ONLY |
| 93 | Rollups drop rows with an empty key and sort by total descending. | metrics.js:198,209 | UI-ONLY |
| 94 | The zone rollup excludes unresolvable rows and reports their count and the resolved percentage. | metrics.js:217-231 | UI-ONLY |
| 95 | SUL attribution skips admins, inactive users and users with no units; the first user assigned to a unit owns it. | metrics.js:247-263 | UI-ONLY |
| 96 | The non-conversion breakdown counts completed-and-not-converted; a missing reason shows as "Not specified". | metrics.js:299-307 | UI-ONLY |
| 97 | Distribution charts show the top 8 with an "Unknown" bucket. | metrics.js:317 | UI-ONLY |
| 98 | Trends bucket by calendar month, last 12. | metrics.js:366-380 | UI-ONLY |
| 99 | SUL coverage's denominator is the sales master; a unit with no active non-admin assignee is a vacancy. | metrics.js:387-416 | UI-ONLY |
| 100 | Pipeline ageing bands are 0-7, 8-30, 31-90 and 90+ days from scan date on still-Pending leads. | metrics.js:424-450 | UI-ONLY |
| 101 | "Uncontacted" means call_count is 0. | metrics.js:440 | UI-ONLY |
| 102 | Revenue bands: 0, under 10k, 10-50k, 50-200k, 200k+; unvalued conversions excluded and reported. | metrics.js:459-477 | UI-ONLY |
| 103 | Revenue-by-key lists the top 10 with an "Unknown" fallback. | metrics.js:481-491 | UI-ONLY |
| 104 | Completion and conversion log rows collapse to one per scan, type and user. | metrics.js:501,540-545 | UI-ONLY |
| 105 | Call and navigation log rows collapse only within a 60-second window. | metrics.js:505,547-551 | UI-ONLY |
| 106 | Only the four field actions are deduplicated; other types pass through (none can exist under the enum). | metrics.js:511,537 | UI-ONLY |
| 107 | Percentages render to one decimal; counts and PKR use thousands separators. | metrics.js:340-346 | UI-ONLY |
| 108 | Money is reconciled to the nearest 0.01. | lib/reconcile.js:26-27 | UI-ONLY |
| 109 | Performance attribution: calls and navigations from ActivityLog; completions, conversions and revenue from CropScan via a case-insensitive sales_unit match; unmatched scans go to an "Unassigned Territory" bucket. | components/dashboard/PerformanceTab.jsx:110-186 | UI-ONLY |
| 110 | The performance period filters scans by completed_at falling back to scan_date. | PerformanceTab.jsx:91-107 | UI-ONLY |
| 111 | Top performers rank by completions, then conversions, top 3. | PerformanceTab.jsx:198 | UI-ONLY |
| 112 | Scan-to-Complete colour: over 100 red, ≥70 green, ≥40 yellow, else red; Call-to-Convert: over 100 red, ≥30 green, ≥10 yellow. | Dashboard.jsx:695-702; pages/SalesTeam.jsx:28-30; PerformanceTab.jsx:405-412 | UI-ONLY |
| 113 | A lead source is a "top performer" only with at least 10 scans, then ranked by revenue. | components/dashboard/SourceAnalytics.jsx:72-74 | UI-ONLY |
| 114 | Source conversion-rate colours: ≥10% green, ≥5% yellow; visit-to-conversion ≥30% and ≥15%. | SourceAnalytics.jsx:199,204 | UI-ONLY |
| 115 | The Pipeline raises an alert when at least half of open leads have never been called. | pages/Pipeline.jsx:88 | UI-ONLY |
| 116 | "Untouched" means not Completed and no call logged; the screen shows the worst 10 units, the export all. | Pipeline.jsx:22-25 | UI-ONLY |
| 117 | User activity status: within 1 day "active today", 7 "this week", 30 "this month", else dormant. | components/dashboard/UsageAnalyticsTab.jsx:27-33,234 | UI-ONLY |
| 118 | Unassigned-scans panel (admin) = non-reported scans whose sales_unit is empty or assigned to nobody; first 50 shown. | Dashboard.jsx:116-119,541 | UI-ONLY |
| 119 | MonthlyPerformance score = completions×5 + conversions×10 + calls×1 + navigations×1 (a different formula from gamification, rule 138). | pages/MonthlyPerformance.jsx:154-156 | UI-ONLY |

### 5.6 Territory resolution

| # | Rule | Where | Flag |
|---|---|---|---|
| 120 | Zone is always derived from the sales master, never read raw from the scan. | lib/zone.js:1-16,426-473 | UI-ONLY |
| 121 | Zone resolution order: valid zone name in any script → strict master match across six scan fields and four master columns → Urdu alias → spacing-insensitive pass → province fallback → null. | zone.js:426-473 | UI-ONLY |
| 122 | An ambiguous master key resolves to the majority zone by row count. | zone.js:345-353,443 | UI-ONLY |
| 123 | A province maps to a zone only when every master row agrees. | zone.js:387-392 | UI-ONLY |
| 124 | Canonical zones are exactly the four city names in the SalesStructure enum. | zone.js:17; SalesStructure.jsonc:27 | BOTH |
| 125 | Unresolved rows are counted openly, never hidden. | zone.js:472; metrics.js:217-231 | UI-ONLY |
| 126 | Territory assignment lists sales units from the SalesStructure master, not from scan data. | components/admin/TerritoryAssignment.jsx:26-35 | UI-ONLY |
| 127 | Only active non-admin users can be given territories. | TerritoryAssignment.jsx:100 | UI-ONLY |
| 128 | Territory save creates the directory record if absent; directory sync errors are ignored. | TerritoryAssignment.jsx:52-68 | UI-ONLY |

### 5.7 Data access, caching, offline, export

| # | Rule | Where | Flag |
|---|---|---|---|
| 129 | Full-table reads paginate 4999 rows at a time sorted by id ascending. | lib/fetchAll.js:31,64-80 | UI-ONLY |
| 130 | A walk stops after 40 pages and reports itself incomplete. | fetchAll.js:35,119-125 | UI-ONLY |
| 131 | A first-page failure throws; a later-page failure returns a partial flagged incomplete. | fetchAll.js:83-92 | UI-ONLY |
| 132 | Duplicate ids are dropped and counted as a signal. | fetchAll.js:98-105 | UI-ONLY |
| 133 | User-facing lists order newest-first by created_date with id as tiebreak. | fetchAll.js:149-158 | UI-ONLY |
| 134 | CropScan is cached 5 minutes with no refetch on mount or focus, assumed complete until proven otherwise. | lib/useCropScans.js:22-31 | UI-ONLY |
| 135 | Report pages show a non-dismissible "incomplete data" banner above the content. | components/reports/ReportShell.jsx:80-95 | UI-ONLY |
| 136 | Export is disabled whenever the fetch was incomplete. | ReportShell.jsx:38 | UI-ONLY |
| 137 | Campaign exports cancel outright rather than emit a short file. | pages/ExportIncipio.jsx:27-31; pages/ExportIsabionGold.jsx:27-31 | UI-ONLY |
| 138 | Every workbook leads with an About sheet: generated, data-as-of, records in scope, date filter, exported by. | lib/exportXlsx.js:40-54 | UI-ONLY |
| 139 | Sheet names are stripped of illegal characters, truncated to 31 characters and de-duplicated. | exportXlsx.js:8-28 | UI-ONLY |
| 140 | Every report footer states "Data as of" plus the record count. | ReportShell.jsx:112-120 | UI-ONLY |
| 141 | Queries retry once and never refetch on window focus. | lib/query-client.js:4-11 | UI-ONLY |
| 142 | While offline, create, update, delete and bulkCreate are queued in localStorage with an optimistic response. | components/offline/offlineBase44.jsx:14-36; offlineQueue.jsx:5-11 | UI-ONLY |
| 143 | Reads are not wrapped and simply fail offline. | offlineBase44.jsx:39-40 | UI-ONLY |
| 144 | On reconnect the queue replays in order; a failed operation stays queued. | offlineSync.jsx:22-47 | UI-ONLY |
| 145 | The bulk export pages have no role or scope check. | pages/ExportAllScans.jsx:68 | UI-ONLY |

### 5.8 Gamification and presentation

| # | Rule | Where | Flag |
|---|---|---|---|
| 146 | Gamification points = completions×5 + conversions×15 + calls×2 + navigations×1. | components/profile/GamificationSection.jsx:16 | UI-ONLY |
| 147 | Eight badges at 1, 10 and 50 visits; 1 and 5 conversions; 50% conversion rate; 50 calls; Rs 50,000 value. | GamificationSection.jsx:18-27 | UI-ONLY |
| 148 | The conversion-rate challenge stays locked until 10 completions; conversion tiers ladder 5 → 10 → 20 → 50. | GamificationSection.jsx:94-98 | UI-ONLY |
| 149 | The leaderboard ranks non-admin users by points, showing the top 5 plus the viewer's own rank. | GamificationSection.jsx:72-83,210,230 | UI-ONLY |
| 150 | Marker colours: completed and converted dark green, completed light green, open hot-lead orange, open red; completed is checked before hot; dark green does not require proof. | lib/markers.js:8-33 | UI-ONLY |
| 151 | Scans with missing, zero or NaN coordinates never appear on the map. | Map.jsx:320-330 | UI-ONLY |
| 152 | The map centres on the Lahore zone when no scan has coordinates. | Map.jsx:379-381 | UI-ONLY |
| 153 | Map date chips: default "This Week" = last 7 days; MTD = month start; "All Scans" = unbounded. | Map.jsx:141,198-215 | UI-ONLY |
| 154 | Acre presets: under 5, 5-15, 15-50, 50+. | components/map/MapQuickFilters.jsx:13-19 | UI-ONLY |
| 155 | Report date presets: All Time, MTD, Custom. | components/reports/ReportDateFilter.jsx:31-42 | UI-ONLY |
| 156 | Location filters cascade: changing a parent clears every child level. | components/filters/FilterPanel.jsx:44-66 | UI-ONLY |
| 157 | Filter options are derived from the loaded scans, narrowed by the parent selection. | FilterPanel.jsx:27-35 | UI-ONLY |
| 158 | The List pages at 20 rows and resets to page 1 when filters or search change. | Farmers.jsx:25,137-144 | UI-ONLY |
| 159 | List search matches first name, last name, phone or village. | Farmers.jsx:72-79 | UI-ONLY |
| 160 | Savera's disease field is a chat snippet: rendered as a message, never as a disease badge, never counted as diseased. | ScanCard.jsx:348,438-446; disease.js:14 | UI-ONLY |
| 161 | A farmer whose name is only punctuation displays as "Unknown User". | ScanCard.jsx:463-468 | UI-ONLY |

### 5.9 User administration and email

| # | Rule | Where | Flag |
|---|---|---|---|
| 162 | Editing a user writes the User entity first (what `me()` reads), then UserDirectory. | components/admin/UserManagement.jsx:97-124 | UI-ONLY |
| 163 | "User not found" on sync is non-blocking; any other sync error surfaces a warning. | UserManagement.jsx:113-119 | UI-ONLY |
| 164 | Saving a user always reactivates them. | UserManagement.jsx:176 | UI-ONLY |
| 165 | Deactivation sets is_active false; admins cannot be deactivated from the UI. | UserManagement.jsx:181-183,313 | UI-ONLY |
| 166 | The assignment picker shown depends on role: units (SUL), zones (ZSM), regions (RSM), sources (PM). | UserManagement.jsx:383-472 | UI-ONLY |
| 167 | A PM can be assigned only the five core sources; Isabion Gold is not offered. | UserManagement.jsx:16 | UI-ONLY |
| 168 | "Sync Users" creates a directory record for every User missing one. | UserManagement.jsx:43-62 | UI-ONLY |
| 169 | Email campaigns target active users with an email address; all are selected by default. | components/admin/EmailCampaign.jsx:41-52 | UI-ONLY |
| 170 | An email cannot be sent without both subject and body. | EmailCampaign.jsx:87 | UI-ONLY |
| 171 | Every campaign is logged to EmailLog with recipient list, count and sender. | EmailCampaign.jsx:107-116 | UI-ONLY |
| 172 | Campaign history shows the last 50 sends. | EmailCampaign.jsx:34 | UI-ONLY |
| 173 | Attachments are appended to the body as a link, not attached. | EmailCampaign.jsx:93-95 | UI-ONLY |

### 5.10 Scheduled summary

| # | Rule | Where | Flag |
|---|---|---|---|
| 174 | The daily summary runs at 09:00 Asia/Karachi, every day, with no end and no condition. | base44/workflows/Daily WhatsApp Summary.jsonc:26-43 | DATA-ONLY |
| 175 | It invokes sendDailySummary, which opens an agent conversation as the service role with no user context. | base44/functions/sendDailySummary/entry.ts:8-18 | DATA-ONLY |
| 176 | The summary covers yesterday in Karachi time: new scans, conversions and PKR, hot leads, pending visits, source breakdown, top three sales units. | entry.ts:16; base44/agents/daily_summary_agent.jsonc:3 | DATA-ONLY |
| 177 | The reporting agent is read-only on CropScan, UserDirectory and SalesStructure and refuses anonymous access. | daily_summary_agent.jsonc:5-24,38 | DATA-ONLY |

### 5.11 Rules enforced in the UI but not the data, and the reverse — the ones that bite

- **UI-only, and the data would accept the violation:** every scoping rule
  (20-28, 41), the proof-image and value-greater-than-zero gates on a
  conversion (44-45), the reason on a non-conversion (46), the manager
  read-only rule (27-29), the import validation (63-76), the "only admin can
  revert" rule (30), the bulk-export scope (145). A direct API call with any
  user's token bypasses all of them.
- **Data-only, and no screen surfaces it:** the EmailLog status enum (12),
  UserDirectory read restriction (14), SalesStructure write restriction
  (19), the zone enum (18), the schedule (174-177).
- **Enforced in two places that disagree:** revert-from-Map deletes log rows,
  revert-from-List does not (53); MonthlyPerformance and Gamification score
  the same actions with different weights (119, 146); the PM source list has
  five values, the enum six (167, 3); the session role and the directory role
  (32) are reconciled on some pages and not others (§3.6).

---

## 6. Gap table against the product canvas

Grades: **Built** (exists and matches), **Partly** (something exists but
short of the canvas), **Missing**, **Contradicts** (exists in a form the
canvas rules out). Canvas references follow
`docs/reference/01-product-canvas.md`.

| Canvas block | Grade | What exists today |
|---|---|---|
| One-sentence product: one ranked, explainable, routed, clocked, PKR-closed queue | Partly | A filterable map and list of scans; not ranked, not scored, no clock; PKR self-declared |
| Primary user: SO, field, offline-first, low-end Android, Urdu | Partly | Mobile-first web app; write queue only; English UI, Urdu font for values |
| L1 Crop Doctor scans (REST pull, severity, confidence, geo, grower id) | Partly | Arrive as spreadsheet rows tagged CDS; crop, diagnosis text, lat/long; no severity or confidence |
| L1 In-app community | Partly | A `scan_source` value on imported rows |
| L1 Savera AI Agent transcripts (LLM extraction) | Partly | A source value; the diagnosis field carries a chat snippet; no extraction |
| L1 WhatsApp inbound (webhook, LLM intent, opt-in state) | Partly | "WhatsApp Chatbot" source value on imported rows; no webhook, no opt-in. The only WhatsApp integration is outbound (daily summary) |
| L1 Facebook | Missing | — |
| L1 TikTok | Missing | — |
| L1 Call-centre capture | Missing | — |
| L1 NPI campaigns (webhook, campaign id) | Partly | "Incipio Campaign" and "Isabion Gold Campaign" as source labels via import; no campaign id |
| L1 Brand campaigns | Partly | As above |
| L1 Every source optional, none on another's critical path | Contradicts | One manual import path is every source's only path |
| L1 Confidence flags per source | Missing | — |
| L1 One campaign ID convention | Missing | Source name only |
| L2 REST connectors | Missing | — |
| L2 Webhook listeners (idempotent, signed, dead-letter) | Missing | — |
| L2 Intent extraction AI | Missing | `hot_lead` is typed into the sheet |
| L2 Batch sync (masters, stewards, rejected rows reported) | Partly | Admin Excel import; SalesStructure seeded from a workbook; first 20 errors logged; no steward, no schedule |
| L2 Canonical Lead Event, idempotent on source event id | Contradicts | CropScan is the sheet row; no event id; duplicates counted by design |
| L2 MCP exclusion | Partly | No MCP in the lead path; a dead MCP consent page exists |
| L3 Identity resolution on verified mobile, survivorship recorded | Contradicts | Free-text phone per scan; Grower keyed by phone string; no verification; "newest spelling wins" |
| L3 Grower profile (crops, acreage, geo, admin units, language, franchise affinity) | Partly | Grower holds phone, name, New/Existing; everything else lives per scan |
| L3 Interaction history, one timeline per grower | Partly | ActivityLog per scan, four types, duplicates |
| L3 Consent and reachability | Missing | No consent anywhere |
| L3 Shared-number split | Missing | — |
| L4 Acreage cascade | Partly | Acre from the sheet or null; no cascade |
| L4 Agronomic context | Missing | Crop and diagnosis text only |
| L4 Product and value mapping | Missing | Value typed by the officer after the visit |
| L4 Territory mapping geo → beat → SO, franchise, serviceability | Partly | Four fixed zones; sales_unit text; fuzzy zone resolution; no geo, beat or franchise |
| L5 Purchase intent (30) | Missing | — |
| L5 Need severity (25) | Missing | — |
| L5 Opportunity value (20) | Missing | — |
| L5 Agronomic timing (15) | Missing | — |
| L5 Grower history (10) | Missing | — |
| L5 Recency decay | Missing | Ageing bands in reporting only |
| L5 Reachability modifier | Missing | — |
| L5 Serviceability modifier | Missing | — |
| L5 Duplicate suppression (merge and raise) | Contradicts | Duplicates counted by design |
| L5 Weights in admin, sum to 100, audited | Missing | Hard-coded gamification weights only |
| L5 Explainability, top three factors | Missing | — |
| L5 Engine v1 deterministic scorecard | Missing | No score |
| L5 Engine v2 / v3 | Missing | — |
| L5 Scorecard guardrail | Missing | — |
| L5 Continuous learning | Missing | — |
| L5 No silent self-retuning | Missing | — |
| L6 Hot: ≥70 and stated intent and acreage known, 24h | Contradicts | `hot_lead` boolean from the sheet; no intent, no acreage gate, no SLA |
| L6 High-Potential | Missing | — |
| L6 Campaign tier with its own SLA and script | Partly | Campaign as a source label only |
| L6 Nurture | Missing | — |
| L7 Territory assignment, unmapped to region pool | Partly | Unit text → users assigned to units; an "unassigned" panel for admins |
| L7 Load balancing, daily cap | Missing | — |
| L7 SLA clock and escalation | Missing | — |
| L7 Nurture automation | Missing | — |
| L8 Ranked queue, three tabs, SLA countdown, capped | Partly | Map and list; filterable, not ranked, not capped |
| L8 Lead card with factors, SKU, value, consent basis | Partly | Card has grower, crop, diagnosis, acre, village, hot flag; none of the rest |
| L8 Act and log: call, WhatsApp inline, two taps | Built (mostly) | Call and Navigate inline with counters; complete in about three taps; WhatsApp not inline |
| L8 Offline-first sync | Partly | Write queue in localStorage, in-order replay; reads not cached; no conflict rule |
| L8 Converted: SKU, quantity, PKR, franchise, date | Partly | PKR float and proof photo; no SKU, quantity or franchise |
| L8 Lost: one of five reason codes | Partly | Four different reasons |
| L8 Unreachable → nurture after two failed attempts | Missing | call_count exists; no rule |
| Closed loop into the engine | Missing | — |
| Z04 Sales Officer dashboard | Partly | Overview KPIs and gamification; no "who to call next" |
| Z04 RSM dashboard, SLA breaches first | Partly | Scoped Dashboard and reports; no SLA |
| Z04 Zonal Manager dashboard, drillable | Partly | Geography report zone → region → unit |
| Z04 Portfolio Manager dashboard | Partly | PM role scoped by source; Category Performance by source |
| Z04 Marketing dashboard, cost per converted lead | Missing | No campaign id or cost |
| Z04 Master analytics, model lift | Missing | — |
| Z04 Named-aggregation rule | Partly | Leaderboards name SULs; not systematic |
| Z00 Admin console (users, roles, territories, weights, SLAs, connector health, audit) | Partly | Users, roles, territories; nothing else |
| Z00 Data platform | Missing | Base44 entities; all computation in the browser |
| Z00 Identity and access: hierarchy-aware RBAC, SSO, marketing aggregate-only | Contradicts | RBAC in the browser; all roles receive the full table; Base44 login |
| Z00 Consent and data protection | Missing | — |
| Z00 Audit and observability | Partly | ActivityLog for four actions; EmailLog; no access, weight or reassignment log |
| Accepted: IVR removed | Consistent | Nothing built |
| Accepted: franchise data removed, value self-declared | Consistent | Value is self-declared |
| Accepted: farm mapping removed | Consistent | Acre from the sheet |

Open decisions D1-D7: the product assumes an answer to none of them
explicitly, but it operates as if D1 (consent for advisory data used for
sales contact) were "yes": Crop Doctor scans become sales leads with no
consent basis. Phase 2 must not inherit that assumption.

---

## 7. Do not carry forward

Patterns in Smart Agro Lite that would violate an invariant (INV-1-9) or a
day-one rule (A1-A10), or a CLAUDE.md rule, with the reason.

| # | Pattern | Violates | Why it must not cross |
|---|---|---|---|
| 1 | Authorisation in the browser: `requiresAuth: false`, role and territory filters applied after the full table is fetched; no read rule on CropScan | INV-7, A8 | A new screen that forgets the filter, or any API call, sees every grower nationwide. INV-7 must be a query-layer function. |
| 2 | Hidden unscoped routes (`/ExportAllScans` and the campaign exports) | INV-7, A8 | Navigation as the access rule. Any signed-in user downloads every phone number. |
| 3 | No consent basis anywhere; growers contacted from imported scans | INV-1, A6 | INV-1 must be a NOT NULL column from the first migration. |
| 4 | Grower name and phone duplicated into ActivityLog with no rules, and no PII marking on any field | A7, PROCESS §12 | PII must be tagged in the schema so logs and exports redact by rule. |
| 5 | Phone as free text on every scan; Grower keyed by a phone string; "newest spelling wins" merge; no verification | INV-2, D4 | A verified mobile maps to at most one grower, and a split is recorded. |
| 6 | No source event id; duplicates counted by design; re-importing a sheet creates a second row | INV-3, A4 | Idempotency must be a unique constraint at the write. |
| 7 | `hot_lead` as a spreadsheet yes/no; no score, factors or engine version | INV-4, INV-8, A1 | Hot requires stated intent and known acreage; a score without factors and a version is not a score. |
| 8 | Lifecycle by direct `CropScan.update` from five call sites with different field sets; revert-from-Map deletes logs, revert-from-List does not | INV-5, A5 | Transitions live in one function or every count is untrustworthy. |
| 9 | Conversion as a float PKR value only; no SKU, quantity, or explicit closing officer | INV-6, CLAUDE.md money rule | Money is integer paisa; a conversion carries value, SKU and officer. |
| 10 | Report flag and converted flag as pseudo-states beside a two-value status | INV-5, A5 | States are an enum; flags that change meaning are hidden state. |
| 11 | One manual import path for every source; validation errors do not block; bad coordinates become 0; bad dates become today | INV-9, A2, A3 | Sources must be independent; silent defaults invent data. |
| 12 | Full-table fetch (4999 × 40 pages) then in-browser metrics, silently truncated at the cap | A8, scale | Dashboards must count from the query layer, not from what the browser managed to download. |
| 13 | Two sources of truth for role and territory (User, UserDirectory), reconciled one way at login | INV-7 | One identity store; the scope a query applies must be the scope the admin set. |
| 14 | Swallowed errors: ActivityLog writes, directory sync, `updateMe`, "user not found" | CLAUDE.md no-swallowed-errors | A swallowed write failure is a silent data loss. |
| 15 | Hard-coded gamification weights; two different score formulas for the same actions | A10 | Weights live in the database, versioned, changed through admin. |
| 16 | Offline queue with optimistic fake ids, reads not cached, failed operations stuck forever, no conflict rule | A9 | Offline-first means local store, outbox, server timestamp wins, officer entry never discarded. |
| 17 | Territory resolved by fuzzy text matching across six fields with Urdu aliases and majority votes | A2, L4 territory mapping | Territory must come from a geo or id lookup against a master, not from string similarity. |
| 18 | A scheduled function running as the service role over all grower data with no audit record of what it sent | Zone 00 audit | Every automated read of PII needs a log line. |
| 19 | No `.env.example`; build-time variables undocumented | CLAUDE.md config rule | Config from env only, every variable documented. |
| 20 | Dead code and dead dependencies (eight unused packages, an unrouted consent page, an unused route guard, a defined-but-unused write gate) | CLAUDE.md no dead code | Dead guards look like guards. |
| 21 | Documentation asserting tests that do not exist | CLAUDE.md evidence rule | "It should work" is not evidence; a claimed harness is worse than none. |
| 22 | Money and rates computed from whichever entity happened to be loaded (conversions from CropScan, calls from ActivityLog, the two disagreeing in the product's own reconciliation) | INV-6, Zone 00 data platform | One semantic layer so every dashboard counts a conversion identically. |

---

## 8. Unknowns

What could not be determined from a read-only export, and why. An honest gap
here beats a confident guess in Phase 2.

1. **Whether the Base44 sandbox is isolated from the live app.** I cannot
   tell. The evidence, all of it from tool descriptions rather than from any
   response: the file tools say a sandbox "is created transparently from the
   last commit" when none is running; the readme says the builder AI and the
   direct-edit tools "write to the same tree"; publishing is a separate
   deploy step and the published URL is distinct from the preview URL.
   Nothing states that the sandbox is ephemeral, how long it persists, or
   that it is isolated from the live app. On the **code** side, therefore:
   the sandbox is a working copy of the last commit and my calls read it
   without writing; whether that copy now lingers is unknown. On the
   **data** side there is no sandbox at all: `list_entity_schemas` reads the
   live app's schema metadata, and `query_entities` would have read live
   records, which is why it was never called. The one root listing I ran in
   the main session and the export agent's reads are the only sandbox
   activity; the export manifest records every call.
2. **Whether the daily WhatsApp summary has ever fired or been delivered.**
   No run history, conversation record or delivery log exists in the export.
   Only the platform's workflow run log would settle it.
3. **Whether an entity with no `rls` key is open or governed by a platform
   default.** The schema shows explicit rules on three entities and none on
   five. The app's own documentation proposes adding a CropScan read rule as
   the next hardening step, which suggests none applies today, but the
   platform default is not visible in the export. Related: whether a
   non-admin can write their own `User.assigned_*` arrays through the API
   (the User entity has no rule), which would let a user widen their own
   scope.
4. **Who uses the app, how much, and the state of the live data.** The
   product documentation (last updated 2026-08-18) quotes counts of scans,
   conversions, duplicate log rows and unassigned scans. None was verified:
   no record was read.
5. **Whether the app builds cleanly from the export.** `leaflet` is not a
   declared dependency; the SDK version pinned in the Deno function is behind
   the client's. Not tested, by design: no command was run.
6. **Where the spreadsheets come from.** The import expects a 16-column layout
   that looks like a Crop Doctor export with extra columns, but the origin
   systems and their export formats are not in the app. Phase 2 needs this
   from Ahsan.
7. **The intent behind Isabion Gold Campaign.** It is the sixth source in the
   enum, has its own export page, but cannot be assigned to a product manager
   and is not in the import's validation list.
8. **What the platform does with `functionsVersion`**, threaded through the
   client and never used; and the semantics of platform built-in fields
   (`created_by`, `created_date`) that metrics rely on.
9. **Whether the MCP consent page was ever configured.** Its config file is
   absent; the platform side is not visible.
10. **Whether the deny rules added to `.claude/settings.json` in this session
    took effect for the running session.** They are on disk and valid JSON;
    proving them live would have meant attempting a forbidden tool, which was
    not done. They are proven at the next session start at the latest.
11. **The SalesStructure master's currency.** Its description names a seed
    workbook and month; whether the live rows match the field today is a
    data question.

---

## 9. Keepers and mistakes

The Phase 1 gate asks which behaviours are keepers. These are behaviours to
re-specify in Synapse's own terms, never code to copy.

**Keepers (as behaviours):**
- Call and Navigate inline on the card, each leaving a trace.
- A structured reason on every non-conversion, with a comment only for
  "Other"; a proof photo on a conversion.
- "Report this scan" with a reason, and admin-only removal.
- The honest reporting habits: an "incomplete data" banner that cannot be
  dismissed, export disabled on a partial read, an About sheet on every
  workbook, "data as of" plus a record count on every report, unresolved
  rows counted openly.
- Revenue stated as a floor with the unvalued count beside it.
- KPI definitions in one place, and a sign-off page that reconciles them.
- One territory master as the single source of truth for zone, region and
  unit.
- Healthy is affirmative; blank is unknown.
- A daily summary to management on WhatsApp.
- The idea of an offline outbox (not this implementation).
- Date presets that match how the field thinks: this week, month to date.

**Mistakes:** everything in §7, plus the manual spreadsheet as the ingestion
layer, gamification with hard-coded weights, and a documentation file that
claims verification it does not have.

---

## Appendix A — Method and tool log

Main session, by Claude: `base44_readme` ×1, `list_user_apps` ×1 (one app
returned), `list_directory` ×1 (root, depth 2, to size the job).

Export agent (general-purpose, prompt-limited to the allowed tools), per its
manifest: `base44_readme` ×1, `list_directory` ×1, `read_file` ×9 (150
distinct files), `list_entity_schemas` ×1, `list_api_catalog` ×6,
`describe_api` ×3. Zero failures. Zero forbidden calls.

Total Base44 calls: 24. Forbidden tools called: none. Records read: none.

Seven `explorer` agents then read the local mirror only, one question each:
screens and navigation; forms; entities; workflows and integrations;
business rules; roles and scoping; documentation claims versus code. Their
conclusions are what this file is built from; their reads never entered the
main session.

## Appendix B — The product's own documentation versus its code

`public/PROJECT_DOCUMENTATION.md` (last updated 2026-08-18) is mostly
accurate. The places it is not:

- Lists five lead sources; the entity has six.
- Lists four roles in the entity section and rebuild recipe; five exist.
- Omits `SalesStructure`, the entity the whole zone model depends on.
- Says Category Performance is "blocked" with no figures and no export; the
  page computes figures and exports.
- Describes a Score column on the performance table; there is a Revenue
  column instead, and the score formula it gives lives only on Monthly
  Performance.
- Omits the Reports link in navigation and the nine report pages from its
  page list.
- Claims a mutation-tested reconciliation harness; no tests exist.
- Documents nothing about the WhatsApp summary agent, function, workflow or
  its page.
- Says an explicit Source column is validated against the enum; unrecognised
  values pass through.

Its self-declared weaknesses are worth keeping in view for Phase 2: revenue
is a floor; a material share of activity-log rows are duplicates; conversion
counts from CropScan and ActivityLog disagree; some scans have no sales unit
or region; some open leads are undated.
