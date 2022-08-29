# Firejail profile for gtk-lbry-viewer
# Description: Gtk front-end to lbry-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gtk-lbry-viewer.local
# added by included profile
#include globals.local

ignore quiet

# Redirect
include lbry-viewer.profile
