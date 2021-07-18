# Firejail profile for swell-foop
# Description: GNOME colored tiles puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include swell-foop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/swell-foop

mkdir ${HOME}/.local/share/swell-foop
whitelist ${HOME}/.local/share/swell-foop

whitelist /usr/share/swell-foop

private-bin swell-foop

dbus-user.own org.gnome.SwellFoop

# Redirect
include gnome_games-common.profile
