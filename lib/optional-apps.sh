# Large or situational apps, installed only if you answer yes
install_optional_group() {
  local question="$1"
  shift

  local missing=()
  local cask
  for cask in "$@"; do
    brew list --cask "${cask}" >/dev/null 2>&1 || missing+=("${cask}")
  done

  if [[ ${#missing[@]} -eq 0 ]]; then
    return
  fi

  if ! confirm "${question}"; then
    echo "Skipping ${missing[*]}"
    return
  fi

  for cask in "${missing[@]}"; do
    brew install --cask "${cask}" || echo "Unable to install ${cask}"
  done
}

install_optional_apps() {
  install_optional_group "Install Docker Desktop (about 2 GB, plus its disk image)?" \
    "docker-desktop"
  install_optional_group "Install Microsoft work apps (Outlook, Teams, Word, Excel, PowerPoint)?" \
    "microsoft-outlook" "microsoft-teams" "microsoft-word" "microsoft-excel" "microsoft-powerpoint"
}
