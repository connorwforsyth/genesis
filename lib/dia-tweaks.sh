install_dia_tweaks() {
  local repo_dir="$HOME/DiaTweaks"

  if [[ ! -d "/Applications/Dia.app" ]]; then
    echo "Skipping DiaTweaks; Dia is not installed"
    return
  fi

  if command -v diatweaks >/dev/null 2>&1; then
    echo "Skipping DiaTweaks; already installed (update with 'diatweaks update')"
    return
  fi

  if ! xcode-select -p >/dev/null 2>&1; then
    echo "Skipping DiaTweaks; run 'xcode-select --install' then 'genesis install_dia_tweaks'"
    return
  fi

  echo "DiaTweaks (github.com/JaceThings/DiaTweaks) is unofficial. It re-signs Dia locally and"
  echo "turns off Dia's own updater, handling updates itself."
  if ! confirm "Install DiaTweaks?"; then
    echo "Skipping DiaTweaks"
    return
  fi

  # A folder without the diatweaks command is a failed earlier attempt: start clean
  rm -rf "${repo_dir}"
  if git clone https://github.com/JaceThings/DiaTweaks.git "${repo_dir}" && "${repo_dir}/install.sh"; then
    echo "If macOS asks about \"Dia Safe Storage\", enter your password and click Always Allow"
  else
    echo "Unable to install DiaTweaks; rerun 'genesis install_dia_tweaks'"
  fi
}
