#
# tsoporan's zshrc config
#

# Pull in Antigen for managing plugins
source ~/scripts/antigen.zsh

antigen use oh-my-zsh

antigen bundle mafredri/zsh-async
antigen bundle git
antigen bundle common-aliases
antigen bundle docker
antigen bundle docker-compose
antigen bundle zdharma/fast-syntax-highlighting # Syntax highlighting
antigen bundle zsh-users/zsh-autosuggestions # Fish style autosuggestions
antigen bundle zsh-users/zsh-completions # Completions
antigen bundle zsh-users/zsh-history-substring-search # Nicer search
antigen bundle ael-code/zsh-colored-man-pages # Colored man pages

antigen theme lambda
antigen apply

# Various aliases
alias v="vim"
alias vi="vim"
alias ga="git add"
alias gstash="git stash"
alias gf="git fetch"
alias gp="git push"
alias gstat="git status"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --show-signature"
alias gcom="git commit -S --signoff"

export EDITOR=vim
export BROWSER=firefox-developer-edition

bindkey -v # vi mode
export KEYTIMEOUT=1 # Less lag

# FZF!
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Fix NPM install
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Local bin
PATH=$PATH:$HOME/.local/bin
