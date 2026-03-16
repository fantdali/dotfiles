.DEFAULT_GOAL := help

DOTFILES_DIR := $(shell pwd)
STOW_FLAGS   := -d $(DOTFILES_DIR) -t $(HOME)

# Packages shared across all platforms
PACKAGES := shell tmux wezterm nvim gitconfig

# macOS-only packages
UNAME := $(shell uname -s)
ifeq ($(UNAME),Darwin)
  PACKAGES += yabai skhd
endif

.PHONY: help install link unlink packages macos

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

install: ## Full setup: packages + stow + OS config
	./install.sh

packages: ## Install tools and dependencies only
	./install.sh packages

link: ## Stow all config symlinks into $HOME
	@for pkg in $(PACKAGES); do \
		stow $(STOW_FLAGS) --adopt --restow $$pkg && \
		printf "  \033[32m✓\033[0m $$pkg\n"; \
	done
	@git -C $(DOTFILES_DIR) checkout -- . 2>/dev/null || true

unlink: ## Remove all stow symlinks from $HOME
	@for pkg in $(PACKAGES); do \
		stow $(STOW_FLAGS) -D $$pkg 2>/dev/null && \
		printf "  \033[33m✗\033[0m $$pkg\n" || true; \
	done

macos: ## Run macOS-specific setup (defaults, services)
	./install.sh macos
