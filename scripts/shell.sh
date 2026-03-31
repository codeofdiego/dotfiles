#!/bin/bash
set -e

echo "==> Setting up shell (Oh My Zsh + Powerlevel10k)..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "    Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "    Oh My Zsh already installed, skipping."
fi

# Install Powerlevel10k
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  echo "    Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
  echo "    Powerlevel10k already installed, skipping."
fi

# Copy configs
echo "    Copying .zshrc..."
cp "$DOTFILES_DIR/config/.zshrc" "$HOME/.zshrc"

echo "    Copying .p10k.zsh..."
cp "$DOTFILES_DIR/config/.p10k.zsh" "$HOME/.p10k.zsh"

echo "==> Shell setup complete."
