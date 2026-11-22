install_vscode_extensions() {
  local extensions=(
    "anthropic.claude-code"
    "github.github-vscode-theme"
    "bierner.markdown-mermaid"
    "biomejs.biome"
    "bradlc.vscode-tailwindcss"
    "dbaeumer.vscode-eslint"
    "esbenp.prettier-vscode"
    "ms-vscode-remote.remote-containers"
    "ms-vscode-remote.remote-ssh"
    "Prisma.prisma"
    "unifiedjs.vscode-mdx"
    "vscode-icons-team.vscode-icons"
    "YoavBls.pretty-ts-errors"
  )

  if ! command -v code >/dev/null 2>&1; then
    echo "Skipping VSCode extensions; install VSCode and ensure 'code' command is available"
    return
  fi

  # Install all extensions in the list
  local extension
  for extension in "${extensions[@]}"; do
    code --install-extension "${extension}"
  done

  # Uninstall any installed extensions not in the list
  local installed
  local to_uninstall=()
  while IFS= read -r installed; do
    local keep=false
    local installed_lower
    installed_lower="$(echo "${installed}" | tr '[:upper:]' '[:lower:]')"
    for extension in "${extensions[@]}"; do
      local extension_lower
      extension_lower="$(echo "${extension}" | tr '[:upper:]' '[:lower:]')"
      if [[ "${installed_lower}" == "${extension_lower}" ]]; then
        keep=true
        break
      fi
    done
    if [[ "${keep}" == false ]]; then
      to_uninstall+=("${installed}")
    fi
  done < <(code --list-extensions)

  if [[ ${#to_uninstall[@]} -gt 0 ]]; then
    echo "The following extensions are not in your list and will be uninstalled:"
    for ext in "${to_uninstall[@]}"; do
      echo "  - ${ext}"
    done
    if confirm "Proceed?"; then
      for ext in "${to_uninstall[@]}"; do
        code --uninstall-extension "${ext}"
      done
    else
      echo "Skipping uninstall."
    fi
  fi
}
