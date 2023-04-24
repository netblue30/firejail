# Firejail profile for gtk2-youtube-viewer
# Description: GTK front-end to youtube-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gtk2-youtube-viewer.local
# added by included profile
#include globals.local

private-bin gtk2-youtube-viewer

include gtk-youtube-viewers-common.profile

# Redirect
include youtube-viewer.profile
