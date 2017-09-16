# Firejail profile for freecad
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/freecad.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt
blacklist /usr/local/bin
blacklist /usr/local/sbin

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/FreeCAD
whitelist ${HOME}/Documents
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
net none
nogroups
noroot
nosound
protocol unix
seccomp
shell none

private-bin freecad,freecadcmd
private-dev
private-etc fonts,passwd,alternatives,X11
private-tmp

noexec ${HOME}
noexec /tmp
