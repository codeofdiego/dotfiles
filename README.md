# dotfiles

MacBook setup for a new machine.

## Setup

```bash
git clone https://github.com/codeofdiego/dotfiles.git ~/dotfiles
cd ~/dotfiles
# Edit Brewfile to remove unwanted entries, then:
bash install.sh
```

## What it sets up

- Homebrew packages, casks, and VS Code extensions (Brewfile)
- Oh My Zsh + Powerlevel10k with Catppuccin Macchiato rainbow theme
- Node LTS via nvm (React Native via Expo — no global CLI needed)
- Android SDK components for React Native (requires Android Studio from Brewfile)
- iTerm2 Catppuccin Macchiato profile with transparency and blur
