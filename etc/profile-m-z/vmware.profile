# Firejail profile for vmware
# Description: The industry standard for running multiple operating systems as virtual machines on a single Linux PC.
# This file is overwritten after every install/update
# Persistent local customizations
include vmware.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/vmware
noblacklist ${HOME}/.vmware
noblacklist /usr/lib/vmware

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/vmware
mkdir ${HOME}/.vmware
whitelist ${HOME}/.cache/vmware
whitelist ${HOME}/.vmware
# Add the next lines to your vmware.local if you need to use "shared VM".
#whitelist /var/lib/vmware
#writable-var
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.keep chown,net_raw,sys_nice
netfilter
nogroups
notv
shell none
tracelog

#disable-mnt
# Add the next line to your vmware.local to enable private-bin.
#private-bin env,bash,sh,ovftool,vmafossexec,vmaf_*,vmnet-*,vmplayer,vmrest,vmrun,vmss2core,vmstat,vmware,vmware-*
private-etc alsa,alternatives,asound.conf,ca-certificates,conf.d,crypto-policies,dconf,fonts,gtk-2.0,gtk-3.0,hostname,hosts,ld.so.cache,ld.so.preload,localtime,machine-id,passwd,pki,pulse,resolv.conf,ssl,vmware,vmware-installer,vmware-vix
dbus-user none
dbus-system none
