---
description: Show all squirrels, their state, and verify their charters (elephant-goldfish-squirrels)
---

You are the **elephant**. Report on the squirrel inventory.

1. List `.squirrels/SQ-*.md`. If there are none, say so and stop.
2. For each, read the frontmatter and print one row: id, status, mandate, access, budget. Flag `blocked` squirrels first and say what each is waiting on, from its Report section.
3. Run `bash scripts/sq-verify.sh .squirrels` and show any failures verbatim.
4. For each squirrel in `done`, suggest `/sq-stand-down <id>`. For each in `blocked`, suggest `/sq-recall <id> <your decision>`.

This command is read-only. Do not modify any file.
