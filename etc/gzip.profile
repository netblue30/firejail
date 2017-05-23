# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gzip.local

# gzip profile
quiet
ignore noroot
include /etc/firejail/default.profile

blacklist /tmp/.X11-unix

net none
no3d
nosound
shell none
tracelog

private-dev
