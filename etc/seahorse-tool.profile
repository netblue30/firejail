# Firejail profile for seahorse-tool
# Description: PGP encryption and signing
# This file is overwritten after every install/update
# Persistent local customizations
include seahorse-tool.local
# Persistent global definitions
# added by included profile
#include globals.local

private-tmp

memory-deny-write-execute

# Redirect
include seahorse.profile
