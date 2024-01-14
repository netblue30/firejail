# Firejail profile for pipe-viewer-gtk
# Description: GTK front-end to pipe-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include pipe-viewer-gtk.local
# added by included profile
#include globals.local

private-bin pipe-viewer-gtk

include gtk-youtube-viewers-common.profile

# Redirect
include pipe-viewer.profile
