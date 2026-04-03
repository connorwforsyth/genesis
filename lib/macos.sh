configure_macos() {
  echo "Configuring macOS settings..."

  # Dock
  defaults write com.apple.dock show-recents -bool false
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock tilesize -int 28

  # Finder
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # Spotlight - hide from menu bar and disable shortcuts
  defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
    "{ enabled = 0; value = { parameters = (65535, 65535, 0); type = standard; }; }"
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 \
    "{ enabled = 0; value = { parameters = (65535, 65535, 0); type = standard; }; }"

  # Trackpad - disable natural scrolling
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

  # Apply changes
  killall Dock
  killall Finder
  killall SystemUIServer
}
