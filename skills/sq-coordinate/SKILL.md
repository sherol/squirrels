---
name: sq-coordinate
description: Plan and run a group of squirrels toward one goal under a single coordinator squirrel, with one approval, one budget, dependency-ordered waves, and an aggregated report. Use when the user invokes sq-coordinate or a goal needs several squirrels.
---

# sq-coordinate (elephant-goldfish-squirrels)

You are the **elephant**. The user wants several squirrels working toward one goal under a single **coordinator** squirrel (`type: coordinate`). Rules: the "Coordination" section of `squirrels/SPEC.md` in elephant-goldfish-squirrels. The goal is the user's request.

## 1. Draft the plan (gate: no dispatch yet)

1. Decompose the goal into the fewest child squirrels that cover it, preferring archetypes (`review`, `mock`, `verify`, ...). If one squirrel is enough, say so and use the `sq-dispatch` skill instead.
2. Allocate ids: the coordinator first, then each child, sequentially (never reuse an id).
3. Write the coordinator charter from `../sq-dispatch/templates/charter-coordinate.md`: `type: coordinate`, `access: stash-write`, `children:` listing every child id, a `budget` that covers all children plus overhead, and `stop_conditions` that include "any child blocked" and "group budget exceeded".
4. Write each child charter as the `sq-dispatch` skill would (archetype table, defaults, required stop conditions), plus `parent: <coordinator id>` and, where order matters, `depends_on: <sibling ids>`.
5. Check the plan before showing it:
   - children's budgets fit inside the coordinator's;
   - no two `scoped-write` children have overlapping scopes (if they must, sequence them with `depends_on` or merge them);
   - `depends_on` has no cycles;
   - the validator passes (`scripts/sq-charter.sh` from the repo, else `../sq-dispatch/scripts/sq-charter.sh`).
6. Show the user the plan as one table (id, type, access, scope, budget, depends_on) followed by each charter, and ask them to approve, refine, or cancel the **whole plan**. **Do not dispatch anything until they approve.**

## 2. Run the group

After approval, set every charter to `status: dispatched`, create a stash for each, and create `.squirrels/stash/<coordinator>/LEDGER.md` with one row per child: id, status, budget used, outcome. Set the coordinator to `foraging`.

Then, in waves:

1. **Ready** children are those whose `depends_on` are all `done`. Dispatch every ready child, in parallel where your tooling allows (otherwise one at a time), exactly as the `sq-dispatch` skill's step 2 does: a fresh context given only that child's charter and `../sq-dispatch/CONTRACT.md`. Children never dispatch other squirrels.
2. As each returns, update its status and the ledger.
3. If a child is `blocked`: dispatch nothing new, let running children finish, set the coordinator to `blocked`, and write an escalation in the coordinator's `## Report` that names the child and quotes its escalation. Stop and report to the user. They resume with `sq-recall <child-id> <decision>`, then `sq-recall <coordinator-id> continue`.
4. If the group's budget is exceeded, treat it as a stop condition: same as a blocked child.
5. Repeat until every child is `done`.

## 3. Aggregate, report back, then stop

Set the coordinator to `reporting` and write its `## Report`: per-child status and one-line outcome, contradictions or conflicts between children's findings (called out, not silently resolved), and an aggregated recommendation. Set it to `done`.

Summarize for the user and offer `sq-stand-down` for the children and then the coordinator. **Do not commit.**
