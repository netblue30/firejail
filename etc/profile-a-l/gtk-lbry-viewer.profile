# Firejail profile for gtk-lbry-viewer
# Description: Gtk front-end to lbry-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gtk-lbry-viewer.local
# added by included profile
#include globals.local

private-bin gtk-lbry-viewer

include gtk-youtube-viewers-common.profile

# Redirect
include lbry-viewer.profile
