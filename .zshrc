# If you come from bash you might have to change your $PATH.
export PATH=$(go env GOPATH)/bin:$PATH
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"

unsetopt BEEP

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

if [ -f ~/.zshrc_secrets ]; then
    source ~/.zshrc_secrets
fi

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting vi-mode kube-ps1)

source $ZSH/oh-my-zsh.sh

# PROMPT=$PROMPT'$(kube_ps1) '
KUBE_PS1_CTX_COLOR=blue
KUBE_PS1_PREFIX=''
KUBE_PS1_SUFFIX=''
KUBE_PS1_SYMBOL_ENABLE=false

INSERT_MODE_INDICATOR="%F{yellow}>>>%f"
bindkey -M viins 'jk' vi-cmd-mode
# ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

export GO111MODULE=on
export GOPATH=$(go env GOPATH)
export GOROOT=$(go env GOROOT)

# colima docker
# export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

# cli tools
eval "$(fzf --zsh)"
export FZF_COMPLETION_TRIGGER='**'

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# bat
export BAT_THEME=gruvbox-dark

# preview fzf
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# fzf-git
# source ~/fzf-git.sh/fzf-git.sh

bindkey '^[[Z' fzf-completion # shift+tab | command **<shift+tab>
# bindkey '^f' fzf-file-widget # ctrl+f | find files 
bindkey '^I' autosuggest-accept  # tab  | autosuggest

# fk
eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

# c++
export MallocNanoZone='0'

alias cd="z"
alias vim="nvim"

alias cld='docker rm -f $(docker ps -aq) && docker network prune -f'

alias py="python3"
alias k="kubectl"
alias kx="kubectx"
alias kns="kubens"
alias cc="clang++ --std=c++20 -fsanitize=address,undefined -Wall -Werror"

alias makec="make -C"
alias cl="clear"

alias g="git"
alias gs="git status"
alias gc="git commit"
alias gl="git log --oneline"

export EDITOR=vim

# shell vim mode
# set -o vi

setopt ignoreeof

source <(kubectl completion zsh)
