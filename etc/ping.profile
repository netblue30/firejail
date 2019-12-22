# Firejail profile for ping
# Description: send ICMP ECHO_REQUEST to network hosts
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ping.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-common.inc

caps.keep net_raw
ipc-namespace
#net tun0
#netfilter /etc/firejail/ping.net
netfilter
no3d
nodvd
nogroups
# ping needs to rise privileges, noroot and nonewprivs will kill it
#nonewprivs
#noroot
nosound
notv
nou2f
novideo
# protocol command is built using seccomp; nonewprivs will kill it
#protocol unix,inet,inet6,netlink,packet
# killed by no-new-privs
#seccomp

disable-mnt
private
#private-bin has mammoth problems with execvp: "No such file or directory"
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,dbus-1,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,tor,xdg
private-tmp

# memory-deny-write-execute is built using seccomp; nonewprivs will kill it
#memory-deny-write-execute
