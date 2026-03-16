#!/usr/bin/env bash

# Close System Preferences to prevent overriding changes
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null

# =============================================================================
# Finder
# =============================================================================
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# =============================================================================
# Dock
# =============================================================================
defaults write com.apple.dock tilesize -int 51
defaults write com.apple.dock show-recents -bool false

# =============================================================================
# Screenshots
# =============================================================================
mkdir -p "${HOME}/Documents/screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Documents/screenshots"

# =============================================================================
# General
# =============================================================================
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# =============================================================================
# Apply changes
# =============================================================================
killall Finder 2>/dev/null
killall Dock 2>/dev/null
killall SystemUIServer 2>/dev/null

echo "macOS defaults applied. Some changes may require a logout/restart."
