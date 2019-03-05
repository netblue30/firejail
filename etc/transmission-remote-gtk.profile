# Firejail profile for transmission-remote-gtk
# Description: A remote control utility for transmission-daemon (GTK GUI)
# This file is overwritten after every install/update
# Persistent local customizations
include transmission-remote-gtk.local
# Persistent global definitions
# added by included profile
#include globals.local

mkdir ${HOME}/.cache/transmission
mkdir ${HOME}/.config/transmission
whitelist ${HOME}/.cache/transmission
whitelist ${HOME}/.config/transmission
include whitelist-common.inc
include whitelist-var-common.inc

private-etc fonts


# Redirect
include transmission-remote.profile
