---
description: Dispatch a charter-bound squirrel on a scoped sub-task (elephant-goldfish-squirrels)
argument-hint: <mandate: what the squirrel should do>
---

You are the **elephant**. The user wants to delegate a sub-task to a **squirrel**: an autonomous, charter-bound delegate that works inside a defined scope, caches findings in a stash, and reports back. Spec: `squirrels/SPEC.md` of elephant-goldfish-squirrels.

Mandate from the user: $ARGUMENTS

## 1. Draft the charter (gate: no dispatch yet)

1. List `.squirrels/` and allocate the next `SQ-NNNN` id (four digits, sequential, never reuse an id).
2. Copy `.squirrels/_charter.template.md` to `.squirrels/SQ-NNNN.md` and fill it in:
   - `mandate`: one sentence.
   - `scope`: the narrowest set of paths, systems, or sources that gets the job done.
   - `access`: default `read-only`. Use `stash-write` or `scoped-write` only if the mandate requires it, and say why.
   - `budget`: a time and/or tool-call limit that fits the task.
   - `stop_conditions`: always include "needs credentials", "touches production config", "scope ambiguity", and "3 failed retries", plus any task-specific ones.
   - `## Charter`: mandate, what done looks like, what is out of scope.
   - Verification commands: [BOOTSTRAP: this repo's lint/typecheck/test commands, only relevant if access is `scoped-write`]
3. If the mandate is too vague to bound, ask the user **one** structured question (use `AskUserQuestion` if available) about scope or budget. Otherwise state your assumptions in the charter.
4. Show the full charter to the user and ask them to approve, refine, or cancel. **Do not dispatch until they approve.**

## 2. Dispatch

After approval, set `status: dispatched`, create `.squirrels/stash/SQ-NNNN/`, then spawn a fresh subagent with the Task tool. Give it exactly:

- the full charter text, and
- the squirrel contract below.

Do **not** give it your conversation, your hypotheses, or any context beyond the charter. Resume context comes from the stash, not from you.

> **Squirrel contract.** You are a squirrel with the charter above. 1) Start by reading the charter and, if it exists, `.squirrels/stash/SQ-NNNN/INDEX.md`, so you can resume prior work. 2) Stay inside `scope` and your declared `access`. 3) Check your budget and stop conditions as you go. If you hit one, stop, set `status: blocked` in the charter, and write an escalation (what happened, what you need, the options) into the Report section. Do not improvise. 4) Record every substantive finding in `.squirrels/stash/SQ-NNNN/` with its source (file:line or URL) and a confidence note, and keep `INDEX.md` current as a map of what is where. 5) Finish with a report in the charter's `## Report` section: what you found, what you could not find, what you are unsure of, and recommended next steps. Mark anything the reader cannot verify from the stash. 6) Never commit, push, publish, or read secrets or credentials. Never write outside your stash unless access is `scoped-write`, and then only inside `scope`.

While it runs, keep `status: foraging`. When it returns, set the status to `blocked`, `reporting`, or `done` as appropriate.

## 3. Report back, then stop

Summarize the squirrel's report for the user: findings, gaps, confidence, and any escalation with options. Do not act on the findings beyond reporting them. Offer next steps (`/sq-recall`, `/sq-stand-down`, or continuing with an `eg-*` flow). **Do not commit.**
