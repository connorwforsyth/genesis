install_window_management() {
  local app_path="/Applications/Window Management+.app"
  local repo="connorwforsyth/window-management-plus"

  if [[ -d "${app_path}" ]]; then
    echo "Skipping Window Management+; already installed"
    return
  fi

  require_gh_auth "Window Management+" install_window_management || return 0

  echo "Installing Window Management+..."
  local tmp_dir
  tmp_dir="$(mktemp -d)"

  if ! gh release download --repo "${repo}" --pattern "*.zip" --dir "${tmp_dir}"; then
    echo "Unable to download Window Management+ from ${repo}"
    rm -rf "${tmp_dir}"
    return
  fi

  ditto -x -k "${tmp_dir}"/*.zip "${tmp_dir}/app"
  ditto "${tmp_dir}/app/Window Management+/Window Management+.app" "${app_path}"
  rm -rf "${tmp_dir}"

  # Unsigned build: clear quarantine so Gatekeeper lets it open
  xattr -dr com.apple.quarantine "${app_path}"
  open "${app_path}"
  echo "Grant Window Management+ Accessibility access from its menu bar icon"
}
