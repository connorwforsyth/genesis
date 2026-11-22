ensure_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Genesis only supports macOS." >&2
    exit 1
  fi
}

load_homebrew() {
  local brew_bin=""

  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    brew_bin="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_bin="/usr/local/bin/brew"
  fi

  if [[ -z "${brew_bin}" ]]; then
    return 1
  fi

  eval "$("${brew_bin}" shellenv)"
}

ensure_homebrew() {
  if ! load_homebrew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    load_homebrew
  else
    echo "Homebrew is already installed"
  fi

  echo "Updating Homebrew..."
  brew update

  echo "Upgrading installed formulae..."
  brew upgrade

  export BREW_PREFIX
  BREW_PREFIX="$(brew --prefix)"
}

# Steps that read private GitHub repos call this first; configure_git signs in earlier in the run
require_gh_auth() {
  if gh auth status >/dev/null 2>&1; then
    return 0
  fi

  echo "Skipping $1; run 'gh auth login' then 'genesis $2'"
  return 1
}
