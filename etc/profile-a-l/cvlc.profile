# Firejail profile for cvlc
# This file is overwritten after every install/update
# Persistent local customizations
include cvlc.local
# Persistent global definitions
# added by included profile
#include globals.local

# cvlc doesn't like private-bin
ignore private-bin

# Redirect
include vlc.profile
