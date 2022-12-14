# Firejail profile for avidemux3_qt5
# Description: The Qt5 GUI for Avidemux.
# This file is overwritten after every install/update
# Persistent local customizations
include avidemux3_qt5.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow translations
whitelist /usr/share/avidemux3
whitelist /usr/share/avidemux6

# Redirect
include avidemux.profile
