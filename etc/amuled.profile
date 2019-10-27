# Firejail profile for amuled
# Description: Daemon for amule
# This file is overwritten after every install/update
# Persistent local customizations
include amule.local
# Persistent global definitions
include globals.local

private-bin amuled

# Redirect
include amule.profile
