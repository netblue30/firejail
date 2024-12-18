# Generic Firejail profile for servers started as root
#
# This profile is used as a default when starting the sandbox as root.
# Example:
#
#       $ sudo firejail
#       [sudo] password for netblue:
#       Reading profile /etc/firejail/server.profile
#       Reading profile /etc/firejail/disable-common.inc
#       Reading profile /etc/firejail/disable-programs.inc
#
#       ** Note: you can use --noprofile to disable server.profile **
#
#       Parent pid 5347, child pid 5348
#       The new log directory is /proc/5348/root/var/log
#       Child process initialized in 64.43 ms
#       root@debian:~#
#
# Customize the profile as usual. Examples: unbound.profile, fdns.profile.
# All the rules for regular user profiles apply with the exception of
# /usr/local/bin symlink redirection and firecfg tool. The redirection is disabled
# by default for root user.

# This file is overwritten after every install/update
# Persistent local customizations
include server.local
# Persistent global definitions
include globals.local

# generic server profile
# it allows /sbin and /usr/sbin directories - this is where servers are installed
# depending on your usage, you can enable some of the commands below:

noblacklist /sbin
noblacklist /usr/sbin
noblacklist /etc/init.d
#noblacklist /var/opt

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
#include disable-devel.inc
#include disable-exec.inc
#include disable-interpreters.inc
include disable-programs.inc
include disable-write-mnt.inc
include disable-x11.inc
include disable-xdg.inc

#include whitelist-runuser-common.inc
#include whitelist-usr-share-common.inc
#include whitelist-var-common.inc

# people use to install servers all over the place!
# apparmor runs executable only from default system locations
#apparmor
caps
#ipc-namespace
machine-id
#netfilter /etc/firejail/webserver.net
no3d
nodvd
#nogroups
noinput
nonewprivs
#noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink,packet
seccomp
tab # allow tab completion

disable-mnt
private
#private-bin program
#private-cache
private-dev
# see /usr/share/doc/firejail/profile.template for more common private-etc paths.
#private-etc alternatives
#private-lib
#private-opt none
private-tmp
#writable-run-user
#writable-var
#writable-var-log

dbus-user none
#dbus-system none

#deterministic-shutdown
#memory-deny-write-execute
#read-only ${HOME}
#restrict-namespaces
