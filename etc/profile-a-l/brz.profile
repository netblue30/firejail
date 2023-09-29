# Firejail profile for brz
# Description: Distributed VCS with support for Bazaar and Git file formats
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include brz.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/breezy

# Redirect
include git.profile
