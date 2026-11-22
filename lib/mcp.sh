# MCP servers for Claude Code and Codex. Servers that need a token use OAuth or
# are signed in afterwards, so no secrets live in this repo.
# Each entry is name|url for HTTP servers, or name|command for local ones.
MCP_SERVERS=(
  "mobbin|https://api.mobbin.com/mcp"
  "Neon|https://mcp.neon.tech/mcp"
  "agentation|npx -y agentation-mcp server"
  "rea|npx -y rea-agents@6.5.0 mcp"
)

add_mcp_server() {
  local agent="$1" name="$2" target="$3"

  if "${agent}" mcp get "${name}" >/dev/null 2>&1; then
    return
  fi

  local added=0
  # shellcheck disable=SC2086 # local commands are split into words on purpose
  case "${agent}:${target}" in
    claude:http*) claude mcp add --scope user --transport http "${name}" "${target}" || added=1 ;;
    claude:*)     claude mcp add --scope user "${name}" -- ${target} || added=1 ;;
    codex:http*)  codex mcp add "${name}" --url "${target}" || added=1 ;;
    codex:*)      codex mcp add "${name}" -- ${target} || added=1 ;;
  esac
  [[ ${added} -eq 0 ]] || echo "Unable to add ${name} to ${agent}"
}

configure_mcp() {
  local agent entry
  for agent in claude codex; do
    if ! command -v "${agent}" >/dev/null 2>&1; then
      echo "Skipping ${agent} MCP servers; ${agent} is not available"
      continue
    fi

    echo "Configuring ${agent} MCP servers..."
    for entry in "${MCP_SERVERS[@]}"; do
      add_mcp_server "${agent}" "${entry%%|*}" "${entry#*|}"
    done
  done
}
