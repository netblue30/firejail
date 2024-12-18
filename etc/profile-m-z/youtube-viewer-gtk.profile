# Firejail profile for youtube-viewer-gtk
# Description: GTK front-end to youtube-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include youtube-viewer-gtk.local
# added by included profile
#include globals.local

private-bin youtube-viewer-gtk

include gtk-youtube-viewers-common.profile

# Redirect
include youtube-viewer.profile
