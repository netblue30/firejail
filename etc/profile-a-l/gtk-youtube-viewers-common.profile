# Firejail profile for gtk-youtube-viewer clones
# Description: common profile for Trizen's gtk Youtube viewers
# This file is overwritten after every install/update
# Persistent local customizations
include gtk-youtube-viewers-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

ignore quiet

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

private-bin firefox,xterm

dbus-user filter
# allow D-Bus communication with firefox for opening links
dbus-user.talk org.mozilla.*
