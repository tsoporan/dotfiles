#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#Personal crap.

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

#Git Aliases
alias gl='git log --pretty=format:"%Cgreen%h %Creset %s %Cblueby %an (%ar) %Cred %d" --graph'


#PS1="\[\e[1;32m\]\u \[\e[1;34m\]\w\[\e[1;37m\] $\[\033[0m\] "

PS1='\[\e[0;32m\]\u\[\e[1;32m\]@\h \[\e[1;35m\]`date +%m-%d-%Y\ %H:%M:%S`\[\e[0;0m\] \[\e[0;35m\]\w > \[\e[0;0m\]'                                                 

EDITOR="vim"
BROWSER="chromium"

alias sv="sudo $EDITOR"
alias v="$EDITOR"

