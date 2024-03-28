# Firejail profile for gtk-youtube-viewer clones
# Description: common profile for Trizen's gtk Youtube viewers
# This file is overwritten after every install/update
# Persistent local customizations
include gtk-youtube-viewers-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

ignore quiet

private-bin fireurl,xterm

dbus-user filter
