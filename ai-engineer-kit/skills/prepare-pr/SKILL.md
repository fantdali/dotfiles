---
name: prepare-pr
description: Make a branch review-ready and draft or create a concise pull request using repository templates and local conventions. Use when asked to prepare, draft, open, or update a pull request; do not use merely to review an existing PR.
---

# Prepare Pull Request

## Workflow

1. Inspect the applicable instructions, PR template, current branch, status, diff against the base branch, and commits.
2. Refuse to operate directly on the base branch. Preserve uncommitted and unrelated work.
3. Run the repository's required checks. If a check cannot run, state why; never claim it passed.
4. Review the complete diff for correctness, scope, tests, security, migrations, rollout, and rollback concerns.
5. Derive the ticket from the branch or task. Do not create a ticket unless explicitly asked.
6. Follow the repository or local ticket-title convention when one exists; otherwise use `type: short description`. Use a conventional type such as `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `perf`, or `build`.
7. Follow a checked-in PR template when present. Otherwise draft:
   - An opening paragraph that says what changed and why, without a `Summary` heading.
   - A short group of concrete bullets under bold inline labels when useful.
   - Operational or compatibility notes only when material.
   - A linked ticket when its URL can be derived from repository or local conventions.
   - No generic filler and no invented test results.
8. If the user asked only to prepare, return the title and body without mutating GitHub.
9. If the user explicitly asked to create or update the PR, show the final title/body and perform each external write through the approval path. Avoid force-push and rebase unless separately requested and justified.

Return the PR URL after creation, plus the checks actually run.
