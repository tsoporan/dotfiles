# dotfiles

Collection of my configuration files and general setup notes

![2021-11-24_10-35](https://user-images.githubusercontent.com/130991/143268401-eabec6a5-24a5-4030-8b08-3f20f1449d3f.png)


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
  - [antigen](https://github.com/zsh-users/antigen) zsh plugin management
  - [fd](https://github.com/sharkdp/fd) "better" `find`
  - [ripgrep](https://github.com/BurntSushi/ripgrep) "better" `grep`
  - [zoxide](https://github.com/ajeetdsouza/zoxide) shell nav (smart `cd`)
  - [sequoia](https://sequoia-pgp.org/) PGP encrypt/decrypt the things
  - [pass](https://www.passwordstore.org/) password manager
  - [rofi/rofi-pass](https://github.com/DaveDavenport/rofi) app runner, window switcher, etc


### Dotfile usage

Not super ideal across multiple machines, but generally can be managed with git branching.

Using `stow` simply `stow <dirname>` from within the cloned dir.

```bash
# For example to add the vim config
stow vim
# Notice now that ~/.vimrc is linked
```


### (Neo)vim

Using [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins, this needs to be initially setup before respective config.


```bash
# Neovim specific
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Open vim and run `:PlugInstall`
