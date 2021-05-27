# Firejail profile for gtk-youtube-viewer
# Description: Gtk front-end to youtube-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gtk-youtube-viewer.local
# added by included profile
#include globals.local

ignore quiet

# Redirect
include youtube-viewer.profile
