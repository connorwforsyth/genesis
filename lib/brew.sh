install_brew_libs() {
  local brew_libs=(
    "btop"
    "dockutil"
    "duti"
    "ffmpeg"
    "gh"
    "git-lfs"
    "mas"
    "mole"
    "oven-sh/bun/bun"
  )

  # Homebrew only installs from third-party taps you've trusted
  brew trust --tap oven-sh/bun >/dev/null 2>&1 || true

  local tool
  for tool in "${brew_libs[@]}"; do
    if brew list "${tool}" >/dev/null 2>&1; then
      echo "Skipping ${tool}; already installed"
      continue
    fi

    brew install "${tool}"
  done
}
