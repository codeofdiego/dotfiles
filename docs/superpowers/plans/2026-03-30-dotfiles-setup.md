# Dotfiles Setup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a `~/dotfiles` git repo with a single `install.sh` that bootstraps a new MacBook with Homebrew packages, Oh My Zsh + Powerlevel10k (Catppuccin Macchiato rainbow), Node LTS via nvm, React Native via Expo, Android SDK, and a pre-configured iTerm2 profile.

**Architecture:** Plain shell scripts — no extra tooling. Each `scripts/*.sh` is idempotent and handles one concern. `config/` holds dotfiles copied to `~` verbatim. `install.sh` orchestrates everything.

**Tech Stack:** Bash, Homebrew, Oh My Zsh, Powerlevel10k, nvm, Android Studio / sdkmanager, iTerm2 Dynamic Profiles

---

## File Map

| File | Responsibility |
|------|----------------|
| `Brewfile` | All taps, brews, casks, VS Code extensions |
| `install.sh` | Entry point — calls each script in order |
| `scripts/brew.sh` | Install Homebrew if missing, run `brew bundle` |
| `scripts/shell.sh` | Install Oh My Zsh, clone p10k, copy `.zshrc` + `.p10k.zsh` |
| `scripts/node.sh` | Source nvm, install Node LTS, set default alias |
| `scripts/android.sh` | Install Android SDK components via `sdkmanager` |
| `scripts/iterm.sh` | Copy iTerm2 dynamic profile, set global dimming prefs |
| `config/.zshrc` | Clean zshrc: Oh My Zsh, p10k, nvm, Android PATH |
| `config/.p10k.zsh` | Catppuccin Macchiato rainbow p10k config (from upstream repo) |
| `config/iterm/profile.json` | iTerm2 dynamic profile with Catppuccin Macchiato colors + transparency |
| `README.md` | One-liner setup instructions |

---

## Task 1: Repo scaffolding

**Files:**
- Create: `.gitignore`
- Create: `README.md`

- [ ] **Step 1: Create `.gitignore`**

```
# macOS
.DS_Store

# Sensitive files — never commit these
*.pem
*.key
.env
```

- [ ] **Step 2: Create `README.md`**

```markdown
# dotfiles

MacBook setup for a new machine.

## Setup

```bash
git clone https://github.com/<you>/dotfiles.git ~/dotfiles
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
```

- [ ] **Step 3: Verify syntax and commit**

```bash
cd ~/dotfiles
bash -n install.sh 2>/dev/null || true  # file doesn't exist yet, that's fine
git add .gitignore README.md
git commit -m "chore: add repo scaffolding"
```

---

## Task 2: Brewfile

**Files:**
- Create: `Brewfile`

- [ ] **Step 1: Generate from current machine and add `android-studio`**

Run:
```bash
brew bundle dump --file=~/dotfiles/Brewfile --force
```

Then open `~/dotfiles/Brewfile` and add this line in the casks section (alphabetically after `arc`):
```
cask "android-studio"
```

- [ ] **Step 2: Verify it parses without errors**

```bash
cd ~/dotfiles
brew bundle check --file=Brewfile
```

Expected: `The Brewfile's dependencies are satisfied.`

- [ ] **Step 3: Commit**

```bash
git add Brewfile
git commit -m "chore: add Brewfile with all current packages + android-studio"
```

---

## Task 3: `config/.zshrc`

**Files:**
- Create: `config/.zshrc`

- [ ] **Step 1: Create the file**

```bash
mkdir -p ~/dotfiles/config
```

Create `config/.zshrc` with this content:

```zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

- [ ] **Step 2: Verify it sources without errors**

```bash
zsh -n ~/dotfiles/config/.zshrc
```

Expected: no output (no syntax errors)

- [ ] **Step 3: Commit**

```bash
git add config/.zshrc
git commit -m "chore: add zshrc config"
```

---

## Task 4: `config/.p10k.zsh`

**Files:**
- Create: `config/.p10k.zsh`

- [ ] **Step 1: Download the Catppuccin Macchiato rainbow theme**

```bash
curl -fsSL \
  "https://raw.githubusercontent.com/tolkonepiu/catppuccin-powerlevel10k-themes/main/themes/.p10k-rainbow-catppuccin-macchiato.zsh" \
  -o ~/dotfiles/config/.p10k.zsh
```

- [ ] **Step 2: Verify the file was downloaded and is non-empty**

```bash
wc -l ~/dotfiles/config/.p10k.zsh
zsh -n ~/dotfiles/config/.p10k.zsh
```

Expected: several hundred lines, no syntax errors

- [ ] **Step 3: Commit**

```bash
git add config/.p10k.zsh
git commit -m "chore: add p10k Catppuccin Macchiato rainbow config"
```

---

## Task 5: `config/iterm/profile.json`

**Files:**
- Create: `config/iterm/profile.json`

- [ ] **Step 1: Create the directory and profile file**

```bash
mkdir -p ~/dotfiles/config/iterm
```

Create `config/iterm/profile.json`:

```json
{
  "Profiles": [
    {
      "Name": "Catppuccin Macchiato",
      "Guid": "catppuccin-macchiato-dotfiles",
      "Normal Font": "MesloLGLNF-Regular 14",
      "Non Ascii Font": "MesloLGLNF-Regular 14",
      "Use Non-ASCII Font": false,
      "Transparency": 0.2026806294326241,
      "Blur": true,
      "Blur Radius": 19.53284574468085,
      "Only The Default BG Color Uses Transparency": true,
      "Dim Inactive Split Panes": false,
      "Background Color": {
        "Red Component": 0.1412,
        "Green Component": 0.1529,
        "Blue Component": 0.2275,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Foreground Color": {
        "Red Component": 0.7922,
        "Green Component": 0.8275,
        "Blue Component": 0.9608,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Bold Color": {
        "Red Component": 0.7922,
        "Green Component": 0.8275,
        "Blue Component": 0.9608,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Cursor Color": {
        "Red Component": 0.9569,
        "Green Component": 0.8588,
        "Blue Component": 0.8392,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Cursor Text Color": {
        "Red Component": 0.1412,
        "Green Component": 0.1529,
        "Blue Component": 0.2275,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Selection Color": {
        "Red Component": 0.2118,
        "Green Component": 0.2275,
        "Blue Component": 0.3098,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Selected Text Color": {
        "Red Component": 0.7922,
        "Green Component": 0.8275,
        "Blue Component": 0.9608,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 0 Color": {
        "Red Component": 0.2863,
        "Green Component": 0.3020,
        "Blue Component": 0.3922,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 1 Color": {
        "Red Component": 0.9294,
        "Green Component": 0.5294,
        "Blue Component": 0.5882,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 2 Color": {
        "Red Component": 0.6510,
        "Green Component": 0.8549,
        "Blue Component": 0.5843,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 3 Color": {
        "Red Component": 0.9333,
        "Green Component": 0.8314,
        "Blue Component": 0.6235,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 4 Color": {
        "Red Component": 0.5412,
        "Green Component": 0.6784,
        "Blue Component": 0.9569,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 5 Color": {
        "Red Component": 0.9608,
        "Green Component": 0.7412,
        "Blue Component": 0.9020,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 6 Color": {
        "Red Component": 0.5451,
        "Green Component": 0.8353,
        "Blue Component": 0.7922,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 7 Color": {
        "Red Component": 0.7216,
        "Green Component": 0.7529,
        "Blue Component": 0.8784,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 8 Color": {
        "Red Component": 0.3569,
        "Green Component": 0.3765,
        "Blue Component": 0.4706,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 9 Color": {
        "Red Component": 0.9294,
        "Green Component": 0.5294,
        "Blue Component": 0.5882,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 10 Color": {
        "Red Component": 0.6510,
        "Green Component": 0.8549,
        "Blue Component": 0.5843,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 11 Color": {
        "Red Component": 0.9333,
        "Green Component": 0.8314,
        "Blue Component": 0.6235,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 12 Color": {
        "Red Component": 0.5412,
        "Green Component": 0.6784,
        "Blue Component": 0.9569,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 13 Color": {
        "Red Component": 0.9608,
        "Green Component": 0.7412,
        "Blue Component": 0.9020,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 14 Color": {
        "Red Component": 0.5451,
        "Green Component": 0.8353,
        "Blue Component": 0.7922,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      },
      "Ansi 15 Color": {
        "Red Component": 0.7922,
        "Green Component": 0.8275,
        "Blue Component": 0.9608,
        "Alpha Component": 1,
        "Color Space": "sRGB"
      }
    }
  ]
}
```

- [ ] **Step 2: Validate JSON**

```bash
python3 -m json.tool ~/dotfiles/config/iterm/profile.json > /dev/null
```

Expected: no output (valid JSON)

- [ ] **Step 3: Commit**

```bash
git add config/iterm/profile.json
git commit -m "chore: add iTerm2 Catppuccin Macchiato dynamic profile"
```

---

## Task 6: `scripts/brew.sh`

**Files:**
- Create: `scripts/brew.sh`

- [ ] **Step 1: Create the script**

```bash
mkdir -p ~/dotfiles/scripts
```

Create `scripts/brew.sh`:

```bash
#!/bin/bash
set -e

