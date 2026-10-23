---
id: SQ-[NNNN]
status: dispatched
type: verify
mandate: Check that the session-timeout refactor in src/auth/ passes the project's lint, typecheck, and tests and still enforces the timeout invariants.
scope: src/auth/, tests/auth/, package.json
access: read-only
budget: 45m / 30 tool calls
stop_conditions: 3 test runs fail with environment errors, needs credentials, touches production config, scope ambiguity
parent: elephant-session
---

# Verify Charter

## Charter

**Mandate.** Check that the session-timeout refactor in src/auth/ passes the project's lint, typecheck, and tests and still enforces the timeout invariants.

**Checklist.** Each item names the command or inspection that proves it. Report failures; do not fix them.

1. Lint is clean for the scope: `npm run lint -- src/auth/`.
2. Types check: `npm run typecheck`.
3. Auth tests pass: `npm test -- tests/auth/`.
4. Invariant: an idle session expires after the configured timeout. Evidence: the test in `tests/auth/` that covers it, and its result.

## Report
_Not yet reported._
