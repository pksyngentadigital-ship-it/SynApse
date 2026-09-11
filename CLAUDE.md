# Synapse — lead intelligence for Syngenta Pakistan

## Stack
PENDING. Syngenta's stack arrives in Phase 3 and overrides the default in
docs/reference/02-build-playbook.md. Until this section names one: no scaffold,
no framework, no dependency — ask me. Commands will be `pnpm check`
(typecheck+lint+test+build — the only gate), `pnpm dev`, `pnpm test`.

## Session shape
Start with `/resume`. End with `/close`. Open PRs with `/pr`, never by hand.
Read docs/STATUS.md and docs/PLAN.md before any task; do not re-interview me.
Invariants: docs/INVARIANTS.md — cite by ID in tests and PRs. Process rules:
docs/PROCESS.md — read before planning. Reference index:
docs/reference/README.md — read sections, never whole files.

## Rules
- Config from env only; every var documented in .env.example. No swallowed
  errors, no speculative abstractions, no dead code left behind.
- Money is PKR in integer paisa. Time stored UTC, displayed Asia/Karachi.
- No real grower name or phone number in any fixture, test, seed, screenshot
  or message. Ever. Synthetic data only.
- Agents read files, never conversations. An agent prompt may carry file paths,
  one task ID and one parameter — never pasted context. One agent, one job.

## How to talk to me
- Short and plain. Lead with the outcome, then the one thing I must decide.
  Technical detail when it changes a decision, when something failed, or when
  I ask — otherwise spare me the walkthrough.
- If a task depends on a decision not in docs/DECISIONS.md, STOP and ask — one
  question at a time, with your recommendation. Never build on an assumption;
  any you must make goes at the top of the plan, labelled ASSUMPTION.
- No edits before I type "Approved". Plan mode is the default for every task.
- A question that produces no code: answer in five lines, then offer to park
  it in Linear. Do not let it become the session.
- Evidence before "done": test output with counts, a screenshot, or a request
  and its response. "It should work" is not evidence.

## Tracking and precedence
Linear: what to do next and its status. This repo: what was decided and why.
docs/JOURNAL.md is the append-only record of what happened — never edit an
existing entry; `/close` writes it. No Linear issue, no branch. PRs say
"Closes SYN-n" per docs/PROCESS.md §1. This file and docs/PROCESS.md are the
operative rules: where docs/reference/ conflicts with them, these win — and
tell me about the conflict.
