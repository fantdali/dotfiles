#!/usr/bin/env bash
set -euo pipefail

umask 077

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
install_dir="${AI_ENGINEER_HOME:-$HOME/.config/ai-engineer-kit}"
local_dir="${AI_ENGINEER_LOCAL_HOME:-$HOME/.config/ai-engineer-kit-local}"
state_dir="${AI_ENGINEER_STATE_HOME:-$HOME/.local/state/ai-engineer-kit}"
local_workstyle="$local_dir/WORKSTYLE.md"
active_workstyle="$state_dir/WORKSTYLE.md"
dry_run=false
apply_settings=true

for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=true ;;
    --no-settings) apply_settings=false ;;
    *) printf 'usage: %s [--dry-run] [--no-settings]\n' "$0" >&2; exit 2 ;;
  esac
done

run() {
  if $dry_run; then
    printf '+ '
    printf '%q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

backup_and_link() {
  local source="$1" destination="$2" stamp
  if [[ -L "$destination" && "$(readlink "$destination")" == "$source" ]]; then
    return
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    stamp="$(date -u +%Y%m%dT%H%M%SZ)"
    run mv "$destination" "${destination}.backup-${stamp}"
  fi
  run ln -s "$source" "$destination"
}

render_workstyle() {
  local temporary
  if $dry_run; then
    printf '+ render %q with optional %q to %q\n' \
      "$source_dir/WORKSTYLE.md" "$local_workstyle" "$active_workstyle"
    return
  fi

  temporary="$(mktemp "$state_dir/WORKSTYLE.XXXXXX")"
  {
    cat "$source_dir/WORKSTYLE.md"
    if [[ -f "$local_workstyle" ]]; then
      printf '\n\n'
      cat "$local_workstyle"
    fi
  } >"$temporary"
  chmod 0600 "$temporary"
  mv "$temporary" "$active_workstyle"
}

run mkdir -p "$HOME/.config" "$HOME/.codex/skills" \
  "$HOME/.claude/skills" "$HOME/.agents/skills" "$HOME/.pi/agent" \
  "$HOME/.config/opencode" "$HOME/.local/bin" "$local_dir" "$state_dir"

backup_and_link "$source_dir" "$install_dir"
active_dir="$install_dir"

run chmod 0755 "$source_dir/install.sh" "$source_dir/merge-codex-config.py"
render_workstyle

backup_and_link "$active_workstyle" "$HOME/.codex/AGENTS.md"
backup_and_link "$active_workstyle" "$HOME/.claude/CLAUDE.md"
backup_and_link "$active_workstyle" "$HOME/.pi/agent/AGENTS.md"
backup_and_link "$active_workstyle" "$HOME/.config/opencode/AGENTS.md"

for skill in "$active_dir"/skills/*; do
  name="$(basename "$skill")"
  backup_and_link "$skill" "$HOME/.codex/skills/$name"
  backup_and_link "$skill" "$HOME/.claude/skills/$name"
  backup_and_link "$skill" "$HOME/.agents/skills/$name"
done

if $apply_settings; then
  if $dry_run; then
    run python3 "$active_dir/merge-codex-config.py" --dry-run
  else
    python3 "$active_dir/merge-codex-config.py"
  fi
fi

printf 'AI engineer kit %s. Restart agent sessions to load global changes.\n' "$($dry_run && printf 'preview complete' || printf 'installed')"
