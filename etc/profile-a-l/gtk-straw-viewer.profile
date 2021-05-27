# Firejail profile for gtk-straw-viewer
# Description: Gtk front-end to straw-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gtk-straw-viewer.local
# added by included profile
#include globals.local

ignore quiet

# Redirect
include straw-viewer.profile
