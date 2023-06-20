# Firejail profile for vmware-view
# Description: VMware Horizon Client, used as a remote desktop client
# This file is overwritten after every install/update
# Persistent local customizations
include vmware-view.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.vmware
noblacklist /usr/lib/vmware

noblacklist /sbin
noblacklist /usr/sbin

include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.vmware
whitelist ${HOME}/.vmware
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
# Add 'ignore novideo' to your vmware-view.local if you need your webcam.
novideo
protocol unix,inet,inet6
seccomp !iopl
seccomp.block-secondary
tracelog

disable-mnt
private-cache
private-dev
private-etc @tls-ca,@x11,bumblebee,gai.conf,gconf,glvnd,host.conf,magic,magic.mgc,mime.types,proxychains.conf,rpc,services,terminfo,vmware,vmware-tools,vmware-vix
# Logs are kept in /tmp. Add 'ignore private-tmp' to your vmware-view.local if you need them without joining the sandbox.
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
