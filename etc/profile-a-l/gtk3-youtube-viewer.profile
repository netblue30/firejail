# Firejail profile for gtk3-youtube-viewer
# Description: Gtk front-end to youtube-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gtk3-youtube-viewer.local
# added by included profile
#include globals.local

private-bin gtk3-youtube-viewer

include gtk-youtube-viewers-common.profile

# Redirect
include youtube-viewer.profile
