# Firejail profile for gconf-editor
# Description: Graphical gconf registry editor
# This file is overwritten after every install/update
# Persistent local customizations
include gconf-editor.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist /tmp/.X11-unix

whitelist /usr/share/gconf-editor

ignore x11 none

ignore memory-deny-write-execute

# Redirect
include gconf.profile
