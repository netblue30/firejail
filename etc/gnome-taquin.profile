# Firejail profile for gnome-taquin
# Description: Sliding tile puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-taquin.local
# Persistent global definitions
include globals.local

ignore machine-id
ignore nosound

whitelist /usr/share/gnome-taquin

private-bin gnome-taquin

# Redirect
include gnome_games-common.profile
