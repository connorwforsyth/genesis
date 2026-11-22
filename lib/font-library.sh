install_font_library() {
  local repo="connorwforsyth/fonts"
  local fonts_dir="$HOME/Library/Fonts"
  # Any one font from the library shows it's been installed before
  local marker_font="Agrandir-Regular.otf"

  if [[ -f "${fonts_dir}/${marker_font}" ]]; then
    echo "Skipping font library; already installed"
    return
  fi

  require_gh_auth "font library" install_font_library || return 0

  echo "Installing font library..."
  local tmp_dir
  tmp_dir="$(mktemp -d)"

  if gh repo clone "${repo}" "${tmp_dir}/fonts" -- --depth 1 --quiet; then
    mkdir -p "${fonts_dir}"
    # -n keeps fonts that are already installed, including Homebrew's
    cp -n "${tmp_dir}/fonts/fonts/"* "${fonts_dir}/" 2>/dev/null || true
  fi
  rm -rf "${tmp_dir}"

  if [[ -f "${fonts_dir}/${marker_font}" ]]; then
    echo "✓ Font library installed"
  else
    echo "Unable to install the font library from ${repo}"
  fi
}
