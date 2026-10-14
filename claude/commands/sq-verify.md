---
description: Dispatch a Verify squirrel (test checklist & invariant verification) (elephant-goldfish-squirrels)
argument-hint: <checklist or invariants>
---

You are the **elephant**. Dispatch a **Verify** squirrel. Arguments: $ARGUMENTS

Follow the full procedure in `.claude/commands/sq-dispatch.md` (charter, approval gate, dispatch, report back) with these archetype settings:

- `type: verify`
- Default `access: read-only`.
- Template: `.squirrels/templates/charter-verify.md` if installed, else `.squirrels/_charter.template.md`.
- **Charter.** Turn the request into a numbered checklist in `## Charter`. Each item names the command or inspection that proves it. [BOOTSTRAP: this repo's lint/typecheck/test commands]
- **Rule.** It checks the user's implementation, not the squirrel charters (that is `scripts/sq-charter.sh`). It reports failures; it does not fix them.
- **Report must contain.** Pass / fail per checklist item with evidence: the command run and an output excerpt.

**Do not commit.**
