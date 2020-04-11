###########################
# tsoporans zshrc config  #
#                Oct 2019 #
###########################

# Profile
# zmodload zsh/zprof

# Zplugin
source "$HOME/.zplugin/bin/zplugin.zsh"

autoload -Uz _zplugin

(( ${+_comps} )) && _comps[zplugin]=_zplugin
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs

# https://github.com/zdharma/zplugin/issues/119
ZSH="$HOME/.zplugin/plugins/robbyrussell---oh-my-zsh/"
local _OMZ_SOURCES=(
    # Libs
    lib/compfix.zsh
    lib/directories.zsh
    lib/functions.zsh
    lib/git.zsh
    lib/termsupport.zsh

    # Plugins
    plugins/command-not-found/command-not-found.plugin.zsh
    plugins/fzf/fzf.plugin.zsh
    plugins/git/git.plugin.zsh
    plugins/gitfast/gitfast.plugin.zsh
    plugins/sudo/sudo.plugin.zsh
    plugins/urltools/urltools.plugin.zsh
)

zplugin ice from"gh" pick"/dev/null" nocompletions blockf lucid \
        multisrc"${_OMZ_SOURCES}" compile"(${(j.|.)_OMZ_SOURCES})" \
        atinit"zpcdreplay" wait"1c"
zplugin light "robbyrussell/oh-my-zsh"


# Plugins
zplugin light "mafredri/zsh-async"
zplugin light "romkatv/powerlevel10k"

zplugin ice wait"0a" lucid
zplugin light "skywind3000/z.lua" # Faster z.sh

zplugin ice wait"0a" compile'{src/*.zsh,src/strategies/*}' atload"_zsh_autosuggest_start" lucid
zplugin light "zsh-users/zsh-autosuggestions"

zplugin ice wait"0a" atload"_zsh_highlight" lucid
zplugin light "zdharma/fast-syntax-highlighting"

zplugin ice wait"0b" blockf lucid
zplugin light "zsh-users/zsh-completions"

zplugin ice wait"0b" lucid
zplugin light "hlissner/zsh-autopair"

_zsh-history-substring-search-setting() {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
  HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
}

zplugin ice wait"0c" atload"_zsh-history-substring-search-setting" lucid
zplugin light "zsh-users/zsh-history-substring-search"

_zsh-git-smart-commands-setting() {
  # + signing
  alias c='git-smart-commit -S --signoff'
  alias a='git-smart-add'
  alias p='git-smart-push seletskiy'
  alias u='git-smart-pull'
  # Won't use
  # alias r='git-smart-remote'
  alias s='git status'
}

zplugin ice wait"1a" atload"_zsh-git-smart-commands-setting" blockf lucid
zplugin light "seletskiy/zsh-git-smart-commands"

zplugin ice wait"1b" lucid
zplugin light "softmoth/zsh-vim-mode"

zplugin ice wait"2" as"program" pick"tldr" lucid
zplugin light "raylee/tldr"

zplugin ice wait"2" lucid
zplugin light "wfxr/forgit"

# https://gist.github.com/ctechols/ca1035271ad134841284
# On slow systems, checking the cached .zcompdump file to see if it must be
# regenerated adds a noticable delay to zsh startup.  This little hack restricts
# it to once a day.  It should be pasted into your own completion file.
#
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.

# Perform compinit only once a day.

# Compile the completion dump to increase startup speed, if dump is newer or doesn't exist,
# in the background as this is doesn't affect the current session.

setopt EXTENDEDGLOB LOCAL_OPTIONS
autoload -Uz compinit
autoload -Uz bashcompinit && bashcompinit
zmodload -i zsh/complist

local zcd=${ZPLGM[ZCOMPDUMP_PATH]:-${ZDOTDIR:-$HOME}/.zcompdump}
local zcdc="$zcd.zwc"
if [[ -f "$zcd"(#qN.m+1) ]]; then
    compinit -i -d "$zcd"
    { rm -f "$zcdc" && zcompile "$zcd" } &!
else
    compinit -C -d "$zcd"
    { [[ ! -f "$zcdc" || "$zcd" -nt "$zcdc" ]] && rm -f "$zcdc" && zcompile "$zcd" } &!
fi

zplugin cdreplay -q

# vi mode
bindkey -v
# Re-map autosuggest-accept (default arrow key), ctrl+space
bindkey '^ ' autosuggest-accept

export LANG=en_US.UTF-8

# Various aliases
alias v="nvim"
alias vim="nvim"
alias e="emacsclient -nw"
alias ls="exa"
alias g="git"
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

export EDITOR=vim
export BROWSER=firefox-developer-edition

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
gpg-connect-agent updatestartuptty /bye >/dev/null

# Setting fd as the default source for fzf, search hidden and symlinks exclude git
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
# Colors
export FZF_DEFAULT_OPTS="--ansi"

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# NPM
NPM_CONFIG_PREFIX=~/.npm-global

termquotes get | cowsay -d

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE


## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

setopt interactivecomments # I want my bash comments

# Gruvbox pallette
source "$HOME/gruvbox-git/gruvbox_256palette.sh"

# zprof
# exit
