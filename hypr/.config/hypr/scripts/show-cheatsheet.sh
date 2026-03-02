#!/bin/sh
set -e
sheet="$HOME/.config/hypr/hypr-cheatsheet.txt"
if [ ! -f "$sheet" ]; then
    printf 'Cheat sheet missing: %s\n' "$sheet" >&2
    exit 1
fi
exec ghostty --class=HyprCheatsheet --title="Hyprland Cheat Sheet" -e less -R "$sheet"
