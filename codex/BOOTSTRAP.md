# Codex bootstrap (planned)

Not implemented yet. The intended design mirrors upstream elephant-goldfish: shared `sq-*` skills installed once into `${CODEX_HOME:-~/.codex}/skills/`, invoked as `$sq-dispatch`, `$sq-status`, `$sq-recall`, and `$sq-stand-down`. They would inspect the current repo at runtime rather than being rewritten per project.

Implement it against `squirrels/SPEC.md`. The Claude Code adapter in `claude/` is the reference.
