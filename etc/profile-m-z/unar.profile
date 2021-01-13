# Firejail profile for unar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include unar.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin unar

# Redirect
include ar.profile
