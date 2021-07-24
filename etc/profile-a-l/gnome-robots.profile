# Firejail profile for gnome-robots
# Description: Based on classic BSD Robots
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-robots.local
# Persistent global definitions
include globals.local

ignore machine-id
ignore nosound

allow  /usr/share/gnome-robots

private-bin gnome-robots

dbus-user.own org.gnome.Robots

# Redirect
include gnome_games-common.profile
