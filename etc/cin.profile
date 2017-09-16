# Firejail profile for cin
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/cin.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt

whitelist ${DOWNLOADS}
whitelist ${HOME}/.bcast5
whitelist ${HOME}/Videos
whitelist /tmp/.X11-unix
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
net none
nogroups
noroot
seccomp
shell none

private-bin cin
private-dev
private-etc fonts,pulse

noexec /home
noexec /tmp
