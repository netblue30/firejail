# Firejail profile alias for thunderbird-beta
# This file is overwritten after every install/update
# Persistent local customizations
include thunderbird-beta.local
# Persistent global definitions
# added by included profile
#include globals.local

whitelist /opt/thunderbird-beta

# Redirect
include thunderbird.profile
