configure_folders() {
  # Conductor and T3 Code manage their own repos and worktrees (~/conductor, ~/.t3).
  # ~/Code is for everything else: quick hacks and projects outside those tools.
  mkdir -p "$HOME/Code"
  echo "✓ ~/Code ready"
}
