quiet
# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/strings.local

# strings profile
ignore noroot
include /etc/firejail/default.profile

net none
no3d
nosound
novideo
shell none
tracelog
private-dev
blacklist /tmp/.X11-unix

memory-deny-write-execute
