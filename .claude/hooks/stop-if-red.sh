#!/usr/bin/env bash
# Stop hook.
#
# Refuses to end the turn while the project's one gate is red — with a
# fail-open after three consecutive blocks, so a genuinely stuck loop writes
# an UNRESOLVED line into docs/STATUS.md instead of burning the usage limit.
#
# Exit codes: 0 = allow the turn to end, 2 = block (stderr shown to Claude).

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
COUNT_FILE="$REPO_ROOT/.claude/.stop-count"
STATUS_FILE="$REPO_ROOT/docs/STATUS.md"
MAX_BLOCKS=3

cat >/dev/null   # drain stdin; this hook does not need the payload

reset_and_allow() { rm -f "$COUNT_FILE"; exit 0; }

# ---- Is there a gate yet? -------------------------------------------------
# Before the M0 scaffold there is no check command. A hook that fails because
# the thing it checks does not exist teaches everyone to ignore hooks.
[ -f "$REPO_ROOT/package.json" ] || reset_and_allow
command -v pnpm >/dev/null 2>&1  || reset_and_allow
grep -q '"check"' "$REPO_ROOT/package.json" 2>/dev/null || reset_and_allow

# ---- Run the gate ---------------------------------------------------------
output="$(cd "$REPO_ROOT" && pnpm check 2>&1)"
if [ $? -eq 0 ]; then
  reset_and_allow
fi

# ---- Red. Count the block. ------------------------------------------------
count=0
[ -f "$COUNT_FILE" ] && count="$(tr -dc '0-9' < "$COUNT_FILE" 2>/dev/null || echo 0)"
[ -z "$count" ] && count=0
count=$((count + 1))
printf '%s' "$count" > "$COUNT_FILE"

if [ "$count" -ge "$MAX_BLOCKS" ]; then
  # Fail open, loudly and on disk.
  if [ -f "$STATUS_FILE" ]; then
    {
      printf '\nUNRESOLVED: `pnpm check` red at %s after %s blocked attempts.\n' \
        "$(date +%F' '%H:%M)" "$count"
      printf 'Last failure output (tail):\n\n```\n%s\n```\n' \
        "$(printf '%s' "$output" | tail -25)"
    } >> "$STATUS_FILE"
  fi
  rm -f "$COUNT_FILE"
  cat >&2 <<MSG
Gate still red after $count attempts. Failing open.

An UNRESOLVED line has been written to docs/STATUS.md with the failure output.

Do not keep trying. Tell Ahsan the gate is red, show him the failure, and stop.
Per docs/PROCESS.md X2: two failed attempts, then a stuck note and /clear.
MSG
  exit 0
fi

cat >&2 <<MSG
BLOCKED by stop-if-red: \`pnpm check\` is failing (block $count of $MAX_BLOCKS).

Do not end the turn with the gate red. Either fix it, or revert what broke it.

Tail of the failure:
$(printf '%s' "$output" | tail -20)
MSG
exit 2
