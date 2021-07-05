# Firejail profile alias for nethack-vultures
# This file is overwritten after every install/update
# Persistent local customizations
include vultureseye.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  /var/games/vultureseye
allow  /var/games/vultureseye

# Redirect
include nethack-vultures.profile
