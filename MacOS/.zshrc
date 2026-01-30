# ------------------------------------------------------------------------------
# Oh My Zsh Configuration
# ------------------------------------------------------------------------------

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme - agnoster requires Powerline/Nerd fonts
ZSH_THEME="agnoster"

# Plugins
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------------------------
# NVM (Node Version Manager)
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ------------------------------------------------------------------------------
# Python (python.org installer)
# ------------------------------------------------------------------------------
# The python.org installer adds Python to /usr/local/bin (Intel) or
# /Library/Frameworks/Python.framework/Versions/X.Y/bin (Universal)
# Both should be in PATH by default after installation.

# ------------------------------------------------------------------------------
# PATH additions
# ------------------------------------------------------------------------------
# Add local node_modules binaries to PATH
export PATH="./node_modules/.bin:$PATH"

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------
alias ll="ls -la"
alias gs="git status"
alias gp="git pull"
alias gc="git commit"
alias gco="git checkout"

# ------------------------------------------------------------------------------
# Editor
# ------------------------------------------------------------------------------
export EDITOR="code"

# ------------------------------------------------------------------------------
# Custom Configuration
# Add your own customizations below this line
# ------------------------------------------------------------------------------
