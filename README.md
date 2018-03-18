# dotfiles

Notes to self on how to set em up.

## Zsh

1. Use zsh: `chsh zsh`

2. Set up `antigen` (https://github.com/zsh-users/antigen)


## Git
```
ln -s $(PWD)/gitconfig ~/.gitconfig
```

## Vim

1. Clone this repo:
```
git clone https://github.com/tsoporan/dotfiles.git dotfiles
```

2. Symlink vimrc:
```
ln -s $(PWD)/vimrc ~/.vimrc
```

3. Set up `vim-plug`:
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

4. Startup vim and install plugins:
```
vim
:PluginInstall
```

## FZF

1. ```git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf```

2. ```~/.fzf/install```
