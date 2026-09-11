# Synapse build journal

The narrative record of how Synapse came to be. **Append only.** One entry per
session, written by `/close` through the `journal-writer` agent.

This is the only record that keeps failure. `docs/STATUS.md` shows the present,
so yesterday's dead end vanishes from it. `docs/DECISIONS.md` records the choice
that was made, not the two hours spent discovering it was necessary. Linear
records work items. Without this file, the project's history reads as a clean
sequence of correct moves — which is both false and useless.

**Rules.** Never edit or delete an existing entry; if one is wrong, write a new
entry that corrects it and names the entry it corrects. Never restate a
decision's reasoning — reference it by date and title, the reasoning lives in
DECISIONS. Honest over flattering. "Learned: nothing new" is a valid line;
padding is not.

Read on demand only. This file is never auto-loaded, so its length costs
nothing.

---

## 000 · <!-- date --> · Phase 0 · seed

**Goal.** Establish the repository, the rule book, and the process that will
govern roughly a hundred pull requests.

**Shipped.** Nothing yet. This entry exists so entry 001 has a predecessor and
the numbering starts somewhere.

**What happened.** The architecture was settled on the Synapse System Canvas
v2.0. The engineering doctrine was adapted from the Prompt to Production laws
into the Build Playbook. An initial twelve-step build process was reviewed
against that playbook, and four structural gaps were found and closed: Linear
and the repo were both going to hold "what's next"; the first deployment sat
after QA rather than at the walking skeleton; adversarial review was applied
uniformly rather than tiered; and "one step, one session" was the wrong unit of
work. The corrected eleven-phase sequence became the Delivery Process.

A second review added four more: agents take their reference from `.md` files
rather than session transcripts; one agent does one job; a read-only process
warden red-flags process violations; and this journal exists.

**Went wrong.** Nothing yet — which is the only time that line will be true.

**Decisions.** See `docs/DECISIONS.md` entry 001, "Delivery process adopted".

**Learned.** The rule files and the agent definitions are worth writing *before*
the first session rather than generating in it: a first session spent
re-deriving settled rules is a first session that never looks at the product.

**Evidence seen by Ahsan.** The three source documents, the delivery process
review, and this starter folder.

**Open at close.** Everything. Phase 0, session 0.1 is next.

---
