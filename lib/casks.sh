install_brew_casks() {
  local brew_casks=(
    "cleanshot"
    "pixelsnap"
    "figma"
    "visual-studio-code"
    "screen-studio"
    "slack"
    "spotify"
    "raycast"
    "ghostty"
    "t3-code"
    "conductor"
    "codex"
    "chatgpt"
    "claude"
    "claude-code"
    "thebrowsercompany-dia"
    "tailscale-app"
  )

  local cask
  for cask in "${brew_casks[@]}"; do
    if brew list --cask "${cask}" >/dev/null 2>&1; then
      echo "Skipping ${cask}; already installed"
      continue
    fi

    if brew install --cask "${cask}" 2>/dev/null; then
      continue
    fi

    # Install failed - app may exist outside Homebrew, prompt to take ownership
    if confirm "${cask} is already installed outside Homebrew. Adopt it?"; then
      brew install --cask --force "${cask}" || echo "Unable to install ${cask}"
    else
      echo "Skipping ${cask}"
    fi
  done
}
