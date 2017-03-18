General Setup
=============

- Chsh zsh
- Install ohmyzsh https://github.com/robbyrussell/oh-my-zsh
- Symlink zshrc to ~/.zshrc
- Symlink gitconfig to ~/.gitconfig
- Symlink tmux.conf to ~/.tmux.conf

Setting up vIM:
===============

Clone this repo:
```
git clone https://github.com/tsoporan/dotfiles.git dotfiles
```

Symlink vimrc:
```
ln -s /path/to/dotfiles/vimrc /home/user/.vimrc
```

Make vim bundle dir for Vundle:
```
mkdir -p ~/.vim/bundle/
```

Put Vundle in there:
```
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Startup vim and run the plugin installer:
```
vim
:PluginInstall
```

FZF
===

1. ```git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf```

2. ```~/.fzf/install```


Notes:
======

- Remember when symlinking to use absolute paths
