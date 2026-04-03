configure_vscode_settings() {
  local vscode_dir="$HOME/Library/Application Support/Code/User"
  local settings_file="${vscode_dir}/settings.json"

  if ! command -v code >/dev/null 2>&1; then
    echo "Skipping VSCode settings; install VSCode and ensure 'code' command is available"
    return
  fi

  mkdir -p "${vscode_dir}"

  cat <<'EOF' > "${settings_file}"
{
  "editor.fontFamily": "JetBrains Mono, Menlo, Monaco, 'Courier New', monospace",
  "editor.fontLigatures": true,
  "editor.outline.enabled": true,
  "editor.timeline.enabled": false,
  "editor.formatOnSave": true,
  "editor.inlineSuggest.enabled": true,
  "editor.minimap.enabled": false,
  "editor.tabSize": 2,
  "editor.wordWrap": "on",
  "files.eol": "\n",
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "terminal.integrated.defaultProfile.osx": "zsh",
  "window.restoreWindows": "none",
  "window.autoDetectColorScheme": true,
  "workbench.startupEditor": "none",
  "workbench.editor.empty.hint": "hidden",
  "workbench.iconTheme": "vscode-icons",
  "workbench.colorTheme": "Tokyo Night",
  "workbench.preferredDarkColorTheme": "Tokyo Night",
  "workbench.preferredLightColorTheme": "Tokyo Night Light",
  "workbench.secondarySideBar.defaultVisibility": "hidden",
  "chat.commandCenter.enabled": false,
  "http.proxyStrictSSL": false,
  "extensions.autoUpdate": true,
  "update.mode": "start"
}
EOF

  echo "✓ VSCode settings configured"
}
