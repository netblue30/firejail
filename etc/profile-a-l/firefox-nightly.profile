# Firejail profile for firefox-nightly
# This file is overwritten after every install/update
# Persistent local customizations
include firefox-nightly.local
# Persistent global definitions
# added by included profile
#include globals.local

# Edition-specific D-Bus filter
dbus-user.own org.mozilla.firefoxnightly.*

# Redirect
include firefox.profile
