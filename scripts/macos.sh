#!/usr/bin/env bash
# macOS-specific system preferences and service setup

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

if [[ "$OS" != "macos" ]]; then
    error "This script is macOS-only"
    exit 1
fi

# ==============================================================================
# macOS defaults
# ==============================================================================

configure_macos_defaults() {
    info "Configuring macOS defaults..."

    # Finder: show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Finder: show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Finder: show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Finder: show status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable smart quotes and dashes
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Dock: auto-hide
    defaults write com.apple.dock autohide -bool true

    # Dock: minimize animation
    defaults write com.apple.dock mineffect -string "scale"

    # Dock: don't show recent applications
    defaults write com.apple.dock show-recents -bool false

    # Mission Control: don't automatically rearrange Spaces
    defaults write com.apple.dock mru-spaces -bool false

    # Trackpad: enable tap to click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

    success "macOS defaults configured"
    warn "Some changes require a logout/restart to take effect"
}

# ==============================================================================
# yabai & skhd services
# ==============================================================================

start_wm_services() {
    info "Starting yabai and skhd services..."

    if has yabai; then
        yabai --start-service 2>/dev/null || brew services start yabai 2>/dev/null || true
        success "yabai service started"
    else
        warn "yabai not found, skipping"
    fi

    if has skhd; then
        skhd --start-service 2>/dev/null || brew services start skhd 2>/dev/null || true
        success "skhd service started"
    else
        warn "skhd not found, skipping"
    fi
}

# ==============================================================================
# Main
# ==============================================================================

setup_macos() {
    info "========================================="
    info " macOS-specific setup"
    info "========================================="

    configure_macos_defaults
    start_wm_services

    success "========================================="
    success " macOS setup complete!"
    success "========================================="
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_macos
fi
