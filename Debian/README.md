# Dotfiles for Debian/Ubuntu

Personal dotfiles and setup script for Debian-based Linux distributions (Debian, Ubuntu, etc.).

## What Gets Installed

| Tool | Description |
|------|-------------|
| **Zsh** | Shell (set as default) |
| **Oh My Zsh** | Zsh framework with themes and plugins |
| **agnoster theme** | Powerline-style prompt (requires Nerd Font) |
| **zsh-syntax-highlighting** | Syntax highlighting for commands |
| **zsh-autosuggestions** | Fish-like autosuggestions |
| **colored-man-pages** | Colorized man pages |
| **NVM** | Node.js version manager |
| **Pyenv** | Python version manager |
| **Docker** | Container runtime (native, no Docker Desktop) |
| **MesloLGS Nerd Font** | Powerline-compatible font |
| **Git** | Version control |
| **Build tools** | gcc, make, etc. (for compiling Python) |

## Setup Instructions

### Step 1: Clone this repo

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/Projects/dotfiles
```

### Step 2: Run the setup script

```bash
cd ~/Projects/dotfiles/Debian
chmod +x setup.sh
./setup.sh
```

The script will prompt you for your Git email address.

### Step 3: Log out and log back in

This is required to:
- Make Zsh your default shell
- Use Docker without sudo

### Step 4: Configure terminal font

**GNOME Terminal:**
1. Open Terminal
2. Go to **Preferences** (hamburger menu → Preferences)
3. Select your profile
4. Check **Custom font**
5. Select **MesloLGS Nerd Font** size 11 or 12

**Other terminals:** Set font to "MesloLGS Nerd Font" in preferences.

### Step 5: Install Node.js

```bash
nvm install --lts
```

### Step 6: Install Python

```bash
pyenv install 3.12
pyenv global 3.12
```

### Step 7: Verify Docker

```bash
docker run hello-world
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
cd Debian
./setup.sh
```

The script is idempotent — it will skip anything already installed and backup existing dotfiles before overwriting.

## Uninstalling

```bash
cd ~/Projects/dotfiles/Debian
chmod +x uninstall.sh
./uninstall.sh
```

This removes:
- Oh My Zsh and plugins
- NVM and pyenv
- Nerd Fonts
- Restores your original .zshrc and .gitconfig from backups

This does NOT remove:
- Zsh, Git, Docker (system packages)
- Build dependencies (other tools may use them)

## Docker Usage

Docker is installed with the Docker Compose plugin (v2). Use:

```bash
# Run containers
docker run -it ubuntu bash

# Docker Compose (new v2 syntax)
docker compose up -d
docker compose down

# Useful aliases (included in .zshrc)
dps    # docker ps
dpa    # docker ps -a
di     # docker images
dc     # docker compose
```

## Customization

Add your personal customizations to the bottom of `~/.zshrc` in the "Custom Configuration" section.

## Troubleshooting

### Prompt looks broken (weird characters)

Set your terminal font to **MesloLGS Nerd Font**.

### `nvm: command not found` or `pyenv: command not found`

Log out and log back in, or run:

```bash
source ~/.zshrc
```

### `pyenv install` fails

Make sure build dependencies are installed:

```bash
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev \
    libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

### Docker permission denied

Make sure you logged out and back in after setup. Verify you're in the docker group:

```bash
groups
```

If "docker" is not listed, run:

```bash
sudo usermod -aG docker $USER
```

Then log out and back in.

### Zsh is not my default shell

Run:

```bash
chsh -s $(which zsh)
```

Then log out and back in.
