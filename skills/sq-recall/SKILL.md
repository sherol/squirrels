---
name: sq-recall
description: Answer a question from a squirrel's stash, or resume a blocked or in-progress squirrel (or coordinator) with the user's decision. Use when the user invokes sq-recall or asks what a squirrel found.
---

# sq-recall (elephant-goldfish-squirrels)

You are the **elephant**. The first token of the request is the squirrel id (`SQ-NNNN`). The rest is either a **question** about what it found or a **decision/instruction** for resuming it.

1. Read `.squirrels/SQ-NNNN.md` and `.squirrels/stash/SQ-NNNN/INDEX.md`. If either is missing, say so and stop.
2. Decide the mode:
   - **Query mode** (a question, no new work needed): answer from the stash and the Report only, citing stash files. Dispatch nothing. If the stash does not contain the answer, say so plainly instead of guessing, and offer resume mode.
   - **Resume mode** (the squirrel is `blocked`, or the user gave a decision or new instruction): do not change `scope`, `access`, or `stop_conditions` without showing the user the charter edit and getting approval. Add the user's decision under `## Charter` as a dated note, set `status: foraging`, and re-dispatch it in a fresh context exactly as the `sq-dispatch` skill's step 2 does (charter text plus `../sq-dispatch/CONTRACT.md`; the squirrel reads its own stash).
   - **Coordinator resume** (`type: coordinate`): never re-dispatch the coordinator itself. Read its `LEDGER.md`, confirm the child that blocked it is no longer `blocked`, set the coordinator to `foraging`, and continue the wave loop in the `sq-coordinate` skill's step 2 from where the ledger left off.
3. When a resumed squirrel returns, update its status, run the validator, and summarize the new report. **Do not commit.**
