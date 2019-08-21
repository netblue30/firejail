# Firejail profile for transmission-qt
# Description: Fast, easy and free BitTorrent client (Qt GUI)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-qt.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin transmission-qt

# private-lib - breaks on Arch
ignore private-lib

ignore memory-deny-write-execute

# Redirect
include transmission-common.profile
