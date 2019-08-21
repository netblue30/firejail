# Firejail profile for transmission-remote-cli
# Description: A remote control utility for transmission-daemon (CLI)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-remote-cli.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include	allow-python2.inc
include	allow-python3.inc

private-bin python*,transmission-remote-cli
private-etc

# Redirect
include transmission-common.profile
