# Prompts

## Update Squirrel Patterns

Paste this into your AI agent inside a project you bootstrapped earlier. It pulls the latest squirrel templates and smart-merges them with your local adaptations.

```
Update the elephant-goldfish-squirrels workflow in this repo.

1. Fetch the latest procedure and templates from
   `gh api repos/sherol/squirrels/contents/claude/BOOTSTRAP.md -H 'Accept: application/vnd.github.raw'`
   and the files under `claude/commands/`, `claude/snippet.md`, `squirrels/templates/charter.md`, and `scripts/sq-verify.sh`.
2. Compare each against my local copies in `.claude/commands/sq-*.md`, `.squirrels/_charter.template.md`, `scripts/sq-verify.sh`, and the "Working with squirrels" section of CLAUDE.md.
3. Identify the local adaptations I made (filled-in [BOOTSTRAP: ...] values and any project-specific edits) and preserve them.
4. Bring in the upstream changes, show me a diff for every file, and ask before overwriting anything I edited by hand.
5. Do not touch any `eg-*` files, existing charters in `.squirrels/`, or stashes. Do not commit.
```

Replace `<owner>` with the account that hosts this repo. To update the base elephant-goldfish workflow, use upstream's own update prompt.
