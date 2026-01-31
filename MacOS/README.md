# Dotfiles for macOS (Apple Silicon M1-M4)

Personal dotfiles and setup script for a fresh macOS installation on Apple Silicon Macs.

## What Gets Installed

| Tool | Description |
|------|-------------|
| **Homebrew** | Package manager (used only for pyenv) |
| **iTerm2** | Better terminal for macOS |
| **Oh My Zsh** | Zsh framework with themes and plugins |
| **agnoster theme** | Powerline-style prompt (requires Nerd Font) |
| **zsh-syntax-highlighting** | Syntax highlighting for commands |
| **zsh-autosuggestions** | Fish-like autosuggestions |
| **NVM** | Node.js version manager |
| **Pyenv** | Python version manager |
| **MesloLGS Nerd Font** | Powerline-compatible font |
| **Git** | Via Xcode Command Line Tools |

## Setup Instructions

### Step 1: Clone this repo

On your new Mac, open Terminal and run:

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/Projects/dotfiles
```

> **Note:** If this is a fresh Mac, you'll be prompted to install Xcode Command Line Tools when you run `git`. Click "Install" and wait for it to complete, then run the clone command again.

### Step 2: Run the setup script

```bash
cd ~/Projects/dotfiles/MacOS
chmod +x setup.sh
./setup.sh
```

The script will prompt you for your Git email address.

### Step 3: Configure iTerm2 font

1. Open **iTerm2** (installed to /Applications)
2. Go to **iTerm2 → Settings → Profiles → Text**
3. Click on **Font** and select **MesloLGS Nerd Font**
4. Set size to **12** or your preference

### Step 4: Restart iTerm2

Close and reopen iTerm2 to apply all changes. You should see the agnoster prompt theme.

### Step 5: Install Node.js

```bash
nvm install --lts
```

### Step 6: Install Python

```bash
pyenv install 3.12
pyenv global 3.12
```

Verify with:

```bash
python --version
node --version
```

## Files

| File | Description |
|------|-------------|
| `setup.sh` | Main installation script |
| `uninstall.sh` | Removes everything installed by setup.sh |
| `.zshrc` | Zsh configuration |
| `.gitconfig` | Git configuration |
| `README.md` | This file |

## Updating

To pull the latest changes and re-run setup:

```bash
cd ~/Projects/dotfiles
git pull
cd MacOS
./setup.sh
```

The script is idempotent — it will skip anything already installed and backup existing dotfiles before overwriting.

## Uninstalling

If something goes wrong or you want to start fresh:

```bash
cd ~/Projects/dotfiles/MacOS
chmod +x uninstall.sh
./uninstall.sh
```

This removes:
- iTerm2
- Oh My Zsh and plugins
- NVM and pyenv
- Nerd Fonts
- Restores your original .zshrc and .gitconfig from backups (if available)

This does NOT remove:
- Homebrew (other tools may depend on it)
- Xcode Command Line Tools (other apps depend on it)

## Customization

Add your personal aliases, environment variables, and other customizations to the bottom of `~/.zshrc` in the "Custom Configuration" section.

## Troubleshooting

### Prompt looks broken (weird characters)

Make sure you set iTerm2's font to **MesloLGS Nerd Font** (Step 3 above).

### `nvm: command not found` or `pyenv: command not found`

Restart your terminal or run:

```bash
source ~/.zshrc
```

### `pyenv install` fails with build errors

Make sure Homebrew installed the build dependencies:

```bash
brew install openssl readline sqlite3 xz zlib tcl-tk
```

### Git asks for credentials every time

The `.gitconfig` uses macOS Keychain for credential storage. When you first push/pull, enter your credentials and check "Remember in Keychain".

For GitHub, you may need to create a Personal Access Token:
https://github.com/settings/tokens
