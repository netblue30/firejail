# Firejail profile for bunzip2
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/bunzip2.local
# Persistent global definitions
# added by included profile
#include /etc/firejail/globals.local

# Redirect
include /etc/firejail/gzip.profile
