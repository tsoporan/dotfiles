# dotfiles

Personal configuration files for Arch Linux + Hyprland, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stack

- **OS:** [Arch Linux](https://www.archlinux.org/)
- **WM:** [Hyprland](https://hyprland.org/) (Wayland)
- **Terminal:** [Ghostty](https://ghostty.org/)
- **Shell:** [Zsh](https://en.wikipedia.org/wiki/Z_shell) + [Antidote](https://github.com/mattmc3/antidote)
- **Editor:** [Neovim](https://neovim.io/) (config not in this repo)
- **Prompt:** [Starship](https://starship.rs/)
- **Theme:** black + electric yellow (`#e6fb04`); GTK [Adwaita-dark](https://gnome.pages.gitlab.gnome.org/libadwaita/)
- **Font:** [JetBrainsMono Nerd Font](https://www.jetbrains.com/lp/mono/)

## Stow Packages

| Package | Description |
|---------|-------------|
| `atuin` | Shell history with fuzzy search |
| `bat` | Syntax-highlighted cat |
| `bin` | Custom utility scripts |
| `btop` | System monitor |
| `clipse` | Clipse clipboard manager (Hyprland autostarts `clipse -listen`) |
| `eza` | `ls` replacement; directories use Adwaita blue, not eza’s default purple |
| `ghostty` | Terminal emulator |
| `git` | Git config, aliases, delta pager |
| `gnupg` | GPG agent confs (`gpg.conf`, `gpg-agent.conf`) |
| `sequoia` | `sq` config: encrypt/sign as self via the YubiKey |
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

`gnupg` links the conf files into `~/.gnupg`. Do not `stow --adopt gnupg` — that copies live keyrings into this tree.

File encrypt/sign/decrypt/verify (YubiKey subkeys, `sq` via gpg-agent):

```bash
pgpe notes.txt      # -> notes.txt.pgp
pgpd notes.txt.pgp  # -> notes.txt
pgps notes.txt      # -> notes.txt.sig
pgpv notes.txt      # verifies notes.txt.sig
```

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

## Zsh plugins

[Antidote](https://github.com/mattmc3/antidote) reads `zsh/.zsh_plugins.txt`. That file is in git. The rest is machine-local:

| Path | What |
|---|---|
| `~/.antidote` | Plugin manager, cloned on first interactive zsh |
| `~/.cache/antidote/` | Plugin git clones (`owner/repo`) |
| `~/.zsh_plugins.zsh` | Generated static load file |
| `~/.local/share/antidote/snapshots/` | SHA snapshots after an update |
| `~/.config/antidote/config.zsh` | zstyles (stowed from `zsh/.config/antidote/`) |

```bash
just zsh-plugins-outdated   # dry-run
just zsh-plugins-update     # pull plugins + antidote, then snapshot
```

`antidote update` walks every clone under `~/.cache/antidote`, including leftovers not in the plugin list. Drop unused clones with `rm`. If a pull is bad, `zsh -c 'source ~/.antidote/antidote.zsh && antidote snapshot restore'`.

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
