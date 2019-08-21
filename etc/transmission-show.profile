# Firejail profile for transmission-show
# Description: CLI utility to show BitTorrent .torrent file metadata
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-show.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin transmission-show
private-etc alternatives,hosts,nsswitch.conf

# Redirect
include transmission-common.profile
