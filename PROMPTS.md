# Prompts

## Update Squirrel Patterns

Paste the prompt for your agent into a project you bootstrapped earlier. It pulls the latest squirrel files and smart-merges them with your local adaptations.

### Claude Code

```
Update the elephant-goldfish-squirrels workflow in this repo.

1. Fetch the latest procedure and templates from
   `gh api repos/sherol/squirrels/contents/claude/BOOTSTRAP.md -H 'Accept: application/vnd.github.raw'`
   and the files under `claude/commands/`, `claude/snippet.md`, `squirrels/templates/` (base and archetype charters), and `scripts/sq-charter.sh`.
2. Compare each against my local copies in `.claude/commands/sq-*.md`, `.squirrels/_charter.template.md`, `.squirrels/templates/`, `scripts/sq-charter.sh` (or the older `scripts/sq-verify.sh`, which it replaces), and the "Working with squirrels" section of CLAUDE.md.
3. Identify the local adaptations I made (filled-in [BOOTSTRAP: ...] values and any project-specific edits) and preserve them.
4. Bring in the upstream changes, show me a diff for every file, and ask before overwriting anything I edited by hand.
5. Do not touch any `eg-*` files, existing charters in `.squirrels/`, or stashes. Do not commit.
```

### Codex

The skills are installed once per user, so run this from any Codex session. Paste:

```
Update the elephant-goldfish-squirrels skills for Codex.

1. Fetch the latest procedure with
   `gh api repos/sherol/squirrels/contents/codex/BOOTSTRAP.md -H 'Accept: application/vnd.github.raw'`
   and clone the source: `src=$(mktemp -d) && git clone --depth 1 https://github.com/sherol/squirrels "$src"`.
2. Compare each directory in `"$src/skills/"` (`sq-dispatch`, `sq-coordinate`, `sq-status`, `sq-recall`, `sq-stand-down`) with my installed copy in `${CODEX_HOME:-~/.codex}/skills/<name>/`. Also compare the bundled files: `"$src"/squirrels/templates/*.md` with `${CODEX_HOME:-~/.codex}/skills/sq-dispatch/templates/`, and `"$src/scripts/sq-charter.sh"` with `${CODEX_HOME:-~/.codex}/skills/sq-dispatch/scripts/sq-charter.sh`.
3. Keep the skills project-agnostic (they inspect the current repo at runtime). Identify any edits I made by hand to the installed copies and preserve them.
4. Bring in the upstream changes, show me a diff for every file, and ask before overwriting anything I edited by hand. Keep `sq-charter.sh` executable.
5. If the current repo has its own `scripts/sq-charter.sh` or a "Working with squirrels" section in `AGENTS.md`, offer to update those too (the section is adapted from `claude/snippet.md`, with `$sq-` skill names instead of `/sq-` commands).
6. Do not touch any `eg-*` skills, existing charters in `.squirrels/`, or stashes. Remove `"$src"` when done. Remind me to restart Codex. Do not commit.
```

### Gemini CLI

The skills are installed per repo, so run this inside the repo. Paste:

```
Update the elephant-goldfish-squirrels workflow in this repo for Gemini CLI.

1. Fetch the latest procedure with
   `gh api repos/sherol/squirrels/contents/gemini/BOOTSTRAP.md -H 'Accept: application/vnd.github.raw'`
   and clone the source: `src=$(mktemp -d) && git clone --depth 1 https://github.com/sherol/squirrels "$src"`.
2. Compare each directory in `"$src/skills/"` (`sq-dispatch`, `sq-coordinate`, `sq-status`, `sq-recall`, `sq-stand-down`) with my local copy in `.gemini/skills/<name>/`. Also compare: `"$src"/squirrels/templates/*.md` with `.gemini/skills/sq-dispatch/templates/`; `"$src/scripts/sq-charter.sh"` with both `.gemini/skills/sq-dispatch/scripts/sq-charter.sh` and `scripts/sq-charter.sh`; and `"$src/claude/snippet.md"` with the "Working with squirrels" section of `GEMINI.md` (which uses skill names instead of `/sq-` commands and `GEMINI.md` instead of `CLAUDE.md`).
3. Identify the local adaptations I made (project-specific edits) and preserve them.
4. Bring in the upstream changes, show me a diff for every file, and ask before overwriting anything I edited by hand. Keep the `sq-charter.sh` copies executable.
5. Do not touch any `eg-*` skills, existing charters in `.squirrels/`, or stashes. Remove `"$src"` when done. Remind me to restart Gemini CLI (or run `/skills reload`). Do not commit.
```

To update the base elephant-goldfish workflow, use upstream's own update prompt.
