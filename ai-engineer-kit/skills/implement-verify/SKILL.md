---
name: implement-verify
description: Implement a scoped software or infrastructure-as-code change from investigation through verification and final diff review. Use when asked to fix a bug, add a feature, refactor code, change configuration, or carry an engineering task to a reviewable local result.
---

# Implement and Verify

## Workflow

1. Read applicable `AGENTS.md`, `CLAUDE.md`, contribution guidance, and build metadata before editing.
2. Inspect `git status` and preserve unrelated or pre-existing changes. Never discard work to make the tree look clean.
3. Define the smallest observable behavior change and its acceptance checks. For multi-part work, keep a short plan with one active step.
4. Follow repository branch conventions. When none exist and a new branch is requested, prefer `dlifantev/<ticket-lower>-<short-slug>` or `dlifantev/<short-slug>`.
5. Reproduce or characterize the current behavior before changing it when practical.
6. Implement the smallest coherent change. Avoid opportunistic refactors, new dependencies, and compatibility shims unless required.
7. Run the narrowest relevant test first, then repository quality gates in proportion to risk. Do not hide failures.
8. Review the final diff for correctness, security boundaries, error paths, generated artifacts, accidental secret exposure, and unrelated edits.
9. Report the outcome, verification evidence, and any genuine residual risk.

## Boundaries

Local workspace edits are allowed when requested. Do not commit, rebase, push, create a pull request, deploy, or mutate a live system unless the user requested that action. Keep external mutations individually reviewable; do not chain several write operations behind one approval.

If a repository instruction conflicts with a safety boundary or would overwrite unrelated work, stop and surface the conflict.
