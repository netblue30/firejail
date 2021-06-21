# Firejail profile for alpinef
# Description: Text-based email and newsgroups reader using function keys
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include alpinef.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin alpinef

# Redirect
include alpine.profile
