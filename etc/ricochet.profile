# Firejail profile for ricochet
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ricochet.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt

whitelist ${DOWNLOADS}
whitelist ${HOME}/.local/share/Ricochet
whitelist /tmp/.X11-unix
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
nogroups
noroot
seccomp
shell none

private-bin ricochet,tor
private-dev
private-etc fonts,tor,X11,alternatives

noexec /home
noexec /tmp
