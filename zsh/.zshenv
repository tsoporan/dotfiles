#!/bin/zsh

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export TERM=xterm
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=brave


# NPM + NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# FZF
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="fd --hidden --follow --exclude .git"
export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude .git"

# ZSH
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTFILE=~/.zhistory
export KEYTIMEOUT=1

# GPG
export GPG_TTY=$(tty)

# ZSH Autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ffffff,bg=#ff5f00,bold,underline"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)


# Not compatible with nvm
# export NPM_PACKAGES="${HOME}/.node_modules"
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$NPM_PACKAGES/bin:$GOBIN:$PATH
