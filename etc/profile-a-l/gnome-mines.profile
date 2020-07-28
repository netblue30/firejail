# Firejail profile for gnome-mines
# Description: The popular logic puzzle minesweeper
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-mines.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/gnome-mines

mkdir ${HOME}/.local/share/gnome-mines
whitelist ${HOME}/.local/share/gnome-mines
whitelist /usr/share/gnome-mines

private-bin gnome-mines

dbus-user.own org.gnome.Mines

# Redirect
include gnome_games-common.profile
