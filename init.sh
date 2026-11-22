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
  install_npm_packages
  install_brew_libs
  configure_git
  install_fonts
  install_font_library
  install_brew_casks
  install_optional_apps
  install_window_management
  install_pica
  install_ruler
  install_dia_tweaks
  install_mas_apps
  uninstall_apps
  configure_folders
  configure_dock
  configure_zsh "${SCRIPT_DIR}"
  configure_macos
  configure_mcp
  install_skills
  install_vscode_extensions
  configure_vscode_settings
  configure_ghostty
  install_browser_extensions
}

# --minimal answers no to every optional prompt and skips Mac App Store apps
if [[ "${1:-}" == "--minimal" ]]; then
  export GENESIS_MINIMAL=1
  shift
fi

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
