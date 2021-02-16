# Firejail profile for gnome-screenshot
# This file is overwritten after every install/update
# Persistent local customizations
include Screenshot.local
# Persistent global definitions
# added by included profile
#include globals.local

# Temporary fix for https://github.com/netblue30/firejail/issues/2624
# Redirect
include gnome-screenshot.profile
