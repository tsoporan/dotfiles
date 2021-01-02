# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files source by it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v4/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
zstyle ':z4h:'                auto-update      'ask'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:'                auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey'         keyboard         'pc'
# When fzf menu opens on TAB, another TAB moves the cursor down ('tab:down')
# or accepts the selection and triggers another TAB-completion ('tab:repeat')?
zstyle ':z4h:fzf-complete'    fzf-bindings     'tab:down'
# When fzf menu opens on Alt+Down, TAB moves the cursor down ('tab:down')
# or accepts the selection and triggers another Alt+Down ('tab:repeat')?
zstyle ':z4h:cd-down'         fzf-bindings     'tab:down'
# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char     'accept'

# Send these files over to the remote host when connecting over ssh.
# Multiple files can be listed here.
# zstyle ':z4h:ssh:*'           send-extra-files '~/.iterm2_shell_integration.zsh'
# Disable automatic teleportation of z4h over ssh when connecting to some-host.
# This makes `ssh some-host` equivalent to `command ssh some-host`.
zstyle ':z4h:ssh:some-host'   passthrough      'yes'

# Move the cursor to the end when Up/Down fetches a command from history?
zstyle ':zle:up-line-or-beginning-search'   leave-cursor 'yes'
zstyle ':zle:down-line-or-beginning-search' leave-cursor 'yes'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Export environment variables.
export GPG_TTY=$TTY

# Extend PATH.
path=(~/bin $path)

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source $Z4H/ohmyzsh/ohmyzsh/lib/diagnostics.zsh
# z4h source $Z4H/ohmyzsh/ohmyzsh/plugins/emoji-clock/emoji-clock.plugin.zsh
# fpath+=($Z4H/ohmyzsh/ohmyzsh/plugins/supervisor)

# Source additional local files if they exist.
# z4h source ~/.iterm2_shell_integration.zsh

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/  # undo the last command line change
z4h bindkey redo Alt+/   # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Replace `ssh` with `z4h ssh` to automatically teleport z4h to remote hosts.
function ssh() { z4h ssh "$@" }

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -n $z4h_win_home ]] && hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu


# My config

#set history size
export HISTSIZE=100000
#save history after logout
export SAVEHIST=100000
#history file
export HISTFILE=~/.zhistory
## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

export npm_config_prefix=~/.node_modules

export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'

export EDITOR=nvim
export BROWSER=firefox-developer-edition

export LANG=en_US.UTF-8

# Various aliases
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
alias pl="git pull"
alias fe="git fetch"
alias fep="git fetch --prune"
alias d="git diff"
alias ds="git diff --staged"
alias mer="git merge"
alias open_ports="ss -lntu"

# Re-map autosuggest-accept (default arrow key), ctrl+space
bindkey '^ ' autosuggest-accept

# Gruvbox (term colors) pallette
source "$HOME/.config/gruvbox/gruvbox_256palette.sh"

# (Z)oxide
eval "$(zoxide init zsh)"
