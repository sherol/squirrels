---
name: sq-dispatch
description: Dispatch a charter-bound squirrel (a scoped, resumable delegate) on a sub-task, optionally as an archetype such as review, mock, verify, afk, report, next, done, pr, clarify, or scribe. Use when the user asks to delegate, dispatch a squirrel, or invokes sq-dispatch or an sq-<archetype> name.
---

# sq-dispatch (elephant-goldfish-squirrels)

You are the **elephant**: the user's full-context working session. The user wants to delegate a sub-task to a **squirrel**, an autonomous, charter-bound delegate that works inside a defined scope, caches findings in a stash, and reports back.

Files that ship with this skill (paths relative to this `SKILL.md`):

- `CONTRACT.md`: the squirrel contract, given verbatim to every squirrel.
- `templates/charter.md` and `templates/charter-<type>.md`: charter templates.
- `scripts/sq-charter.sh`: the charter validator.

## 0. Parse the request and prepare the repo

The request may start with an archetype: `review: <topic>`, `sq-mock <interface>`, `afk <queue>`, and so on. If it does, use that archetype. Otherwise, if the mandate clearly matches one archetype, propose it in the charter and say why; if none fits, dispatch a generic squirrel (no `type`). If the work needs several squirrels, use the `sq-coordinate` skill instead.

If `.squirrels/` does not exist in the repo root, tell the user you will create it, then:

- create `.squirrels/` and `.squirrels/stash/`;
- add `.squirrels/stash/` to `.gitignore` (create it if needed; do not duplicate the line).

**Validator.** Use `scripts/sq-charter.sh` from the repo if it exists, else the copy shipped with this skill. Run it as `bash <path> .squirrels`.

**Verification commands.** Inspect the repo's manifests and CI config (`package.json`, `pyproject.toml`, `Cargo.toml`, `Gemfile`, `go.mod`, `Makefile`, `.github/workflows/`, `AGENTS.md`, `GEMINI.md`) to work out its lint, typecheck, and test commands. You need them for `scoped-write` and `verify` squirrels.

## 1. Draft the charter (gate: no dispatch yet)

1. List `.squirrels/` and allocate the next `SQ-NNNN` id (four digits, sequential, never reuse an id).
2. Copy the archetype template (or `templates/charter.md` for a generic squirrel) to `.squirrels/SQ-NNNN.md` and fill it in. Template values are examples; replace all of them.
   - `type`: the archetype, or omit the field.
   - `mandate`: one sentence.
   - `scope`: the narrowest set of paths, systems, or sources that gets the job done.
   - `access`: the archetype's default from the table below, or `read-only` for a generic squirrel. Use a wider level only if the mandate requires it, and say why.
   - `budget`: a time and/or tool-call limit that fits the task.
   - `stop_conditions`: always include "needs credentials", "touches production config", "scope ambiguity", and "3 failed retries", plus any task-specific ones.
   - `## Charter`: mandate, what done looks like (including the archetype's required report contents), what is out of scope, and the verification commands if access is `scoped-write`.
3. If the mandate is too vague to bound, ask the user **one** question about scope or budget. Otherwise state your assumptions in the charter.
4. Run the validator and fix any failure. Show the full charter to the user and ask them to approve, refine, or cancel. **Do not dispatch until they approve.**

### Archetypes

| `type` | Default access | Charter must establish | Report must contain |
| --- | --- | --- | --- |
| `afk` | `scoped-write` (`read-only` for pure monitoring) | An ordered queue of independently checkable tasks. The squirrel halts on the first judgment call the charter does not settle; it never guesses | Per-task outcome (done / skipped / blocked) and the ambiguity it halted on |
| `review` | `stash-write` | The question the review answers and the source types in scope | Sources with links, comparison of approaches, synthesis and recommendation |
| `mock` | `scoped-write` in a throwaway dir (`stash-write` to keep it in the stash) | The design being mocked and the ergonomic questions. Never wired into real code | How to run it, what it proved or disproved, friction found |
| `verify` | `read-only` | A numbered checklist, each item with the command or inspection that proves it. Reports failures, does not fix them | Pass / fail per item with command and output excerpt |
| `scribe` | `scoped-write`, scope is the one target charter | The target charter and the exact change. Changes to its scope, access, or stop conditions need user approval of the edit | The diff applied and validator output |
| `report` | `read-only` | Focus, if any. Defaults to git log, open charters, stash indexes, recent diffs | What is happening, blockers, decisions needed, next steps, landed impact, future work |
| `next` | `read-only` | The current work in scope | Two lists: what the human must do, what an agent can do or is doing |
| `done` | `read-only` | The milestone's Definition of Done (draft one for approval if none exists) | DoD checklist with status and evidence, scope creep detected |
| `pr` | `read-only` | Diff against the target branch, contribution guide, PR templates. Drafts only; never pushes or opens a PR | Title, description, test plan, commit-style notes |
| `clarify` | `scoped-write` (`stash-write` to only propose) | The document(s) and whether to simplify, elaborate, or both. Flags uncertain staleness instead of deleting | Before/after summary and what was removed or added, and why |

## 2. Dispatch

After approval, set `status: dispatched`, create `.squirrels/stash/SQ-NNNN/`, then run the squirrel in a **fresh context** given exactly the full charter text and the contents of `CONTRACT.md` (with `SQ-NNNN` filled in). Do **not** give it your conversation, hypotheses, or any other context. Resume context comes from the stash.

Use the first of these your environment supports:

1. A built-in subagent or task tool that starts with a fresh context.
2. A separate non-interactive run of the same CLI, with the prompt written to `.squirrels/stash/SQ-NNNN/PROMPT.md` first. For example, Codex: `codex exec "$(cat .squirrels/stash/SQ-NNNN/PROMPT.md)"`; Gemini CLI: `gemini -p "$(cat .squirrels/stash/SQ-NNNN/PROMPT.md)"`. Use the user's normal sandbox and approval settings; never a mode that bypasses approvals.
3. If neither is possible, tell the user the squirrel will not have a fresh context, then do the work yourself as a clearly separated phase: re-read only the charter and stash, follow the contract, and do not use anything from this conversation that is not in the charter.

While it runs, keep `status: foraging`. When it returns, set the status to `blocked`, `reporting`, or `done` as appropriate, and run the validator.

## 3. Report back, then stop

Summarize the squirrel's report for the user: findings, gaps, confidence, and any escalation with options. Do not act on the findings beyond reporting them. Offer next steps (`sq-recall`, `sq-stand-down`). **Do not commit.**
