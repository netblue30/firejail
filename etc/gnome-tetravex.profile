# Firejail profile for gnome-tetravex
# Description: A simple puzzle game for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-tetravex.local
# Persistent global definitions
include globals.local

private-bin gnome-tetravex

# Redirect
include gnome_games-common.profile
