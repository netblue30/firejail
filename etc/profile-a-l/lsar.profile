# Firejail profile for lsar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include lsar.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin lsar

# Redirect
include ar.profile
