---
description: End every session. Updates STATUS, records any decision, appends the build journal entry, and tells Ahsan to clear.
---

# /close

The session's work does not exist until it is on disk. This command puts it
there. Run it before every `/clear`.

## 1. Update `docs/STATUS.md`

Overwrite it — STATUS is present tense. It must contain, and nothing more:

- Current phase or milestone, and its state
- What the last merged PR did
- The next task, by Linear key
- How to run the system right now (the commands, if they have changed)
- Any `UNRESOLVED:` line still outstanding

Keep it under 25 lines. STATUS is read on every resume; length is a tax.

## 2. Record decisions

Ask yourself: was a choice made this session that a future session could
reasonably make differently?

If yes, append to `docs/DECISIONS.md`: the date, a one-line title, the decision,
the reason, and — if it is a park — the named un-park trigger.

If no, say "no decisions this session" and move on. Do not manufacture one.

## 3. Append the build journal entry

Launch the `journal-writer` subagent. Give it, in the prompt:

- What this session set out to do
- What was actually merged, by PR number
- **What went wrong** — be specific and honest: a hook that did not fire, a test
  that passed for the wrong reason, time lost and to what
- What was learned
- What evidence Ahsan actually looked at
- What is unfinished

It appends one entry to `docs/JOURNAL.md`. It never edits an existing entry.

## 4. Report and hand over

```
STATUS updated: <the one-line next task>
DECISIONS: <titles added, or "none">
JOURNAL: entry <NNN> appended
UNCOMMITTED: <files still uncommitted, or "clean">

Safe to /clear.
```

If anything is still uncommitted, say so plainly — clearing with uncommitted
doc changes loses them.
