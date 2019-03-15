# Firejail profile for seahorse-daemon
# Description: PGP encryption and signing
# This file is overwritten after every install/update
# Persistent local customizations
include seahorse-daemon.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist /tmp/.X11-unix

memory-deny-write-execute

# Redirect
include seahorse.profile
