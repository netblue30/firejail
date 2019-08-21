# Firejail profile for transmission-create
# Description: CLI utility to create BitTorrent .torrent files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-create.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin transmission-create

# Redirect
include transmission-common.profile
