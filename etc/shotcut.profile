# Firejail profile for shotcut
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/shotcut.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /usr/local/bin

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Meltytech
whitelist ${HOME}/Videos
whitelist /tmp/.X11-unix
include /etc/firejail/whitelist-common.inc

caps.drop all
net none
nogroups
noroot
seccomp
shell none

private-bin shotcut,melt,qmelt,nice
private-dev
private-etc X11,alternatives,pulse,fonts

noexec ${HOME}
noexec /tmp
