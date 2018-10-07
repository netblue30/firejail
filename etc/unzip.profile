# Firejail profile for unzip
# Description: De-archiver for .zip files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/unzip.local
# Persistent global definitions
# added by included default.profile
#include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

hostname unzip
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

private-bin unzip
private-dev
private-etc passwd,group,localtime

# GNOME Shell integration (chrome-gnome-shell)
noblacklist ${HOME}/.local/share/gnome-shell

include /etc/firejail/default.profile
