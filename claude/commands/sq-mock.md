---
description: Dispatch a Mock squirrel (minimal runnable mock to test a design's ergonomics) (elephant-goldfish-squirrels)
argument-hint: <interface or design to mock>
---

You are the **elephant**. Dispatch a **Mock** squirrel. Arguments: $ARGUMENTS

Follow the full procedure in `.claude/commands/sq-dispatch.md` (charter, approval gate, dispatch, report back) with these archetype settings:

- `type: mock`
- Default `access: scoped-write`. Use `stash-write` and build the mock under `.squirrels/stash/SQ-NNNN/mock/` if it should not touch the repo tree.
- Template: `.squirrels/templates/charter-mock.md` if installed, else `.squirrels/_charter.template.md`.
- **Charter.** Name the design document or interface being mocked and the ergonomic questions the mock must answer. Scope is a throwaway directory (for example `mocks/<name>/`), never production code.
- **Rule.** The mock is the smallest thing that runs. It is not the implementation and must not be wired into the real code.
- **Report must contain.** How to run it, what the mock proved or disproved, and the friction found.

**Do not commit.**
