# Gemini CLI bootstrap: squirrels

You are installing the **squirrel layer** into the current repo for Gemini CLI. It extends the elephant-goldfish workflow and must never replace or break it. Follow these steps in order. Do not commit anything.

The skills are installed as **workspace skills** under `.gemini/skills/` (`sq-dispatch`, `sq-coordinate`, `sq-status`, `sq-recall`, `sq-stand-down`) and described in a "Working with squirrels" section of `GEMINI.md`. Archetypes go through `sq-dispatch`, for example "sq-dispatch review: prior art for stash-based caching".

## 1. Check the base workflow

Look for upstream elephant-goldfish skills (`eg-*`) in `.gemini/skills/`.

- If present, continue.
- If absent, tell the user the squirrel layer builds on elephant-goldfish and ask whether to install it first. If yes, fetch and follow upstream's Gemini procedure:
  `gh api repos/vshvedov/elephant-goldfish/contents/gemini/BOOTSTRAP.md -H 'Accept: application/vnd.github.raw'`
  If no, continue, and say that the `eg-*` skills referenced in the docs will not exist.

## 2. Fetch the source

```
src=$(mktemp -d)
git clone --depth 1 https://github.com/sherol/squirrels "$src"
```

## 3. Install the skills

For each directory in `"$src/skills/"`: if `.gemini/skills/<name>` already exists, show the user a diff and ask before overwriting. Never touch `eg-*` skills. Then copy it to `.gemini/skills/<name>`.

Bundle the templates and validator with `sq-dispatch`, which the other skills reference:

```
mkdir -p .gemini/skills/sq-dispatch/templates .gemini/skills/sq-dispatch/scripts
cp "$src"/squirrels/templates/*.md .gemini/skills/sq-dispatch/templates/
cp "$src/scripts/sq-charter.sh" .gemini/skills/sq-dispatch/scripts/
chmod +x .gemini/skills/sq-dispatch/scripts/sq-charter.sh
```

## 4. Create the inventory and validator

- Create `.squirrels/` and add `.squirrels/stash/` to `.gitignore` (create the file if needed; do not duplicate the line).
- Copy `"$src/scripts/sq-charter.sh"` to `scripts/sq-charter.sh` and make it executable. If the repo has CI, offer (do not force) a step that runs `bash scripts/sq-charter.sh .squirrels`.

## 5. Inject the instructions snippet

Append `"$src/claude/snippet.md"` to the repo's `GEMINI.md` under a "Working with squirrels" heading, replacing `/sq-` command names with the skill names above and `CLAUDE.md` with `GEMINI.md`. If `GEMINI.md` does not exist, propose creating it. If the section already exists, update it in place rather than duplicating it.

## 6. Summarize and stop

Remove `"$src"`. Print which files were created or changed and whether the base `eg-*` workflow was found. Tell the user to restart Gemini CLI (or run `/skills reload` in an interactive session) and check that the `sq-*` skills appear in its skills list; if workspace skills are not loaded, they may need enabling in the Gemini CLI settings. **Do not commit.**
