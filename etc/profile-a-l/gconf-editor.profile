# Firejail profile for gconf-editor
# Description: Graphical gconf registry editor
# This file is overwritten after every install/update
# Persistent local customizations
include gconf-editor.local
# Persistent global definitions
# added by included profile
#include globals.local

deny  /tmp/.X11-unix

allow  /usr/share/gconf-editor

ignore x11 none

# Redirect
include gconf.profile
