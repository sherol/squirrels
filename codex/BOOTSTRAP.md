# Codex bootstrap: squirrels

You are installing the **squirrel layer** for Codex. It extends the elephant-goldfish workflow and must never replace or break it. Follow these steps in order. Do not commit anything.

The skills are installed **once per user** into `${CODEX_HOME:-~/.codex}/skills/` and invoked as `$sq-dispatch`, `$sq-coordinate`, `$sq-status`, `$sq-recall`, and `$sq-stand-down`. They inspect the current repo at runtime (verification commands, `.squirrels/`) instead of being rewritten per project. Archetypes go through `$sq-dispatch`, for example `$sq-dispatch review: prior art for stash-based caching`.

## 1. Check the base workflow

Look for upstream elephant-goldfish skills (`eg-*`) in `${CODEX_HOME:-~/.codex}/skills/`.

- If present, continue.
- If absent, tell the user the squirrel layer builds on elephant-goldfish and ask whether to install it first. If yes, fetch and follow upstream's Codex procedure:
  `gh api repos/vshvedov/elephant-goldfish/contents/codex/BOOTSTRAP.md -H 'Accept: application/vnd.github.raw'`
  If no, continue, and say that the `eg-*` skills referenced in the docs will not exist.

## 2. Fetch the source

```
src=$(mktemp -d)
git clone --depth 1 https://github.com/sherol/squirrels "$src"
```

## 3. Install the skills

```
dest="${CODEX_HOME:-$HOME/.codex}/skills"
```

For each directory in `"$src/skills/"` (`sq-dispatch`, `sq-coordinate`, `sq-status`, `sq-recall`, `sq-stand-down`): if `"$dest/<name>"` already exists, show the user a diff and ask before overwriting. Never touch `eg-*` skills. Then copy it to `"$dest/<name>"`.

Bundle the templates and validator with `sq-dispatch`, which the other skills reference:

```
mkdir -p "$dest/sq-dispatch/templates" "$dest/sq-dispatch/scripts"
cp "$src"/squirrels/templates/*.md "$dest/sq-dispatch/templates/"
cp "$src/scripts/sq-charter.sh" "$dest/sq-dispatch/scripts/"
chmod +x "$dest/sq-dispatch/scripts/sq-charter.sh"
```

## 4. Optional: wire up the current repo

Only if the user is in a repo they want to set up now (the skills otherwise do this on first dispatch):

- Create `.squirrels/` and add `.squirrels/stash/` to `.gitignore` (do not duplicate the line).
- Offer (do not force) to copy `scripts/sq-charter.sh` into the repo and add a CI step that runs `bash scripts/sq-charter.sh .squirrels`.
- Offer to append a short "Working with squirrels" section to the repo's `AGENTS.md` (create it only if the user agrees; update it in place if it already exists), adapted from `claude/snippet.md` with `$sq-` skill names instead of `/sq-` commands.

## 5. Summarize and stop

Remove `"$src"`. Print which skills were installed or updated, whether the base `eg-*` workflow was found, and what was changed in the current repo, if anything. Remind the user to restart Codex so the new skills load. **Do not commit.**
