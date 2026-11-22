configure_git() {
  echo "Configuring git..."
  git config --global init.defaultBranch main
  git config --global push.autoSetupRemote true
  git config --global core.ignoreCase false

  if ! command -v gh >/dev/null 2>&1; then
    echo "Skipping git identity; gh is not available"
    return
  fi

  # Sign in now so later steps (fonts, Window Management+, private skills) can use gh
  if ! gh auth status >/dev/null 2>&1; then
    gh auth login --web --git-protocol https || true
    require_gh_auth "git identity" configure_git || return 0
  fi

  # Let git use gh's sign-in for HTTPS pushes and pulls
  gh auth setup-git || echo "Unable to set gh as git's credential helper"

  local login id name
  if ! IFS=$'\t' read -r login id name < <(gh api user --jq '[.login, .id, .name // ""] | @tsv'); then
    echo "Unable to read your GitHub profile; rerun 'genesis configure_git'"
    return
  fi

  if [[ -z "$(git config --global user.name)" ]]; then
    git config --global user.name "${name:-${login}}"
  fi

  # GitHub's private noreply address keeps your real email out of commits
  if [[ -z "$(git config --global user.email)" ]]; then
    git config --global user.email "${id}+${login}@users.noreply.github.com"
  fi

  echo "✓ git configured as $(git config --global user.name) <$(git config --global user.email)>"
}
