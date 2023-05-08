#
# Plugins / Addons

# Use antigen to manage plugins
source /usr/share/zsh/share/antigen.zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-completions

antigen apply

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # Init FZF
source ~/.fzf/fzf-git.sh

# Z alternative, jump dirs
eval "$(zoxide init zsh)" 

#
# Theme
source "$HOME/.config/gruvbox/gruvbox_256palette.sh"

#
# Nav
setopt auto_cd # Switch dir by name

# Key bindings

#bindkey -e 
bindkey -v # Vi mode
bindkey "^ " autosuggest-accept # Re-map autosuggest-accept (default arrow key), ctrl+space
#bindkey "^A" vi-beginning-of-line # Ctrl-a/e start/end
#bindkey "^E" vi-end-of-line
#bindkey -M vicmd 'k' history-substring-search-up
#bindkey -M vicmd 'j' history-substring-search-down

#
# History
#
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

#
# Aliases
#
alias jj="jobs"
alias nv="nvim"
alias v="nvim"
alias e="emacsclient -nc"
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
alias dco='docker compose'
alias dock='docker'
alias zi='z -I' # Use fzf
alias zb='cd -' # Jump back
alias g="git"
alias c="git commit -S --signoff"
alias a="git add -p"
alias ai="git add -i"
alias co="git checkout"
alias cob="git checkout -b"
alias s="git status"
alias sta="git stash"
alias p="git push"
alias po='git push origin "$(git symbolic-ref --short HEAD)"'
alias pf="git push --force-with-lease"
alias pl="git pull"
alias fe="git fetch"
alias fep="git fetch --prune"
alias d="git diff"
alias ds="git diff --staged"
alias mer="git merge"
alias open_ports="ss -lntu"

eval "$(starship init zsh)"
