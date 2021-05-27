# Firejail profile for ppsspp
# Description: A PSP emulator
# This file is overwritten after every install/update
# Persistent local customizations
include ppsspp.local
# Persistent global definitions
include globals.local

# Note: you must whitelist your games folder in your ppsspp.local.

noblacklist ${HOME}/.config/ppsspp

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.config/ppsspp
whitelist ${HOME}/.config/ppsspp
whitelist /usr/share/ppsspp
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none

private-bin ppsspp,PPSSPP,PPSSPPQt,PPSSPPSDL
# Add the next line to your ppsspp.local if you do not need controller support.
#private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,drirc,fonts,group,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,machine-id,nsswitch.conf,passwd,pki,pulse,resolv.conf,ssl
private-opt ppsspp
private-tmp

dbus-user none
dbus-system none
