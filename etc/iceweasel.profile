# Firejail profile for iceweasel
# This file is overwritten after every install/update
# Persistent local customizations
include iceweasel.local
# Persistent global definitions
include globals.local

# private-etc must first be enabled in firefox-common.profile
#private-etc iceweasel

# Redirect
include firefox.profile
