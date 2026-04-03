configure_dock() {
  local dock_items=(
    "/Applications/Microsoft Outlook.app"
    "/Applications/Microsoft Teams.app"
    "/Applications/Arc.app"
    "/Applications/Ghostty.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/GitHub Desktop.app"
    "/Applications/Figma.app"
    "/Applications/IA Writer.app"
  )

  if ! command -v dockutil >/dev/null 2>&1; then
    echo "Skipping Dock configuration; dockutil is not available"
    return
  fi

  echo "Configuring Dock..."
  dockutil --remove all --no-restart

  local app_path
  for app_path in "${dock_items[@]}"; do
    if [[ ! -d "${app_path}" ]]; then
      echo "Skipping Dock item ${app_path}; app not found"
      continue
    fi

    dockutil --add "${app_path}" --no-restart
  done

  killall Dock
}
