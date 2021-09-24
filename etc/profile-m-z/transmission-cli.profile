# Firejail profile for transmission-cli
# Description: Fast, easy and free BitTorrent client (CLI tools and web client)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-cli.local
# Persistent global definitions
include globals.local

private-bin transmission-cli
private-etc alternatives,ca-certificates,crypto-policies,ld.so.preload,nsswitch.conf,pki,resolv.conf,ssl

# Redirect
include transmission-common.profile
