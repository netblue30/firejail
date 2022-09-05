# Firejail profile for firefox-beta
# This file is overwritten after every install/update
# Persistent local customizations
include firefox-beta.local
# Persistent global definitions
# added by included profile
#include globals.local

# Edition-specific D-Bus filter
dbus-user.own org.mozilla.firefox_beta.*

# Redirect
include firefox.profile
