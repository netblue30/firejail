# Firejail profile for ping
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/ping.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/whitelist-common.inc

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
#private-etc resolv.conf,hosts
private-tmp

# memory-deny-write-execute is built using seccomp; nonewprivs will kill it
#memory-deny-write-execute
noexec ${HOME}
noexec /tmp


