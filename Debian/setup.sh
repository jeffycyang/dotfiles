#!/bin/bash
#
# Dotfiles setup script for Debian/Ubuntu
#
# Run: chmod +x setup.sh && ./setup.sh
#

set -e

echo "🚀 Starting Debian/Ubuntu setup..."
echo ""

# ------------------------------------------------------------------------------
# Check if running as root (we need sudo for apt)
# ------------------------------------------------------------------------------
if [ "$EUID" -eq 0 ]; then
    echo "❌ Please run this script as a regular user, not root."
    echo "   The script will use sudo when needed."
    exit 1
fi

# ------------------------------------------------------------------------------
# Gather user info upfront
# ------------------------------------------------------------------------------
read -p "Enter your Git email address: " GIT_EMAIL

if [ -z "$GIT_EMAIL" ]; then
    echo "❌ Email is required for Git configuration."
    exit 1
fi

read -p "Enter your Git name [Jeff Y.C. Yang]: " GIT_NAME
GIT_NAME="${GIT_NAME:-Jeff Y.C. Yang}"

echo ""

# ------------------------------------------------------------------------------
# Update apt
# ------------------------------------------------------------------------------
echo "📦 Updating apt..."
sudo apt update

# ------------------------------------------------------------------------------
# Install essential packages
# ------------------------------------------------------------------------------
echo "📦 Installing essential packages..."
sudo apt install -y \
    git \
    curl \
    wget \
    zsh \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    fontconfig

echo "✅ Essential packages installed"

# ------------------------------------------------------------------------------
# Set Zsh as default shell
# ------------------------------------------------------------------------------
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
    echo "   ⚠️  You'll need to log out and back in for this to take effect"
else
    echo "✅ Zsh is already the default shell"
fi

# ------------------------------------------------------------------------------
# Oh My Zsh
# ------------------------------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🐚 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh already installed"
fi

# ------------------------------------------------------------------------------
# Zsh Plugins
# ------------------------------------------------------------------------------
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "📦 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "✅ zsh-syntax-highlighting already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "📦 Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "✅ zsh-autosuggestions already installed"
fi

# ------------------------------------------------------------------------------
# Powerline/Nerd Fonts (for agnoster theme)
# ------------------------------------------------------------------------------
FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="MesloLGSNerdFont-Regular.ttf"

mkdir -p "$FONT_DIR"

if [ ! -f "$FONT_DIR/$FONT_NAME" ]; then
    echo "🔤 Installing Nerd Fonts (MesloLGS)..."
    curl -fsSL -o "$FONT_DIR/MesloLGSNerdFont-Regular.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/MesloLGSNerdFont-Regular.ttf"
    curl -fsSL -o "$FONT_DIR/MesloLGSNerdFont-Bold.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Bold/MesloLGSNerdFont-Bold.ttf"
    curl -fsSL -o "$FONT_DIR/MesloLGSNerdFont-Italic.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Italic/MesloLGSNerdFont-Italic.ttf"
    curl -fsSL -o "$FONT_DIR/MesloLGSNerdFont-BoldItalic.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Bold-Italic/MesloLGSNerdFont-BoldItalic.ttf"
    
    # Refresh font cache
    fc-cache -fv
    echo "✅ Fonts installed to ~/.local/share/fonts"
else
    echo "✅ Nerd Fonts already installed"
fi

# ------------------------------------------------------------------------------
# NVM (Node Version Manager)
# ------------------------------------------------------------------------------
if [ ! -d "$HOME/.nvm" ]; then
    echo "📦 Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
    echo "✅ NVM already installed"
fi

# ------------------------------------------------------------------------------
# Pyenv (Python Version Manager)
# ------------------------------------------------------------------------------
if [ ! -d "$HOME/.pyenv" ]; then
    echo "🐍 Installing pyenv..."
    curl https://pyenv.run | bash
else
    echo "✅ pyenv already installed"
fi

# ------------------------------------------------------------------------------
# Docker
# ------------------------------------------------------------------------------
if ! command -v docker &>/dev/null; then
    echo "🐳 Installing Docker..."
    
    # Remove old versions if any
    sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
    
    # Install prerequisites
    sudo apt install -y ca-certificates gnupg
    
    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    
    # Add the repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Add user to docker group (so you can run docker without sudo)
    sudo usermod -aG docker "$USER"
    
    echo "✅ Docker installed"
    echo "   ⚠️  Log out and back in to use Docker without sudo"
else
    echo "✅ Docker already installed"
fi

# ------------------------------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "📝 Installing .zshrc..."
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    echo "   (Backed up existing .zshrc)"
fi
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

echo "📝 Installing .gitconfig..."
if [ -f "$HOME/.gitconfig" ]; then
    cp "$HOME/.gitconfig" "$HOME/.gitconfig.backup.$(date +%Y%m%d%H%M%S)"
    echo "   (Backed up existing .gitconfig)"
fi
cp "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"

# Configure git with user input
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
echo "   Configured Git as: $GIT_NAME <$GIT_EMAIL>"

# ------------------------------------------------------------------------------
# Done
# ------------------------------------------------------------------------------
echo ""
echo "════════════════════════════════════════════════════════════════════════════"
echo "✅ Setup complete!"
echo "════════════════════════════════════════════════════════════════════════════"
echo ""
echo "⚠️  IMPORTANT: Log out and log back in to apply:"
echo "   - Zsh as your default shell"
echo "   - Docker group membership (run docker without sudo)"
echo ""
echo "After logging back in:"
echo ""
echo "  1. Configure your terminal font to 'MesloLGS Nerd Font'"
echo "     (GNOME Terminal: Preferences → Profile → Custom font)"
echo ""
echo "  2. Install Node.js:"
echo "     nvm install --lts"
echo ""
echo "  3. Install Python:"
echo "     pyenv install 3.12"
echo "     pyenv global 3.12"
echo ""
echo "  4. Verify Docker:"
echo "     docker run hello-world"
echo ""
