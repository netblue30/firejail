# Firejail profile for less
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/less.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

ignore noroot
net none
no3d
nosound
novideo
shell none
tracelog

private-dev

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

include /etc/firejail/default.profile
