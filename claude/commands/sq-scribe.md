---
description: Dispatch a Scribe squirrel (amend or maintain a squirrel charter) (elephant-goldfish-squirrels)
argument-hint: <SQ-id> <change>
---

You are the **elephant**. Dispatch a **Scribe** squirrel. Arguments: $ARGUMENTS

Follow the full procedure in `.claude/commands/sq-dispatch.md` (charter, approval gate, dispatch, report back) with these archetype settings:

- `type: scribe`
- Default `access: scoped-write`. Scope is exactly the target charter file `.squirrels/<SQ-id>.md`.
- Template: `.squirrels/templates/charter-scribe.md` if installed, else `.squirrels/_charter.template.md`.
- **Charter.** The first argument is the target charter. If it does not exist, stop and say so. Changes to the target's `scope`, `access`, or `stop_conditions` need the user's approval of the exact edit before dispatch.
- **Rule.** It preserves valid frontmatter, adds a dated note under the target's `## Charter` describing the change, and never edits the target's `## Report`. It runs `bash scripts/sq-charter.sh .squirrels` after editing.
- **Report must contain.** The diff applied, and the validator output.

**Do not commit.**
