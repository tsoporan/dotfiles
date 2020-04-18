# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###########################
# tsoporans zshrc config  #
###########################

# Perf profile
# zmodload zsh/zprof
autoload -Uz compinit && compinit

# Make git completion bearable
__git_files () {
    _wanted files expl 'local files' _files
}

# Plugins
# Syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Auto suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Better history search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Z lua
eval "$(lua $HOME/.config/z/z.lua --init zsh)"

# vi mode
bindkey -v
# Re-map autosuggest-accept (default arrow key), ctrl+space
bindkey '^ ' autosuggest-accept

# Still use ctrl+a/ctrl+e for beginning/end of line (emacs)
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line

export LANG=en_US.UTF-8

# Various aliases
alias v="nvim"
alias vim="nvim"
alias e="emacsclient -nw"
alias ls="exa"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias rm="rm -i"
alias ..="cd .."
alias ~="cd ~"
alias /="cd /"
alias cp="cp -i"
alias df="df -h"
alias free="free -m"
alias more="less"
alias bc="bc -l"
alias sha1="openssl sha1"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias dco='docker-compose'
alias dock='docker'
alias zi='z -I' # Use fzf
alias zb='cd -' # Jump back
# Git, use gitconfig for less frequent commands
alias g="git"
alias c="git commit -S --signoff"
alias a="git add -p"
alias ai="git add -i"
alias co="git checkout"
alias s="git status"
alias sta="git stash"
alias p="git push"
alias pf="git push --force-with-lease"
alias pu="git pull"
alias fe="git fetch"
alias fep="git fetch --prune"
alias d="git diff"
alias ds="git diff --staged"
alias mer="git merge"

export EDITOR=nvim
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

# termquotes get | cowsay -d

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE


## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

setopt interactivecomments # I want my bash comments

# Gruvbox (term colors) pallette
source "$HOME/.config/gruvbox/gruvbox_256palette.sh"


# Powerlevel10k theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# zprof
# exit
