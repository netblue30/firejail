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
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.keep chown,net_raw,sys_nice,sys_rawio
netfilter
nogroups
notv
shell none
tracelog

#disable-mnt
private-etc alsa,asound.conf,ca-certificates,conf.d,crypto-policies,dconf,fonts,gtk-2.0,gtk-3.0,hostname,hosts,ld.so.cache,localtime,machine-id,pulse,pki,resolv.conf,ssl,vmware,vmware-installer,vmware-vix

dbus-user none
dbus-system none
