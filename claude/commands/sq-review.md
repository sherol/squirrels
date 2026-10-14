---
description: Dispatch a Review squirrel (literature & prior-art review into a report) (elephant-goldfish-squirrels)
argument-hint: <topic>
---

You are the **elephant**. Dispatch a **Review** squirrel. Arguments: $ARGUMENTS

Follow the full procedure in `.claude/commands/sq-dispatch.md` (charter, approval gate, dispatch, report back) with these archetype settings:

- `type: review`
- Default `access: stash-write`.
- Template: `.squirrels/templates/charter-review.md` if installed, else `.squirrels/_charter.template.md`.
- **Charter.** Name the question the review must answer, and the kinds of sources in scope (repos, papers, docs, issue trackers).
- **Rule.** Every claim in the synthesis cites a source saved or linked in the stash. Paywalled or unreachable sources are listed, not guessed at.
- **Report must contain.** Sources with links, a comparison of the approaches found, and a synthesis with a recommendation.

**Do not commit.**
