---
name: worktrunk
description: Use and configure Worktrunk (`wt`) without treating every task as a new worktree. Load for checkout/worktree decisions, `wt` commands, .config/wt.toml or ~/.config/worktrunk/config.toml, hooks, aliases, commit generation, and Worktrunk troubleshooting.
license: MIT OR Apache-2.0
---

# Worktrunk

Worktrunk manages worktrees; it does not make a worktree the unit of every change.

## Decide whether a worktree is needed

Start with `git status --short --branch` and `wt list`.

Reuse the current worktree when the work belongs to the same logical project or task, including:

- a small fix or follow-up;
- another commit on the current branch;
- a new branch that can replace the current checkout;
- sequential work that does not need two branches checked out at once.

A commit boundary is not a worktree boundary. When a new branch is useful but a parallel checkout is not, use normal Git in the current directory:

```bash
git switch -c dlifantev/<ticket-lower>-<short-slug>
```

Create or switch to another worktree only when:

- the user explicitly asks for one;
- independent work must proceed in parallel;
- another worktree already owns the required branch;
- switching the current checkout would conflict with or contaminate ongoing work;
- the task genuinely benefits from filesystem isolation.

Never move or discard dirty work merely to simplify checkout state. Do not create a new worktree just because the request contains “fix,” “change,” or “implement.”

## Core commands

```bash
wt list                         # worktrees and branch state
wt switch <branch>              # enter an existing branch/worktree
wt switch --create <branch>     # create a branch plus worktree
wt switch -                     # previous worktree
wt remove <branch>              # remove a worktree
wt config show                  # resolved configuration
```

Use `wt <command> --help` for the installed version's exact flags.

## Configuration

- `~/.config/worktrunk/config.toml` is personal configuration: worktree paths, command defaults, personal hooks, and commit generation.
- `<repo>/.config/wt.toml` is versioned project automation shared with the team.

Preserve existing comments and unrelated settings. Derive project hook commands from the repository and run them directly before adding them. Independent commands can share one hook table; dependent commands use an ordered array of tables.

Common hook choices:

- dependency or environment setup: `pre-start`;
- background build or dev server: `post-start`;
- formatting and linting: `pre-commit`;
- required tests: `pre-merge`;
- notifications or deployment: `post-commit` / `post-merge`;
- terminal or IDE integration: `post-switch`;
- cleanup: `pre-remove` / `post-remove`.

Worktrunk may require approval before executing repository-provided hooks. Inspect the rendered commands. If the user has authorized those exact hooks, proceed using the available approval mechanism; otherwise surface the commands for their decision.

## References

Load only the relevant file:

- [config.md](reference/config.md): user/project config and path templates
- [switch.md](reference/switch.md), [list.md](reference/list.md), [merge.md](reference/merge.md), [remove.md](reference/remove.md): commands
- [hook.md](reference/hook.md): lifecycle hooks
- [llm-commits.md](reference/llm-commits.md): generated commit messages
- [extending.md](reference/extending.md): aliases and pipelines
- [shell-integration.md](reference/shell-integration.md), [troubleshooting.md](reference/troubleshooting.md): diagnosis
- [tips-patterns.md](reference/tips-patterns.md): parallel agents and advanced layouts

Only create agent handoff worktrees when the user explicitly requests parallel or delegated work.
