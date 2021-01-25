# Firejail profile alias for nethack-vultures
# This file is overwritten after every install/update

# Persistent local customizations
include vulturesclaw.local

noblacklist /var/games/vulturesclaw
whitelist /var/games/vulturesclaw

# Redirect
include nethack-vultures.profile
