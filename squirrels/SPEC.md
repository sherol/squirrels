# Squirrel specification (v0.2)

Tool-agnostic. Adapters (`claude/`, `codex/`, `gemini/`) implement this spec for a specific agent.

## Definition

A **squirrel** is an autonomous, charter-bound delegate that owns one scoped sub-task on behalf of the user. It forages within its scope, caches findings in a **stash**, and returns a **report**. It is resumable: its charter and stash are enough to continue its work without the originating conversation.

A squirrel differs from a **goldfish** (fresh context, no memory, a single cold read) and from the **elephant** (the full-context working session). It is not a reviewer, and it never reviews its own work.

## Files

Inside a target repo:

```
.squirrels/
├── _charter.template.md  # base template (ignored by the validator)
├── SQ-0001.md            # charter + report (one file per squirrel)
└── stash/
    └── SQ-0001/
        ├── INDEX.md      # cache map: what was found, where, and how confident
        └── ...           # raw artifacts (notes, excerpts, logs)
```

- `.squirrels/stash/` is gitignored. Charters are small and may be committed.
- IDs are `SQ-NNNN` (four digits), allocated sequentially. An ID is never reused.

## Charter frontmatter

| Field | Required | Meaning |
| --- | --- | --- |
| `id` | yes | Must match the filename stem |
| `status` | yes | See lifecycle below |
| `mandate` | yes | One sentence: what the squirrel is for |
| `scope` | yes | List of paths, systems, or sources it may touch |
| `access` | yes | `read-only`, `stash-write`, or `scoped-write` |
| `budget` | yes | Time and/or tool-call limit |
| `stop_conditions` | yes | Conditions that force it to stop and escalate |
| `type` | no | An archetype (see below). Omitted means a generic squirrel |
| `parent` | no | What dispatched it: `elephant-session`, or the `SQ-` id of a coordinator |
| `children` | coordinate only | Comma-separated `SQ-` ids the coordinator owns |
| `depends_on` | no | Comma-separated `SQ-` ids (siblings under the same coordinator) that must be `done` before this one is dispatched |

Required body sections: `## Charter` and `## Report`.

### Access levels

- `read-only` (default): reads inside scope; writes only to its own stash and the Report section of its charter.
- `stash-write`: same as `read-only`, plus may write generated artifacts into its stash.
- `scoped-write`: may modify files inside `scope`. Never outside it.

No access level permits committing, pushing, or reading secrets and credentials.

## Lifecycle

```
dispatched -> foraging -> reporting -> done
                 |
                 +-> blocked -> foraging   (user decides; resume)
done | blocked -> stood-down (harvest, then delete)
```

- `dispatched`: charter approved by the user, squirrel not yet running.
- `foraging`: working inside scope and budget.
- `blocked`: a stop condition or budget limit was hit. The report contains an **escalation**: what happened, what it needs, and the options.
- `reporting`: writing the final report.
- `done`: report complete, awaiting stand-down.
- `stood-down`: terminal. Durable findings were promoted where the user chose; charter and stash are then deleted.

## The squirrel contract

A squirrel must:

1. Begin by reading its charter and, if present, `stash/SQ-NNNN/INDEX.md`, so it can resume.
2. Stay inside `scope` and its declared `access`.
3. Check budget and stop conditions as it goes. On a hit, set `blocked` and escalate rather than improvise.
4. Record every substantive finding in the stash with a source and a confidence note, and keep `INDEX.md` current.
5. Finish with a report: what was found, what was not, what it is unsure of, and recommended next steps. Findings the elephant can't verify from the stash should be marked as such.
6. Never commit, push, publish, or access secrets.

A squirrel runs in a **fresh context**: it is given the charter text and this contract, nothing else. Adapters that cannot spawn a fresh-context subagent must say so to the user and run the squirrel as a clearly separated phase that re-reads only the charter and stash.

## Archetypes

An archetype is a pre-shaped charter for a recurring kind of delegation. It sets `type`, a default `access`, and what the report must contain. Everything else in this spec still applies. The user may override the default access when approving the charter.

