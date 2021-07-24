# Firejail profile for swell-foop
# Description: GNOME colored tiles puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include swell-foop.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.local/share/swell-foop

mkdir ${HOME}/.local/share/swell-foop
allow  ${HOME}/.local/share/swell-foop

allow  /usr/share/swell-foop

private-bin swell-foop

dbus-user.own org.gnome.SwellFoop

# Redirect
include gnome_games-common.profile
