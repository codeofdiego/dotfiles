#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║        dotfiles setup starting       ║"
echo "╚══════════════════════════════════════╝"
echo ""

bash "$DOTFILES_DIR/scripts/brew.sh"
echo ""
bash "$DOTFILES_DIR/scripts/shell.sh"
echo ""
bash "$DOTFILES_DIR/scripts/node.sh"
echo ""

echo "==> Android SDK setup requires a manual step."
echo ""
echo "    1. Open Android Studio (just installed via Homebrew)"
echo "    2. Complete the setup wizard — it will download the Android SDK"
echo "    3. Once the wizard finishes, come back here and press Enter to continue"
echo ""
read -rp "    Press Enter when Android Studio setup is complete..." _ </dev/tty
echo ""
bash "$DOTFILES_DIR/scripts/android.sh"
echo ""
bash "$DOTFILES_DIR/scripts/iterm.sh"
echo ""

echo "╔══════════════════════════════════════╗"
echo "║         setup complete!              ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Restart iTerm2 — go to Preferences > Profiles and set 'Catppuccin Macchiato' as default"
echo "  2. Open a new terminal session for zsh changes to take effect"
echo "  3. Launch Android Studio once to finish initial SDK setup (if first install)"
