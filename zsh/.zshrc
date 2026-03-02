# ==============================================================================
# tsoporan's zshrc
# Last updated: 2025-12-26
# ==============================================================================
#
# Shell startup order: .zshenv -> .zshrc (interactive) -> .zlogin
# Environment variables are in .zshenv, interactive config is here.
#
# Dependencies:
#   - antidote (plugin manager)
#   - starship (prompt)
#   - zoxide (smart cd)
#   - atuin (history search)
#   - direnv (per-directory env)
#   - fzf, fd, bat, eza (modern CLI tools)
#   - mise (runtime version manager - replaces nvm/pyenv/etc)
#
# ==============================================================================

# zmodload zsh/zprof  # Uncomment to profile startup time

# ------------------------------------------------------------------------------
# Plugin Manager (Antidote)
# ------------------------------------------------------------------------------
[[ -e ${ZDOTDIR:-~}/.antidote ]] ||
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# ------------------------------------------------------------------------------
# FZF Integration
# ------------------------------------------------------------------------------
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# ------------------------------------------------------------------------------
# Key Bindings
# ------------------------------------------------------------------------------
bindkey -v                        # Vi mode
bindkey "^ " autosuggest-accept   # Ctrl+Space accepts autosuggestion
export KEYTIMEOUT=1               # Reduce mode switch delay (set in .zshenv too)

# ------------------------------------------------------------------------------
# Shell Options
# ------------------------------------------------------------------------------
# Navigation
setopt auto_cd                    # cd by typing directory name

# History - comprehensive deduplication and sharing
setopt extended_history           # Record timestamp of command
setopt hist_expire_dups_first     # Delete duplicates first when HISTFILE exceeds HISTSIZE
setopt hist_ignore_all_dups       # Remove older duplicate entries
setopt hist_ignore_space          # Ignore commands starting with space
setopt hist_verify                # Show command before running with history expansion
setopt inc_append_history         # Add commands immediately
setopt share_history              # Share history between sessions

# ------------------------------------------------------------------------------
# Aliases - General
# ------------------------------------------------------------------------------
alias jj="jobs"
alias v="nvim"
alias e="emacsclient -nc"
alias rm="rm -i"
alias cp="cp -i"
alias ..="cd .."
alias ~="cd ~"
alias /="cd /"
alias df="df -h"
alias free="free -m"
alias more="less"
alias bc="bc -l"
alias sha1="openssl sha1"

# Modern CLI replacements
alias l="eza --icons=auto -s accessed --group-directories-first"
alias ls="eza --icons=auto -s accessed --group-directories-first"
alias ll="eza --icons=auto -la -s accessed --group-directories-first"
alias tree="eza --tree --icons=auto"
alias cat="bat --paging=never"
alias grep="rg"
alias fgrep="rg -F"
alias egrep="rg"

# ------------------------------------------------------------------------------
# Aliases - Git (short and sweet)
# ------------------------------------------------------------------------------
alias g="git"
alias s="git status"
alias a="git add -p"
alias ai="git add -i"
alias c="git commit -S --signoff"
alias co="git checkout"
alias d="git diff"
alias ds="git diff --staged"
alias p="git push"
alias po='git push origin "$(git symbolic-ref --short HEAD)"'
alias pf="git push --force-with-lease"
alias pl="git pull"
alias fe="git fetch"
alias fep="git fetch --prune"
alias mer="git merge"
alias sta="git stash"
alias gl="git log --oneline --graph -20"
alias glo="git log --oneline -20"
alias lg="lazygit"

# ------------------------------------------------------------------------------
# Aliases - Docker
# ------------------------------------------------------------------------------
alias dco='docker compose'

# ------------------------------------------------------------------------------
# Aliases - Navigation & Multiplexer
# ------------------------------------------------------------------------------
alias zb='cd -'                   # Jump back to previous directory
alias zj="zellij"
alias zja="zellij attach"
alias zjl="zellij list-sessions"
alias zi="zoxide query -i"        # Interactive fuzzy directory picker

# ------------------------------------------------------------------------------
# Aliases - Utilities
# ------------------------------------------------------------------------------
alias open_ports="ss -lntu"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias y="yazi"

# Modern CLI tool shortcuts
alias dus="dust -r"                # Disk usage (largest last)
alias duf="duf --only local"       # Disk free (skip network mounts)
alias hf="hyperfine"               # Benchmarking
alias tk="tokei"                   # Code statistics
alias http="xh"                    # HTTP client (curl replacement)
alias j="just"                     # Task runner
alias we="watchexec"               # File watcher
alias rec="wf-recorder -f ~/Videos/recording-\$(date +%Y%m%d-%H%M%S).mp4"

# ------------------------------------------------------------------------------
# Tool Initialization
# ------------------------------------------------------------------------------
# Zoxide - smart directory jumping (z command)
eval "$(zoxide init zsh)"

# Starship - fast, customizable prompt
eval "$(starship init zsh)"

# Atuin - better shell history with SQLite backend
# Ctrl+R for interactive history search, syncs across machines
eval "$(atuin init zsh)"

# Mise - polyglot runtime manager (replaces nvm, pyenv, rbenv, etc)
# Faster than nvm, manages node/python/ruby/go versions
eval "$(mise activate zsh)"

# ------------------------------------------------------------------------------
# Docker (Rootless)
# ------------------------------------------------------------------------------
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# ------------------------------------------------------------------------------
# Android SDK (AUR packages: android-sdk, android-emulator, etc.)
# ------------------------------------------------------------------------------
export ANDROID_HOME=/opt/android-sdk
export ANDROID_JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$PATH"
export PATH="/opt/android-emulator:$PATH"

# ------------------------------------------------------------------------------
# Bun
# ------------------------------------------------------------------------------
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# zprof  # Uncomment to see profiling results
