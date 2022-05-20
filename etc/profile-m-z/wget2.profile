# Firejail profile for wget2
# Description: Updated version of the popular wget URL retrieval tool
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include wget2.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/wget
noblacklist ${HOME}/.local/share/wget
ignore noblacklist ${HOME}/.wgetrc

private-bin wget2
# Depending on workflow you can add the next line to your wget2.local.
#private-etc wget2rc

# Redirect
include wget.profile
