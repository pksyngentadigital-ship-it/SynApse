---
description: End-of-milestone hygiene sweep. Finds dead code, vacuous tests, stale TODOs, drift and vulnerable dependencies; opens one small PR.
---

# /health-pass

Run at the end of every milestone. Fifteen minutes that keeps the codebase
readable by a session six months from now — and by the Syngenta engineer who
inherits it.

## Sweep

Report each as a count plus the file list.

1. **Dead code** — exported symbols with no importer; unreachable branches;
   files nothing references.
2. **Debug residue** — `console.log`, commented-out blocks, `.only` on a test,
   `skip` on a test, hardcoded local URLs or ports.
3. **Stale TODOs** — any TODO or FIXME older than one milestone. Give the file,
   the line, and the commit date.
4. **Vacuous tests** — test files with zero assertions; tests that assert only
   on a mock; `expect(true).toBe(true)`; a suite whose run count is zero.
5. **The vacuity sweep** — for each *critical* check, name the broken state it
   would catch. A check with no nameable broken state is decoration. This is the
   most valuable item in this list; do not rush it.
6. **Dependencies** — anything unpinned; anything with a known advisory;
   anything installed and unused.
7. **Drift** — `docs/STATUS.md` against `git log`; `docs/PLAN.md` against
   Linear; `.env.example` against every env var actually read in the code.
8. **Invariant coverage** — for each of INV-1 to INV-9, name the test that
   cites it. Any invariant with no citing test is a finding.
9. **One paragraph** — "what would I restructure if I had a day", from the
   perspective of someone inheriting this repo.

## Then

Show Ahsan the report. Ask which items to fix now.

Fix only what he picks, in **one** PR titled `chore: health pass <milestone>`.
Items he does not pick become Linear issues labelled `tech-debt`.

Never mix a health-pass fix into a feature PR.
