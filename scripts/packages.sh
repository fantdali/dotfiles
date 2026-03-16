#!/usr/bin/env bash
# Package installation for macOS and Linux
# Installs all tools needed for the development environment

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# ==============================================================================
# Package managers
# ==============================================================================

install_homebrew() {
    if has brew; then
        info "Homebrew already installed"
        return
    fi
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to path for current session
    if [[ "$OS" == "macos" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    success "Homebrew installed"
}

ensure_apt_updated() {
    if [[ "${_APT_UPDATED:-}" != "1" ]]; then
        info "Updating apt package list..."
        sudo apt-get update -qq
        _APT_UPDATED=1
    fi
}

# ==============================================================================
# Core packages (both platforms)
# ==============================================================================

BREW_PACKAGES=(
    stow
    neovim
    tmux
    fzf
    fd
    bat
    eza
    zoxide
    thefuck
    lazygit
    ripgrep
    git
    curl
    wget
    jq
    tree
    go
    node
    python3
)

APT_PACKAGES=(
    stow
    git
    curl
    wget
    jq
    tree
    tmux
    python3
    python3-pip
    build-essential
    unzip
    fontconfig
)

# Packages only installable via brew (even on Linux)
BREW_ONLY_PACKAGES=(
    neovim
    fzf
    fd
    bat
    eza
    zoxide
    thefuck
    lazygit
    ripgrep
    go
    node
)

BREW_CASKS_MACOS=(
    wezterm
    font-meslo-lg-nerd-font
    raycast
)

BREW_MACOS_ONLY=(
    yabai
    skhd
    kubectl
    kubectx
    gnu-sed
    grep
    findutils
)

# ==============================================================================
# Install functions
# ==============================================================================

install_packages_macos() {
    info "Installing macOS packages via Homebrew..."
    brew install "${BREW_PACKAGES[@]}" 2>/dev/null || true

    info "Installing macOS-only packages..."
    brew install "${BREW_MACOS_ONLY[@]}" 2>/dev/null || true

    info "Installing casks..."
    brew install --cask "${BREW_CASKS_MACOS[@]}" 2>/dev/null || true

    success "macOS packages installed"
}

install_packages_linux() {
    local distro
    distro="$(detect_distro)"

    case "$distro" in
        debian)
            ensure_apt_updated
            info "Installing base apt packages..."
            sudo apt-get install -y -qq "${APT_PACKAGES[@]}"
            ;;
        fedora)
            info "Installing base dnf packages..."
            sudo dnf install -y "${APT_PACKAGES[@]}" 2>/dev/null || true
            ;;
        arch)
            info "Installing base pacman packages..."
            sudo pacman -S --noconfirm --needed "${APT_PACKAGES[@]}" 2>/dev/null || true
            ;;
        *)
            warn "Unknown distro '$distro', attempting apt..."
            ensure_apt_updated
            sudo apt-get install -y -qq "${APT_PACKAGES[@]}" || true
            ;;
    esac

    # Install Homebrew on Linux for tools not in distro repos
    install_homebrew
    info "Installing brew-only packages on Linux..."
    brew install "${BREW_ONLY_PACKAGES[@]}" 2>/dev/null || true

    # kubectl
    if ! has kubectl; then
        info "Installing kubectl..."
        curl -fsSL "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /tmp/kubectl
        sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
        rm -f /tmp/kubectl
    fi

    # kubectx/kubens
    if ! has kubectx; then
        info "Installing kubectx/kubens..."
        brew install kubectx 2>/dev/null || true
    fi

    success "Linux packages installed"
}

# ==============================================================================
# Shell setup
# ==============================================================================

install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        info "oh-my-zsh already installed"
    else
        info "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "oh-my-zsh installed"
    fi

    # Install zsh plugins
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    success "oh-my-zsh plugins ready"
}

install_kube_ps1_plugin() {
    local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/kube-ps1"
    if [[ -d "$plugin_dir" ]]; then
        info "kube-ps1 plugin already installed"
        return
    fi
    info "Installing kube-ps1 oh-my-zsh plugin..."
    git clone https://github.com/jonmosco/kube-ps1 "$plugin_dir"
    success "kube-ps1 plugin installed"
}

install_zsh_if_needed() {
    if has zsh; then
        info "zsh already installed"
        return
    fi
    info "Installing zsh..."
    if [[ "$OS" == "macos" ]]; then
        brew install zsh
    else
        local distro
        distro="$(detect_distro)"
        case "$distro" in
            debian)
                ensure_apt_updated
                sudo apt-get install -y -qq zsh
                ;;
            fedora) sudo dnf install -y zsh ;;
            arch)   sudo pacman -S --noconfirm --needed zsh ;;
        esac
    fi
    success "zsh installed"
}

set_default_shell_zsh() {
    if [[ "$SHELL" == *"zsh"* ]]; then
        info "Default shell is already zsh"
        return
    fi
    info "Setting default shell to zsh..."
    local zsh_path
    zsh_path="$(command -v zsh)"
    if ! grep -qF "$zsh_path" /etc/shells 2>/dev/null; then
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    fi
    sudo chsh -s "$zsh_path" "$USER" 2>/dev/null || chsh -s "$zsh_path" || warn "Could not change shell. Run: chsh -s $zsh_path"
    success "Default shell set to zsh"
}

# ==============================================================================
# Tmux plugin manager
# ==============================================================================

install_tpm() {
    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        info "TPM already installed"
        return
    fi
    info "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    success "TPM installed — run 'prefix + I' inside tmux to install plugins"
}

# ==============================================================================
# Main
# ==============================================================================

install_all() {
    info "========================================="
    info " Installing packages for ${BOLD}${OS}${NC}"
    info "========================================="

    # Package manager & packages
    if [[ "$OS" == "macos" ]]; then
        install_homebrew
        install_packages_macos
    else
        install_packages_linux
    fi

    # Shell
    install_zsh_if_needed
    set_default_shell_zsh
    install_oh_my_zsh
    install_kube_ps1_plugin

    # Tmux
    install_tpm

    success "========================================="
    success " All packages installed!"
    success "========================================="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_all
fi
