# Firejail profile for cvlc
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/cvlc.local
# Persistent global definitions
include /etc/firejail/globals.local

# cvlc doesn't like private-bin
ignore private-bin

# Redirect
include /etc/firejail/vlc.profile
