# Firejail profile for pcsxr
# Description: A PlayStation emulator
# This file is overwritten after every install/update
# Persistent local customizations
include pcsxr.local
# Persistent global definitions
include globals.local

# Note: you must whitelist your games folder in your pcsxr.local

noblacklist ${HOME}/.pcsxr

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.pcsxr
whitelist ${HOME}/.pcsxr
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
net none
netfilter
# Add the next line to your pcsxr.local when not loading games from disc.
#nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
tracelog

private-bin pcsxr
private-cache
# Add the next line to your pcsxr.local if you do not need controller support.
#private-dev
private-etc @tls-ca,@x11,bumblebee,gconf,glvnd,host.conf,mime.types,rpc,services
private-opt none
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
