#!/bin/zsh
export TERM=alacritty
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox-developer-edition

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
export GPG_TTY=$TTY

# ZSH Autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
