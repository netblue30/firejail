# Firejail profile for transmission-show
# Description: CLI utility to show BitTorrent .torrent file metadata
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-show.local
# Persistent global definitions
include globals.local

private-bin transmission-show
private-etc

# Redirect
include transmission-common.profile
