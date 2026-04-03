configure_ghostty() {
  local config_dir="$HOME/.config/ghostty"
  local config_file="${config_dir}/config"

  if ! command -v ghostty >/dev/null 2>&1; then
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

  echo "✓ Ghostty configured"
}
