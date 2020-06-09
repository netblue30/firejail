# Firejail profile for seahorse-tool
# Description: PGP encryption and signing
# This file is overwritten after every install/update
# Persistent local customizations
include seahorse-tool.local
# Persistent global definitions
# added by included profile
#include globals.local

# private-etc workaround for: #2877
private-etc firejail,login.defs,passwd
private-tmp

# Redirect
include seahorse.profile
