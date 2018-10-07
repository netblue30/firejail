# Firejail profile for gzip
# Description: GNU compression utilities
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/gzip.local
# Persistent global definitions
# added by included default.profile
#include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

ignore noroot
net none
no3d
nodbus
nodvd
nosound
notv
novideo
shell none
tracelog

private-dev

include /etc/firejail/default.profile
