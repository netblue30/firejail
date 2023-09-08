# Firejail profile for gmpc
# Description: MPD client
# This file is overwritten after every install/update
# Persistent local customizations
include gmpc.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gmpc
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/gmpc
whitelist ${HOME}/.config/gmpc
whitelist ${MUSIC}
whitelist /usr/share/gmpc
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
#private-bin gmpc
private-cache
private-etc
private-tmp
writable-run-user

dbus-user filter
dbus-user.talk org.mpris.MediaPlayer2.mpd
dbus-system none

#memory-deny-write-execute # breaks on Arch
restrict-namespaces
