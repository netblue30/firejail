# Firejail profile for lbry-viewer-gtk
# Description: GTK front-end to lbry-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include lbry-viewer-gtk.local
# added by included profile
#include globals.local

private-bin lbry-viewer-gtk

include gtk-youtube-viewers-common.profile

# Redirect
include lbry-viewer.profile
