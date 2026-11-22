configure_ghostty() {
  local config_dir="$HOME/.config/ghostty"
  local config_file="${config_dir}/config"

  # The Homebrew cask installs the app but no ghostty command, so check for the app
  if [[ ! -d "/Applications/Ghostty.app" ]]; then
    echo "Skipping Ghostty config; install Ghostty first"
    return
  fi

  mkdir -p "${config_dir}"

  cat <<'EOF' > "${config_file}"
# Window
background-opacity = 0.9
background-blur-radius = 20

# Cursor
cursor-style = bar
cursor-style-blink = true
EOF

  # macOS has no single "default terminal" setting; this makes Ghostty open
  # shell scripts and executables you double-click in Finder
  if command -v duti >/dev/null 2>&1; then
    duti -s com.mitchellh.ghostty com.apple.terminal.shell-script all 2>/dev/null || true
    duti -s com.mitchellh.ghostty public.unix-executable all 2>/dev/null || true
  fi

  echo "✓ Ghostty configured"
}
