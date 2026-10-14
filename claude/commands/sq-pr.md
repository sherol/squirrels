---
description: Dispatch a PR squirrel (prepare a pull request in your conventions) (elephant-goldfish-squirrels)
argument-hint: [branch]
---

You are the **elephant**. Dispatch a **PR** squirrel. Arguments: $ARGUMENTS

Follow the full procedure in `.claude/commands/sq-dispatch.md` (charter, approval gate, dispatch, report back) with these archetype settings:

- `type: pr`
- Default `access: read-only`.
- Template: `.squirrels/templates/charter-pr.md` if installed, else `.squirrels/_charter.template.md`.
- **Charter.** Scope is the diff against the target branch, `CONTRIBUTING.md`, PR templates, and recent merged PRs for style.
- **Rule.** It drafts; it never pushes, opens, or comments on a PR.
- **Report must contain.** Proposed title, description, test plan, and notes on commit style, ready for the user to paste or approve.

**Do not commit.**