echo "==> Setting up Homebrew..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

if ! command -v brew &>/dev/null; then
  echo "    Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "    Running brew bundle..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "==> Homebrew setup complete."
```

- [ ] **Step 2: Make executable and check syntax**

```bash
chmod +x ~/dotfiles/scripts/brew.sh
bash -n ~/dotfiles/scripts/brew.sh
```

Expected: no output

- [ ] **Step 3: Commit**

```bash
git add scripts/brew.sh
git commit -m "feat: add brew.sh — installs Homebrew and runs brew bundle"
```

---

## Task 7: `scripts/shell.sh`

**Files:**
- Create: `scripts/shell.sh`

- [ ] **Step 1: Create the script**

Create `scripts/shell.sh`:

```bash
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
```

- [ ] **Step 2: Make executable and check syntax**

```bash
chmod +x ~/dotfiles/scripts/shell.sh
bash -n ~/dotfiles/scripts/shell.sh
```

Expected: no output

- [ ] **Step 3: Commit**

```bash
git add scripts/shell.sh
git commit -m "feat: add shell.sh — installs Oh My Zsh and Powerlevel10k"
```

---

## Task 8: `scripts/node.sh`

**Files:**
- Create: `scripts/node.sh`

- [ ] **Step 1: Create the script**

Create `scripts/node.sh`:

```bash
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
```

- [ ] **Step 2: Make executable and check syntax**

```bash
chmod +x ~/dotfiles/scripts/node.sh
bash -n ~/dotfiles/scripts/node.sh
```

Expected: no output

- [ ] **Step 3: Commit**

```bash
git add scripts/node.sh
git commit -m "feat: add node.sh — installs Node LTS via nvm"
```

---

## Task 9: `scripts/android.sh`

**Files:**
- Create: `scripts/android.sh`

- [ ] **Step 1: Create the script**

Create `scripts/android.sh`:

```bash
#!/bin/bash
set -e

echo "==> Setting up Android SDK..."

ANDROID_HOME="$HOME/Library/Android/sdk"

# sdkmanager location varies by Android Studio version
if [ -f "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" ]; then
  SDKMANAGER="$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"
elif [ -f "$ANDROID_HOME/tools/bin/sdkmanager" ]; then
  SDKMANAGER="$ANDROID_HOME/tools/bin/sdkmanager"
