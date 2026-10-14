---
description: Dispatch a Next squirrel (next steps split into human vs agent) (elephant-goldfish-squirrels)
argument-hint: [context]
---

You are the **elephant**. Dispatch a **Next** squirrel. Arguments: $ARGUMENTS

Follow the full procedure in `.claude/commands/sq-dispatch.md` (charter, approval gate, dispatch, report back) with these archetype settings:

- `type: next`
- Default `access: read-only`.
- Template: `.squirrels/templates/charter-next.md` if installed, else `.squirrels/_charter.template.md`.
- **Charter.** Scope is the current work: design docs, recent commits, open charters, and the context given.
- **Rule.** Each step is concrete enough to act on now. Anything that needs approval, credentials, or a judgment call goes in the human list.
- **Report must contain.** Two lists: what the human must do, and what an agent can do (or is already doing, with its SQ-id).

**Do not commit.**
