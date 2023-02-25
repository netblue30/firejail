# Firejail profile for transmission-remote
# Description: A remote control utility for transmission-daemon (CLI)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-remote.local
# Persistent global definitions
include globals.local

private-bin transmission-remote
private-etc

# Redirect
include transmission-common.profile
