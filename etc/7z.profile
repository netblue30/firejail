# Firejail profile for 7z
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include 7z.local
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
