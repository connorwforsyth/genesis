# Agent skills, installed globally for Claude Code and Codex with the skills CLI
# (npx skills). Public skills come from their GitHub sources; private ones from
# connorwforsyth/skills. Reruns only add skills that aren't installed yet.
add_skills() {
  local source="$1"
  shift

  npx --yes skills add "${source}" --global --yes --agent claude-code --agent codex "$@" \
    || echo "Unable to install skills from ${source}"
}

install_skills() {
  # Each entry is source|skill names
  local skill_sources=(
    "benjitaylor/agentation|agentation agentation-self-driving"
    "brianlovin/claude-config|simplify"
    "emilkowalski/skill|animate animate-expo animation-vocabulary apple-design ask-sonner emil-design-eng find-animation-opportunities improve-animations pick-ui-library review-animations write-swift"
    "haydenbleasel/ultracite|ultracite"
    "humanlayer/skills|show-me"
    "jimliu/baoyu-skills|baoyu-diagram"
    "mattpocock/skills|ask-matt chief-of-staff claude-handoff code-review codebase-design diagnosing-bugs domain-modeling git-guardrails-claude-code grill-me grill-with-docs grilling handoff implement implement-spec improve-codebase-architecture loop-me migrate-to-shoehorn pr prototype research retro scaffold-exercises setup-matt-pocock-skills setup-pre-commit setup-ts-deep-modules tdd teach to-questionnaire to-spec to-tickets triage wait-what wayfinder wizard writing-beats writing-for-agents writing-fragments writing-shape"
    "posthog/posthog-for-claude|posthog-instrumentation"
    "remotion-dev/skills|remotion-best-practices"
    "shadcn-ui/ui|migrate-radix-to-base shadcn"
    "shadcn/improve|improve"
    "vercel-labs/agent-skills|vercel-react-best-practices"
    "vercel-labs/skills|find-skills"
  )

  if ! command -v npx >/dev/null 2>&1; then
    echo "Skipping skills; npx is not available"
    return
  fi

  echo "Installing agent skills..."
  local entry source skill
  for entry in "${skill_sources[@]}"; do
    source="${entry%%|*}"

    local args=()
    for skill in ${entry#*|}; do
      [[ -d "$HOME/.agents/skills/${skill}" ]] || args+=(-s "${skill}")
    done

    if [[ ${#args[@]} -eq 0 ]]; then
      echo "Skipping ${source}; skills already installed"
      continue
    fi

    add_skills "${source}" "${args[@]}"
  done

  require_gh_auth "private skills" install_skills || return 0

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  if gh repo clone connorwforsyth/skills "${tmp_dir}/skills" -- --depth 1 --quiet; then
    add_skills "${tmp_dir}/skills" -s '*' --copy
  else
    echo "Unable to clone connorwforsyth/skills"
  fi
  rm -rf "${tmp_dir}"
}
