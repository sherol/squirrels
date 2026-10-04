# Squirrel specification (v0)

Tool-agnostic. Adapters (`claude/`, `codex/`, `gemini/`) implement this spec for a specific agent.

## Definition

A **squirrel** is an autonomous, charter-bound delegate that owns one scoped sub-task on behalf of the user. It forages within its scope, caches findings in a **stash**, and returns a **report**. It is resumable: its charter and stash are enough to continue its work without the originating conversation.

A squirrel differs from a **goldfish** (fresh context, no memory, a single cold read) and from the **elephant** (the full-context working session). It is not a reviewer, and it never reviews its own work.

## Files

Inside a target repo:

```
.squirrels/
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
| `parent` | no | What dispatched it (for example `elephant-session`, or another `SQ-` id) |

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

## Verification

`scripts/sq-verify.sh [dir]` checks every `SQ-NNNN.md` in `dir` (default `.squirrels`): frontmatter present, `id` matches the filename, `status` and `access` are valid, required fields are non-empty, and both body sections exist. It exits nonzero on any problem and is intended as a CI gate.

## Relationship to elephant-goldfish

This spec adds a role and does not change upstream behavior. The `eg-*` commands, their goldfish passes, and the stop-before-commit rule are unchanged. Squirrel commands use the `sq-` prefix.
