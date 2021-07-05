# Firejail profile for gnome-klotski
# Description: Sliding block puzzles game for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-klotski.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.local/share/gnome-klotski

mkdir ${HOME}/.local/share/gnome-klotski
allow  ${HOME}/.local/share/gnome-klotski

private-bin gnome-klotski

dbus-user.own org.gnome.Klotski

# Redirect
include gnome_games-common.profile
