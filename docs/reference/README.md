# docs/reference — routing index

**Read this file first, then read only the section you need.** These three
documents total about 85 KB; loading one whole when a section would do is the
single easiest way to waste a session's context.

Nothing in this folder is ever auto-loaded. It is Layer 3 memory: source
material, not working memory. After Phase 5 the build loop should rarely need
it at all.

## Precedence

1. `CLAUDE.md` and `docs/PROCESS.md` — the operative rules. **These win.**
2. `03-delivery-process.md` — the corrected phase sequence.
3. `01-product-canvas.md` — architecture truth.
4. `02-build-playbook.md` — doctrine and the stack default. Superseded by 03
   wherever they describe the same thing.

If two files disagree, follow the ladder **and tell Ahsan about the conflict**.

## What is where

### `01-product-canvas.md` — what Synapse is
The architecture source of truth. Zones, layers, and the detail behind every
block.

| If you need | Read |
|---|---|
| The one-sentence product and who it is for | *The one-sentence product* |
| A source's method, signals, and confidence flag | *Zone 01 → L1 Sources* — the family table only |
| Why MCP is not in the lead path | *Zone 01 → L2 → The MCP exclusion* |
| Identity resolution, merge, the shared-number problem | *Zone 01 → L3* |
| The acreage cascade, product mapping, territory mapping | *Zone 02 → L4* |
| The five weights, four modifiers, engine versions v1–v3 | *Zone 02 → L5* |
| Tier rules and their SLA promises | *Zone 02 → L6* |
| Routing, load balancing, the SLA clock | *Zone 03 → L7* |
| The SO app's screens and the two-tap rule | *Zone 03 → L8* |
| Conversion, loss codes, unreachable | *Zone 03 → Outcome* |
| The six dashboards and the grain rule | *Zone 04* |
| Admin, data platform, access, consent, audit | *Zone 00* |
| **What is not yet decided** | *Open decisions D1–D7* |
| **What was cut, and what that costs** | *Consequences already accepted* |

### `02-build-playbook.md` — engineering doctrine
The laws, the default stack, the repo shape, the day-one rules, and the Capture
milestone plan.

| If you need | Read |
|---|---|
| Why evidence beats claims; why rules need hooks | *The four laws* |
| Who does what | *The division of labour* |
| To explain a git or CI term to Ahsan | *Vocabulary — twelve words* |
| Which account is needed when, and who owns it | *Accounts and tools* |
| The default stack, pending Syngenta's | *Default stack* |
| Where a file belongs | *Repo shape* |
| Hook shapes and what each enforces | *The three hooks* |
| **The A1–A10 architecture rules** | *Day-one architecture rules* |
| **M0–M8 scope, acceptance and PR estimates** | *Capture in milestones* — the one milestone you need |
| The per-task loop | *The task cycle* — superseded by 03 §Phase 7 |
| When to spawn agents in parallel | *Multiple agents* |
| Token and money budgets | *Economics* |

### `03-delivery-process.md` — the phase sequence
How the work is ordered, session by session. **Wins on process.**

| If you need | Read |
|---|---|
| Why the process is shaped this way | *The seven structural decisions* |
| The prompts for the current phase | *Phase N* — that phase only |
| The task loop with its Linear steps | *Phase 7 → Task* |
| Where Ahsan reviews the architecture | *Phase 3, Phase 7, Phase 9* — the three checkpoints |
| Session and PR estimates per phase | *Session budget* |

## Rules for reading this folder

- **Name the section in the prompt.** "Read the M3 entry in
  `02-build-playbook.md`" costs a fraction of "read the playbook".
- **Delegate a wide read** to the `explorer` agent when you genuinely need to
  search across all three — its reads stay out of the main window.
- **Never paste from these files into an agent prompt.** Give the agent the
  path and the section name; it reads the file itself (PROCESS.md A1).
- The HTML originals live outside the repo. They are for humans; these markdown
  files are for the machine, and they carry the same content.
