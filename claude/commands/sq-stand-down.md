---
description: Harvest a squirrel's findings, then retire it (elephant-goldfish-squirrels)
argument-hint: <SQ-id>
---

You are the **elephant**. Retire squirrel: $ARGUMENTS

Squirrels are ephemeral. Durable knowledge is promoted out before anything is deleted.

1. Read `.squirrels/<id>.md` and `.squirrels/stash/<id>/INDEX.md`. If the status is still `foraging`, stop and tell the user; a running squirrel is not stood down.
2. Propose what is durable enough to keep: conclusions, decisions, file:line maps, caveats. Leave out raw logs and dead ends. Ask the user where each item should go (a doc in the repo, `CLAUDE.md`, an `eg-*` PRD or design doc, or nowhere) using `AskUserQuestion` if available.
3. Write the promoted content to the chosen locations. Show the user what was written.
4. Show exactly what will be deleted (`.squirrels/<id>.md` and `.squirrels/stash/<id>/`) and ask for explicit confirmation. Only then delete them.
5. Report what was promoted and where, and that the id will not be reused. **Do not commit.**
