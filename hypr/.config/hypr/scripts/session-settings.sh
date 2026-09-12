#!/usr/bin/env bash
# Session gsettings that should match gtk-3.0/gtk-4.0 settings.ini.
set -euo pipefail

gsettings set org.gnome.desktop.interface gtk-enable-primary-paste true
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme Dracula
gsettings set org.gnome.desktop.interface icon-theme Dracula
gsettings set org.gnome.desktop.interface cursor-theme Adwaita
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans 11'
