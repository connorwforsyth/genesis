configure_zsh() {
  local genesis_dir="${1:-}"
  touch ~/.zprofile ~/.zshrc

  local brew_bin="/opt/homebrew/bin/brew"
  [[ -x "${brew_bin}" ]] || brew_bin="/usr/local/bin/brew"

  # .zprofile
  if grep -q ">>> genesis >>>" ~/.zprofile; then
    sed -i '' '/>>> genesis >>>/,/<<< genesis <<</d' ~/.zprofile
  fi
  cat << EOF >> ~/.zprofile
# >>> genesis >>>
# Homebrew (its installer doesn't add this for you)
eval "\$(${brew_bin} shellenv)"

# Native installers (Claude Code) put binaries here
export PATH="\$HOME/.local/bin:\$PATH"

# VS Code
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# <<< genesis <<<
EOF
  echo "✓ .zprofile configured"

  # .zshrc
  if grep -q ">>> genesis >>>" ~/.zshrc; then
    sed -i '' '/>>> genesis >>>/,/<<< genesis <<</d' ~/.zshrc
  fi
  cat << EOF >> ~/.zshrc
# >>> genesis >>>
# Full path prompt
PROMPT='%~ %# '

# Type a directory name (e.g. ..) to cd into it
setopt autocd

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload -Uz compinit && compinit

# Keep Biome from using every core
export BIOME_THREADS=2

# Genesis CLI
genesis() { bash "${genesis_dir}/init.sh" "\$@"; }
# <<< genesis <<<
EOF
  echo "✓ .zshrc configured"
}
