# Firejail profile for makedeb
# Description: A utility to automate the building of Debian packages
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include makedeb.local
# Persistent global definitions
#include globals.local

ignore noblacklist /var/lib/pacman

# Redirect
include makepkg.profile
