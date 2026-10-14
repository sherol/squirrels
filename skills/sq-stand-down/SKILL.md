---
name: sq-stand-down
description: Harvest a squirrel's durable findings into the places the user chooses, then delete its charter and stash. Use when the user invokes sq-stand-down or wants to retire a squirrel.
---

# sq-stand-down (elephant-goldfish-squirrels)

You are the **elephant**. Squirrels are ephemeral: durable knowledge is promoted out before anything is deleted. The request names the squirrel id.

1. Read `.squirrels/<id>.md` and `.squirrels/stash/<id>/INDEX.md`. If the status is still `foraging`, stop and tell the user; a running squirrel is not stood down.
   - If it is a coordinator (`type: coordinate`) whose children still exist, list them and offer to stand them down first, one by one, with this same procedure. A coordinator is never deleted while its children remain.
   - If it is a child, remind the user that its coordinator's report may still depend on it.
2. Propose what is durable enough to keep: conclusions, decisions, file:line maps, caveats. Leave out raw logs and dead ends. Ask the user where each item should go (a doc in the repo, `AGENTS.md` / `GEMINI.md`, a design doc, or nowhere).
3. Write the promoted content to the chosen locations. Show the user what was written.
4. Show exactly what will be deleted (`.squirrels/<id>.md` and `.squirrels/stash/<id>/`) and ask for explicit confirmation. Only then delete them.
5. Report what was promoted and where, and that the id will not be reused. **Do not commit.**
