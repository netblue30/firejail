# Firejail profile for virtualbox
# Description: x86 virtualization solution
# This file is overwritten after every install/update
# Persistent local customizations
include virtualbox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.VirtualBox
noblacklist ${HOME}/.config/VirtualBox
noblacklist ${HOME}/VirtualBox VMs
# noblacklist /usr/bin/virtualbox
noblacklist /usr/lib/virtualbox
noblacklist /usr/lib64/virtualbox

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/VirtualBox
mkdir ${HOME}/VirtualBox VMs
whitelist ${HOME}/.config/VirtualBox
whitelist ${HOME}/VirtualBox VMs
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.keep net_raw,sys_nice
netfilter
nodvd
#nogroups
notv
shell none
tracelog

#disable-mnt
private-cache
private-etc alsa,asound.conf,ca-certificates,dconf,fonts,hostname,hosts,ld.so.cache,pulse,localtime,machine-id,conf.d,resolv.conf,ssl,X11

dbus-user none
dbus-system none
