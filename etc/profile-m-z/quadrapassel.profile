# Firejail profile for quadrapassel
# Description: Tetris-like game for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include quadrapassel.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.local/share/quadrapassel

mkdir ${HOME}/.local/share/quadrapassel
allow  ${HOME}/.local/share/quadrapassel
allow  /usr/share/quadrapassel

private-bin quadrapassel

dbus-user.own org.gnome.Quadrapassel

# Redirect
include gnome_games-common.profile
