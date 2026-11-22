# Agent skills, installed globally for Claude Code and Codex.
# Public skills come from their GitHub sources; the private ones from connorwforsyth/skills.
install_skill() {
  local source="$1"
  shift

  npx --yes skills add "${source}" --global --yes --agent claude-code --agent codex "$@" \
    || echo "Unable to install skills from ${source}"
}

install_skills() {
  if ! command -v npx >/dev/null 2>&1; then
    echo "Skipping skills; npx is not available"
    return
  fi

  echo "Installing agent skills..."
  install_skill "benjitaylor/agentation" -s agentation -s agentation-self-driving
  install_skill "brianlovin/claude-config" -s simplify
  install_skill "emilkowalski/skill" -s animate -s animate-expo -s animation-vocabulary \
    -s apple-design -s ask-sonner -s emil-design-eng -s find-animation-opportunities \
    -s improve-animations -s pick-ui-library -s review-animations -s write-swift
  install_skill "haydenbleasel/ultracite" -s ultracite
  install_skill "humanlayer/skills" -s show-me
  install_skill "jimliu/baoyu-skills" -s baoyu-diagram
  install_skill "mattpocock/skills" -s ask-matt -s chief-of-staff -s claude-handoff \
    -s code-review -s codebase-design -s diagnosing-bugs -s domain-modeling \
    -s git-guardrails-claude-code -s grill-me -s grill-with-docs -s grilling -s handoff \
    -s implement -s implement-spec -s improve-codebase-architecture -s loop-me \
    -s migrate-to-shoehorn -s pr -s prototype -s research -s retro -s scaffold-exercises \
    -s setup-matt-pocock-skills -s setup-pre-commit -s setup-ts-deep-modules -s tdd \
    -s teach -s to-questionnaire -s to-spec -s to-tickets -s triage -s wait-what \
    -s wayfinder -s wizard -s writing-beats -s writing-for-agents -s writing-fragments \
    -s writing-shape
  install_skill "posthog/posthog-for-claude" -s posthog-instrumentation
  install_skill "remotion-dev/skills" -s remotion-best-practices
  install_skill "shadcn-ui/ui" -s migrate-radix-to-base -s shadcn
  install_skill "shadcn/improve" -s improve
  install_skill "vercel-labs/agent-skills" -s vercel-react-best-practices
  install_skill "vercel-labs/skills" -s find-skills

  require_gh_auth "private skills" install_skills || return 0

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  if gh repo clone connorwforsyth/skills "${tmp_dir}/skills" -- --depth 1 --quiet; then
    install_skill "${tmp_dir}/skills" -s '*' --copy
  else
    echo "Unable to clone connorwforsyth/skills"
  fi
  rm -rf "${tmp_dir}"
}
