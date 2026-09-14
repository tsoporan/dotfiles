# ==============================================================================
# tsoporan's zshrc
# Last updated: 2026-09-13
# ==============================================================================
#
# Shell startup order: .zshenv -> .zshrc (interactive) -> .zlogin
# Environment variables are in .zshenv, interactive config is here.
#
# Init order: antidote -> vi keys -> fzf -> mise -> zoxide -> atuin -> starship
#
# Dependencies:
#   - antidote (plugin manager)
#   - starship (prompt)
#   - zoxide (smart cd)
#   - atuin (history search)
#   - fzf, fd, bat, eza (modern CLI tools)
#   - mise (runtime version manager - replaces nvm/pyenv/etc)
#
# ==============================================================================

# zmodload zsh/zprof  # Uncomment to profile startup time

# ------------------------------------------------------------------------------
# Plugin Manager (Antidote)
# ------------------------------------------------------------------------------
[[ -e ${ZDOTDIR:-~}/.antidote ]] ||
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# ------------------------------------------------------------------------------
# Key Bindings (vi first so fzf/atuin bind viins/vicmd)
# ------------------------------------------------------------------------------
bindkey -v
bindkey -M viins "^ " autosuggest-accept
bindkey -M viins "^E" end-of-line
bindkey -M viins "^[[C" forward-char
bindkey -M viins "^[OC" forward-char

# ------------------------------------------------------------------------------
# FZF Integration
# ------------------------------------------------------------------------------
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# ------------------------------------------------------------------------------
# Wayland env self-heal
# ------------------------------------------------------------------------------
# Multiplexer servers (zellij/tmux) started under X11 keep that environment for
# every pane they spawn, so nvim/wl-copy never see WAYLAND_DISPLAY after a
# switch to Hyprland. Recover it from the live compositor socket.
if [[ -z $WAYLAND_DISPLAY && -n $XDG_RUNTIME_DIR ]]; then
  for _wl_sock in $XDG_RUNTIME_DIR/wayland-<->(N); do
    [[ -S $_wl_sock ]] && export WAYLAND_DISPLAY=${_wl_sock:t} XDG_SESSION_TYPE=wayland && break
  done
  unset _wl_sock
fi

# ------------------------------------------------------------------------------
# Shell Options
# ------------------------------------------------------------------------------
setopt auto_cd

# Zsh hist is a small fallback. Atuin owns Ctrl+R.
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

# ------------------------------------------------------------------------------
# Aliases - General
# ------------------------------------------------------------------------------
alias v="nvim"
alias e="emacsclient -nc"
alias rm="rm -i"
alias cp="cp -i"
alias ..="cd .."
alias ~="cd ~"
alias df="df -h"
alias free="free -m"
alias bc="bc -l"

alias l="eza --icons=auto -s accessed --group-directories-first"
alias ls="eza --icons=auto -s accessed --group-directories-first"
alias ll="eza --icons=auto -la -s accessed --group-directories-first"
alias tree="eza --tree --icons=auto"

# ------------------------------------------------------------------------------
# Aliases - Git
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
alias po="git push -u origin HEAD"
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
alias zb='cd -'
alias zj="zellij"
alias zja="zellij attach"
alias zjl="zellij list-sessions"
alias zi="zoxide query -i"

# ------------------------------------------------------------------------------
# Aliases - Utilities
# ------------------------------------------------------------------------------
alias open_ports="ss -lntu"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias y="yazi"
alias dus="dust -r"
alias duf="duf --only local"
alias hf="hyperfine"
alias tk="tokei"
alias http="xh"
alias j="just"
alias we="watchexec"
alias rec="wf-recorder -f ~/Videos/recording-\$(date +%Y%m%d-%H%M%S).mp4"

# ------------------------------------------------------------------------------
# Tool Initialization
# ------------------------------------------------------------------------------
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
alias cd=z

# Ctrl+R: Atuin TUI. Up-arrow stays line-by-line. Empty-line ? is not AI.
# Rebind after init: the viins widget passes --keymap-mode=vim-insert and
# would ignore keymap_mode = "emacs". vicmd ^R would stay on fzf.
eval "$(atuin init zsh --disable-up-arrow --disable-ai)"
bindkey -M emacs '^r' atuin-search
bindkey -M viins '^r' atuin-search
bindkey -M vicmd '^r' atuin-search

eval "$(starship init zsh)"

# ------------------------------------------------------------------------------
# GPG Agent (SSH signing via YubiKey)
# Remote: use stable symlink to forwarded agent (updated by ~/.ssh/rc on each login)
# Local: use gpg-agent with SSH support
# ------------------------------------------------------------------------------
export GPG_TTY=${TTY:-$(tty)}
if [[ -S "$HOME/.ssh/agent-forward.sock" ]] && [[ -n "$ZELLIJ" || -n "$ZELLIJ_SESSION_NAME" ]]; then
    export SSH_AUTH_SOCK="$HOME/.ssh/agent-forward.sock"
elif [[ -z "$SSH_AUTH_SOCK" ]] || [[ "$SSH_AUTH_SOCK" == *"gpg-agent"* ]]; then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

# ------------------------------------------------------------------------------
# Docker (Rootless)
# ------------------------------------------------------------------------------
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# zprof  # Uncomment to see profiling results

# Machine-local overrides (not in git). Installers should append here, not above.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
