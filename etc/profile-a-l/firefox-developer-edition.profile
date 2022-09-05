# Firejail profile for firefox-developer-edition
# Description: Developer Edition of the popular Firefox web browser
# This file is overwritten after every install/update
# Persistent local customizations
include firefox-developer-edition.local
# Persistent global definitions
# added by included profile
#include globals.local

# Edition-specific DBus filter
dbus-user.own org.mozilla.firefoxdeveloperedition.*

# Redirect
include firefox.profile
