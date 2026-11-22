install_npm_packages() {
  local npm_packages=(
    "vercel"
  )

  if ! command -v npm >/dev/null 2>&1; then
    echo "Skipping npm packages; npm is not available"
    return
  fi

  local installed
  installed="$(npm list -g --depth=0 --parseable 2>/dev/null || true)"

  local package
  for package in "${npm_packages[@]}"; do
    if grep -q "/node_modules/${package}$" <<< "${installed}"; then
      echo "Skipping ${package}; already installed"
      continue
    fi

    npm install -g "${package}"
  done
}
