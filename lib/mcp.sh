# MCP servers for Claude Code and Codex. Servers that need a token use OAuth or
# are signed in afterwards, so no secrets live in this repo.
add_mcp_server() {
  local agent="$1" name="$2" target="$3"

  if "${agent}" mcp get "${name}" >/dev/null 2>&1; then
    echo "Skipping ${name} for ${agent}; already added"
    return
  fi

  local ok=true
  # shellcheck disable=SC2086 # local commands are split into words on purpose
  case "${agent}:${target}" in
    claude:http*) claude mcp add --scope user --transport http "${name}" "${target}" || ok=false ;;
    claude:*)     claude mcp add --scope user "${name}" -- ${target} || ok=false ;;
    # `codex mcp add --url` signs in straight away and waits; write the config instead.
    # Sign in later with `codex mcp login <name>` when you first need it
    codex:http*)  mkdir -p "$HOME/.codex" \
                    && printf '\n[mcp_servers.%s]\nurl = "%s"\n' "${name}" "${target}" >> "$HOME/.codex/config.toml" \
                    || ok=false ;;
    codex:*)      codex mcp add "${name}" -- ${target} || ok=false ;;
  esac
  [[ "${ok}" == true ]] || echo "Unable to add ${name} to ${agent}"
}

configure_mcp() {
  # Each entry is name|url for HTTP servers, or name|command for local ones
  local mcp_servers=(
    "mobbin|https://api.mobbin.com/mcp"
    "Neon|https://mcp.neon.tech/mcp"
    "agentation|npx -y agentation-mcp server"
    "rea|npx -y rea-agents@6.5.0 mcp"
  )

  local agent entry
  for agent in claude codex; do
    if ! command -v "${agent}" >/dev/null 2>&1; then
      echo "Skipping ${agent} MCP servers; ${agent} is not available"
      continue
    fi

    echo "Configuring ${agent} MCP servers..."
    for entry in "${mcp_servers[@]}"; do
      add_mcp_server "${agent}" "${entry%%|*}" "${entry#*|}"
    done
  done
}
