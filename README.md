# dotfiles

Collection of dotfiles for my day-to-day programs.

![2019-02-25-231425_3840x2160_scrot](https://user-images.githubusercontent.com/130991/53387138-6e78f380-3953-11e9-86eb-abc36fed6986.png)

### My setup

- Distro: [ArchLinux](https://www.archlinux.org/)
- Window manager: [Awesome](https://awesomewm.org/)
- Config mgmt.: [GNU Stow](https://www.gnu.org/software/stow/)
- Window switcher/app runner: [rofi & rofi-pass](https://github.com/DaveDavenport/rofi)
- Terminal: [alacritty terminal](https://github.com/jwilm/alacritty)
- Text Editor: [(n)vim](https://www.vim.org/)
- Shell: [zsh](https://wiki.archlinux.org/index.php/zsh)
- Working in the shell:
  - Alternative to `grep`: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - Alternative to `find`: [fd](https://github.com/sharkdp/fd)
  - Jump around / MRU nav: [(z)oxide](https://github.com/ajeetdsouza/zoxide)
  - Fuzzy file finder + vim integration: [fzf/fzf.vim](https://github.com/junegunn/fzf)
- Font [Fira Code](https://github.com/tonsky/FiraCode)

### Dotfile usage

Using `stow` simply `stow <dirname>` from within the cloned dir.

```bash
# For example to add the vim config
stow vim
# Notice now that ~/.vimrc is linked
```

Enjoy!

### WM Theme

The theme is customized for my needs but heavily based on: [awesome-pro](https://github.com/4ban/awesome-pro) - check it out!

### HiDPI

The main branch contains a HiDPI set up, due to my primary driver, check out the `desktop` branch if you aren't using
HiDPI.
