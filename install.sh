#!/usr/bin/env bash
#
# Bootstrap script — installs chezmoi and applies dotfiles.
#
# Fresh machine one-liner (from GitHub):
#   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <github-username>
#
# Or clone first, then:
#   git clone https://github.com/<you>/dotfiles.git ~/dotfiles
#   cd ~/dotfiles && ./install.sh
#

set -euo pipefail

# Install chezmoi if not present
if ! command -v chezmoi &>/dev/null; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEZMOI_SOURCE="$HOME/.local/share/chezmoi"

if [[ -f "$SCRIPT_DIR/.chezmoi.yaml.tmpl" ]]; then
    # Running from a local clone — symlink it as chezmoi's source dir
    if [[ -e "$CHEZMOI_SOURCE" ]] && [[ ! -L "$CHEZMOI_SOURCE" ]]; then
        echo "Backing up existing chezmoi source to ${CHEZMOI_SOURCE}.bak"
        mv "$CHEZMOI_SOURCE" "${CHEZMOI_SOURCE}.bak"
    fi
    mkdir -p "$(dirname "$CHEZMOI_SOURCE")"
    ln -sfn "$SCRIPT_DIR" "$CHEZMOI_SOURCE"
    chezmoi init --apply
else
    echo "Error: Run this from the dotfiles repo root, or use:"
    echo "  sh -c \"\$(curl -fsLS get.chezmoi.io)\" -- init --apply <github-username>"
    exit 1
fi
