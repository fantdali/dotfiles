#!/usr/bin/env bash
#
# install.sh — Bootstrap a fresh macOS or Linux machine
#
# Usage:
#   git clone https://github.com/<you>/dotfiles.git ~/dotfiles
#   cd ~/dotfiles
#   ./install.sh          # full install (packages + stow + OS setup)
#   ./install.sh link     # only stow symlinks
#   ./install.sh unlink   # remove stow symlinks
#   ./install.sh packages # only install packages
#   ./install.sh macos    # only run macOS-specific setup
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

# Stow packages — shared across all platforms
STOW_PACKAGES=(shell tmux wezterm nvim gitconfig)

# macOS-only stow packages
STOW_PACKAGES_MACOS=(yabai skhd)

usage() {
    cat <<EOF
Usage: ./install.sh [command]

Commands:
  (no args)   Run full setup (packages + stow + OS config)
  packages    Install packages and tools only
  link        Stow all config symlinks
  unlink      Remove all stow symlinks
  macos       Run macOS-specific setup only (macOS only)

EOF
}

# ==============================================================================
# Stow helpers
# ==============================================================================

stow_packages() {
    local packages=("${STOW_PACKAGES[@]}")

    if [[ "$OS" == "macos" ]]; then
        packages+=("${STOW_PACKAGES_MACOS[@]}")
    fi

    info "========================================="
    info " Stowing configs → \$HOME"
    info "========================================="

    # Clean up any stale/absolute symlinks from a previous dotfiles setup
    # that would conflict with stow. Only removes symlinks pointing into
    # this dotfiles dir.
    for pkg in "${packages[@]}"; do
        if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
            while IFS= read -r -d '' rel_path; do
                local target="$HOME/$rel_path"
                if [[ -L "$target" ]]; then
                    local link_dest
                    link_dest="$(readlink "$target")"
                    if [[ "$link_dest" == "$DOTFILES_DIR"* ]]; then
                        rm "$target"
                        info "Removed stale symlink: $target"
                    fi
                fi
            done < <(cd "$DOTFILES_DIR/$pkg" && find . -mindepth 1 \( -type f -o -type l \) -print0 | sed -z 's|^\./||')
        fi
    done

    for pkg in "${packages[@]}"; do
        if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
            # --adopt moves conflicting existing files into the package dir,
            # then we restore repo contents with git to keep ours.
            stow -d "$DOTFILES_DIR" -t "$HOME" --adopt --restow "$pkg"
            success "Stowed: $pkg"
        else
            warn "Package directory not found, skipping: $pkg"
        fi
    done

    # Restore repo state in case --adopt pulled in differing files
    git -C "$DOTFILES_DIR" checkout -- . 2>/dev/null || true

    success "========================================="
    success " All configs stowed!"
    success "========================================="
}

unstow_packages() {
    local packages=("${STOW_PACKAGES[@]}" "${STOW_PACKAGES_MACOS[@]}")

    info "Removing stow symlinks..."

    for pkg in "${packages[@]}"; do
        if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
            stow -d "$DOTFILES_DIR" -t "$HOME" -D "$pkg" 2>/dev/null && \
                success "Unstowed: $pkg" || true
        fi
    done

    success "All stow symlinks removed"
}

# ==============================================================================
# Full install
# ==============================================================================

full_install() {
    echo ""
    info "========================================="
    info "  ${BOLD}Dotfiles Setup${NC}"
    info "  OS: $OS"
    info "========================================="
    echo ""

    # 1. Install all packages and tools
    source "$SCRIPT_DIR/scripts/packages.sh"
    install_all

    echo ""

    # 2. Stow configs
    stow_packages

    echo ""

    # 3. OS-specific setup
    if [[ "$OS" == "macos" ]]; then
        source "$SCRIPT_DIR/scripts/macos.sh"
        setup_macos
    fi

    echo ""
    success "========================================="
    success "  Setup complete!"
    success "========================================="
    echo ""
    info "Next steps:"
    info "  1. Restart your terminal (or run: exec zsh)"
    info "  2. Open tmux and press ${BOLD}prefix + I${NC} to install tmux plugins"
    info "  3. Open nvim — Lazy will auto-install plugins on first launch"
    if [[ "$OS" == "macos" ]]; then
        info "  4. Grant accessibility permissions to yabai and skhd in System Settings"
        info "  5. Import raycast.rayconfig in Raycast settings"
    fi
    echo ""
}

# ==============================================================================
# Entrypoint
# ==============================================================================

case "${1:-}" in
    packages)
        source "$SCRIPT_DIR/scripts/packages.sh"
        install_all
        ;;
    link)
        stow_packages
        ;;
    unlink)
        unstow_packages
        ;;
    macos)
        source "$SCRIPT_DIR/scripts/macos.sh"
        setup_macos
        ;;
    help|--help|-h)
        usage
        ;;
    "")
        full_install
        ;;
    *)
        error "Unknown command: $1"
        usage
        exit 1
        ;;
esac
