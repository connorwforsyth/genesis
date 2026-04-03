install_brew_casks() {
  local brew_casks=(
    "arc"
    "cleanshot"
    "pixelsnap"
    "figma"
    "visual-studio-code"
    "github"
    "notion"
    "screen-studio"
    "slack"
    "spotify"
    "raycast"
    "ghostty"
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
    read -r -p "${cask} is already installed outside Homebrew. Adopt it? [y/N] " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      brew install --cask --force "${cask}"
    else
      echo "Skipping ${cask}"
    fi
  done
}
