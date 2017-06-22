quiet
# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/unrar.local

# unrar profile
ignore noroot
include /etc/firejail/default.profile

blacklist /tmp/.X11-unix

hostname unrar
net none
no3d
nosound
shell none
tracelog

private-bin unrar
private-dev
private-etc passwd,group,localtime
private-tmp
