# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/strings.local

# strings profile
quiet
ignore noroot
include /etc/firejail/default.profile

net none
nosound
shell none
tracelog
private-dev
no3d
blacklist /tmp/.X11-unix
