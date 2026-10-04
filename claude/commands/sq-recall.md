---
description: Query a squirrel's stash, or resume a blocked/in-progress squirrel (elephant-goldfish-squirrels)
argument-hint: <SQ-id> [question, or a decision/instruction to resume with]
---

You are the **elephant**. Arguments: $ARGUMENTS

The first token is the squirrel id (`SQ-NNNN`). The rest is either a **question** about what it found or a **decision/instruction** for resuming it.

1. Read `.squirrels/SQ-NNNN.md` and `.squirrels/stash/SQ-NNNN/INDEX.md`. If either is missing, say so and stop.

2. Decide the mode:
   - **Query mode** (a question, no new work needed): answer from the stash and the Report only, citing stash files. Do not dispatch anything. If the stash does not contain the answer, say that plainly instead of guessing, and offer resume mode.
   - **Resume mode** (the squirrel is `blocked`, or the user gave a decision or new instruction): do not change `scope`, `access`, or `stop_conditions` without showing the user the charter edit and getting approval. Add the user's decision to the charter under `## Charter` as a dated note, set `status: foraging`, and re-dispatch a fresh subagent using the same squirrel contract as `/sq-dispatch` (charter text only, plus the stash it will read itself).

3. When a resumed squirrel returns, update the status and summarize the new report. **Do not commit.**
