# Firejail profile for gtk-pipe-viewer
# Description: Gtk front-end to pipe-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gtk-pipe-viewer.local
# added by included profile
#include globals.local

private-bin gtk-pipe-viewer

include gtk-youtube-viewers-common.profile

# Redirect
include pipe-viewer.profile
