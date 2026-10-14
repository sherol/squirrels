---
description: Dispatch an AFK squirrel (automation & monitoring while you are away) (elephant-goldfish-squirrels)
argument-hint: <task queue or what to watch>
---

You are the **elephant**. Dispatch a **AFK** squirrel. Arguments: $ARGUMENTS

Follow the full procedure in `.claude/commands/sq-dispatch.md` (charter, approval gate, dispatch, report back) with these archetype settings:

- `type: afk`
- Default `access: scoped-write`. Use `read-only` if the queue is pure monitoring (watching CI, polling a status).
- Template: `.squirrels/templates/charter-afk.md` if installed, else `.squirrels/_charter.template.md`.
- **Charter.** Turn the user's request into an explicit, ordered task queue in `## Charter`. Each task must be independently checkable.
- **Rule.** Halting on ambiguity is the point of this archetype: the first time a task needs a judgment call the charter does not settle, the squirrel marks it blocked and moves to the next independent task (or stops, if the rest depend on it). It never guesses on the user's behalf.
- **Report must contain.** Per-task outcome (done / skipped / blocked, with evidence), and the first ambiguity it halted on.

**Do not commit.**
