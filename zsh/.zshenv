#!/bin/zsh
export EDITOR=nvim
export BROWSER=brave


# NPM + NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# FZF
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --no-info'
export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude .git"
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="fd --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="
  --prompt '∷ '
  --pointer '▶ '
  --marker '⇒ '
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="
  --prompt '∷ '
  --pointer '▶ '
  --marker '⇒ '
"

# ZSH
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTFILE=~/.zhistory
export KEYTIMEOUT=1

# GPG
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# ZSH Autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ffffff,bg=#ff5f00,bold,underline"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$NPM_PACKAGES/bin:$GOBIN:$PATH
