# Firejail profile for hitori
# Description: Play the Hitori puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include hitori.local
# Persistent global definitions
include globals.local

private-bin hitori

dbus-user.own org.gnome.Hitori

# Redirect
include gnome_games-common.profile
