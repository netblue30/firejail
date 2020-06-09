# Firejail profile for transmission-edit
# Description: CLI utility to modify BitTorrent .torrent files' announce URLs
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-edit.local
# Persistent global definitions
include globals.local

private-bin transmission-edit

# Redirect
include transmission-common.profile
