# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zshrc config

#
# Plugins / Addons
#
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # Init FZF
_fzf_compgen_dir() {
  fd --type d . "$1"
}

eval "$(zoxide init zsh)" # Z alternative, jump dirs

#
# Theme
#
source "$HOME/.config/gruvbox/gruvbox_256palette.sh"

#
# Nav
#
setopt auto_cd # Switch dir by name

#
# Prompt
#
# TODO

#
# Completions
#
setopt extendedglob 
setopt automenu
setopt alwaystoend

# Speed up completions, see: https://lethalman.blogspot.com/2009/10/speeding-up-zsh-completion.html
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# autoload -Uz compinit
# compinit


#
# Key bindings
#
bindkey -v # Vi mode
bindkey "^ " autosuggest-accept # Re-map autosuggest-accept (default arrow key), ctrl+space
bindkey "^A" vi-beginning-of-line # Ctrl-a/e start/end
bindkey "^E" vi-end-of-line

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
alias v="nvim"
alias vim="nvim"
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
alias dco='docker-compose'
alias dock='docker'
alias zi='z -I' # Use fzf
alias zb='cd -' # Jump back
alias g="git"
alias c="git commit -S --signoff"
alias a="git add -p"
alias ai="git add -i"
alias co="git checkout"
alias s="git status"
alias sta="git stash"
alias p="git push"
alias pf="git push --force-with-lease"
alias pl="git pull"
alias fe="git fetch"
alias fep="git fetch --prune"
alias d="git diff"
alias ds="git diff --staged"
alias mer="git merge"
alias open_ports="ss -lntu"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
