#
# tsoporan's zshrc config
# 

# Pull in Antigen for managing plugins
source ~/scripts/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle common-aliases
antigen bundle docker
antigen bundle docker-compose

antigen bundle zsh-users/zsh-syntax-highlighting # Syntax highlighting
antigen bundle zsh-users/zsh-autosuggestions # Fish style autosuggestions
antigen bundle zsh-users/zsh-completions # Completions
antigen bundle zsh-users/zsh-history-substring-search # Nicer search

antigen theme lambda

# All done
antigen apply

# Customize to your needs...
alias lock="xscreensaver-command -lock"
alias startx="ssh-agent startx"
alias v="vim"
alias vi="vim"
alias gfetch="git fetch"
alias gstat="git status"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --show-signature"
alias gcom="git commit -S --signoff"

export EDITOR=vim
export BROWSER=firefox-developer-edition

# Good fortune
if [ `which fortune` ]; then
    fortune
    echo ""
fi

bindkey -v #vi mode
export KEYTIMEOUT=1 # Less lag

# FZF! 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Fix NPM install
PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules

# NVM
source /usr/share/nvm/init-nvm.sh

# Color man: https://wiki.archlinux.org/index.php/Color_output_in_console#man
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
