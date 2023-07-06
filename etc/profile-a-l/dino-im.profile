# Firejail profile for dino-im
# Description: Modern XMPP Chat Client using GTK/Vala, Ubuntu specific bin name
# This file is overwritten after every install/update
# Persistent local customizations
include dino-im.local
# Persistent global definitions
# added by included profile
#include globals.local

# Add Ubuntu specific binary name
private-bin dino-im

# Redirect
include dino.profile
