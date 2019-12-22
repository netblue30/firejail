# Firejail profile for audio-recorder
# Description: Audio Recorder Application
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include audio-recorder.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${MUSIC}
whitelist ${DOWNLOADS}
whitelist /usr/share/audio-recorder
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
net none
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

disable-mnt
# private-bin audio-recorder
private-cache
private-etc alsa,alternatives,asound.conf,dbus-1,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,passwd,pulse,xdg
private-tmp

# memory-deny-write-execute - breaks on Arch
