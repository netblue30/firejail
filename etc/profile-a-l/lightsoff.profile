# Firejail profile for lightsoff
# Description: GNOME Lightsoff game
# This file is overwritten after every install/update
# Persistent local customizations
include lightsoff.local
# Persistent global definitions
include globals.local

whitelist /usr/share/lightsoff

private-bin lightsoff

dbus-user.own org.gnome.LightsOff

# Redirect
include gnome_games-common.profile
