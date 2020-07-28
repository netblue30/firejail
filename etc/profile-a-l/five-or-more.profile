# Firejail profile for five-or-more
# Description: GNOME port of the once-popular Colour Lines game
# This file is overwritten after every install/update
# Persistent local customizations
include five-or-more.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/five-or-more

mkdir ${HOME}/.local/share/five-or-more
whitelist ${HOME}/.local/share/five-or-more

whitelist /usr/share/five-or-more

private-bin five-or-more

dbus-user.own org.gnome.five-or-more

# Redirect
include gnome_games-common.profile
