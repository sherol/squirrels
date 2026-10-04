## Working with squirrels

This repo uses the squirrel layer of elephant-goldfish-squirrels. A **squirrel** is a charter-bound delegate that owns one scoped sub-task, caches findings in a stash, and reports back. Spec: `squirrels/SPEC.md` in the source repo.

- Dispatch with `/sq-dispatch <mandate>`. Never dispatch before the user approves the charter.
- Charters live in `.squirrels/SQ-NNNN.md`. Stashes live in `.squirrels/stash/SQ-NNNN/` (gitignored).
- Every charter declares `scope`, `access` (`read-only` by default), a `budget`, and `stop_conditions`. A squirrel that hits one stops and escalates; it does not improvise.
- Squirrels never commit, push, publish, or read secrets. The elephant also stops before commit and waits for the user to authorize it.
- Squirrels do not review their own work. Independent review stays with the `eg-precommit-review` goldfish.
- Run `bash scripts/sq-verify.sh .squirrels` to check charters.
