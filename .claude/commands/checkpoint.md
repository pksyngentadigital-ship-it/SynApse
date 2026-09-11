---
description: Run the process warden on demand. Read-only audit against docs/PROCESS.md. Reports what is wrong and how to fix it; changes nothing.
---

# /checkpoint

Launch the `process-warden` subagent and relay its report verbatim.

Nothing else happens in this command. Do not fix findings. Do not edit files. Do
not offer to. If Ahsan wants something fixed he will ask in a separate turn.

Good moments to run this:

- Before opening a PR, if `/pr` was not used
- After a session that went sideways
- Before closing a milestone
- After coming back from more than a few days away
- Any time Ahsan has a feeling that something was skipped

After relaying the report, add one line only:

`Nothing here is fixed. Tell me which finding to act on.`
