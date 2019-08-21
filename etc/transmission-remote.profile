# Firejail profile for transmission-remote
# Description: A remote control utility for transmission-daemon (CLI)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-remote.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin transmission-remote
private-etc alternatives,hosts,nsswitch.conf

# Redirect
include transmission-common.profile
