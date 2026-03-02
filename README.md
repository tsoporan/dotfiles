# dotfiles

Personal configuration files for Arch Linux + Hyprland, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stack

- **OS:** [Arch Linux](https://www.archlinux.org/)
- **WM:** [Hyprland](https://hyprland.org/) (Wayland)
- **Terminal:** [Ghostty](https://ghostty.org/)
- **Shell:** [Zsh](https://en.wikipedia.org/wiki/Z_shell) + [Antidote](https://github.com/mattmc3/antidote)
- **Editor:** [Neovim](https://neovim.io/)
- **Prompt:** [Starship](https://starship.rs/)
- **Theme:** [Dracula](https://draculatheme.com/)
- **Font:** [JetBrainsMono Nerd Font](https://www.jetbrains.com/lp/mono/)

## Stow Packages

| Package | Description |
|---------|-------------|
| `atuin` | Shell history with fuzzy search |
| `bat` | Syntax-highlighted cat |
| `bin` | Custom utility scripts |
| `btop` | System monitor |
| `clipse` | Clipboard manager |
| `docker` | Rootless Docker systemd units |
| `ghostty` | Terminal emulator |
| `git` | Git config, aliases, delta pager |
| `gnupg` | GPG agent and config |
| `hypr` | Hyprland, hyprpaper, hypridle, hyprlock |
| `lazygit` | Git TUI |
| `mise` | Runtime version management |
| `starship` | Shell prompt theme |
| `swaync` | Notification center |
| `systemd` | User services (syncthing, wallpaper-rotate) |
| `wallpapers` | Desktop wallpapers |
| `waybar` | Status bar |
| `zellij` | Terminal multiplexer |
| `zsh` | Shell config, plugins, aliases |

## Usage

```bash
# Clone the repo
git clone https://github.com/tsoporan/dotfiles.desktop.git
cd dotfiles.desktop

# Link a package (creates symlinks in $HOME)
stow <package>

# Link everything
for d in */; do stow "$d"; done

# Unlink a package
stow -D <package>
```

## Key Tools

- [fd](https://github.com/sharkdop/fd), [ripgrep](https://github.com/BurntSushi/ripgrep), [eza](https://github.com/eza-community/eza) -- modern coreutils
- [zoxide](https://github.com/ajeetdsouza/zoxide) -- smart cd
- [fzf](https://github.com/junegunn/fzf) -- fuzzy finder
- [wofi](https://hg.sr.ht/~scoopta/wofi) + [wofi-pass](https://github.com/schmidtandreas/wofi-pass) -- app launcher + password management
- [grim](https://github.com/emersion/grim) + [slurp](https://github.com/emersion/slurp) + [satty](https://github.com/gabm/satty) -- screenshots + annotation
- [cliphist](https://github.com/sentriz/cliphist) -- clipboard history (Wayland)
- [atuin](https://github.com/atuinsh/atuin) -- shell history
- [mise](https://mise.jdx.dev/) -- runtime/tool version management
- [delta](https://github.com/dandavison/delta) -- git diff viewer
