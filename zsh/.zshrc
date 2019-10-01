#
# tsoporan's zshrc config (based on ohmyzsh)
#

# Path to your oh-my-zsh installation.
export ZSH="/home/tsoporan/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

ZSH_THEME="spaceship"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=5

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

plugins=(git dotenv colored-man-pages colorize docker aws)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8


# Various aliases
alias v="vim"
alias e="emacsclient -nw"
alias l="exa -al"
alias g="git"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias rm="rm -i"

export EDITOR=vim
export BROWSER=firefox-developer-edition

bindkey -v # vi mode
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

# Setting fd as the default source for fzf, search hidden and symlinks exclude git
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
# Colors
export FZF_DEFAULT_OPTS="--ansi"

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Z
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# NPM
NPM_CONFIG_PREFIX=~/.npm-global

# Syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Fish style auto suggests
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Re-map autosuggest-accept (default arrow key)
bindkey '^ ' autosuggest-accept

# Spaceship theme config
SPACESHIP_PROMPT_ORDER=(
  time
  user
  dir
  host
  git
  docker
  venv
  pyenv
  kubecontext
  terraform
  aws
  exec_time
  line_sep
  jobs
  exit_code
  char
)
SPACESHIP_DOCKER_SYMBOL=🐳·

termquotes get | cowsay -f vader
