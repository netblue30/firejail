# Firejail profile for less
# Description: Pager program similar to more
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include less.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist /tmp/.X11-unix
include disable-exec.inc

ignore noroot
apparmor
ipc-namespace
machine-id
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
writable-var-log

# The user can have a custom coloring script configured in ${HOME}/.lessfilter.
# Enable private-bin and private-lib if you are not using any filter.
# private-bin less
# private-lib
private-cache
private-dev

memory-deny-write-execute

include default.profile
