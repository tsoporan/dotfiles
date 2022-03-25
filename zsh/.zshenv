#!/bin/zsh
export TERM=alacritty
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox


# NPM
export NPM_CONFIG_PREFIX=~/.node_modules

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


export NPM_PACKAGES="${HOME}/.node_modules"
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$NPM_PACKAGES/bin:$GOBIN:$PATH
