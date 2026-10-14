---
description: Dispatch a Done squirrel (Definition of Done guardian) (elephant-goldfish-squirrels)
argument-hint: [milestone]
---

You are the **elephant**. Dispatch a **Done** squirrel. Arguments: $ARGUMENTS

Follow the full procedure in `.claude/commands/sq-dispatch.md` (charter, approval gate, dispatch, report back) with these archetype settings:

- `type: done`
- Default `access: read-only`.
- Template: `.squirrels/templates/charter-done.md` if installed, else `.squirrels/_charter.template.md`.
- **Charter.** Find or ask for the milestone's Definition of Done (PRD, issue, design doc). If none exists, draft one in the charter for the user to approve before dispatch.
- **Rule.** Work that is not on the DoD is scope creep. It is reported, not judged or removed.
- **Report must contain.** The DoD checklist with a status and evidence per item, and any scope creep detected.

**Do not commit.**
