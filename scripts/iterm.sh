#!/bin/bash
set -e

echo "==> Setting up iTerm2..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"

mkdir -p "$DYNAMIC_PROFILES_DIR"

echo "    Copying Catppuccin Macchiato profile..."
cp "$DOTFILES_DIR/config/iterm/profile.json" "$DYNAMIC_PROFILES_DIR/catppuccin-macchiato.json"

echo "    Disabling window dimming..."
defaults write com.googlecode.iterm2 DimBackgroundWindows -bool false
defaults write com.googlecode.iterm2 DimInactiveSplitPanes -bool false
defaults write com.googlecode.iterm2 DimOnlyText -bool false

echo "==> iTerm2 setup complete."
echo "    Restart iTerm2 for the profile to appear under Preferences > Profiles."
