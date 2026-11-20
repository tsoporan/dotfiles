#!/usr/bin/env bash
# Universal copy/paste for Hyprland 0.57+.
# Terminals get Ctrl+Insert / Shift+Insert (Ghostty is bound to those).
# Everything else gets Ctrl+C / Ctrl+V.
# Down then up avoids Hyprland's sendshortcut stuck-modifier bug.
set -euo pipefail

usage() {
  printf 'usage: %s copy|paste\n' "${0##*/}" >&2
  exit 2
}

[[ ${1:-} == copy || ${1:-} == paste ]] || usage

send() {
  local mods=$1 key=$2
  hyprctl dispatch "hl.dsp.send_key_state({ mods = '${mods}', key = '${key}', state = 'down' })" >/dev/null
  sleep 0.05
  hyprctl dispatch "hl.dsp.send_key_state({ mods = '${mods}', key = '${key}', state = 'up' })" >/dev/null
}

is_terminal=$(hyprctl activewindow -j | jq -r '
  if ((.tags // []) | any(. == "terminal"))
     or ((.class // "") | IN(
       "com.mitchellh.ghostty",
       "Alacritty",
       "kitty",
       "foot",
       "org.codeberg.dnkl.foot",
       "org.wezfurlong.wezterm"
     ))
  then 1 else 0 end')

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
