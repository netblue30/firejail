# Firejail profile for unzip
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/unzip.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

hostname unzip
ignore noroot
net none
no3d
nodvd
nosound
notv
novideo
shell none
tracelog

private-bin unzip
private-dev
private-etc passwd,group,localtime

include /etc/firejail/default.profile
