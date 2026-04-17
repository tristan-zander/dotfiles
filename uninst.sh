#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

cleanup_global_helper() {
  if [[ -f "$HOME_DIR/../usr/local/bin/get-user-shell.sh" ]]; then
    sudo rm "$HOME_DIR/../usr/local/bin/get-user-shell.sh"
    echo "removed /usr/local/bin/get-user-shell.sh"
  fi
}

clean_shellrcs() {
  local shells=('.bashrc' '.zshrc')
  for shell in "${shells[@]}"; do
    shell_path="$HOME_DIR/$shell"
    [[ -f "$shell_path" ]] || continue
    
    # Remove source ~/.shellrc.sh line (simple pattern match)
    if grep -q "source.*\.shellrc\.sh" "$shell_path" 2>/dev/null; then
      sed -i '/^[[:space:]]*source[[:space:]]*.[.]/s/[^a-zA-Z0-9]\{1\}source[[:space:]]*.[.]/#\n# removed source line\n/' "$shell_path"
      echo "cleaned $shell of source ~/.shellrc.sh"
    fi
  done
}

cleanup_stow() {
  STOW_DIR="$SCRIPT_DIR/stow"
  if [[ ! -d "$STOW_DIR" ]]; then
	return
  fi

  stow --delete -t "$HOME_DIR" -d "$SCRIPT_DIR" 'stow' || echo "warning: stow not available or no symlinks found"
  echo "unlinked stow symlinks in $HOME_DIR"
}

main() {
  cleanup_global_helper
  clean_shellrcs
  cleanup_stow
  echo "uninstall complete"
}

main
