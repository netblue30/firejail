# Firejail profile for wget2
# Description: Updated version of the popular wget URL retrieval tool
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include wget2.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin wget2

# Redirect
include wget.profile
