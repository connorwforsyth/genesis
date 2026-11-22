install_font_library() {
  local repo="connorwforsyth/fonts"
  local fonts_dir="$HOME/Library/Fonts"

  require_gh_auth "font library" install_font_library || return 0

  echo "Installing font library..."
  local tmp_dir
  tmp_dir="$(mktemp -d)"

  if ! gh repo clone "${repo}" "${tmp_dir}/fonts" -- --depth 1 --quiet; then
    echo "Unable to clone ${repo}"
    rm -rf "${tmp_dir}"
    return
  fi

  mkdir -p "${fonts_dir}"
  # -n keeps fonts that are already installed, including Homebrew's
  cp -n "${tmp_dir}/fonts/fonts/"* "${fonts_dir}/" 2>/dev/null || true
  rm -rf "${tmp_dir}"
  echo "✓ Font library installed"
}
