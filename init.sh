#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

for script in "${SCRIPT_DIR}/lib/"*.sh; do
  source "$script"
done

main() {
  ensure_macos
  ensure_homebrew
  setup_nvm
  install_brew_libs
  install_fonts
  install_brew_casks
  install_mas_apps
  configure_dock
  configure_zsh "${SCRIPT_DIR}"
  configure_macos
  install_vscode_extensions
  configure_vscode_settings
  configure_ghostty
  install_browser_extensions
}

# If you pass function names as args, call those instead of main
if [[ $# -gt 0 ]]; then
  for cmd in "$@"; do
    if declare -f "$cmd" > /dev/null; then
      echo "Running ${cmd}..."
      "$cmd"
    else
      echo "No such task: $cmd"
      exit 1
    fi
  done
else
  main
fi
