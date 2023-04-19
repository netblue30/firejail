# Firejail profile for gtk-youtube-viewer
# Description: Gtk front-end to youtube-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gtk-youtube-viewer.local
# added by included profile
#include globals.local

private-bin gtk-youtube-viewer

include gtk-youtube-viewers-common.profile

# Redirect
include youtube-viewer.profile
