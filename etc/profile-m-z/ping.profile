# Firejail profile for ping
# Description: send ICMP ECHO_REQUEST to network hosts
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ping.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

#include whitelist-common.inc # see #903
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# If your kernel allows the creation of user namespaces by unprivileged users
# (for example, if running `unshare -U echo enabled` prints "enabled"), you
# can add the next line to your ping.local.
#include ping-hardened.inc.profile

apparmor
caps.keep net_raw
ipc-namespace
machine-id
#net tun0
#netfilter /etc/firejail/ping.net
netfilter
no3d
nodvd
nogroups
noinput
# ping needs to raise privileges, nonewprivs and noroot will kill it
#nonewprivs
noprinters
#noroot
nosound
notv
nou2f
novideo
# protocol command is built using seccomp; nonewprivs will kill it
#protocol unix,inet,inet6,netlink,packet
#seccomp
tracelog

disable-mnt
private
#private-bin ping # has mammoth problems with execvp: "No such file or directory"
private-cache
private-dev
private-etc @tls-ca
private-lib
private-tmp

# memory-deny-write-execute is built using seccomp; nonewprivs will kill it
#memory-deny-write-execute

dbus-user none
dbus-system none

read-only ${HOME}
#restrict-namespaces
