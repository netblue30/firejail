# Firejail profile for gpg2
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gpg2.local
# Persistent global definitions
# added by included profile
#include globals.local

#private-bin gpg2

# Redirect
include gpg.profile
