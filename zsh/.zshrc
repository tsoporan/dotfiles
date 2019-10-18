###########################
# tsoporans zshrc config  #
#                Oct 2019 #
###########################

# Profile
# zmodload zsh/zprof

# Zplugin
source "$HOME/.zplugin/bin/zplugin.zsh"

autoload -Uz _zplugin

(( ${+_comps} )) && _comps[zplugin]=_zplugin

# Plugins
zplugin light "romkatv/powerlevel10k"
zplugin light "zsh-users/zsh-autosuggestions"
zplugin light "zsh-users/zsh-history-substring-search"
zplugin light "zsh-users/zsh-completions"
zplugin light "zdharma/fast-syntax-highlighting"
zplugin light "skywind3000/z.lua" # Faster z.sh
zplugin light "softmoth/zsh-vim-mode"


# vi mode
bindkey -v
# Re-map autosuggest-accept (default arrow key), ctrl+space
bindkey '^ ' autosuggest-accept

export LANG=en_US.UTF-8

# Various aliases
alias v="vim"
alias e="emacsclient -nw"
alias ls="exa"
alias g="git"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias rm="rm -i"

export EDITOR=vim
export BROWSER=firefox-developer-edition

export KEYTIMEOUT=1 # Less lag

# FZF!
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Local bin
PATH=$PATH:$HOME/.local/bin:$HOME/.npm-global/bin

# Keychain
eval $(keychain --eval --quiet id_rsa)

# Go
export GOPATH=$HOME/projects/gocode

# GPG display, can lead to odd signing error
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# Setting fd as the default source for fzf, search hidden and symlinks exclude git
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
# Colors
export FZF_DEFAULT_OPTS="--ansi"

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# NPM
NPM_CONFIG_PREFIX=~/.npm-global

termquotes get | cowsay -d

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# zprof
# exit
