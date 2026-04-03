install_brew_libs() {
  local brew_libs=(
    "dockutil"
    "gh"
    "mas"
    "anomalyco/tap/opencode"
    "oven-sh/bun/bun"
    "8ta4/extension/extension"
  )

  local tool
  for tool in "${brew_libs[@]}"; do
    if brew list "${tool}" >/dev/null 2>&1; then
      echo "Skipping ${tool}; already installed"
      continue
    fi

    brew install "${tool}"
  done
}
