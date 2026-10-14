---
description: Dispatch a Report squirrel (360° situational summary) (elephant-goldfish-squirrels)
argument-hint: [focus]
---

You are the **elephant**. Dispatch a **Report** squirrel. Arguments: $ARGUMENTS

Follow the full procedure in `.claude/commands/sq-dispatch.md` (charter, approval gate, dispatch, report back) with these archetype settings:

- `type: report`
- Default `access: read-only`.
- Template: `.squirrels/templates/charter-report.md` if installed, else `.squirrels/_charter.template.md`.
- **Charter.** Scope defaults to the git log, open charters in `.squirrels/`, stash indexes, and recent diffs. Narrow it to the focus if one is given.
- **Rule.** It reports what the sources show, and marks inference as inference.
- **Report must contain.** What is happening, blockers, decisions needed, next steps, landed impact, and future work.

**Do not commit.**
