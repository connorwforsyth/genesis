configure_zsh() {
  local genesis_dir="${1:-}"
  touch ~/.zprofile ~/.zshrc

  # .zprofile
  if grep -q ">>> genesis >>>" ~/.zprofile; then
    sed -i '' '/>>> genesis >>>/,/<<< genesis <<</d' ~/.zprofile
  fi
  cat << EOF >> ~/.zprofile
# >>> genesis >>>
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

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload -Uz compinit && compinit

# Genesis CLI
genesis() { bash "${genesis_dir}/init.sh" "\$@"; }
# <<< genesis <<<
EOF
  echo "✓ .zshrc configured"
}
