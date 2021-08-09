# Firejail profile for ping
# Description: send ICMP ECHO_REQUEST to network hosts
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ping.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.keep net_raw
ipc-namespace
#net tun0
#netfilter /etc/firejail/ping.net
netfilter
no3d
nodvd
nogroups
noinput
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
# /etc/hosts is required in private-etc; however, just adding it to the list doesn't solve the problem!
#private-etc ca-certificates,crypto-policies,hosts,pki,resolv.conf,ssl
private-tmp

# memory-deny-write-execute is built using seccomp; nonewprivs will kill it
#memory-deny-write-execute

dbus-user none
dbus-system none
