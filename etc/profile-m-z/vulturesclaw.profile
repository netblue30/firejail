# Firejail profile alias for nethack-vultures
# This file is overwritten after every install/update
# Persistent local customizations
include vulturesclaw.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  /var/games/vulturesclaw
allow  /var/games/vulturesclaw

# Redirect
include nethack-vultures.profile
