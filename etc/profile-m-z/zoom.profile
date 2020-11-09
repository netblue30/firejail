# Firejail profile for zoom
# Description: Video Conferencing and Web Conferencing Service
# This file is overwritten after every install/update
# Persistent local customizations
include zoom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/zoomus.conf
noblacklist ${HOME}/.zoom

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/zoom
mkfile ${HOME}/.config/zoomus.conf
mkdir ${HOME}/.zoom
whitelist ${HOME}/.cache/zoom
whitelist ${HOME}/.config/zoomus.conf
whitelist ${HOME}/.zoom
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
#nogroups - breaks webcam access (see #3711)
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none
tracelog

disable-mnt
private-cache
private-dev
# Disable for now, see https://github.com/netblue30/firejail/issues/3726
#private-etc alternatives,ca-certificates,crypto-policies,fonts,group,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nsswitch.conf,pki,resolv.conf,ssl
private-tmp
