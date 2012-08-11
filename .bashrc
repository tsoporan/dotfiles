#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#personal crap.

alias ls='ls --color=auto'
alias grep='grep --color=auto -I'
alias egrep="egrep --color=auto"
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'

alias ~="cd $HOME"
alias ..='cd ..'
alias ...="cd ../../"
alias cd..="cd .."
alias cls="clear;ls"

alias ls='ls -hF --color=always'
alias lr='ls -R'
alias ll='ls -l'

alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'

alias vi='vim'

#Git Aliases
alias gcomm='git commit'
alias gadd='git add'
alias gpush='git push'
alias gstat="git status"
alias glog="git log --graph --decorate --pretty=oneline --abbrev-commit --color"
alias gdiff="git diff --color"
alias glog='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gdiff='git diff --color'
alias gstat='git status'

export EDITOR="vim"
export BROWSER="chromium"

alias sv="sudo $EDITOR"
alias v="$EDITOR"
