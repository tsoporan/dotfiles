# dotfiles

Personal configuration files for Arch Linux + Hyprland, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stack

- **OS:** [Arch Linux](https://www.archlinux.org/)
- **WM:** [Hyprland](https://hyprland.org/) (Wayland)
- **Terminal:** [Ghostty](https://ghostty.org/)
- **Shell:** [Zsh](https://en.wikipedia.org/wiki/Z_shell) + [Antidote](https://github.com/mattmc3/antidote)
- **Editor:** [Neovim](https://neovim.io/) (config not in this repo)
- **Prompt:** [Starship](https://starship.rs/)
- **Theme:** black + electric yellow (`#e6fb04`); GTK still [Dracula](https://draculatheme.com/)
- **Font:** [JetBrainsMono Nerd Font](https://www.jetbrains.com/lp/mono/)

## Stow Packages

| Package | Description |
|---------|-------------|
| `atuin` | Shell history with fuzzy search |
| `bat` | Syntax-highlighted cat |
| `bin` | Custom utility scripts |
| `btop` | System monitor |
| `clipse` | Clipse clipboard manager (Hyprland autostarts `clipse -listen`) |
| `ghostty` | Terminal emulator |
| `git` | Git config, aliases, delta pager |
| `gnupg` | GPG agent confs only (`gpg.conf`, `gpg-agent.conf`) |
| `gtk` | GTK 3/4 settings (theme, dark, primary paste) |
| `hypr` | Hyprland, hyprpaper, hypridle, hyprlock |
| `lazygit` | Git TUI |
| `mise` | Runtime version management |
| `ripgrep` | Ripgrep flags (`~/.ripgreprc`) |
| `satty` | Screenshot annotation (Enter copies + saves) |
| `starship` | Shell prompt theme |
| `swaync` | Notification center |
| `systemd` | User services (syncthing, wallpaper-rotate) |
| `wallpapers` | Desktop wallpapers |
| `waybar` | Status bar |
| `wofi` | App launcher + window switcher theme |
| `zellij` | Terminal multiplexer |
| `zsh` | Shell config, plugins, aliases |

`gnupg` links the two conf files into `~/.gnupg`. Do not `stow --adopt gnupg` — that copies live keyrings into this tree.

Machine-local zsh overrides go in `~/.zshrc.local` (not git).

## Usage

Run commands from the repo root (`.stowrc` sets `--target=$HOME`).

```bash
# Clone the repo
git clone git@github.com:tsoporan/dotfiles.git
cd dotfiles

# Dry-run / inventory / script syntax
just check

# Link a package (creates symlinks in $HOME)
stow <package>

# Unlink a package
stow -D <package>
```

`just check` must be green before stowing a new machine. Do not blindly `stow */`.

## Key Tools

- [fd](https://github.com/sharkdp/fd), [ripgrep](https://github.com/BurntSushi/ripgrep), [eza](https://github.com/eza-community/eza) -- modern coreutils
- [zoxide](https://github.com/ajeetdsouza/zoxide) -- smart cd
- [fzf](https://github.com/junegunn/fzf) -- fuzzy finder
- [wofi](https://hg.sr.ht/~scoopta/wofi) + [wofi-pass](https://github.com/schmidtandreas/wofi-pass) -- app launcher + password management
- [grim](https://github.com/emersion/grim) + [slurp](https://github.com/emersion/slurp) + [satty](https://github.com/gabm/satty) -- screenshots + annotation
- [clipse](https://github.com/savedra1/clipse) -- clipboard history (Wayland)
- [atuin](https://github.com/atuinsh/atuin) -- shell history
- [mise](https://mise.jdx.dev/) -- runtime/tool version management
- [delta](https://github.com/dandavison/delta) -- git diff viewer
