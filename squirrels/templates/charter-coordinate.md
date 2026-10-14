---
id: SQ-[NNNN]
status: dispatched
type: coordinate
mandate: Coordinate a prior-art review and a runnable mock of the charter parser, then verify the mock against the spec.
scope: .squirrels/, the child squirrels' scopes
access: stash-write
budget: 3h / 120 tool calls (all children included)
stop_conditions: any child blocked, group budget exceeded, overlapping scoped-write scopes, scope ambiguity
parent: elephant-session
children: SQ-[NNNN+1], SQ-[NNNN+2], SQ-[NNNN+3]
---

# Coordinate Charter

## Charter

**Mandate.** Coordinate a prior-art review and a runnable mock of the charter parser, then verify the mock against the spec.

**Plan.**

| Child | Type | Access | Depends on |
| --- | --- | --- | --- |
| SQ-[NNNN+1] | review | stash-write | none |
| SQ-[NNNN+2] | mock | scoped-write | SQ-[NNNN+1] |
| SQ-[NNNN+3] | verify | read-only | SQ-[NNNN+2] |

**Done looks like.** Every child is `done`, and the report aggregates their outcomes and calls out any contradictions.

**Ledger.** `.squirrels/stash/SQ-[NNNN]/LEDGER.md`

## Report
_Not yet reported._
