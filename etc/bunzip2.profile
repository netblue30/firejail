# Firejail profile for bunzip2
# Description: A high-quality data compression program
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include bunzip2.local
# Persistent global definitions
# added by included profile
#include globals.local

# Redirect
include gzip.profile
