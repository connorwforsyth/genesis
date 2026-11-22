# Apps that aren't on Homebrew.
#
# install_app <name> <fetch_fn> installs "<name>.app" into /Applications.
# fetch_fn gets an empty folder and must put a .zip or .dmg in it, printing its own
# error and returning non-zero if it can't. install_app unpacks it, finds the app,
# copies it in, clears quarantine and cleans up. It returns 0 only when it installed
# something new, so callers can run first-launch steps with `install_app ... || return 0`.
install_app() {
  local name="$1" fetch_fn="$2"
  local app_path="${GENESIS_APPS_DIR:-/Applications}/${name}.app"

  if [[ -d "${app_path}" || -d "$HOME/Applications/${name}.app" ]]; then
    echo "Skipping ${name}; already installed"
    return 1
  fi

  echo "Installing ${name}..."
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  mkdir "${tmp_dir}/download" "${tmp_dir}/unpacked"

  local ok=false
  if "${fetch_fn}" "${tmp_dir}/download" && unpack_archive "${tmp_dir}/download" "${tmp_dir}/unpacked"; then
    local found
    found="$(find "${tmp_dir}/unpacked" -maxdepth 3 -name "${name}.app" -print -quit)"
    if [[ -n "${found}" ]] && ditto "${found}" "${app_path}"; then
      xattr -dr com.apple.quarantine "${app_path}" 2>/dev/null || true
      ok=true
    fi
  fi

  hdiutil detach -quiet "${tmp_dir}/unpacked" 2>/dev/null || true
  rm -rf "${tmp_dir}"

  if [[ "${ok}" == true ]]; then
    echo "✓ ${name} installed"
    return 0
  fi
  echo "Unable to install ${name}"
  return 1
}

# Open a just-installed app by path: macOS may not know it by name yet. Never stops the run
open_app() {
  open "${GENESIS_APPS_DIR:-/Applications}/$1.app" 2>/dev/null || echo "Open $1 from Applications to finish setup"
}

unpack_archive() {
  local archive
  archive="$(find "$1" -maxdepth 1 \( -name '*.zip' -o -name '*.dmg' \) -print -quit)"
  case "${archive}" in
    *.zip) ditto -x -k "${archive}" "$2" ;;
    *.dmg) hdiutil attach -nobrowse -quiet -mountpoint "$2" "${archive}" ;;
    *) echo "No .zip or .dmg was downloaded"; return 1 ;;
  esac
}

# Pica (Josh Puckett's font tool): newest DMG from its update feed
fetch_pica() {
  local url
  url="$(curl -fsSL https://pica.joshpuckett.me/appcast.xml | grep -oE 'url="[^"]+\.dmg"' | head -1 | cut -d'"' -f2 || true)"
  if [[ -z "${url}" ]]; then
    echo "Unable to find a Pica download in its update feed"
    return 1
  fi
  curl -fsSL "${url}" -o "$1/Pica.dmg"
}

install_pica() {
  install_app "Pica" fetch_pica || true
}

# Window Management+: unsigned build from the latest release of a private repo
fetch_window_management() {
  require_gh_auth "Window Management+" install_window_management || return 1
  gh release download --repo connorwforsyth/window-management-plus --pattern "*.zip" --dir "$1"
}

install_window_management() {
  install_app "Window Management+" fetch_window_management || return 0
  open_app "Window Management+"
  echo "Grant Window Management+ Accessibility access from its menu bar icon"
}

# Ruler: screen ruler and annotation tool, from the latest release of a private repo
fetch_ruler() {
  require_gh_auth "Ruler" install_ruler || return 1
  gh release download --repo connorwforsyth/ruler --pattern "*.zip" --dir "$1"
}

install_ruler() {
  install_app "Ruler" fetch_ruler || return 0
  open_app "Ruler"
  echo "Ruler asks for Screen Recording the first time you measure; allow it, then relaunch Ruler"
}
