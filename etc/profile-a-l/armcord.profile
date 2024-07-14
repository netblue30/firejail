# Firejail profile for armcord
# Description: Standalone Discord client
# This file is overwritten after every install/update
# Persistent local customizations
include armcord.local
# Persistent global definitions
include globals.local

# Modules might depend on nodejs.
# Add the below lines to your armcord.local if you need this.
# Allow node (disabled by disable-interpreters.inc)
#include allow-nodejs.inc
#private-bin node

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

noblacklist ${HOME}/.config/ArmCord

mkdir ${HOME}/.config/ArmCord
whitelist ${HOME}/.config/ArmCord
whitelist /opt/armcord
whitelist /usr/share/armcord

ignore novideo
private-bin armcord

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
# Allow D-Bus communication with Firefox for opening links
dbus-user.talk org.mozilla.*
ignore dbus-user none

join-or-start armcord

# Redirect
include electron-common.profile
