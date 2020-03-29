# Firejail profile for gnome-tetravex
# Description: Sliding tile puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-tetravex.local
# Persistent global definitions
include globals.local

private-bin gnome-tetravex

# Redirect
include gnome_games-common.profile
