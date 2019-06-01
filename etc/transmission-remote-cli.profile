# Firejail profile for transmission-remote-cli
# Description: A remote control utility for transmission-daemon (CLI)
# This file is overwritten after every install/update
# Persistent local customizations
include transmission-remote-cli.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include	allow-python2.inc
include	allow-python3.inc

mkdir ${HOME}/.cache/transmission
mkdir ${HOME}/.config/transmission
whitelist ${HOME}/.cache/transmission
whitelist ${HOME}/.config/transmission
include whitelist-common.inc
include whitelist-var-common.inc

# private-bin python*
private-etc fonts


# Redirect
include transmission-remote.profile
