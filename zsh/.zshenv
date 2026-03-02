# ==============================================================================
# tsoporan's zshenv
# Last updated: 2025-12-26
# ==============================================================================
#
# This file is sourced for ALL zsh sessions (interactive, login, scripts).
# Keep it minimal - only environment variables that ALL sessions need.
# Interactive-only config goes in .zshrc.
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Core Environment
# ------------------------------------------------------------------------------
export EDITOR=nvim
export BROWSER=brave

# ------------------------------------------------------------------------------
# FZF Configuration
# ------------------------------------------------------------------------------
# Uses fd for file finding (respects .gitignore, faster than find)
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --no-info'

# Ctrl+T: Insert file path
export FZF_CTRL_T_COMMAND="fd --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="
  --prompt '∷ '
  --pointer '▶'
  --marker '⇒'
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Alt+C: cd into directory
export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude .git"

# Ctrl+R: handled by atuin (not fzf)

# ------------------------------------------------------------------------------
# ZSH History
# ------------------------------------------------------------------------------
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTFILE=~/.zhistory
export HISTORY_IGNORE="(fc|fg|bg|jobs|kill|exit|ls|cd|pwd|echo|man|cat|less|more|vi|vim|nvim|v)"
export KEYTIMEOUT=1               # Faster vi mode switching

# ------------------------------------------------------------------------------
# ZSH Autosuggestions
# ------------------------------------------------------------------------------
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ffffff,bg=#ff5f00,bold,underline"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ------------------------------------------------------------------------------
# Language Runtimes
# ------------------------------------------------------------------------------
# Go
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

# Ruby (lazy - only set if gem command exists)
if command -v gem &>/dev/null; then
  export GEM_HOME="${HOME}/.gem/ruby"
  export PATH="$PATH:$GEM_HOME/bin"
fi

# ------------------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------------------
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$GOBIN:$PATH"

# ------------------------------------------------------------------------------
# GPG
# ------------------------------------------------------------------------------
export GPG_TTY=$(tty)

# ------------------------------------------------------------------------------
# Ripgrep
# ------------------------------------------------------------------------------
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# ------------------------------------------------------------------------------
# GTK Scaling (HiDPI)
# ------------------------------------------------------------------------------
export GDK_SCALE=1
export GDK_DPI_SCALE=1.25
