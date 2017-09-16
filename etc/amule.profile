# Firejail profile for amule
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/amule.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt
blacklist /usr/local/bin
blacklist /usr/local/sbin

whitelist ${DOWNLOADS}
whitelist ${HOME}/.aMule
whitelist ${HOME}/.gtkrc-2.0
whitelist ${HOME}/.gtkrc.mine
whitelist ${HOME}/.themes
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
nogroups
nonewprivs
noroot
seccomp
shell none

private-bin amule
private-dev
private-etc fonts,hosts
private-tmp
