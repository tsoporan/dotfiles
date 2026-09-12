#!/usr/bin/env bash
# Universal copy/paste for Hyprland.
# Terminals get Ctrl+Insert / Shift+Insert (Ghostty is bound to those).
# Everything else gets Ctrl+C / Ctrl+V.
# sendkeystate down/up avoids Hyprland's sendshortcut stuck-modifier bug.
set -euo pipefail

usage() {
  printf 'usage: %s copy|paste\n' "${0##*/}" >&2
  exit 2
}

[[ ${1:-} == copy || ${1:-} == paste ]] || usage

send() {
  local mods=$1 key=$2
  hyprctl dispatch sendkeystate "$mods, $key, down, activewindow" >/dev/null
  sleep 0.05
  hyprctl dispatch sendkeystate "$mods, $key, up, activewindow" >/dev/null
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
