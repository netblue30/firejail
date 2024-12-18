# Firejail profile for seahorse-daemon
# Description: PGP encryption and signing
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include seahorse-daemon.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist ${RUNUSER}/wayland-*
include disable-x11.inc

memory-deny-write-execute

# Redirect
include seahorse.profile
