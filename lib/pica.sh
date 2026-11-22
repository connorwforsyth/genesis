install_pica() {
  # Pica (Josh Puckett) isn't on Homebrew; take the newest DMG from its update feed
  local app_path="/Applications/Pica.app"
  local feed="https://pica.joshpuckett.me/appcast.xml"

  if [[ -d "${app_path}" ]]; then
    echo "Skipping Pica; already installed"
    return
  fi

  local dmg_url
  dmg_url="$(curl -fsSL "${feed}" | grep -oE 'url="[^"]+\.dmg"' | head -1 | cut -d'"' -f2 || true)"
  if [[ -z "${dmg_url}" ]]; then
    echo "Unable to find a Pica download in ${feed}"
    return
  fi

  echo "Installing Pica..."
  local tmp_dir mount_dir
  tmp_dir="$(mktemp -d)"
  mount_dir="${tmp_dir}/mount"
  curl -fsSL "${dmg_url}" -o "${tmp_dir}/Pica.dmg"
  hdiutil attach -nobrowse -quiet -mountpoint "${mount_dir}" "${tmp_dir}/Pica.dmg"
  ditto "${mount_dir}/Pica.app" "${app_path}"
  hdiutil detach -quiet "${mount_dir}"
  rm -rf "${tmp_dir}"
  echo "✓ Pica installed"
}
