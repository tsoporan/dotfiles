# dotfiles

Collection of my configuration files and general setup notes

![2023-06-05_13-06](https://github.com/tsoporan/dotfiles/assets/130991/12b55350-cebd-4758-b827-37058f1be4a5)


### Stuff I use

- OS/Distro:
    - [ArchLinux](https://www.archlinux.org/)
- WM:
    - [i3](https://i3wm.org/)
- Tools: 
  - [wezterm](https://wezfurlong.org/wezterm/) term emulator + multiplexer
  - [zsh](https://en.wikipedia.org/wiki/Z_shell) shell
  - [GNU Stow](https://www.gnu.org/software/stow/) config management (this repo)
  - [neovim](https://neovim.io/) the editor
  - [antidote](https://github.com/mattmc3/antidote) zsh plugin management
  - [fd](https://github.com/sharkdp/fd) "better" `find`
  - [ripgrep](https://github.com/BurntSushi/ripgrep) "better" `grep`
  - [zoxide](https://github.com/ajeetdsouza/zoxide) shell nav (smart `cd`)
  - [sequoia](https://sequoia-pgp.org/) PGP encrypt/decrypt the things
  - [pass](https://www.passwordstore.org/) password manager
  - [rofi/rofi-pass](https://github.com/DaveDavenport/rofi) app runner, window switcher, etc
  - [rofi-greenclip](https://github.com/erebe/greenclip) clipboard manager
  - [fzf](https://github.com/junegunn/fzf) fuzzy finder (integrated with zsh)




### Dotfile usage

Not super ideal across multiple machines, but generally can be managed with git branching.

Using `stow` simply `stow <dirname>` from within the cloned dir.

```bash
# For example to add the vim config
stow nvim 
# Notice now that ~/.config/nvim/init.vim is linked
```


### (Neo)vim

Using [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins, this needs to be initially setup before respective config.


```bash
# Neovim specific
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Open vim and run `:PlugInstall`


### Rofi

Configured with:
- [rofi-greenclip](https://github.com/erebe/greenclip) for clipboard
    - https://wiki.archlinux.org/title/Greenclip
- [rofi pass](https://github.com/carnager/rofi-pass) for `pass`
    - https://github.com/carnagar/rofi-pass

### Candy

- [arc](https://github.com/horst3180/arc-theme) (dark) gtk theme w/ icons
- [dracula](https://draculatheme.com/) theme for WM/shell/vim
- [JetBrainsMono](https://www.jetbrains.com/lp/mono/) font
