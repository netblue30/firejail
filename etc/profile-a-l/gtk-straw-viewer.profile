# Firejail profile for gtk-straw-viewer
# Description: GTK front-end to straw-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gtk-straw-viewer.local
# added by included profile
#include globals.local

private-bin gtk-straw-viewer

include gtk-youtube-viewers-common.profile

# Redirect
include straw-viewer.profile
