If not otherwise specified setting up is a matter of symlinking the respective files.


General Setup
=============

- Chsh zsh
- Install ohmyzsh https://github.com/robbyrussell/oh-my-zsh
- Symlink zshrc
- Symlink gitconfig

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

Notes:
======

- Remember when symlinking to use absolute paths
