# Firejail profile for gnome-2048
# Description: Sliding tile puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-2048.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/gnome-2048

mkdir ${HOME}/.local/share/gnome-2048
whitelist ${HOME}/.local/share/gnome-2048

private-bin gnome-2048

dbus-user.own org.gnome.TwentyFortyEight

# Redirect
include gnome_games-common.profile
