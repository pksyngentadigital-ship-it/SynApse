---
description: Start every session. Loads state, reconciles it against git and Linear, runs the process warden, and proposes the next task.
---

# /resume

Do these five steps in order. Keep the whole output under about 20 lines — this
runs at the start of every session and its job is to orient, not to brief.

## 1. Read the on-resume memory layer, and only that layer

- `docs/STATUS.md`
- `docs/PLAN.md` — the current milestone's section only
- `docs/INVARIANTS.md`
- `docs/DECISIONS.md` — **the entry titles only**, not the bodies
- The open milestone's issues from Linear, if the MCP is available

Do not read `docs/reference/**`. Do not read SPEC, ARCHITECTURE, UX or the
journal unless a later step in this session names them.

## 2. Reconcile

Compare `docs/STATUS.md` against `git log --oneline -15` and against Linear.
STATUS is a claim about the past; git is the truth.

If they disagree, **say so before anything else** and propose the smallest
correction. Do not proceed to step 5 until Ahsan has resolved it.

## 3. Run the process warden

Launch the `process-warden` subagent. Relay its RED and AMBER findings verbatim.
Do not soften them, do not fix them, do not act on them without being asked.

If the warden reports RED, say plainly: "Clear these before starting a task."

## 3b. Linear checks — the three the warden cannot run

The warden has no Linear access by design. Using the Linear MCP, check:

- **PR2** — the issue matching the current branch (or the top Todo issue) has
  an acceptance sentence, files, invariant IDs, a keystone flag and no
  unresolved decision. Name what is missing.
- **LIN3** — any issue In Progress with no branch, or In Review with no open PR.
- **LIN6** — any Parked issue without a named un-park trigger or a DECISIONS
  entry.

Report findings in the same PROCESS CHECK block, cited by rule ID, same
severity scale. Onboarding issues Linear created itself (Canceled, outside the
project) are ignored.

## 4. State where we are

Two sentences. Current phase or milestone, and what the last merged PR did.

## 5. Propose the next task

The top Todo issue in the open milestone. Give its key, its title, and its
acceptance sentence. Then check Definition of Ready (PROCESS.md PR2) and say
whether it is ready or what is missing.

Then **stop and wait.** Do not plan it, do not read its files, do not edit
anything.

## Output shape

```
STATE: <two sentences>
RECONCILE: consistent | <the disagreement, and the fix>
PROCESS CHECK: <the warden's findings plus the Linear checks, or "clear">
NEXT: <SYN-n> — <title>
  Acceptance: <the sentence>
  Ready: yes | no — <what is missing>
Waiting for you.
```
