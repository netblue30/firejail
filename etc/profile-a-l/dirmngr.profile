# Firejail profile for dirmngr
# Description: GNU privacy guard - network access daemon
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include dirmngr.local
# Persistent global definitions
# added by included profile
#include globals.local

# private-bin dirmngr

# Redirect
include gpg-agent.profile
