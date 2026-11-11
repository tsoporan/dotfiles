#!/usr/bin/env bash
# Universal copy/paste for Hyprland.
# Terminals get Ctrl+Insert / Shift+Insert (Ghostty is bound to those).
# Everything else gets Ctrl+C / Ctrl+V.
# Down then up avoids Hyprland's sendshortcut stuck-modifier bug.
#
# The compositor still running may be 0.56, which only accepts sendkeystate.
# 0.57 speaks Lua dispatch. Check once per invocation. After a 0.57 start,
# hyprctl version no longer says 0.56 and this takes the Lua path.
set -euo pipefail

usage() {
  printf 'usage: %s copy|paste\n' "${0##*/}" >&2
  exit 2
}

[[ ${1:-} == copy || ${1:-} == paste ]] || usage

hypr_version=$(hyprctl version 2>/dev/null | head -n 1 || true)
hypr_ipc=lua
if [[ $hypr_version == 'Hyprland 0.56.'* ]]; then
  hypr_ipc=legacy
fi

send() {
  local mods=$1 key=$2
  if [[ $hypr_ipc == legacy ]]; then
    hyprctl dispatch sendkeystate "$mods, $key, down, activewindow" >/dev/null
    sleep 0.05
    hyprctl dispatch sendkeystate "$mods, $key, up, activewindow" >/dev/null
  else
    hyprctl dispatch "hl.dsp.send_key_state({ mods = '${mods}', key = '${key}', state = 'down' })" >/dev/null
    sleep 0.05
    hyprctl dispatch "hl.dsp.send_key_state({ mods = '${mods}', key = '${key}', state = 'up' })" >/dev/null
  fi
}

win=$(hyprctl activewindow -j)
class=$(jq -r '.class // empty' <<<"$win")
tagged=$(jq -r '.tags[]? // empty' <<<"$win")

is_terminal=0
if [[ $tagged == *terminal* ]]; then
  is_terminal=1
fi
case "$class" in
  com.mitchellh.ghostty | Alacritty | kitty | foot | org.codeberg.dnkl.foot | org.wezfurlong.wezterm)
    is_terminal=1
    ;;
esac

if [[ $1 == copy ]]; then
  if ((is_terminal)); then
    send CTRL Insert
  else
    send CTRL C
  fi
else
  if ((is_terminal)); then
    send SHIFT Insert
  else
    send CTRL V
  fi
fi
