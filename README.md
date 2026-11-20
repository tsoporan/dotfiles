# dotfiles

Personal configuration files for Arch Linux + Hyprland, managed with [GNU Stow](https://www.gnu.org/software/stow/).

The machine itself (hardware, LUKS2 disk encryption with a YubiKey, maintenance timers) is in [SYSTEM.md](SYSTEM.md).

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
| `tldraw` | Live tldraw whiteboard shared with Claude (app + `tldraw` skill) |
| `clipse` | Clipse clipboard manager (Hyprland autostarts `clipse -listen`) |
| `eza` | `ls` replacement; directories use Adwaita blue, not eza’s default purple |
| `ghostty` | Terminal emulator |
| `git` | Git config, aliases, delta pager |
| `gnupg` | GPG agent confs (`gpg.conf`, `gpg-agent.conf`) |
| `sequoia` | `sq` config: encrypt/sign as self via the YubiKey |
| `gtk` | GTK 3/4 settings (theme, dark, primary paste) |
| `herdr` | Agent workspace manager, on trial next to Zellij (`Ctrl+g` prefix) |
| `hypr` | Hyprland, hyprpaper, hypridle, hyprlock |
| `lazygit` | Git TUI |
| `mise` | Runtime version management |
| `ripgrep` | Ripgrep flags (`~/.ripgreprc`) |
| `satty` | Screenshot annotation (Enter copies + saves) |
| `starship` | Shell prompt theme |
| `swaync` | Notification center |
| `systemd` | User services (`wallpaper-rotate`, `herdr`, `herdr-pr`) and `waybar`/`hyprpaper` drop-ins |
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

### Claude Code notifications

`claude-notify` (in `bin`) sends a desktop notification when a Claude Code turn that ran a minute or longer finishes, or when Claude needs permission. The title is the Zellij session and the Claude session name; the body is the first line of Claude's reply. Clicking it, or pressing Super+U, focuses the window and the Zellij tab and pane, or herdr pane, that Claude runs in. It also renames the Zellij or herdr tab to the session name, unless you named the tab yourself.

The hooks live in `~/.claude/settings.json`, which is not in this repo:

```json
{
  "preferredNotifChannel": "notifications_disabled",
  "hooks": {
    "UserPromptSubmit": [{ "hooks": [{ "type": "command", "command": "\"$HOME/.local/bin/claude-notify\"", "timeout": 5 }] }],
    "Stop": [{ "hooks": [{ "type": "command", "command": "\"$HOME/.local/bin/claude-notify\"", "timeout": 5 }] }],
    "Notification": [{ "hooks": [{ "type": "command", "command": "\"$HOME/.local/bin/claude-notify\"", "timeout": 5 }] }]
  }
}
```

`preferredNotifChannel` turns off Claude Code's own terminal notification, which would otherwise arrive as a duplicate.

While the screen is locked, the same events also go to the phone through [ntfy](https://ntfy.sh): "Finished" or "Needs you" (high priority), titled with the session name. Claude's reply isn't sent, since the ntfy server sees every message. The topic URL lives in `~/.config/claude-notify/ntfy`, outside git, because anyone who knows it can read the pushes. Subscribe to that URL in the ntfy app.

### Claude Code status line

`claude-statusline` (in `bin`) prints the model, effort, context size against a 700k handoff limit, and 5-hour and weekly usage. The context figure turns red and says `handoff` at 560k. In `~/.claude/settings.json`:

```json
{
  "statusLine": { "type": "command", "command": "\"$HOME/.local/bin/claude-statusline\"" },
  "autoCompactWindow": 700000
}
```

Inside herdr the script also puts the context size on the agent's sidebar row and writes the usage figures for herdr's tab bar.

### Pull requests on the herdr sidebar

`herdr-pr` (in `bin`) shows each Claude session's pull requests under its herdr sidebar row: `#123 ci…`, `ci ✓`, `approved`, red `ci ✗` or `changes`, green `merged`. Every PR a session opens is tracked, so paired PRs (say, an API change and the frontend change that uses it) both show. A Claude Code hook records each PR when a session runs `gh pr create`. To adopt an existing PR, the session runs `herdr-pr track <url>`. PRs are stored per Claude session, so they survive a herdr restart. A PR leaves the row 12 hours after it merges or closes.

`herdr-pr.timer` (in `systemd`) polls GitHub every minute while herdr runs, and raises a herdr toast when a PR merges, naming any of the session's PRs still open. `prefix+m` then tells the focused agent which of its PRs merged and which are still open. Enable the timer once with `systemctl --user enable --now herdr-pr.timer`. The hook goes in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [{ "matcher": "Bash", "hooks": [{ "type": "command", "command": "\"$HOME/.local/bin/herdr-pr\" hook", "timeout": 5 }] }]
  }
}
```

### Jumping to the agent that needs you

Inside herdr, Ctrl+Alt+Enter runs `herdr-attention` (in `bin`). It focuses a blocked agent (one waiting on a permission prompt or question) first, otherwise the agent that finished most recently and hasn't been looked at. Press again for the next one. Unlike Super+U, it doesn't need a desktop notification, so it also finds agents whose turn was under a minute. Ctrl+Alt+arrows switch herdr tabs (left/right) and agents (up/down). Ctrl+Alt+1..9 jumps to a workspace by its place in the sidebar, and Ctrl+Alt+Shift+Up/Down steps through workspaces.

### Cleaning up leftover processes

Ctrl+Alt+Backspace in herdr opens `herdr-cleanup` (in `bin`) in a popup. It lists what holds RAM, most suspicious first:

- `orphan`: a process tree whose parent died, started from a terminal or an agent. Usually a leftover dev server, browser or test runner.
- `gone`: running from a deleted directory, such as a removed worktree.
- `server`: a terminal-started process listening on a port, with the herdr pane it runs in.
- `container`: a Docker container.
- `app`: a detached desktop app over 150 MB.
- `pane`: each herdr pane and everything under it, for scale.

Memory is PSS, so the column adds up. Enter shows the process tree; Ctrl-X kills the row after asking (SIGTERM, then SIGKILL after five seconds, or `docker stop`). It also runs on its own in any terminal.

### Starting the next Claude session

`claude-next <name> <prompt-file>` (in `bin`) opens a new herdr or Zellij tab in the current directory with Claude already working on the prompt, and leaves focus where it was. Handoffs end with it.

### tldraw: a whiteboard shared with Claude

`tldraw` (in `bin`, with the app in the `tldraw` package) opens a [tldraw](https://tldraw.dev) board in the default browser. Claude draws on it and Titus edits by hand. A small Bun server on `localhost:4747` serves the page and relays JavaScript from the CLI to the open tab over a WebSocket. The tab autosaves the board to a `.tldr` file, by default `docs/diagrams/<name>.tldr` in the current repo, which tldraw.com and the VS Code tldraw extension can also open.

```bash
tldraw open auth-flow                  # opens ./docs/diagrams/auth-flow.tldr in the browser
tldraw exec auth-flow draw.js          # run JS against the tab (or pipe it on stdin)
tldraw read auth-flow                  # shapes, arrows, selection as JSON
tldraw shot auth-flow out.png          # PNG of the board
tldraw status / tldraw stop
```

The `tldraw` skill (stowed into `~/.claude/skills/tldraw`) tells Claude when to reach for it (architecture, statecharts, flows, brainstorms), how to use the `board` helpers in `web/board.ts` (bound arrows, frames, ELK auto-layout), and to screenshot its work before describing it. It's named `tldraw` rather than "canvas" so a session doesn't confuse it with Claude's Artifacts, and its description says "canvas" and "whiteboard" mean this board unless Titus says "artifact".

Every API call needs an `X-Tldraw` header, the Host must be `localhost` or `127.0.0.1`, and board paths must be absolute `.tldr` files, so another web page can't drive the board or write files through it, even via DNS rebinding. The server log is `~/.local/state/tldraw/server.log`. tldraw shows a small "license for production" note, which is expected on localhost.

`.stowrc` sets `--no-folding` (and `just check` enforces it via `check-claude`), so `stow tldraw` links only the skill files under `~/.claude/skills/tldraw/` and never folds `~/.claude` into this repo.

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

## Hyprland

Keybinds live in [`hypr/.config/hypr/hyprland.lua`](hypr/.config/hypr/hyprland.lua). Hyprland 0.57 reads that file only. Super+Shift+Tab opens [`hypr-cheatsheet.txt`](hypr/.config/hypr/hypr-cheatsheet.txt).

Super+1 through Super+0 focus workspaces 1 through 10. Pressing the key for the workspace that is already focused returns to the previous workspace. From workspace 4, Super+2 focuses 2, and Super+2 again returns to 4. Focusing any other workspace replaces the one that jump remembers. Super+Escape focuses that previous workspace directly. Both read Hyprland's workspace history (`binds.workspace_back_and_forth`, and `hl.dsp.focus({ workspace = "previous" })` for Escape). The setting is under [binds](https://wiki.hypr.land/configuring/core/config-options/).

Super+Shift+1 through Super+0 moves the focused window (`hl.dsp.window.move({ workspace = N })`).

`swaync`, `waybar`, `hyprpaper`, `hypridle`, and `hyprpolkitagent` all run as their packaged systemd user services, restarted by Hyprland after `dbus-update-activation-environment`. Starting `swaync` as a bare process raced with D-Bus, and systemd-managed `waybar`/`hyprpaper`/`hypridle` surface crashes in the failed-units bar module. Drop-ins in `systemd` clear the `graphical-session.target` requirement on `waybar` and `hyprpaper` so they start cleanly without `uwsm`.

### Waybar

- 󰚩 shows how many herdr agents are blocked or finished and waiting for you: green when they have finished, red when any is blocked. The tooltip lists them; a click focuses herdr's window and the agent that most needs you (`waybar-agents` in `bin`). It finds the window by the `herdr: ` title set in herdr's config.
- Memory is total minus available, so disk cache doesn't count. The tooltip shows what's available and swap. Click opens `herdr-cleanup`; right-click opens btop.
- 󰀦 counts failed systemd units, user and system, and names them in the tooltip (`waybar-failed-units` in `bin`). Click shows the details.

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