else
  echo "    ERROR: sdkmanager not found under $ANDROID_HOME"
  echo "    Make sure Android Studio is installed and you have launched it at least once"
  echo "    to complete the initial SDK setup, then re-run this script."
  exit 1
fi

echo "    Installing SDK components..."
yes | "$SDKMANAGER" \
  "platforms;android-35" \
  "build-tools;35.0.1" \
  "system-images;android-35;google_apis;arm64-v8a" \
  "emulator"

echo "    Accepting licenses..."
yes | "$SDKMANAGER" --licenses

echo "==> Android SDK setup complete."
```

- [ ] **Step 2: Make executable and check syntax**

```bash
chmod +x ~/dotfiles/scripts/android.sh
bash -n ~/dotfiles/scripts/android.sh
```

Expected: no output

- [ ] **Step 3: Commit**

```bash
git add scripts/android.sh
git commit -m "feat: add android.sh — installs Android SDK components"
```

---

## Task 10: `scripts/iterm.sh`

**Files:**
- Create: `scripts/iterm.sh`

- [ ] **Step 1: Create the script**

Create `scripts/iterm.sh`:

```bash
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
```

- [ ] **Step 2: Make executable and check syntax**

```bash
chmod +x ~/dotfiles/scripts/iterm.sh
bash -n ~/dotfiles/scripts/iterm.sh
```

Expected: no output

- [ ] **Step 3: Commit**

```bash
git add scripts/iterm.sh
git commit -m "feat: add iterm.sh — installs Catppuccin Macchiato iTerm2 profile"
```

---

## Task 11: `install.sh`

**Files:**
- Create: `install.sh`

- [ ] **Step 1: Create the script**

Create `install.sh` in the repo root:

```bash
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
bash "$DOTFILES_DIR/scripts/android.sh"
echo ""
bash "$DOTFILES_DIR/scripts/iterm.sh"
echo ""

echo "╔══════════════════════════════════════╗"
echo "║         setup complete! 🎉           ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Restart iTerm2 — go to Preferences > Profiles and set 'Catppuccin Macchiato' as default"
echo "  2. Open a new terminal session for zsh changes to take effect"
echo "  3. Launch Android Studio once to finish initial SDK setup (if first install)"
```

- [ ] **Step 2: Make executable and check syntax**

```bash
chmod +x ~/dotfiles/install.sh
bash -n ~/dotfiles/install.sh
```

Expected: no output

- [ ] **Step 3: Final commit**

```bash
git add install.sh
git commit -m "feat: add install.sh — main orchestration entry point"
```

---

## Task 12: Smoke test on current machine

This verifies the scripts don't blow up on a machine where everything is already installed (idempotency check).

- [ ] **Step 1: Syntax-check all scripts at once**

```bash
for f in ~/dotfiles/scripts/*.sh ~/dotfiles/install.sh; do
  bash -n "$f" && echo "OK: $f" || echo "FAIL: $f"
done
```

Expected: `OK:` for every file

- [ ] **Step 2: Dry-run brew.sh (Homebrew already present)**

```bash
cd ~/dotfiles && bash scripts/brew.sh
```

Expected: `==> Setting up Homebrew...`, skips Homebrew install, runs `brew bundle` (already satisfied)

- [ ] **Step 3: Dry-run shell.sh (Oh My Zsh already present)**

```bash
cd ~/dotfiles && bash scripts/shell.sh
```

Expected: prints "already installed, skipping" for both Oh My Zsh and Powerlevel10k, copies configs

- [ ] **Step 4: Dry-run iterm.sh**

```bash
cd ~/dotfiles && bash scripts/iterm.sh
```

Expected: copies profile JSON, sets dimming defaults, no errors

- [ ] **Step 5: Final commit if any fixes were needed**

```bash
cd ~/dotfiles
git status  # should be clean
```
