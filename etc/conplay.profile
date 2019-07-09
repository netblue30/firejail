# Firejail profile for conplay
# Persistent local customizations
include conplay.local
# Persistent global definitions
# added by included profile
#include globals.local

## system-wide profile
#+ overrides
# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

# Redirect
include mpg123.profile
