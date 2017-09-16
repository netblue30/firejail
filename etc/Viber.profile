# Firejail profile for Viber
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/Viber.local
# Persistent global definitions
include /etc/firejail/globals.local


whitelist ${DOWNLOADS}
whitelist ${HOME}/.ViberPC
whitelist /dev/dri
whitelist /dev/full
whitelist /dev/null
whitelist /dev/ptmx
whitelist /dev/pts
whitelist /dev/random
whitelist /dev/shm
whitelist /dev/snd
whitelist /dev/tty
whitelist /dev/urandom
whitelist /dev/video0
whitelist /dev/zero
whitelist /opt/viber
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
nogroups
noroot
seccomp
shell none

private-bin sh,dig,awk
private-etc hosts,fonts,mailcap,resolv.conf,X11,pulse,alternatives,localtime,nsswitch.conf,ssl,proxychains.conf
private-tmp

noexec ${HOME}
noexec /tmp
