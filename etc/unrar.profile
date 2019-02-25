# Firejail profile for unrar
# Description: Unarchiver for .rar files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include unrar.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist /tmp/.X11-unix

hostname unrar
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

private-bin unrar
private-dev
private-etc alternatives,passwd,group,localtime
private-tmp

include default.profile
