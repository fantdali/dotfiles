# dotfiles

Personal development environment for macOS and Linux, managed with [chezmoi](https://chezmoi.io).

## What's included

| Tool                | Config                         |
| ------------------- | ------------------------------ |
| **zsh** + oh-my-zsh | `.zshrc` (templated per OS)    |
| **Neovim**          | `.config/nvim/`                |
| **tmux** + TPM      | `.tmux.conf`                   |
| **WezTerm**         | `.wezterm.lua`                 |
| **Git**             | `.gitconfig`, `git/templates/` |
| **yabai** (macOS)   | `.config/yabai/yabairc`        |
| **skhd** (macOS)    | `.config/skhd/skhdrc`          |
| **VS Code**         | `vscode/` (manual import)      |
| **Raycast**         | `raycast.rayconfig` (manual)   |

### CLI tools installed

fzf, fd, bat, eza, zoxide, thefuck, lazygit, ripgrep, kubectl, kubectx/kubens, Go, Node, Python3

## Quick start

**One-liner from a fresh machine** (installs chezmoi + applies everything):

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <github-username>
```

**Or clone first:**

```bash
git clone https://github.com/<you>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Day-to-day usage

```bash
chezmoi edit ~/.zshrc        # Edit a managed file
chezmoi diff                 # Preview changes before applying
chezmoi apply                # Apply changes to $HOME
chezmoi update               # Pull latest from repo + apply
chezmoi add ~/.config/foo    # Add a new config to management
chezmoi cd                   # cd into the source directory
```

## How it works

This repo is a [chezmoi source directory](https://chezmoi.io/reference/concepts/). On `chezmoi apply`:

1. **`run_once_install-packages.sh.tmpl`** — installs Homebrew, all CLI tools, zsh + oh-my-zsh + plugins, TPM, fonts (runs once per machine, re-runs if script content changes)
2. **Configs are applied** — chezmoi copies templated/exact files into `$HOME` (`dot_zshrc.tmpl` → `~/.zshrc`, `dot_config/nvim/` → `~/.config/nvim/`, etc.)
3. **`run_once_after_configure-macos.sh.tmpl`** — (macOS only) sets system defaults, starts yabai/skhd services

### Templating

`.zshrc` is templated (`dot_zshrc.tmpl`) — it conditionally sets the Homebrew path and macOS-specific PATH/flags based on the OS:

```
{{- if eq .chezmoi.os "darwin" }}
eval "$(/opt/homebrew/bin/brew shellenv)"
{{- else }}
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
{{- end }}
```

yabai/skhd configs are automatically skipped on Linux via `.chezmoiignore`.

## Post-install steps

1. Restart your terminal (or `exec zsh`)
2. Open tmux and press `Ctrl-a + I` to install tmux plugins
3. Open nvim — Lazy will auto-install plugins on first launch
4. (macOS) Grant accessibility permissions to **yabai** and **skhd** in System Settings → Privacy & Security
5. (macOS) Import `raycast.rayconfig` in Raycast settings

## Structure

```
dotfiles/                              (chezmoi source directory)
├── .chezmoi.yaml.tmpl                 # chezmoi config (prompts for email, etc.)
├── .chezmoiignore                     # skip yabai/skhd on Linux
├── install.sh                         # bootstrap: installs chezmoi + applies
│
├── run_once_install-packages.sh.tmpl  # package installation (brew/apt/zsh/tpm)
├── run_once_after_configure-macos.sh.tmpl  # macOS defaults + services
│
├── dot_zshrc.tmpl                     # .zshrc (templated for OS)
├── dot_tmux.conf                      # .tmux.conf
├── dot_wezterm.lua                    # .wezterm.lua
├── dot_gitconfig                      # .gitconfig
├── dot_config/
│   ├── nvim/                          # Neovim (Lazy + lua/dali/)
│   ├── skhd/skhdrc                    # skhd hotkeys (macOS)
│   └── yabai/yabairc                  # yabai WM config (macOS)
├── exact_git/exact_templates/hooks/   # Git hooks (prepare-commit-msg)
│
├── vscode/                            # VS Code profile export (manual)
└── raycast.rayconfig                  # Raycast config (manual)
```

## Adding new configs

```bash
# Add an existing file to chezmoi management
chezmoi add ~/.config/foo/config.toml

# Or for a templated file
chezmoi add --template ~/.config/bar/settings.conf
```

The file appears in the source directory with chezmoi naming, and will be managed on future `chezmoi apply` runs.
