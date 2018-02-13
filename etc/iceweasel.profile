# Firejail profile for iceweasel
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/iceweasel.local
# Persistent global definitions
include /etc/firejail/globals.local

# private-etc must first be enabled in firefox-common.profile
#private-etc iceweasel

# Redirect
include /etc/firejail/firefox.profile
