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
    zsh-autosuggestions
    zsh-syntax-highlighting
    colored-man-pages
    nvm
    docker
)

source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------------------------
# NVM (Node Version Manager)
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ------------------------------------------------------------------------------
# Pyenv (Python Version Manager)
# ------------------------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# ------------------------------------------------------------------------------
# PATH additions
# ------------------------------------------------------------------------------
# Add local binaries to PATH
export PATH="$HOME/.local/bin:$PATH"

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

# Docker aliases
alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias dc="docker compose"

# ------------------------------------------------------------------------------
# Editor
# ------------------------------------------------------------------------------
export EDITOR="code"

# ------------------------------------------------------------------------------
# Custom Configuration
# Add your own customizations below this line
# ------------------------------------------------------------------------------
