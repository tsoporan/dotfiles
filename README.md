# dotfiles

Collection of dotfiles for my day-to-day programs.

![2021-11-24_10-35](https://user-images.githubusercontent.com/130991/143268401-eabec6a5-24a5-4030-8b08-3f20f1449d3f.png)


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
- Font [Fira Code](https://github.com/tonsky/FiraCode)
- Keyboard: [Ducky 2 Mini](https://www.duckychannel.com.tw/en/Ducky-One2-Mini-Pure-White-RGB)
  - Note no arrow keys, configured bottom right (Fn, Alt -> Left, Win -> Down, Ctrl -> Right, R-Shift -> Up)
  - Arrow key setup notes:
    - Use profile 2, profile 1 cannot be changed
    - Swap keycaps on right hand side to match: Fn, Alt, win, Ctrl
    - This version of the keyboard requires re-mapping of the bottom-right Fn key (after previous step)
    - Hold Fn+Alt+K for 5 secs to see binding, press-hold source key and touch target key to swap around function
      - Match to colors: Indigo, Green, Blue, Purple
    - Hold Fn+Alt+Tab (note new binding) for 3s to get into macro recording mode
    - In this mode tap the source key, and map to the target key, direction keys require pressing function e.g Fn+I for up
    - Tap Fn+Alt together to record, Esc light should blink
    - Fn + Alt + Tab to exit
    - Can always factor reset keyboard holding both win keys (using original positions)

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
