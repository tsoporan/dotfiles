# dotfiles

Collection of dotfiles for my day-to-day programs.

![2019-02-25-231425_3840x2160_scrot](https://user-images.githubusercontent.com/130991/53387138-6e78f380-3953-11e9-86eb-abc36fed6986.png)

### My setup

- [ArchLinux](https://www.archlinux.org/)
- [AwesomeWM](https://awesomewm.org/)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [rofi & rofi-pass](https://github.com/DaveDavenport/rofi)
- [kitty term](https://github.com/kovidgoyal/kitty)
- [vim](https://www.vim.org/)
- [zsh](https://wiki.archlinux.org/index.php/zsh)
  - [antibody](https://github.com/getantibody/antibody)
- [fzf](https://github.com/junegunn/fzf)
- [Fira Code font](https://github.com/tonsky/FiraCode)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)

### Dotfile usage

Using `stow` simply `stow <dirname>` from within the cloned dir.

```bash
# For example to add the vim config
stow vim
# Notice now that ~/.vimrc is linked
```

Enjoy!

### Theme

The theme is customized for my needs but heavily based on: [awesome-pro](https://github.com/4ban/awesome-pro) - check it out!

### HiDPI

The `laptop` branch contains adjustments to the configs for HiDPI
