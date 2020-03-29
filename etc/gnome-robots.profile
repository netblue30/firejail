# Firejail profile for gnome-robots
# Description: Sliding tile puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-robots.local
# Persistent global definitions
include globals.local

ignore machine-id
ignore nosound

whitelist /usr/share/gnome-robots

private-bin gnome-robots

# Redirect
include gnome_games-common.profile
