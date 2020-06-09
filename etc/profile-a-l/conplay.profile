# Firejail profile for conplay
# Description: MPEG audio player/decoder
# This file is overwritten after every install/update
# Persistent local customizations
include conplay.local
# Persistent global definitions
# added by included profile
#include globals.local

## system-wide profile
#+ overrides
# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

whitelist /usr/share/perl5

# Redirect
include mpg123.profile
