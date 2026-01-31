#!/bin/bash
#
# Dotfiles setup script for macOS (Apple Silicon M1-M4)
# Uses Homebrew only for pyenv (Python version manager)
#
# Run: chmod +x setup.sh && ./setup.sh
#

set -e

echo "🚀 Starting macOS setup for Apple Silicon..."
echo ""

# ------------------------------------------------------------------------------
# Gather user info upfront
# ------------------------------------------------------------------------------
read -p "Enter your Git email address: " GIT_EMAIL

if [ -z "$GIT_EMAIL" ]; then
    echo "❌ Email is required for Git configuration."
    exit 1
fi

read -p "Enter your Git name [Jeffrey Yang]: " GIT_NAME
GIT_NAME="${GIT_NAME:-Jeffrey Yang}"

echo ""

# ------------------------------------------------------------------------------
# Xcode Command Line Tools (includes Git)
# ------------------------------------------------------------------------------
if ! xcode-select -p &>/dev/null; then
    echo "📦 Installing Xcode Command Line Tools (includes Git)..."
    xcode-select --install
    echo "⏳ Please complete the Xcode installation, then re-run this script."
    exit 1
fi

echo "✅ Xcode Command Line Tools installed (includes Git)"

# ------------------------------------------------------------------------------
# Homebrew (for pyenv only)
# ------------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew (needed for pyenv)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure Homebrew is in PATH for Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "✅ Homebrew installed"

# ------------------------------------------------------------------------------
# iTerm2
# ------------------------------------------------------------------------------
if [ ! -d "/Applications/iTerm.app" ]; then
    echo "📦 Installing iTerm2..."
    curl -fsSL -o /tmp/iTerm2.zip "https://iterm2.com/downloads/stable/iTerm2-3_6_6.zip"
    unzip -q /tmp/iTerm2.zip -d /tmp/
    mv /tmp/iTerm.app /Applications/
    rm /tmp/iTerm2.zip
    echo "✅ iTerm2 installed to /Applications"
else
    echo "✅ iTerm2 already installed"
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
FONT_DIR="$HOME/Library/Fonts"
FONT_NAME="MesloLGSNerdFont-Regular.ttf"

if [ ! -f "$FONT_DIR/$FONT_NAME" ]; then
    echo "🔤 Installing Nerd Fonts (MesloLGS)..."
    curl -fsSL -o "$FONT_DIR/MesloLGSNerdFont-Regular.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/MesloLGSNerdFont-Regular.ttf"
    curl -fsSL -o "$FONT_DIR/MesloLGSNerdFont-Bold.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Bold/MesloLGSNerdFont-Bold.ttf"
    curl -fsSL -o "$FONT_DIR/MesloLGSNerdFont-Italic.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Italic/MesloLGSNerdFont-Italic.ttf"
    curl -fsSL -o "$FONT_DIR/MesloLGSNerdFont-BoldItalic.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Bold-Italic/MesloLGSNerdFont-BoldItalic.ttf"
    echo "✅ Fonts installed to ~/Library/Fonts"
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
# Pyenv (Python Version Manager) via Homebrew
# ------------------------------------------------------------------------------
if ! command -v pyenv &>/dev/null; then
    echo "🐍 Installing pyenv and build dependencies..."
    brew install pyenv openssl readline sqlite3 xz zlib tcl-tk
else
    echo "✅ pyenv already installed"
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
echo "Next steps:"
echo ""
echo "  1. Open iTerm2 (installed to /Applications)"
echo ""
echo "  2. Configure iTerm2 font:"
echo "     iTerm2 → Settings → Profiles → Text → Font → 'MesloLGS Nerd Font'"
echo ""
echo "  3. Restart iTerm2 or run: source ~/.zshrc"
echo ""
echo "  4. Install Node.js:"
echo "     nvm install --lts"
echo ""
echo "  5. Install Python:"
echo "     pyenv install 3.12"
echo "     pyenv global 3.12"
echo ""
