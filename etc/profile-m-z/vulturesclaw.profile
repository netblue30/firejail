# Firejail profile alias for nethack-vultures
# This file is overwritten after every install/update
# Persistent local customizations
include vulturesclaw.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist /var/games/vulturesclaw
whitelist /var/games/vulturesclaw

# Redirect
include nethack-vultures.profile
