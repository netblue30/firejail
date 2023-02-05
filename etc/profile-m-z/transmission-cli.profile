# Firejail profile for transmission-cli
# Description: Fast, easy and free BitTorrent client (CLI tools and web client)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-cli.local
# Persistent global definitions
include globals.local

private-bin transmission-cli
private-etc @tls-ca

# Redirect
include transmission-common.profile
