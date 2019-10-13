###########################
# tsoporans zshrc config  #
#                Oct 2019 #
###########################

# Profile
# zmodload zsh/zprof


# Manage plugins - https://github.com/zplug/zplug
source ~/.zplug/init.zsh

# Plugins
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "plugins/git-extras",   from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions", defer:2
zplug "zdharma/fast-syntax-highlighting", defer:2
zplug "skywind3000/z.lua" # Faster z.sh
zplug "softmoth/zsh-vim-mode"


# Install & Loads plugins
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
fi
zplug load

# vi mode
bindkey -v
# Re-map autosuggest-accept (default arrow key), ctrl+space
bindkey '^ ' autosuggest-accept

export LANG=en_US.UTF-8

# Various aliases
alias v="vim"
alias e="emacsclient -nw"
alias ls="exa"
alias g="git"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias rm="rm -i"

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

termquotes get | cowsay -f vader

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"

# zprof
# exit
