# Firejail profile for firefox-esr
# This file is overwritten after every install/update
# Persistent local customizations
include firefox-esr.local
# Persistent global definitions
# added by included profile
#include globals.local

whitelist /usr/share/firefox-esr

# Edition-specific D-Bus filter
dbus-user.own org.mozilla.firefox_esr.*

# Redirect
include firefox.profile
