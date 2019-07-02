# Firejail profile for gconf-editor
# Description: Graphical gconf registry editor
# This file is overwritten after every install/update
# Persistent local customizations
include gconf-editor.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist /tmp/.X11-unix

ignore net none
ignore x11 none

# Redirect
include gconf.profile