| `type` | Default access | Purpose | Report must contain |
| --- | --- | --- | --- |
| `afk` | `scoped-write` (`read-only` for pure monitoring) | Work through or watch a queue of tasks while the user is away | Per-task outcome (done / skipped / blocked), and the first ambiguity it halted on |
| `review` | `stash-write` | Literature and prior-art survey on a topic | Sources with links, comparison of approaches, synthesis and recommendation |
| `mock` | `scoped-write` (`stash-write` if the mock lives in the stash) | Minimal runnable mock of a design to test its ergonomics before full implementation | How to run it, what the mock proved or disproved, friction found |
| `verify` | `read-only` | Run a checklist of tests and invariants against the current implementation | Pass / fail per item with evidence (command and output excerpt) |
| `scribe` | `scoped-write` (scope: the target charter only) | Amend or maintain another squirrel's charter | The diff applied, and confirmation the validator still passes |
| `report` | `read-only` | 360° situational summary | What is happening, blockers, decisions needed, next steps, landed impact, future work |
| `next` | `read-only` | Immediate next steps | Two lists: what the human must do, what an agent can do (or is doing) |
| `done` | `read-only` | Guard the Definition of Done for a milestone | DoD checklist with status, and any scope creep detected |
| `pr` | `read-only` | Prepare a pull request in the user's conventions | Proposed title, description, test plan, and commit-style notes. It never opens the PR itself |
| `clarify` | `scoped-write` (`stash-write` to propose only) | Simplify or elaborate a document; remove redundancy and stale context | Before/after summary and a list of what was removed and why |
| `coordinate` | `stash-write` | Own a group of child squirrels working toward one goal | Per-child status and outcome, conflicts found between children, aggregated recommendation |

## Coordination

A **coordinator** (`type: coordinate`) is a squirrel whose sub-task is to run other squirrels. It exists so that multi-squirrel work has one charter, one budget, and one report.

- **Single approval.** The elephant drafts the coordinator and every child charter together and shows them to the user as one plan. Nothing is dispatched until the user approves the plan. Adding a child later is a charter change and needs approval again.
- **Ownership.** The coordinator lists its children in `children`. Each child sets `parent` to the coordinator's id. A child belongs to exactly one coordinator. Coordinators do not nest.
- **Budget.** The children's budgets must fit inside the coordinator's budget. Exceeding the coordinator's budget is a stop condition for the whole group.
- **Scopes.** Two children with `scoped-write` access must not have overlapping scopes. Read-only children may overlap freely.
- **Ordering.** `depends_on` orders children. Children with no unmet dependencies may run in parallel. A dependency cycle is a charter error.
- **Execution.** The elephant runs the coordinator: it dispatches each ready child under the normal squirrel contract, records progress in the coordinator's stash (`stash/SQ-NNNN/LEDGER.md`: child, status, budget used, outcome), and dispatches the next wave as dependencies complete. Children never dispatch other squirrels.
- **Escalation.** When any child goes `blocked`, the coordinator stops dispatching new children, lets running children finish, sets itself `blocked`, and escalates with that child's escalation attached.
- **Report.** When every child is `done`, the coordinator writes the aggregated report. It must call out contradictions between children rather than resolve them silently.
- **Stand-down.** A coordinator is stood down only after all of its children have been stood down, or together with them.

## Verification

`scripts/sq-charter.sh [dir]` checks every `SQ-NNNN.md` in `dir` (default `.squirrels`):

- frontmatter present, `id` matches the filename;
- `status`, `access`, and (if present) `type` are valid values;
- required fields are non-empty and both body sections exist;
- coordination links are consistent: every `children` id exists and names the coordinator as `parent`, every `parent` that is an `SQ-` id exists and is a coordinator listing the child, and every `depends_on` id exists and shares the same `parent`. Dependency cycles are not detected; the elephant checks for them when drafting the plan.

It exits nonzero on any problem and is intended as a CI gate. The name is distinct from the `verify` archetype (`/sq-verify`), which checks the user's implementation, not the charters.

## Relationship to elephant-goldfish

This spec adds a role and does not change upstream behavior. The `eg-*` commands, their goldfish passes, and the stop-before-commit rule are unchanged. Squirrel commands use the `sq-` prefix.
