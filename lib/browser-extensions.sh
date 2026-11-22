install_browser_extensions() {
  # Dia has no extension CLI, so open each store page to click "Add to Dia"
  local extensions=(
    "fdjamakpfbbddfjaooikfcpapjohcfmg|Dashlane"
  )

  if [[ ! -d "/Applications/Dia.app" ]]; then
    echo "Skipping browser extensions; Dia is not installed"
    return
  fi

  local dia_extensions="$HOME/Library/Application Support/Dia/User Data/Default/Extensions"
  local entry id name
  for entry in "${extensions[@]}"; do
    id="${entry%%|*}"
    name="${entry#*|}"
    if [[ -d "${dia_extensions}/${id}" ]]; then
      echo "Skipping ${name}; already in Dia"
      continue
    fi

    echo "Opening ${name} in Dia; click Add to Dia"
    open -a "/Applications/Dia.app" "https://chromewebstore.google.com/detail/${id}" \
      || echo "Add ${name} from https://chromewebstore.google.com/detail/${id}"
  done
}
