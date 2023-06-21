# Firejail profile for vmware
# Description: VMWare Workstation Player, used for running virtual machines
# This file is overwritten after every install/update
# Persistent local customizations
include vmware.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/vmware
noblacklist ${HOME}/.vmware
noblacklist /usr/lib/vmware

include disable-common.inc
#include disable-devel.inc # gcc is used to compile kernel modules
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
tracelog

#disable-mnt
# Add the next line to your vmware.local to enable private-bin.
#private-bin env,bash,sh,ovftool,vmafossexec,vmaf_*,vmnet-*,vmplayer,vmrest,vmrun,vmss2core,vmstat,vmware,vmware-*
private-etc @tls-ca,@x11,conf.d,mtab,vmware,vmware-installer,vmware-vix
dbus-user none
dbus-system none
