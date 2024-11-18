# Firejail profile for firefox-esr
# This file is overwritten after every install/update
# Persistent local customizations
include firefox-esr.local
# Persistent global definitions
# added by included profile
#include globals.local

whitelist /usr/share/firefox-esr

private-etc firefox-esr

# Redirect
include firefox.profile
