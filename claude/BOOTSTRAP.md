# Claude Code bootstrap: squirrels

You are installing the **squirrel layer** into the current repo. It extends the elephant-goldfish workflow and must never replace or break it. Follow these steps in order. Do not commit anything.

Replace `<owner>` below with the owner of this repo (taken from the `gh api` path you were given).

## 1. Check the base workflow

Look for `.claude/commands/eg-*.md` in the target repo.

- If present, continue.
- If absent, tell the user the squirrel layer builds on elephant-goldfish and ask whether to install it first. If yes, fetch and follow upstream's procedure:
  `gh api repos/vshvedov/elephant-goldfish/contents/claude/BOOTSTRAP.md -H 'Accept: application/vnd.github.raw'`
  If no, you may continue, but say that the `eg-*` commands referenced in the docs will not exist.

## 2. Inspect the stack (adaptive injection)

Read the manifests that exist (`package.json`, `Gemfile`, `pyproject.toml`, `pubspec.yaml`, `Cargo.toml`, `mise.toml`, `.tool-versions`, CI config) and the target's `CLAUDE.md`. Work out the repo's lint, typecheck, and test commands. You will use them to fill `[BOOTSTRAP: ...]` markers.

## 3. Install the commands

Fetch each file in `claude/commands/` from this repo:

```
gh api repos/sherol/squirrels/contents/claude/commands -H 'Accept: application/vnd.github+json' --jq '.[].name'
gh api repos/sherol/squirrels/contents/claude/commands/<name> -H 'Accept: application/vnd.github.raw'
```

For each, replace `[BOOTSTRAP: ...]` markers with the real commands from step 2, then write it to `<target>/.claude/commands/`. If a file with the same name already exists, show the user a diff and ask before overwriting. Never touch `eg-*` files.

## 4. Create the inventory

- Create `.squirrels/` in the target repo.
- Fetch `squirrels/templates/charter.md` and save it as `.squirrels/_charter.template.md`.
- Add `.squirrels/stash/` to the target's `.gitignore` (create the file if needed; do not duplicate the line).

## 5. Install the verify script

Fetch `scripts/sq-verify.sh` to `<target>/scripts/sq-verify.sh` and make it executable. If the target has CI, offer (do not force) a step that runs `bash scripts/sq-verify.sh .squirrels`.

## 6. Inject the instructions snippet

Append the contents of `claude/snippet.md` to the target's `CLAUDE.md` under a "Working with squirrels" heading. If `CLAUDE.md` does not exist, propose creating one. If the section already exists, update it in place rather than duplicating it.

## 7. Summarize and stop

Print: which files were created or changed, which `[BOOTSTRAP: ...]` values you chose, and whether the base `eg-*` workflow was found. Remind the user to restart the Claude Code session so `/sq-` autocomplete refreshes. **Do not commit.**
