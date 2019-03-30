#
# tsoporan's zshrc config
#

# Profiling
#zmodload zsh/zprof

# Use antibody
export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"
source ~/.zsh_plugins.sh

# Some fun
fortune | cowsay -f vader | lolcat

# Various aliases
alias v="vim"
alias lx="exa"
alias ll="exa -al"
alias gdiff="git diff"
alias gadd="git add"
alias gstash="git stash"
alias gstat="git status"
alias gf="git fetch"
alias gp="git push"
alias gstat="git status"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --show-signature"
alias gcom="git commit -S --signoff"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias rm="rm -i"

export EDITOR=vim
export BROWSER=firefox-developer-edition

bindkey -v # vi mode
export KEYTIMEOUT=1 # Less lag

# FZF!
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Fix NPM install
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Local bin
PATH=$PATH:$HOME/.local/bin

# Keychain
eval $(keychain --eval --quiet id_rsa)

# Go
export GOPATH=$HOME/projects/gocode

# GPG display, can lead to odd signing error
export GPG_TTY=$(tty)

# Setting fd as the default source for fzf, search hidden and symlinks exclude git
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
# Colors
export FZF_DEFAULT_OPTS="--ansi"

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export PURE_PROMPT_SYMBOL="λ"

# Z
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh


# Correct prev command
eval $(thefuck --alias fuu)

# NPM install
PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules

# End profiling
#zprof
