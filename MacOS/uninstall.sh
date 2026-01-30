#!/bin/bash
#
# Uninstall script - reverses setup.sh
# Run: chmod +x uninstall.sh && ./uninstall.sh
#

set -e

echo "🗑️  Dotfiles Uninstaller"
echo ""
echo "This will remove:"
echo "  - iTerm2"
echo "  - Oh My Zsh (and plugins)"
echo "  - NVM"
echo "  - MesloLGS Nerd Fonts"
echo "  - .zshrc and .gitconfig (restores backups if available)"
echo ""
echo "This will NOT remove:"
echo "  - Xcode Command Line Tools (other apps may depend on it)"
echo "  - Python (if you installed it from python.org)"
echo "  - Any Node.js versions installed via NVM"
echo ""

read -p "Are you sure you want to continue? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""

# ------------------------------------------------------------------------------
# Remove iTerm2
# ------------------------------------------------------------------------------
if [ -d "/Applications/iTerm.app" ]; then
    echo "🗑️  Removing iTerm2..."
    rm -rf "/Applications/iTerm.app"
    echo "   Removed /Applications/iTerm.app"
else
    echo "⏭️  iTerm2 not found, skipping"
fi

# ------------------------------------------------------------------------------
# Remove Oh My Zsh
# ------------------------------------------------------------------------------
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "🗑️  Removing Oh My Zsh..."
    rm -rf "$HOME/.oh-my-zsh"
    echo "   Removed ~/.oh-my-zsh"
else
    echo "⏭️  Oh My Zsh not found, skipping"
fi

# ------------------------------------------------------------------------------
# Remove NVM
# ------------------------------------------------------------------------------
if [ -d "$HOME/.nvm" ]; then
    echo "🗑️  Removing NVM..."
    rm -rf "$HOME/.nvm"
    echo "   Removed ~/.nvm"
    echo "   ⚠️  Note: Any Node.js versions installed via NVM are now gone"
else
    echo "⏭️  NVM not found, skipping"
fi

# ------------------------------------------------------------------------------
# Remove Nerd Fonts
# ------------------------------------------------------------------------------
FONT_DIR="$HOME/Library/Fonts"
FONTS_REMOVED=0

for font in MesloLGSNerdFont-Regular.ttf MesloLGSNerdFont-Bold.ttf MesloLGSNerdFont-Italic.ttf MesloLGSNerdFont-BoldItalic.ttf; do
    if [ -f "$FONT_DIR/$font" ]; then
        rm "$FONT_DIR/$font"
        FONTS_REMOVED=$((FONTS_REMOVED + 1))
    fi
done

if [ $FONTS_REMOVED -gt 0 ]; then
    echo "🗑️  Removed $FONTS_REMOVED Nerd Font files from ~/Library/Fonts"
else
    echo "⏭️  Nerd Fonts not found, skipping"
fi

# ------------------------------------------------------------------------------
# Restore .zshrc backup
# ------------------------------------------------------------------------------
echo ""
ZSHRC_BACKUP=$(ls -t "$HOME"/.zshrc.backup.* 2>/dev/null | head -1)

if [ -n "$ZSHRC_BACKUP" ]; then
    echo "📄 Found .zshrc backup: $ZSHRC_BACKUP"
    read -p "   Restore this backup? (y/N): " RESTORE_ZSHRC
    if [[ "$RESTORE_ZSHRC" =~ ^[Yy]$ ]]; then
        cp "$ZSHRC_BACKUP" "$HOME/.zshrc"
        echo "   ✅ Restored .zshrc from backup"
    else
        echo "   Skipped .zshrc restore"
        echo "   ⚠️  Your current .zshrc references Oh My Zsh which was removed"
        echo "   ⚠️  You may need to create a new .zshrc or restore manually"
    fi
else
    echo "⚠️  No .zshrc backup found"
    echo "   Your current .zshrc references Oh My Zsh which was removed"
    echo "   Creating a minimal .zshrc..."
    
    cat > "$HOME/.zshrc" << 'EOF'
# Minimal .zshrc (created by uninstall.sh)
export PATH="$HOME/bin:/usr/local/bin:$PATH"

alias ll="ls -la"
EOF
    echo "   ✅ Created minimal ~/.zshrc"
fi

# ------------------------------------------------------------------------------
# Restore .gitconfig backup
# ------------------------------------------------------------------------------
GITCONFIG_BACKUP=$(ls -t "$HOME"/.gitconfig.backup.* 2>/dev/null | head -1)

if [ -n "$GITCONFIG_BACKUP" ]; then
    echo ""
    echo "📄 Found .gitconfig backup: $GITCONFIG_BACKUP"
    read -p "   Restore this backup? (y/N): " RESTORE_GITCONFIG
    if [[ "$RESTORE_GITCONFIG" =~ ^[Yy]$ ]]; then
        cp "$GITCONFIG_BACKUP" "$HOME/.gitconfig"
        echo "   ✅ Restored .gitconfig from backup"
    else
        echo "   Skipped .gitconfig restore (current .gitconfig left in place)"
    fi
fi

# ------------------------------------------------------------------------------
# Done
# ------------------------------------------------------------------------------
echo ""
echo "════════════════════════════════════════════════════════════════════════════"
echo "✅ Uninstall complete!"
echo "════════════════════════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
echo "  2. You're back to the default macOS Terminal/zsh setup"
echo ""
echo "To reinstall, run: ./setup.sh"
echo ""
