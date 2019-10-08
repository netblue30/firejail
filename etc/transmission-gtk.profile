# Firejail profile for transmission-gtk
# Description: Fast, easy and free BitTorrent client (GTK GUI)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-gtk.local
# Persistent global definitions
include globals.local

include whitelist-usr-share-common.inc

private-bin transmission-gtk

ignore memory-deny-write-execute

# Redirect
include transmission-common.profile
