# Firejail profile for gnome-nibbles
# Description: A worm game for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-nibbles.local
# Persistent global definitions
include globals.local

ignore machine-id
ignore nosound

noblacklist ${HOME}/.local/share/gnome-nibbles

mkdir ${HOME}/.local/share/gnome-nibbles
whitelist ${HOME}/.local/share/gnome-nibbles
whitelist /usr/share/gnome-nibbles

private-bin gnome-nibbles

dbus-user.own org.gnome.Nibbles

# Redirect
include gnome_games-common.profile
