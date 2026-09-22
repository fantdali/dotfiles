# If you come from bash you might have to change your $PATH.
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

unsetopt BEEP

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

if [ -f ~/.zshrc_secrets ]; then
    source ~/.zshrc_secrets
fi

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting vi-mode kube-ps1 fzf-tab)

source $ZSH/oh-my-zsh.sh

PROMPT="%(?:%{$fg_bold[green]%}%1{>%} :%{$fg_bold[red]%}%1{>%} )%{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'
PROMPT+='$(kube_ps1)'
PROMPT+='$(vi_mode_prompt_info)'
PROMPT+=$'\n$ '
RPROMPT=""
KUBE_PS1_CTX_COLOR=blue
KUBE_PS1_NS_COLOR=red
KUBE_PS1_PREFIX=''
KUBE_PS1_SUFFIX=' '
KUBE_PS1_SYMBOL_ENABLE=false

INSERT_MODE_INDICATOR="%F{yellow}>>>%f"
bindkey -M viins 'jk' vi-cmd-mode
# ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

export GO111MODULE=on
export GOPATH=$(go env GOPATH)
export GOROOT=$(go env GOROOT)

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# CLI navigation
if command -v wt >/dev/null 2>&1; then
  eval "$(wt config shell init zsh)"
fi

# fzf key bindings and completion. fzf-tab turns native zsh completion
# candidates (including kubectx contexts and kubectl kinds) into an fzf picker.
source <(fzf --zsh)
export FZF_COMPLETION_TRIGGER='**'

# Use fd instead of find for file and directory candidates.
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

export BAT_THEME=gruvbox-dark
export CODEGRAPH_TELEMETRY=0
export CODEGRAPH_NO_UPDATE_CHECK=1

# Preview files with bat and directories with eza.
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' fzf-flags --bind=ctrl-j:down,ctrl-k:up

bindkey '^[[Z' fzf-tab-complete # shift+tab | fuzzy native completion
bindkey '^f' fzf-file-widget    # ctrl+f | find files
bindkey '^t' fzf-cd-widget      # ctrl+t | find directories
bindkey '^I' autosuggest-accept  # tab  | autosuggest

# fk
eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

source <(kubectl completion zsh)

# c++ (macOS-only: suppress malloc nano zone warnings)
if [[ "$(uname)" == "Darwin" ]]; then
  export MallocNanoZone='0'
fi

alias vim="nvim"
alias vi="nvim"

alias cld='docker rm -f $(docker ps -aq) && docker network prune -f'

alias py="python3"
alias k="kubectl"
alias kx="kubectx"
alias kns="kubens"

kc() {
	local configpath=${1}
	if [ -f "$configpath" ]; then
		export KUBECONFIG="$configpath"
		return
	fi

	kc-tmux
}

kcd() {
  local ns secret output
  ns="$(kubectl config view --minify -o jsonpath='{..namespace}')"

  secret="${ns}-kubeconfig-external"
  if ! kubectl -n "$ns" get secret "$secret" >/dev/null 2>&1; then
    secret="${ns}-kubeconfig"
  fi

  output="/tmp/${secret}"

  kubectl -n "$ns" get secret "$secret" \
    -o jsonpath='{.data.value}' | base64 -d > "$output" || return 1

  print -r -- "$output"
}

kcn() {
  local ns config
  ns="$(kubectl config view --minify -o jsonpath='{..namespace}')"

  for config in \
    "/tmp/${ns}-kubeconfig-external" \
    "/tmp/${ns}-kubeconfig"; do
    if [[ -f "$config" ]]; then
      kc "$config"
      return
    fi
  done

  kcd

  for config in \
    "/tmp/${ns}-kubeconfig-external" \
    "/tmp/${ns}-kubeconfig"; do
    if [[ -f "$config" ]]; then
      kc "$config"
      return
    fi
  done

  echo "Failed to select context"
  return 1
}

kc-tmux() {
	# Isolate Kubernetes context per tmux session
	if [ -n "$TMUX" ]; then
		# 1. Get the current tmux session name
		TMUX_SESSION=$(tmux display-message -p '#S')

		# 2. Define a unique path for this session's config
		export KUBECONFIG="$HOME/.kube/config-tmux-$TMUX_SESSION"

		# 3. If the session config doesn't exist yet, seed it from the default config
		if [ ! -f "$KUBECONFIG" ] && [ -f "$HOME/.kube/config" ]; then
			cp "$HOME/.kube/config" "$KUBECONFIG"
		fi
	fi
}

kc-tmux

alias argopf="kubectl port-forward svc/argocd-server 8443:443 -n argocd"

alias cc="clang++ --std=c++20 -fsanitize=address,undefined -Wall -Werror"

alias makec="make -C"
alias cl="clear"

alias g="git"
alias gs="git status"
alias gc="git commit"
alias gl="git log --oneline"
alias lg="lazygit"

export EDITOR=vim

# shell vim mode
# set -o vi

setopt ignoreeof

if command -v go &>/dev/null; then
  export PATH=$(go env GOPATH)/bin:$PATH
fi

if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
  export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
  export PATH="/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/findutils/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
fi

export PATH="$HOME/.local/bin:$PATH"

export K9S_FEATURE_GATE_NODE_SHELL=true

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh --disable-up-arrow)"
bindkey -M viins '^R' atuin-search-viins
bindkey -M vicmd '^R' atuin-search-vicmd
