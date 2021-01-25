# Firejail profile alias for nethack-vultures
# This file is overwritten after every install/update

# Persistent local customizations
include vultureseye.local

noblacklist /var/games/vultureseye
whitelist /var/games/vultureseye

# Redirect
include nethack-vultures.profile
