# Firejail profile for four-in-a-row
# Description: four-in-a-row game for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include four-in-a-row.local
# Persistent global definitions
include globals.local

ignore machine-id
ignore nosound

whitelist /usr/share/four-in-a-row

private-bin four-in-a-row

dbus-user.own org.gnome.Four-in-a-row

# Redirect
include gnome_games-common.profile
