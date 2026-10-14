---
name: sq-status
description: Show every squirrel in this repo with its type, state, and budget, and validate the charters. Read-only. Use when the user asks for squirrel status or invokes sq-status.
---

# sq-status (elephant-goldfish-squirrels)

You are the **elephant**. Report on the squirrel inventory. This skill is read-only: do not modify any file.

1. List `.squirrels/SQ-*.md`. If there are none, say so and stop.
2. For each, read the frontmatter and print one row: id, type (or `generic`), status, mandate, access, budget. Indent children under their coordinator (`parent: SQ-NNNN`) and show each coordinator's progress as `done/total` children, from `.squirrels/stash/<id>/LEDGER.md` if present. Flag `blocked` squirrels first and say what each is waiting on, from its Report section.
3. Run the validator (`scripts/sq-charter.sh` from the repo if present, else `../sq-dispatch/scripts/sq-charter.sh` next to this skill) as `bash <path> .squirrels` and show any failures verbatim.
4. For each squirrel in `done`, suggest `sq-stand-down <id>`. For each in `blocked`, suggest `sq-recall <id> <your decision>`.
