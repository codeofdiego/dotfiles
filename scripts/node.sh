#!/bin/bash
set -e

echo "==> Setting up Node.js..."

# Ensure Homebrew is in PATH (each script runs in a fresh bash process)
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true

export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

NVM_SH="/opt/homebrew/opt/nvm/nvm.sh"
if [ ! -f "$NVM_SH" ]; then
  echo "    ERROR: nvm not found at $NVM_SH."
  echo "    Make sure brew.sh ran successfully (nvm is installed via Brewfile)."
  exit 1
fi

\. "$NVM_SH"

if ! command -v nvm &>/dev/null; then
  echo "    ERROR: nvm failed to load."
  exit 1
fi

echo "    Installing Node LTS..."
nvm install --lts
nvm use --lts
nvm alias default node

echo "    Node $(node --version) installed and set as default."
echo "==> Node.js setup complete."
