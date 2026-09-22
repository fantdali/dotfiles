# AI engineer kit

This is a small dotfiles-managed layer shared by Codex, Claude Code, Pi, and OpenCode:

- one `WORKSTYLE.md` with personal engineering conventions;
- focused skills that load only when their task matches;
- optional Codex memory configuration.

It does not add command policies, shell hooks, infrastructure accounts, RBAC, or custom approval profiles. Use each agent's native session permissions.

## Install

```bash
./ai-engineer-kit/install.sh --dry-run
./ai-engineer-kit/install.sh
```

The installer links the skills into each supported agent and renders the active workstyle outside the repository at `~/.local/state/ai-engineer-kit/WORKSTYLE.md`. Existing files are moved to timestamped backups before a link replaces them.

### Private local conventions

Keep employer, client, cluster, internal ticket, and private knowledge-base conventions in:

```text
~/.config/ai-engineer-kit-local/WORKSTYLE.md
```

When present, the installer appends that file to the public `WORKSTYLE.md` while rendering the active workstyle. The private file is outside the repository, so it cannot be committed accidentally. Run the installer again after changing it.

## Development and worktrees

Start in the repository you want to change. The agent reuses that checkout by default, including for another commit or a new sequential branch.

Worktrunk is for a genuinely separate checkout:

```bash
wt list
wt switch --create user/abc-123-short-slug
```

Use one when you want parallel work, a branch is already checked out elsewhere, or you explicitly want isolation. It is not required for every edit.

## Live infrastructure sessions

Put the operating mode and boundary at the start of the prompt:

```text
Infra mode: autonomous
Boundary: context=lab, namespace=sandbox, hosts=lab-node-01
Goal: reproduce and fix the CNI failure
Stop if: another namespace or shared node would be affected
```

Available modes are `suggest-only`, `observe`, `careful-change`, and `autonomous`. In `careful-change`, approve a concrete mutation or coherent batch once. In `autonomous`, the agent iterates inside the named boundary without asking on every command.

Use native agent controls to match the mode:

| Intent | Codex | Claude Code |
| --- | --- | --- |
| Suggest or plan only | Chat/read-only | `claude --permission-mode plan` |
| Observe | `/permissions` -> read-only | Plan or Manual |
| Careful changes | Ask for approval | `claude --permission-mode default` |
| Autonomous experiment | Approve for me; Full access only if needed | `claude --permission-mode auto` |

Codex's `Approve for me` uses automatic review for actions that cross the sandbox boundary. `Full access` removes the sandbox and approval prompts. Claude's Auto mode uses its classifier instead of prompting for routine actions. In Claude CLI, `Shift+Tab` cycles the available modes.

The prompt's boundary remains important: native permissions decide whether an action can run without a human prompt; they do not know which cluster, namespace, or host you intended.

## Skills

Skills are task-specific playbooks, not always-on policy. Keep the set small enough to understand, and remove a skill when its trigger or instructions no longer add value. The two local workflow skills are:

- `worktrunk`: decide whether to reuse or create a checkout, then use/configure `wt`;
- `safe-infra-investigation`: select an infra session mode and work within its target boundary.
