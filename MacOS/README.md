# Dotfiles for macOS (Apple Silicon M1-M4)

Personal dotfiles and setup script for a fresh macOS installation on Apple Silicon Macs.

**No Homebrew required!**

## What Gets Installed

| Tool | Description |
|------|-------------|
| **iTerm2** | Better terminal for macOS |
| **Oh My Zsh** | Zsh framework with themes and plugins |
| **agnoster theme** | Powerline-style prompt (requires Nerd Font) |
| **zsh-syntax-highlighting** | Syntax highlighting for commands |
| **zsh-autosuggestions** | Fish-like autosuggestions |
| **NVM** | Node.js version manager |
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

Download Python from [python.org/downloads](https://www.python.org/downloads/):

1. Download the **macOS 64-bit universal2 installer**
2. Run the installer
3. Verify with: `python3 --version`

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

The script will backup existing dotfiles before overwriting.

## Customization

Add your personal aliases, environment variables, and other customizations to the bottom of `~/.zshrc` in the "Custom Configuration" section.

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
- NVM
- Nerd Fonts
- Restores your original .zshrc and .gitconfig from backups (if available)

This does NOT remove:
- Xcode Command Line Tools (other apps depend on it)
- Python (if installed from python.org)

## Why No Homebrew?

This setup avoids Homebrew by:

- Using **Xcode Command Line Tools** for Git
- Installing **Oh My Zsh** and **NVM** via their official curl scripts
- Downloading **iTerm2** directly from iterm2.com
- Using **python.org installers** instead of pyenv
- Downloading **Nerd Fonts** directly from GitHub

If you later decide you want Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Troubleshooting

### Prompt looks broken (weird characters)

Make sure you set iTerm2's font to **MesloLGS Nerd Font** (Step 3 above).

### `nvm: command not found`

Restart your terminal or run:

```bash
source ~/.zshrc
```

### Git asks for credentials every time

The `.gitconfig` uses macOS Keychain for credential storage. When you first push/pull, enter your credentials and check "Remember in Keychain".

For GitHub, you may need to create a Personal Access Token:
https://github.com/settings/tokens
