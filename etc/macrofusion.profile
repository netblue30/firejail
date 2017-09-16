# Firejail profile for macrofusion
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/macrofusion.local
# Persistent global definitions
include /etc/firejail/globals.local


whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/gtk-3.0
whitelist ${HOME}/.config/mfusion
whitelist ${HOME}/.themes
whitelist ${HOME}/Pictures
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
net none
nogroups
nonewprivs
noroot
seccomp
shell none

private-bin python3,macrofusion,env,enfuse,exiftool,align_image_stack
private-dev
private-etc fonts
private-tmp
