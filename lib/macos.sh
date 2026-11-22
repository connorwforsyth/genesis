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

  # Dock - minimize windows into their app icon
  defaults write com.apple.dock minimize-to-application -bool true

  # Don't write .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  # Spotlight - hide from menu bar and disable shortcuts
  defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
    "{ enabled = 0; value = { parameters = (65535, 65535, 0); type = standard; }; }"
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 \
    "{ enabled = 0; value = { parameters = (65535, 65535, 0); type = standard; }; }"
  # Apply the shortcut change now instead of after logging out
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u \
    >/dev/null 2>&1 || true

  # Desktop - hide widgets (Stage Manager too)
  defaults write com.apple.WindowManager StandardHideWidgets -bool true
  defaults write com.apple.WindowManager StageManagerHideWidgets -bool true

  # Wallpaper - Raycast's "Glaze 2"
  local wallpaper="$HOME/Pictures/Wallpapers/glaze_2.heic"
  if [[ ! -f "${wallpaper}" ]]; then
    mkdir -p "$(dirname "${wallpaper}")"
    curl -fsSL https://misc-assets.raycast.com/wallpapers/glaze_2.heic -o "${wallpaper}" \
      || rm -f "${wallpaper}"
  fi
  if [[ -f "${wallpaper}" ]]; then
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"${wallpaper}\"" \
      >/dev/null 2>&1 || echo "Unable to set wallpaper; set it from ${wallpaper}"
  fi

  # Photos - don't open when an iPhone or camera is plugged in
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

  # iCloud Photos can only be switched off in System Settings, so open it there
  # Asked once per Mac; delete ~/.config/genesis/icloud-photos-asked to be asked again
  local photos_asked="$HOME/.config/genesis/icloud-photos-asked"
  if [[ ! -f "${photos_asked}" ]]; then
    if confirm "Keep iCloud Photos off this Mac? Opens iCloud settings to switch Photos off"; then
      open "x-apple.systempreferences:com.apple.systempreferences.AppleIDSettings:icloud"
      echo "Turn off Photos in the iCloud settings that just opened (nothing is deleted from iCloud)"
    fi
    mkdir -p "$(dirname "${photos_asked}")" && touch "${photos_asked}"
  fi

  # Trackpad and mouse - disable natural scrolling
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

  # Apply changes
  killall Dock >/dev/null 2>&1 || true
  killall Finder >/dev/null 2>&1 || true
  killall SystemUIServer >/dev/null 2>&1 || true
}
