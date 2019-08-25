# Firejail profile for transmission-remote-gtk
# Description: A remote control utility for transmission-daemon (GTK GUI)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-remote-gtk.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/transmission-remote-gtk

mkdir ${HOME}/.config/transmission-remote-gtk
whitelist ${HOME}/.config/transmission-remote-gtk

private-etc fonts,hostname,hosts,resolv.conf
# Problems with private-lib (see issue #2889)
ignore private-lib

ignore memory-deny-write-execute

# Redirect
include transmission-common.profile
