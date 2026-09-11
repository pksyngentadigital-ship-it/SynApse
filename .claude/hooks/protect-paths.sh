#!/usr/bin/env bash
# PreToolUse hook for Edit|Write.
#
# Blocks writes to load-bearing paths unless the current task has explicitly
# been allowed to touch them, and blocks any edit to a migration that has
# already shipped to main.
#
# The bypass is deliberately VISIBLE rather than impossible: to work on a
# protected path, the task writes its prefix into .claude/allow-protected.
# That file is git-ignored, the process warden flags it if it is left behind,
# and /close reports it. A rule you can bypass silently is not a rule; a rule
# you can bypass loudly is a rule with an escape hatch.
#
# Exit codes: 0 = allow, 2 = block (stderr is shown to Claude).

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
ALLOW_FILE="$REPO_ROOT/.claude/allow-protected"

PROTECTED_PREFIXES=(
  "packages/scoring/"
  "infra/"
  "packages/schema/"
)

payload="$(cat)"

# Extract the target path. Prefer jq; fall back to sed so the hook still works
# on a machine without jq installed.
if command -v jq >/dev/null 2>&1; then
  target="$(printf '%s' "$payload" | jq -r '
    .tool_input.file_path // .tool_input.path // .tool_input.notebook_path // empty
  ' 2>/dev/null)"
else
  target="$(printf '%s' "$payload" \
    | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
    | head -1)"
fi

# Nothing to check: allow. A hook that guesses is worse than a hook that abstains.
[ -z "${target:-}" ] && exit 0

# Normalise to a repo-relative path.
case "$target" in
  "$REPO_ROOT"/*) rel="${target#"$REPO_ROOT"/}" ;;
  /*)             rel="$target" ;;
  *)              rel="$target" ;;
esac

# ---------------------------------------------------------------- migrations
# A migration that exists on main has shipped. New migrations follow it.
case "$rel" in
  *migrations/*|*migration/*)
    if git -C "$REPO_ROOT" cat-file -e "main:$rel" 2>/dev/null; then
      cat >&2 <<MSG
BLOCKED by protect-paths: $rel

This migration already exists on main, which means it has shipped. Editing a
shipped migration desynchronises every environment that already ran it.

Add a NEW migration that makes the change instead. See docs/PROCESS.md PR7.
MSG
      exit 2
    fi
    ;;
esac

# ------------------------------------------------------------ protected dirs
for prefix in "${PROTECTED_PREFIXES[@]}"; do
  case "$rel" in
    "$prefix"*)
      if [ -f "$ALLOW_FILE" ] && grep -Fq "$prefix" "$ALLOW_FILE" 2>/dev/null; then
        exit 0
      fi
      cat >&2 <<MSG
BLOCKED by protect-paths: $rel

'$prefix' is load-bearing. Writes there are blocked unless the current task
explicitly names it.

If this task is genuinely meant to change $prefix:
  1. Confirm the Linear issue lists this path under "Files".
  2. Tell Ahsan you are about to touch $prefix and why.
  3. Then run:  echo "$prefix" >> .claude/allow-protected
  4. Remove that line when the task is done.

If it is not, you are editing outside the task's scope. Stop and re-plan.
See docs/PROCESS.md §10 and docs/reference/02-build-playbook.md rule A1.
MSG
      exit 2
      ;;
  esac
done

exit 0
