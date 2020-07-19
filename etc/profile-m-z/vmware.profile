# Firejail profile for vmware
# Description: The industry standard for running multiple operating systems as virtual machines on a single Linux PC.
# This file is overwritten after every install/update
# Persistent local customizations
include vmware.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.vmware
noblacklist ${HOME}/.cache/vmware

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.vmware
mkdir ${HOME}/.cache/vmware
whitelist ${HOME}/.vmware
whitelist ${HOME}/.cache/vmware
include whitelist-common.inc

caps.keep sys_nice
ipc-namespace
netfilter


nogroups
notv
shell none

#disable-mnt
private-etc private-etc alsa,asound.conf,ca-certificates,conf.d,dconf,fonts,gtk-2.0,gtk-3.0,hostname,hosts,ld.so.cache,localtime,machine-id,pulse,resolv.conf,ssl,vmware,vmware-installer,vmware-vix,X11

dbus-user none
dbus-system none
