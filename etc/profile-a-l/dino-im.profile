# Firejail profile for dino-im
# Description: Modern XMPP Chat Client using GTK+/Vala, Ubuntu specific bin name
# This file is overwritten after every install/update
##quiet
# Persistent local customizations
include dino-im.local
# Persistent global definitions
include globals.local

# Add Ubuntu specific binary name
private-bin dino-im

# Redirect
include dino.profile
