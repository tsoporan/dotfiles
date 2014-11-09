# ZSH Configuration.

HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=10000

unsetopt beep
bindkey -v

# Completion
zstyle :compinstall filename '/home/tsoporan/.zshrc'
autoload -Uz compinit
compinit

# Vars
export BROWSER='chromium'
export EDITOR='vim'

# Aliases
alias ls="ls --color -F"
alias ll="ls --color -lh"
alias vi="vim"


# Fish-style syntax highlighting.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
