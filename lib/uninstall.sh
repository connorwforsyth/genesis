uninstall_apps() {
  # Preinstalled Apple apps that can be deleted.
  # Safari, Mail, Music, News and other built-in apps are part of macOS and can't be removed.
  local apps=(
    "GarageBand"
    "iMovie"
    "Keynote"
    "Numbers"
    "Pages"
  )

  local found=()
  local app
  for app in "${apps[@]}"; do
    if [[ -d "/Applications/${app}.app" ]]; then
      found+=("${app}")
    fi
  done

  if [[ ${#found[@]} -eq 0 ]]; then
    echo "Skipping uninstall; nothing on the list is installed"
    return
  fi

  echo "These apps are on the uninstall list:"
  for app in "${found[@]}"; do
    echo "  - ${app}"
  done
  read -r -p "Uninstall them? [y/N] " response
  if [[ ! "${response}" =~ ^[Yy]$ ]]; then
    echo "Skipping uninstall"
    return
  fi

  for app in "${found[@]}"; do
    sudo rm -rf "/Applications/${app}.app"
  done

  # GarageBand's sound library is several GB on its own
  if [[ " ${found[*]} " == *" GarageBand "* ]]; then
    sudo rm -rf "/Library/Application Support/GarageBand" \
      "/Library/Application Support/Logic" \
      "/Library/Audio/Apple Loops"
    rm -rf "$HOME/Library/Application Support/GarageBand"
  fi
}
