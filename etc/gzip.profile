# Firejail profile for gzip
# Description: GNU compression utilities
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gzip.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist /tmp/.X11-unix

ignore noroot
net none
no3d
nodbus
nodvd
nosound
notv
nou2f
novideo
shell none
tracelog

private-dev

include default.profile
