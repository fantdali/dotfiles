# dotfiles

Personal development environment configs for macOS and Linux.

## What's included

| Tool                | Stow package | Config                            |
| ------------------- | ------------ | --------------------------------- |
| **zsh** + oh-my-zsh | `shell`      | `.zshrc`                          |
| **Neovim**          | `nvim`       | `.config/nvim/`                   |
| **tmux** + TPM      | `tmux`       | `.tmux.conf`                      |
| **WezTerm**         | `wezterm`    | `.wezterm.lua`                    |
| **Git**             | `gitconfig`  | `.gitconfig`, `git/templates/`    |
| **yabai** (macOS)   | `yabai`      | `.config/yabai/yabairc`           |
| **skhd** (macOS)    | `skhd`       | `.config/skhd/skhdrc`             |
| **VS Code**         | —            | `vscode/` (manual profile import) |
| **Raycast**         | —            | `raycast.rayconfig` (manual)      |

### CLI tools installed

fzf, fd, bat, eza, zoxide, thefuck, lazygit, ripgrep, kubectl, kubectx/kubens, Go, Node, Python3

## Quick start

```bash
# 1. Clone the repo
git clone https://github.com/<you>/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Run full setup (install tools + stow configs + configure OS)
./install.sh
```

## Selective setup

```bash
./install.sh packages   # Install tools only
./install.sh link       # Stow all config symlinks
./install.sh unlink     # Remove all stow symlinks
./install.sh macos      # macOS defaults + yabai/skhd services only
```

Or via Make:

```bash
make link               # Stow configs
make unlink             # Remove stow symlinks
make packages           # Install tools
make macos              # macOS setup
make install            # Full setup
```

## How it works

Each top-level directory (e.g. `shell/`, `nvim/`, `tmux/`) is a **stow package** — its contents mirror the `$HOME` directory structure.  
Running `stow shell` creates `~/.zshrc` → `dotfiles/shell/.zshrc`, etc.

1. **Installs packages** — Homebrew (macOS/Linux), all CLI tools, language runtimes, fonts, stow
2. **Stows configs** — `stow --restow <package>` for each package, creating symlinks into `$HOME`
3. **Sets up the shell** — zsh as default, oh-my-zsh with plugins (autosuggestions, syntax-highlighting, vi-mode, kube-ps1)
4. **macOS setup** (macOS only) — configures system defaults (key repeat, Finder settings, Dock), starts yabai/skhd services

## Post-install steps

1. Restart your terminal (or `exec zsh`)
2. Open tmux and press `Ctrl-a + I` to install tmux plugins
3. Open nvim — Lazy will auto-install plugins on first launch
4. (macOS) Grant accessibility permissions to **yabai** and **skhd** in System Settings → Privacy & Security
5. (macOS) Import `raycast.rayconfig` in Raycast settings

## Structure

```
dotfiles/
├── install.sh              # Main entrypoint
├── Makefile                # Convenience targets
├── scripts/
│   ├── utils.sh            # Shared helpers (OS detection, colors)
│   ├── packages.sh         # Package installation (brew/apt)
│   └── macos.sh            # macOS defaults & services
│
│  # --- stow packages (each mirrors $HOME) ---
├── shell/
│   └── .zshrc
├── tmux/
│   └── .tmux.conf
├── wezterm/
│   └── .wezterm.lua
├── nvim/
│   └── .config/nvim/       # Neovim (Lazy + lua/dali/)
├── gitconfig/
│   ├── .gitconfig           # Git config with conditional includes
│   └── git/templates/hooks/ # Git hooks (prepare-commit-msg)
├── yabai/
│   └── .config/yabai/      # yabai WM config (macOS)
├── skhd/
│   └── .config/skhd/       # skhd hotkeys (macOS)
│
├── vscode/                 # VS Code profile export (manual)
└── raycast.rayconfig       # Raycast config (manual)
```

## Adding new configs

1. Create a new stow package directory: `mkdir -p <name>/<path matching $HOME>`
2. Put the config file inside it (e.g. `foo/.config/foo/config.toml`)
3. Add the package name to `STOW_PACKAGES` in `install.sh` and `Makefile`
4. If the tool needs installing, add it to the lists in `scripts/packages.sh`
5. Run `make link` to activate
