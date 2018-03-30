# Firejail profile for unrar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/unrar.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

hostname unrar
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

private-bin unrar
private-dev
private-etc passwd,group,localtime
private-tmp

include /etc/firejail/default.profile
