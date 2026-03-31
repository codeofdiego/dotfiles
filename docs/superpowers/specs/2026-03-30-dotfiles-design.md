# Dotfiles Setup Design

**Date:** 2026-03-30
**Goal:** A single git repo that bootstraps a new MacBook to match the current machine's development environment.

---

## Overview

A `~/dotfiles` git repo with a plain shell script approach. Running `install.sh` on a fresh Mac sets up Homebrew packages, shell environment, Node.js, React Native (iOS + Android), and iTerm2. No extra tooling dependencies beyond Homebrew.

---

## Repo Structure

```
~/dotfiles/
├── Brewfile
├── install.sh
├── scripts/
│   ├── brew.sh
│   ├── shell.sh
│   ├── node.sh
│   ├── android.sh
│   └── iterm.sh
├── config/
│   ├── .zshrc
│   ├── .p10k.zsh
│   └── iterm/
│       └── profile.json
└── README.md
```

---

## Section 1: Brewfile

Generated from the current machine via `brew bundle dump`. Includes:

- **Taps:** dokku/repo, gromgit/brewtils, nikitabobko/tap, peonping/tap, specstoryai/tap
- **Brews:** btop, cloudflared, cocoapods, gh, nvm, scrcpy, tailscale, tmux, zplug, and tap-specific formulas
- **Casks:** All current casks plus `android-studio` (added explicitly)
- **VS Code extensions:** All current extensions

The user will manually remove entries they don't need before running on a new machine.

---

## Section 2: Shell Setup (`scripts/shell.sh`)

1. Install Oh My Zsh non-interactively (`--unattended` flag, skip chsh)
2. Clone powerlevel10k into `~/.oh-my-zsh/custom/themes/powerlevel10k`
3. Download the Catppuccin Macchiato p10k color config from `https://github.com/tolkonepiu/catppuccin-powerlevel10k-themes` and append/source it at the end of `~/.p10k.zsh`
4. Copy `config/.zshrc` → `~/.zshrc`
5. Copy `config/.p10k.zsh` → `~/.p10k.zsh`

### `.zshrc` contents

- `ZSH_THEME="powerlevel10k/powerlevel10k"` (no instant prompt)
- `plugins=(git)`
- nvm sourcing block
- `ANDROID_HOME` and `PATH` exports for Android SDK
- `source ~/.p10k.zsh` at the bottom

All scripts are idempotent — they check for existing installations before acting.

---

## Section 3: Node.js + React Native (`scripts/node.sh`)

1. Source nvm (installed via Brewfile)
2. `nvm install --lts && nvm use --lts && nvm alias default node`

React Native is used via Expo (`npx create-expo-app`, `npx expo`) — no global CLI install needed.
iOS support comes from cocoapods in the Brewfile — no extra script needed.

---

## Section 4: Android SDK (`scripts/android.sh`)

The `ANDROID_HOME` export and `PATH` entries are already present in `config/.zshrc` (tracked in git). `android.sh` only installs SDK components via `sdkmanager`:
   - `platforms;android-35`
   - `build-tools;35.0.1`
   - `system-images;android-35;google_apis;arm64-v8a` (M-series Mac)
   - `emulator`

Assumes Android Studio (and thus `sdkmanager`) is installed via Brewfile.

---

## Section 5: iTerm2 (`scripts/iterm.sh`)

Drops `config/iterm/profile.json` into `~/Library/Application Support/iTerm2/DynamicProfiles/`.

The profile includes:
- **Colors:** Catppuccin Macchiato palette
- **Transparency:** ~20% (`Transparency = 0.2026806294326241`)
- **Blur:** enabled, radius 19.5
- **Only default bg color uses transparency:** true
- **Dimming:** all disabled (`DimBackgroundWindows`, `DimInactiveSplitPanes`, `DimOnlyText` all `0`)
- **Font:** MesloLGS NF (installed via Brewfile cask `font-meslo-lg-nerd-font`)

---

## Section 6: `install.sh` Orchestration

```bash
#!/bin/bash
set -e

./scripts/brew.sh
./scripts/shell.sh
./scripts/node.sh
./scripts/android.sh
./scripts/iterm.sh
```

Each script prints a header (`==> Setting up ...`) and exits with a clear error message on failure. All scripts are idempotent.

---

## Usage (README)

```bash
git clone https://github.com/<you>/dotfiles.git ~/dotfiles
cd ~/dotfiles
# Edit Brewfile to remove unwanted entries
bash install.sh
```

---

## Out of Scope

- SSH keys / GPG keys (too sensitive for a repo)
- macOS system preferences (`defaults write` commands)
- Cursor or VS Code settings sync (handled by their own sync)
