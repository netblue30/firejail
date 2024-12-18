# Firejail profile for PCSX2
# Description: A PlayStation 2 emulator
# This file is overwritten after every install/update
# Persistent local customizations
include PCSX2.local
# Persistent global definitions
include globals.local

# Note: you must whitelist your games folder in your PCSX2.local.

noblacklist ${HOME}/.config/PCSX2

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.config/PCSX2
whitelist ${HOME}/.config/PCSX2
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
net none
netfilter
# Add the next line to your PCSX2.local if you're not loading games from disc.
#nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
#seccomp # breaks loading with no logs
#tracelog # 32/64 bit incompatibility

private-bin PCSX2
private-cache
# Add the next line to your PCSX2.local if you do not need controller support.
#private-dev
private-etc @tls-ca,@x11,bumblebee,gconf,glvnd,host.conf,mime.types,rpc,services
private-opt none
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
