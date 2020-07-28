# Firejail profile for bzcat
# Description: A high-quality data compression program
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include bzcat.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore read-write
read-only ${HOME}

# Redirect
include gzip.profile
