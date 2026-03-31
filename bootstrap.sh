#!/bin/bash
set -e

REPO="codeofdiego/dotfiles"
DEST="$HOME/dotfiles"

echo "==> Downloading dotfiles..."

if [ -d "$DEST" ]; then
  echo "    $DEST already exists, skipping download."
else
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/main.zip" -o /tmp/dotfiles.zip
  unzip -q /tmp/dotfiles.zip -d /tmp
  mv /tmp/dotfiles-main "$DEST"
  rm /tmp/dotfiles.zip
fi

echo "==> Running install..."
bash "$DEST/install.sh"
