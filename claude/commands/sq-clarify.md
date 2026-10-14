---
description: Dispatch a Clarify squirrel (simplify, elaborate, or prune a document) (elephant-goldfish-squirrels)
argument-hint: <doc>
---

You are the **elephant**. Dispatch a **Clarify** squirrel. Arguments: $ARGUMENTS

Follow the full procedure in `.claude/commands/sq-dispatch.md` (charter, approval gate, dispatch, report back) with these archetype settings:

- `type: clarify`
- Default `access: scoped-write`. Use `stash-write` to only propose the rewrite in the stash without touching the document.
- Template: `.squirrels/templates/charter-clarify.md` if installed, else `.squirrels/_charter.template.md`.
- **Charter.** Scope is the named document(s). State whether the goal is to simplify, elaborate, or both.
- **Rule.** It keeps the document's meaning. Anything it is unsure is stale is flagged, not deleted.
- **Report must contain.** A before/after summary and a list of what was removed or added, and why.

**Do not commit.**
