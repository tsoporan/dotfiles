Setting up vIM:
===============

Clone this repo:
```
  git clone https://github.com/tsoporan/dotfiles.git dotfiles
```

Symlink vimrc:
```
  ln -s dotfiles/vimrc ~/.vimrc
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


Setting up tmux
===============

Make sure you have tmux installed.

Symlink tmux.conf
```
ln -s dotfiles/tmux.conf ~/.tmux.conf
```

