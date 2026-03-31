#!/bin/bash
set -e

echo "==> Setting up Node.js..."

export NVM_DIR="$HOME/.nvm"

if [ ! -d "$NVM_DIR" ]; then
  echo "    ERROR: nvm directory not found at $NVM_DIR."
  echo "    Make sure brew.sh ran successfully (nvm is installed via Brewfile)."
  exit 1
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

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
