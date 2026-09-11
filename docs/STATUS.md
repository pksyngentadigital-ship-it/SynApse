# Synapse status

Where we are right now. Overwritten every session by `/close`; `git log` is the
truth and `/resume` reconciles the two.

## Where we are

Phase 0, session 0.1. The starter folder has been read and reviewed. No git
repository yet. No PR yet. The session 0.1 plan (git init, /setup-repo, Linear
seed, naming and enforcement corrections, new docs, PR #1) was shown and is
**not yet approved or executed**.

## Setups

| Item | State |
|---|---|
| GitHub repo | Exists, private, empty: https://github.com/pksyngentadigital-ship-it/SynApse — not yet initialised locally |
| Linear MCP | **Verified connected, 2026-09-11.** Project scope, `.mcp.json` at repo root, HTTP transport to `https://mcp.linear.app/mcp`. OAuth sign-in done by Ahsan in the browser. No token is stored anywhere in the repo |
| Linear workspace | `syngentadigital` — https://linear.app/syngentadigital |
| Linear project | `SynApse` — https://linear.app/syngentadigital/project/synapse-be473bf50d39 — status Backlog, **no milestones, no labels seeded, no issues** |
| Linear team / issue prefix | Team `Syngentadigital`, key **SYN** — issues are `SYN-n` |
| Branch protection, labels, environments | Not done |
| CI | Does not exist until M0-T1 |

## Next

Approve or amend the session 0.1 plan, then execute it in order: git init and
baseline push first, /setup-repo second.
