# Firejail profile for unzip
# Description: De-archiver for .zip files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include unzip.local
# Persistent global definitions
# added by included default.profile
#include globals.local

blacklist /tmp/.X11-unix

hostname unzip
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

private-bin unzip
private-dev
private-etc alternatives,passwd,group,localtime

# GNOME Shell integration (chrome-gnome-shell)
noblacklist ${HOME}/.local/share/gnome-shell

include default.profile
